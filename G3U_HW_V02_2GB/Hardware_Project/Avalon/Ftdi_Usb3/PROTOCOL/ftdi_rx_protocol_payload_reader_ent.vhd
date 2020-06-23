library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;
use work.ftdi_protocol_crc_pkg.all;

entity ftdi_rx_protocol_payload_reader_ent is
	generic(
		g_DELAY_QQWORD_CLKDIV : natural range 0 to 65535 := 0 -- [100 MHz / 1 = 100 MHz = 10 ns]
	);
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_rx_stop_i                : in  std_logic;
		data_rx_start_i               : in  std_logic;
		payload_reader_abort_i        : in  std_logic;
		payload_reader_start_i        : in  std_logic;
		payload_reader_reset_i        : in  std_logic;
		payload_length_bytes_i        : in  std_logic_vector(31 downto 0);
		payload_qqword_delay_i        : in  std_logic_vector(15 downto 0);
		rx_dc_data_fifo_rddata_data_i : in  std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_i   : in  std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_i     : in  std_logic;
		rx_dc_data_fifo_rdfull_i      : in  std_logic;
		rx_dc_data_fifo_rdusedw_i     : in  std_logic_vector(11 downto 0);
		buffer_stat_full_i            : in  std_logic;
		buffer_wrready_i              : in  std_logic;
		payload_reader_busy_o         : out std_logic;
		payload_crc32_match_o         : out std_logic;
		payload_eop_error_o           : out std_logic;
		payload_last_rx_buffer_o      : out std_logic;
		rx_dc_data_fifo_rdreq_o       : out std_logic;
		buffer_data_loaded_o          : out std_logic;
		buffer_wrdata_o               : out std_logic_vector(255 downto 0);
		buffer_wrreq_o                : out std_logic
	);
end entity ftdi_rx_protocol_payload_reader_ent;

-- (Rx: FTDI => FPGA)

architecture RTL of ftdi_rx_protocol_payload_reader_ent is

	signal s_payload_length_cnt  : std_logic_vector(31 downto 0);
	signal s_payload_crc32       : std_logic_vector(31 downto 0);
	signal s_payload_crc32_match : std_logic;
	signal s_payload_eop_error   : std_logic;

	type t_ftdi_tx_prot_payload_reader_fsm is (
		STOPPED,                        -- payload reader stopped
		IDLE,                           -- payload reader in idle
		WAITING_RX_DATA_SOP,            -- wait until the rx fifo have data
		PAYLOAD_RX_START_OF_PAYLOAD,    -- parse a start of payload from the rx fifo (discard all data until a sop)
		WAITING_RX_READY,               -- wait until there is data to be fetched and space to write
		PRE_FETCH_DELAY,                -- pre fetch delay
		FETCH_RX_DWORD_0,               -- fetch rx dword data 0 (32b)
		FETCH_RX_DWORD_1,               -- fetch rx dword data 1 (32b)
		FETCH_RX_DWORD_2,               -- fetch rx dword data 2 (32b)
		FETCH_RX_DWORD_3,               -- fetch rx dword data 3 (32b)
		FETCH_RX_DWORD_4,               -- fetch rx dword data 4 (32b)
		FETCH_RX_DWORD_5,               -- fetch rx dword data 5 (32b)
		FETCH_RX_DWORD_6,               -- fetch rx dword data 6 (32b)
		FETCH_RX_DWORD_7,               -- fetch rx dword data 7 (32b)
		WRITE_RX_QQWORD,                -- write rx qqword data (256b)
		WAITING_QQWORD_DELAY,           -- wait until the qqword delay is finished
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER,                  -- change rx buffer
		LOAD_BUFFER,                    -- load rx buffer
		WAITING_RX_DATA_CRC,            -- wait until there is enough data in the rx fifo for the crc
		PAYLOAD_RX_PAYLOAD_CRC,         -- fetch and parse the payload crc to the rx fifo
		WAITING_RX_DATA_EOP,            -- wait until there is enough data in the rx fifo for the eop
		PAYLOAD_RX_END_OF_PAYLOAD,      -- fetch and parse a end of payload to the rx fifo
		PAYLOAD_RX_ABORT,               -- abort a payload receival (consume all data in the rx fifo)
		FINISH_PAYLOAD_RX               -- finish the payload read
	);

	signal s_ftdi_tx_prot_payload_reader_state : t_ftdi_tx_prot_payload_reader_fsm;

	signal s_rx_dword_0 : std_logic_vector(31 downto 0);
	signal s_rx_dword_1 : std_logic_vector(31 downto 0);
	signal s_rx_dword_2 : std_logic_vector(31 downto 0);
	signal s_rx_dword_3 : std_logic_vector(31 downto 0);
	signal s_rx_dword_4 : std_logic_vector(31 downto 0);
	signal s_rx_dword_5 : std_logic_vector(31 downto 0);
	signal s_rx_dword_6 : std_logic_vector(31 downto 0);
	signal s_rx_dword_7 : std_logic_vector(31 downto 0);

	signal s_qqword_delay_clear    : std_logic;
	signal s_qqword_delay_trigger  : std_logic;
	signal s_qqword_delay_busy     : std_logic;
	signal s_qqword_delay_finished : std_logic;

	subtype t_windowing_parameters_cnt is natural range 0 to 512;
	signal s_windowing_parameters_cnt : t_windowing_parameters_cnt;

begin

	qqword_delay_block_ent_inst : entity work.delay_block_ent
		generic map(
			g_CLKDIV      => std_logic_vector(to_unsigned(g_DELAY_QQWORD_CLKDIV, 16)),
			g_TIMER_WIDTH => payload_qqword_delay_i'length
		)
		port map(
			clk_i            => clk_i,
			rst_i            => rst_i,
			clr_i            => s_qqword_delay_clear,
			delay_trigger_i  => s_qqword_delay_trigger,
			delay_timer_i    => payload_qqword_delay_i,
			delay_busy_o     => s_qqword_delay_busy,
			delay_finished_o => s_qqword_delay_finished
		);

	p_ftdi_tx_prot_payload_reader : process(clk_i, rst_i) is
		variable v_ftdi_tx_prot_payload_reader_state : t_ftdi_tx_prot_payload_reader_fsm := STOPPED;
		variable v_fetch_dword                       : std_logic;
		variable v_read_dword                        : std_logic;
		variable v_mask_cnt                          : natural range 0 to 33;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_tx_prot_payload_reader_state <= STOPPED;
			v_ftdi_tx_prot_payload_reader_state := STOPPED;
			-- internal signals reset
			s_payload_length_cnt                <= (others => '0');
			s_payload_crc32_match               <= '0';
			s_payload_eop_error                 <= '0';
			s_qqword_delay_clear                <= '0';
			s_qqword_delay_trigger              <= '0';
			s_windowing_parameters_cnt          <= 0;
			v_fetch_dword                       := '0';
			v_read_dword                        := '0';
			v_mask_cnt                          := 0;
			-- outputs reset
			payload_reader_busy_o               <= '0';
			s_payload_crc32                     <= (others => '0');
			payload_crc32_match_o               <= '0';
			payload_eop_error_o                 <= '0';
			payload_last_rx_buffer_o            <= '0';
			rx_dc_data_fifo_rdreq_o             <= '0';
			buffer_data_loaded_o                <= '0';
			buffer_wrdata_o                     <= (others => '0');
			buffer_wrreq_o                      <= '0';
			s_rx_dword_0                        <= (others => '0');
			s_rx_dword_1                        <= (others => '0');
			s_rx_dword_2                        <= (others => '0');
			s_rx_dword_3                        <= (others => '0');
			s_rx_dword_4                        <= (others => '0');
			s_rx_dword_5                        <= (others => '0');
			s_rx_dword_6                        <= (others => '0');
			s_rx_dword_7                        <= (others => '0');
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_tx_prot_payload_reader_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- payload reader stopped
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= STOPPED;
					v_ftdi_tx_prot_payload_reader_state := STOPPED;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if a start command was issued
					if (data_rx_start_i = '1') then
						s_ftdi_tx_prot_payload_reader_state <= IDLE;
						v_ftdi_tx_prot_payload_reader_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- payload reader in idle
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= IDLE;
					v_ftdi_tx_prot_payload_reader_state := IDLE;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if a payload writer start was issued
					if (payload_reader_start_i = '1') then
						s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_SOP;
						v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_SOP;
						if (unsigned(payload_length_bytes_i) >= 4) then
							s_payload_length_cnt <= payload_length_bytes_i;
						else
							s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_EOP;
							v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_EOP;
						end if;
					end if;

				-- state "WAITING_RX_DATA_SOP"
				when WAITING_RX_DATA_SOP =>
					-- wait until the rx fifo have data
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_SOP;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_SOP;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if the rx dc data fifo is not empty 
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_payload_reader_state <= PAYLOAD_RX_START_OF_PAYLOAD;
						v_ftdi_tx_prot_payload_reader_state := PAYLOAD_RX_START_OF_PAYLOAD;
					end if;

				-- state "PAYLOAD_RX_START_OF_PAYLOAD"
				when PAYLOAD_RX_START_OF_PAYLOAD =>
					-- parse a start of payload from the rx fifo (discard all data until a sop)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_SOP;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_SOP;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if a start of package was detected
					if (rx_dc_data_fifo_rddata_data_i = c_FTDI_PROT_START_OF_PAYLOAD) then
						s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_READY;
						v_ftdi_tx_prot_payload_reader_state := WAITING_RX_READY;
					end if;

				-- state "WAITING_RX_READY"
				when WAITING_RX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_READY;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_READY;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					-- conditional state transition
					-- check if the remaining payload length is equivalent to a full qqword
					if (unsigned(s_payload_length_cnt) >= 32) then
						-- check (if the rx dc data fifo have at least eight dwords available) and (if the rx data buffer is ready to be written and not full) 
						if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 8)) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
							s_ftdi_tx_prot_payload_reader_state <= PRE_FETCH_DELAY;
							v_ftdi_tx_prot_payload_reader_state := PRE_FETCH_DELAY;
							v_fetch_dword                       := '1';
							v_read_dword                        := '1';
						end if;
					elsif (unsigned(s_payload_length_cnt) > 4) then
						-- check (if the rx dc data fifo have at least the (remaining payload length)/4 dwords available) and (if the rx data buffer is ready to be written and not full) 
						if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= to_integer(unsigned(s_payload_length_cnt(31 downto 2))))) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
							s_ftdi_tx_prot_payload_reader_state <= PRE_FETCH_DELAY;
							v_ftdi_tx_prot_payload_reader_state := PRE_FETCH_DELAY;
							v_fetch_dword                       := '1';
							v_read_dword                        := '1';
						end if;
					else
						-- check (if the rx dc data fifo have at least one dword available) and (if the rx data buffer is ready to be written and not full) 
						if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 1)) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
							s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_0;
							v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_0;
							v_fetch_dword                       := '1';
							v_read_dword                        := '1';
						end if;
					end if;

				-- state "PRE_FETCH_DELAY"
				when PRE_FETCH_DELAY =>
					-- pre fetch delay
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_0;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_0;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
				-- conditional state transition

				-- state "FETCH_RX_DWORD_0"
				when FETCH_RX_DWORD_0 =>
					-- fetch rx dword data 0 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_1;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_1;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_1"
				when FETCH_RX_DWORD_1 =>
					-- fetch rx dword data 1 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_2;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_2;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_2"
				when FETCH_RX_DWORD_2 =>
					-- fetch rx dword data 2 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_3;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_3;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_3"
				when FETCH_RX_DWORD_3 =>
					-- fetch rx dword data 3 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_4;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_4;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_4"
				when FETCH_RX_DWORD_4 =>
					-- fetch rx dword data 4 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_5;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_5;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_5"
				when FETCH_RX_DWORD_5 =>
					-- fetch rx dword data 5 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_6;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_6;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_6"
				when FETCH_RX_DWORD_6 =>
					-- fetch rx dword data 6 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_7;
					v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_7;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "FETCH_RX_DWORD_7"
				when FETCH_RX_DWORD_7 =>
					-- fetch rx dword data 7 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WRITE_RX_QQWORD;
					v_ftdi_tx_prot_payload_reader_state := WRITE_RX_QQWORD;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- check if the windowing parameters are over
					if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
						-- windowing parameters are over
						-- update mask counter
						if (v_mask_cnt < 33) then
							v_mask_cnt := v_mask_cnt + 1;
						else
							v_mask_cnt := 0;
						end if;
					else
						-- windowing parameters are not over
						-- keep mask counter cleared
						v_mask_cnt                 := 0;
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					end if;
					-- conditional state transition
					-- check if there is still payload to be fetched
					if (unsigned(s_payload_length_cnt) > 8) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '1';
						v_read_dword         := '1';
					elsif (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_fetch_dword        := '0';
						v_read_dword         := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_fetch_dword        := '0';
						v_read_dword         := '0';
					end if;

				-- state "WRITE_RX_QQWORD"
				when WRITE_RX_QQWORD =>
					-- write rx qqword data (256b)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WRITE_DELAY;
					v_ftdi_tx_prot_payload_reader_state := WRITE_DELAY;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if a qqword delay was specified
					if (payload_qqword_delay_i /= std_logic_vector(to_unsigned(0, payload_qqword_delay_i'length))) then
						-- a qqword delay was specified
						s_qqword_delay_trigger              <= '1';
						s_ftdi_tx_prot_payload_reader_state <= WAITING_QQWORD_DELAY;
						v_ftdi_tx_prot_payload_reader_state := WAITING_QQWORD_DELAY;
					end if;

				-- state "WAITING_QQWORD_DELAY"
				when WAITING_QQWORD_DELAY =>
					-- wait until the qqword delay is finished
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_QQWORD_DELAY;
					v_ftdi_tx_prot_payload_reader_state := WAITING_QQWORD_DELAY;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if the qqword delay is over
					if (s_qqword_delay_finished = '1') then
						-- delay finished
						s_ftdi_tx_prot_payload_reader_state <= WRITE_DELAY;
						v_ftdi_tx_prot_payload_reader_state := WRITE_DELAY;
					end if;

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_READY;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_READY;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '1';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					-- conditional state transition
					-- check if the rx data buffer is full
					if (buffer_stat_full_i = '1') then
						s_ftdi_tx_prot_payload_reader_state <= CHANGE_BUFFER;
						v_ftdi_tx_prot_payload_reader_state := CHANGE_BUFFER;
					else
						if (unsigned(s_payload_length_cnt) < 4) then
							s_ftdi_tx_prot_payload_reader_state <= LOAD_BUFFER;
							v_ftdi_tx_prot_payload_reader_state := LOAD_BUFFER;
							s_payload_length_cnt                <= (others => '0');
						else
							-- check if the remaining payload length is equivalent to a full qqword
							if (unsigned(s_payload_length_cnt) >= 32) then
								-- check (if the rx dc data fifo have at least eight dwords available) and (if the rx data buffer is ready to be written and not full) 
								if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 8)) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
									s_ftdi_tx_prot_payload_reader_state <= PRE_FETCH_DELAY;
									v_ftdi_tx_prot_payload_reader_state := PRE_FETCH_DELAY;
									v_fetch_dword                       := '1';
									v_read_dword                        := '1';
								end if;
							elsif (unsigned(s_payload_length_cnt) > 4) then
								-- check (if the rx dc data fifo have at least the (remaining payload length)/4 dwords available) and (if the rx data buffer is ready to be written and not full) 
								if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= to_integer(unsigned(s_payload_length_cnt(31 downto 2))))) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
									s_ftdi_tx_prot_payload_reader_state <= PRE_FETCH_DELAY;
									v_ftdi_tx_prot_payload_reader_state := PRE_FETCH_DELAY;
									v_fetch_dword                       := '1';
									v_read_dword                        := '1';
								end if;
							else
								-- check (if the rx dc data fifo have at least one dword available) and (if the rx data buffer is ready to be written and not full) 
								if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 1)) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
									s_ftdi_tx_prot_payload_reader_state <= FETCH_RX_DWORD_0;
									v_ftdi_tx_prot_payload_reader_state := FETCH_RX_DWORD_0;
									v_fetch_dword                       := '1';
									v_read_dword                        := '1';
								end if;
							end if;
						end if;
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_READY;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_READY;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					if (unsigned(s_payload_length_cnt) < 4) then
						s_payload_length_cnt                <= (others => '0');
						s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_CRC;
						v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_CRC;
					end if;

				-- state "LOAD_BUFFER"
				when LOAD_BUFFER =>
					-- load tx buffer
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_CRC;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_CRC;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
				-- conditional state transition

				-- state "WAITING_RX_DATA_CRC"
				when WAITING_RX_DATA_CRC =>
					-- wait until there is enough data in the rx fifo for the crc
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_CRC;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_CRC;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if there is data in the rx fifo for the crc
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_payload_reader_state <= PAYLOAD_RX_PAYLOAD_CRC;
						v_ftdi_tx_prot_payload_reader_state := PAYLOAD_RX_PAYLOAD_CRC;
					end if;

				-- state "PAYLOAD_RX_PAYLOAD_CRC"
				when PAYLOAD_RX_PAYLOAD_CRC =>
					-- fetch and parse the payload crc to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_EOP;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_EOP;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if the received payload crc32 match the calculated crc32
					if (rx_dc_data_fifo_rddata_data_i = f_ftdi_protocol_finish_crc32(s_payload_crc32)) then
						s_payload_crc32_match <= '1';
					end if;

				-- state "WAITING_RX_DATA_EOP"
				when WAITING_RX_DATA_EOP =>
					-- wait until there is enough data in the rx fifo for the eop
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= WAITING_RX_DATA_EOP;
					v_ftdi_tx_prot_payload_reader_state := WAITING_RX_DATA_EOP;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if there is data in the rx fifo for the eop
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_payload_reader_state <= PAYLOAD_RX_END_OF_PAYLOAD;
						v_ftdi_tx_prot_payload_reader_state := PAYLOAD_RX_END_OF_PAYLOAD;
					end if;

				-- state "PAYLOAD_RX_END_OF_PAYLOAD"
				when PAYLOAD_RX_END_OF_PAYLOAD =>
					-- fetch and parse a end of payload to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FINISH_PAYLOAD_RX;
					v_ftdi_tx_prot_payload_reader_state := FINISH_PAYLOAD_RX;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if a payload end of payload was not received
					if (rx_dc_data_fifo_rddata_data_i /= c_FTDI_PROT_END_OF_PAYLOAD) then
						s_payload_eop_error <= '1';
					end if;

				-- state "PAYLOAD_RX_ABORT"
				when PAYLOAD_RX_ABORT =>
					-- abort a payload receival (consume all data in the rx fifo)
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= PAYLOAD_RX_ABORT;
					v_ftdi_tx_prot_payload_reader_state := PAYLOAD_RX_ABORT;
					-- default internal signal values
					s_payload_crc32_match               <= '0';
					s_payload_eop_error                 <= '0';
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if the rx fifo is empty
					if (rx_dc_data_fifo_rdempty_i = '1') then
						-- rx fifo is empty, go to finish
						s_ftdi_tx_prot_payload_reader_state <= FINISH_PAYLOAD_RX;
						v_ftdi_tx_prot_payload_reader_state := FINISH_PAYLOAD_RX;
					end if;

				-- state "FINISH_PAYLOAD_RX"
				when FINISH_PAYLOAD_RX =>
					-- finish the payload read
					-- default state transition
					s_ftdi_tx_prot_payload_reader_state <= FINISH_PAYLOAD_RX;
					v_ftdi_tx_prot_payload_reader_state := FINISH_PAYLOAD_RX;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_fetch_dword                       := '0';
					v_read_dword                        := '0';
					v_mask_cnt                          := 0;
					-- conditional state transition
					-- check if a payload writer reset was issued
					if (payload_reader_reset_i = '1') then
						s_ftdi_tx_prot_payload_reader_state <= IDLE;
						v_ftdi_tx_prot_payload_reader_state := IDLE;
						s_payload_crc32_match               <= '0';
						s_payload_eop_error                 <= '0';
					end if;

				-- all the other states (not defined)
				when others =>
					s_ftdi_tx_prot_payload_reader_state <= STOPPED;
					v_ftdi_tx_prot_payload_reader_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_rx_stop_i = '1') then
				s_ftdi_tx_prot_payload_reader_state <= STOPPED;
				v_ftdi_tx_prot_payload_reader_state := STOPPED;
			-- check if an abort was received and the header is not stopped or in idle or in abort or finished
			elsif ((payload_reader_abort_i = '1') and ((s_ftdi_tx_prot_payload_reader_state /= STOPPED) and (s_ftdi_tx_prot_payload_reader_state /= IDLE) and (s_ftdi_tx_prot_payload_reader_state /= PAYLOAD_RX_ABORT) and (s_ftdi_tx_prot_payload_reader_state /= FINISH_PAYLOAD_RX))) then
				s_ftdi_tx_prot_payload_reader_state <= PAYLOAD_RX_ABORT;
				v_ftdi_tx_prot_payload_reader_state := PAYLOAD_RX_ABORT;
			end if;

			-- Output generation FSM
			case (v_ftdi_tx_prot_payload_reader_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- payload reader stopped
					-- default output signals
					payload_reader_busy_o    <= '0';
					s_payload_crc32          <= (others => '0');
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- payload reader in idle
					-- default output signals
					payload_reader_busy_o    <= '0';
					s_payload_crc32          <= c_FTDI_PROT_CRC32_START;
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_DATA_SOP"
				when WAITING_RX_DATA_SOP =>
					-- wait until the rx fifo have data
					-- default output signals
					payload_reader_busy_o    <= '1';
					s_payload_crc32          <= c_FTDI_PROT_CRC32_START;
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_START_OF_PAYLOAD"
				when PAYLOAD_RX_START_OF_PAYLOAD =>
					-- parse a start of payload from the rx fifo (discard all data until a sop)
					-- default output signals
					payload_reader_busy_o    <= '1';
					s_payload_crc32          <= c_FTDI_PROT_CRC32_START;
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '1';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_READY"
				when WAITING_RX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "PRE_FETCH_DELAY"
				when PRE_FETCH_DELAY =>
					-- pre fetch delay
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '1';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
					-- conditional output signals
					-- check if the word does not need to be fetched
					if (v_fetch_dword = '0') then
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;

				-- state "FETCH_RX_DWORD_0"
				when FETCH_RX_DWORD_0 =>
					-- fetch rx dword data 0 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						-- check if the windowing parameters are over
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_0(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_0(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_1 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_0 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_0 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_1"
				when FETCH_RX_DWORD_1 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_1(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_1(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_0 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_1 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_1 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_2"
				when FETCH_RX_DWORD_2 =>
					-- fetch rx dword data 2 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_2(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_2(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_3 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_2 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_2 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_3"
				when FETCH_RX_DWORD_3 =>
					-- fetch rx dword data 3 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_3(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_3(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_2 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_3 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_3 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_4"
				when FETCH_RX_DWORD_4 =>
					-- fetch rx dword data 4 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_4(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_4(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_5 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_4 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_4 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_5"
				when FETCH_RX_DWORD_5 =>
					-- fetch rx dword data 5 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_5(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_5(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_4 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_5 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_5 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_6"
				when FETCH_RX_DWORD_6 =>
					-- fetch rx dword data 6 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be fetched
					if (v_fetch_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					else
						rx_dc_data_fifo_rdreq_o <= '0';
					end if;
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_6(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_6(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_7 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_6 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_6 <= (others => '0');
					end if;

				-- state "FETCH_RX_DWORD_7"
				when FETCH_RX_DWORD_7 =>
					-- fetch rx dword data 7 (32b)
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					-- conditional output signals
					-- check if the word need to be read
					if (v_read_dword = '1') then
						if (s_windowing_parameters_cnt = t_windowing_parameters_cnt'high) then
							-- windowing parameters are over
							-- check if the data is pixels or masks
							if (v_mask_cnt < 32) then
								-- pixel data, need to swap words
								s_rx_dword_7(15 downto 0)  <= rx_dc_data_fifo_rddata_data_i(31 downto 16);
								s_rx_dword_7(31 downto 16) <= rx_dc_data_fifo_rddata_data_i(15 downto 0);
							else
								-- mask data, need to swap dwords
								s_rx_dword_6 <= rx_dc_data_fifo_rddata_data_i;
							end if;
						else
							-- windowing parameters are not over
							-- windowing parameter data, no need to swap
							s_rx_dword_7 <= rx_dc_data_fifo_rddata_data_i;
						end if;
						s_payload_crc32 <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, rx_dc_data_fifo_rddata_data_i);
					else
						s_rx_dword_7 <= (others => '0');
					end if;

				-- state "WRITE_RX_QQWORD"
				when WRITE_RX_QQWORD =>
					-- write rx qqword data (256b)
					-- default output signals
					payload_reader_busy_o           <= '1';
					payload_crc32_match_o           <= '0';
					payload_eop_error_o             <= '0';
					payload_last_rx_buffer_o        <= '0';
					rx_dc_data_fifo_rdreq_o         <= '0';
					buffer_data_loaded_o            <= '0';
					buffer_wrdata_o(31 downto 0)    <= s_rx_dword_0;
					buffer_wrdata_o(63 downto 32)   <= s_rx_dword_1;
					buffer_wrdata_o(95 downto 64)   <= s_rx_dword_2;
					buffer_wrdata_o(127 downto 96)  <= s_rx_dword_3;
					buffer_wrdata_o(159 downto 128) <= s_rx_dword_4;
					buffer_wrdata_o(191 downto 160) <= s_rx_dword_5;
					buffer_wrdata_o(223 downto 192) <= s_rx_dword_6;
					buffer_wrdata_o(255 downto 224) <= s_rx_dword_7;
					buffer_wrreq_o                  <= '1';
					-- conditional output signals
					-- check if it is the last buffer
					if (unsigned(s_payload_length_cnt) < 8) then -- payload length counter comparison need adjust to generate correct output
						payload_last_rx_buffer_o <= '1';
					end if;

				-- state "WAITING_QQWORD_DELAY"
				when WAITING_QQWORD_DELAY =>
					-- wait until the qqword delay is finished
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
					-- conditional output signals
					-- check if it is the last buffer
					if (unsigned(s_payload_length_cnt) < 4) then
						payload_last_rx_buffer_o <= '1';
					end if;

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
					-- conditional output signals
					-- check if it is the last buffer
					if (unsigned(s_payload_length_cnt) < 4) then
						payload_last_rx_buffer_o <= '1';
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change rx buffer
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
					-- conditional output signals
					-- check if it is the last buffer
					if (unsigned(s_payload_length_cnt) < 4) then
						payload_last_rx_buffer_o <= '1';
					end if;

				-- state "LOAD_BUFFER"
				when LOAD_BUFFER =>
					-- load rx buffer
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '1';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '1';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_DATA_CRC"
				when WAITING_RX_DATA_CRC =>
					-- wait until there is enough data in the rx fifo for the crc
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '1';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_PAYLOAD_CRC"
				when PAYLOAD_RX_PAYLOAD_CRC =>
					-- fetch and parse the payload crc to the rx fifo
					-- default output signals
					payload_reader_busy_o    <= '1';
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '1';
					rx_dc_data_fifo_rdreq_o  <= '1';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_DATA_EOP"
				when WAITING_RX_DATA_EOP =>
					-- wait until there is enough data in the rx fifo for the eop
					-- default output signals
					payload_reader_busy_o    <= '1';
					s_payload_crc32          <= (others => '0');
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '1';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_END_OF_PAYLOAD"
				when PAYLOAD_RX_END_OF_PAYLOAD =>
					-- fetch and parse a end of payload to the rx fifo
					-- default output signals
					payload_reader_busy_o    <= '1';
					s_payload_crc32          <= (others => '0');
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '1';
					rx_dc_data_fifo_rdreq_o  <= '1';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_ABORT"
				when PAYLOAD_RX_ABORT =>
					-- abort a payload receival (consume all data in the rx fifo)
					-- default output signals
					payload_reader_busy_o    <= '1';
					s_payload_crc32          <= (others => '0');
					payload_crc32_match_o    <= '0';
					payload_eop_error_o      <= '0';
					payload_last_rx_buffer_o <= '0';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
					-- conditional output signals
					-- check if the rx fifo must be read
					if (v_read_dword = '1') then
						rx_dc_data_fifo_rdreq_o <= '1';
					end if;

				-- state "FINISH_PAYLOAD_RX"
				when FINISH_PAYLOAD_RX =>
					-- finish the payload read
					-- default output signals
					payload_reader_busy_o    <= '0';
					s_payload_crc32          <= (others => '0');
					payload_crc32_match_o    <= s_payload_crc32_match;
					payload_eop_error_o      <= s_payload_eop_error;
					payload_last_rx_buffer_o <= '1';
					rx_dc_data_fifo_rdreq_o  <= '0';
					buffer_data_loaded_o     <= '0';
					buffer_wrdata_o          <= (others => '0');
					buffer_wrreq_o           <= '0';
					s_rx_dword_0             <= (others => '0');
					s_rx_dword_1             <= (others => '0');
					s_rx_dword_2             <= (others => '0');
					s_rx_dword_3             <= (others => '0');
					s_rx_dword_4             <= (others => '0');
					s_rx_dword_5             <= (others => '0');
					s_rx_dword_6             <= (others => '0');
					s_rx_dword_7             <= (others => '0');
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_tx_prot_payload_reader;

end architecture RTL;
