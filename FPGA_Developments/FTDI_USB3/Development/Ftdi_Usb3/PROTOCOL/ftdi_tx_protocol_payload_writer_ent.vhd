library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;
use work.ftdi_protocol_crc_pkg.all;

entity ftdi_tx_protocol_payload_writer_ent is
	generic(
		g_DELAY_QQWORD_CLKDIV : natural range 0 to 65535 := 0 -- [100 MHz / 1 = 100 MHz = 10 ns]
	);
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_tx_stop_i                : in  std_logic;
		data_tx_start_i               : in  std_logic;
		payload_writer_abort_i        : in  std_logic;
		payload_writer_start_i        : in  std_logic;
		payload_writer_reset_i        : in  std_logic;
		payload_length_bytes_i        : in  std_logic_vector(31 downto 0);
		payload_qqword_delay_i        : in  std_logic_vector(15 downto 0);
		lut_winparams_ccd1_wincfg_i   : in  t_ftdi_lut_winparams_ccdx_wincfg;
		lut_winparams_ccd2_wincfg_i   : in  t_ftdi_lut_winparams_ccdx_wincfg;
		lut_winparams_ccd3_wincfg_i   : in  t_ftdi_lut_winparams_ccdx_wincfg;
		lut_winparams_ccd4_wincfg_i   : in  t_ftdi_lut_winparams_ccdx_wincfg;
		buffer_stat_empty_i           : in  std_logic;
		buffer_rddata_i               : in  std_logic_vector(255 downto 0);
		buffer_rdready_i              : in  std_logic;
		tx_dc_data_fifo_wrempty_i     : in  std_logic;
		tx_dc_data_fifo_wrfull_i      : in  std_logic;
		tx_dc_data_fifo_wrusedw_i     : in  std_logic_vector(11 downto 0);
		payload_writer_busy_o         : out std_logic;
		buffer_rdreq_o                : out std_logic;
		buffer_change_o               : out std_logic;
		tx_dc_data_fifo_wrdata_data_o : out std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_o   : out std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_o       : out std_logic
	);
end entity ftdi_tx_protocol_payload_writer_ent;

-- (Tx: FPGA => FTDI)

architecture RTL of ftdi_tx_protocol_payload_writer_ent is

	signal s_payload_length_cnt : std_logic_vector(31 downto 0);
	signal s_payload_crc32      : std_logic_vector(31 downto 0);

	type t_ftdi_tx_prot_payload_writer_fsm is (
		STOPPED,                        -- payload writer stopped
		IDLE,                           -- payload writer idle
		WAITING_TX_DATA_SOP,            -- wait until there is enough space in the tx fifo for the sop (4 Bytes)
		WRITE_TX_START_OF_PAYLOAD,      -- write a start of payload to the tx fifo
		WAITING_TX_WIND_PARAMS,         -- wait until there is enough space in the tx fifo for the windowing parameters (512 Bytes)
		WRITE_TX_WIND_PARAMS,           -- write the windowing parameters to the tx fifo
		WAITING_TX_READY,               -- wait until there is data to be fetched and space to write
		FETCH_TX_QQWORD,                -- fetch tx qqword data (256b)
		FETCH_DELAY,                    -- fetch delay
		WRITE_TX_DWORD_0,               -- write tx dword data 0 (32b)
		WRITE_TX_DWORD_1,               -- write tx dword data 1 (32b)
		WRITE_TX_DWORD_2,               -- write tx dword data 2 (32b)
		WRITE_TX_DWORD_3,               -- write tx dword data 3 (32b)
		WRITE_TX_DWORD_4,               -- write tx dword data 4 (32b)
		WRITE_TX_DWORD_5,               -- write tx dword data 5 (32b)
		WRITE_TX_DWORD_6,               -- write tx dword data 6 (32b)
		WRITE_TX_DWORD_7,               -- write tx dword data 7 (32b)
		WAITING_QQWORD_DELAY,           -- wait until the qqword delay is finished
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER,                  -- change tx buffer
		WAITING_TX_SPACE_CRC,           -- wait until there is enough space in the tx fifo for the crc and eop (4 Bytes)
		WRITE_TX_PAYLOAD_CRC,           -- write the payload crc to the tx fifo
		WAITING_TX_SPACE_EOP,           -- wait until there is enough space in the tx fifo for the eop (4 Bytes)
		WRITE_TX_END_OF_PAYLOAD,        -- write a end of payload to the tx fifo
		PAYLOAD_TX_ABORT,               -- abort a payload transmission (consume all data in the tx buffer)
		FINISH_PAYLOAD_TX               -- finish the payload write
	);
	signal s_ftdi_tx_prot_payload_writer_state : t_ftdi_tx_prot_payload_writer_fsm;

	signal s_tx_dword_0 : std_logic_vector(31 downto 0);
	signal s_tx_dword_1 : std_logic_vector(31 downto 0);
	signal s_tx_dword_2 : std_logic_vector(31 downto 0);
	signal s_tx_dword_3 : std_logic_vector(31 downto 0);
	signal s_tx_dword_4 : std_logic_vector(31 downto 0);
	signal s_tx_dword_5 : std_logic_vector(31 downto 0);
	signal s_tx_dword_6 : std_logic_vector(31 downto 0);
	signal s_tx_dword_7 : std_logic_vector(31 downto 0);

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

	p_ftdi_tx_protocol_payload_writer : process(clk_i, rst_i) is
		variable v_ftdi_tx_prot_payload_writer_state : t_ftdi_tx_prot_payload_writer_fsm := STOPPED;
		variable v_write_dword                       : std_logic;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_tx_prot_payload_writer_state <= STOPPED;
			v_ftdi_tx_prot_payload_writer_state := STOPPED;
			-- internal signals reset
			s_payload_length_cnt                <= (others => '0');
			s_qqword_delay_clear                <= '0';
			s_qqword_delay_trigger              <= '0';
			s_windowing_parameters_cnt          <= 0;
			v_write_dword                       := '0';
			-- outputs reset
			payload_writer_busy_o               <= '0';
			s_payload_crc32                     <= (others => '0');
			buffer_rdreq_o                      <= '0';
			buffer_change_o                     <= '0';
			tx_dc_data_fifo_wrdata_data_o       <= (others => '0');
			tx_dc_data_fifo_wrdata_be_o         <= (others => '0');
			tx_dc_data_fifo_wrreq_o             <= '0';
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_tx_prot_payload_writer_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- payload writer stopped
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= STOPPED;
					v_ftdi_tx_prot_payload_writer_state := STOPPED;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if a start command was issued
					if (data_tx_start_i = '1') then
						s_ftdi_tx_prot_payload_writer_state <= IDLE;
						v_ftdi_tx_prot_payload_writer_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- payload writer idle
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= IDLE;
					v_ftdi_tx_prot_payload_writer_state := IDLE;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if a payload writer start was issued
					if (payload_writer_start_i = '1') then
						s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_DATA_SOP;
						v_ftdi_tx_prot_payload_writer_state := WAITING_TX_DATA_SOP;
						if (unsigned(payload_length_bytes_i) >= 4) then
							s_payload_length_cnt <= payload_length_bytes_i;
						else
							s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_EOP;
							v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_EOP;
						end if;
					end if;

				-- state "WAITING_TX_DATA_SOP"
				when WAITING_TX_DATA_SOP =>
					-- wait until there is enough space in the tx fifo for the sop 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_DATA_SOP;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_DATA_SOP;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if there is enough space in the tx fifo for the sop
					if (tx_dc_data_fifo_wrfull_i = '0') then
						s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_START_OF_PAYLOAD;
						v_ftdi_tx_prot_payload_writer_state := WRITE_TX_START_OF_PAYLOAD;
					end if;

				-- state "WRITE_TX_START_OF_PAYLOAD"
				when WRITE_TX_START_OF_PAYLOAD =>
					-- write a start of payload to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_WIND_PARAMS;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_WIND_PARAMS;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_write_dword                       := '0';
				-- conditional state transition

				-- state "WAITING_TX_WIND_PARAMS"
				when WAITING_TX_WIND_PARAMS =>
					-- wait until there is enough space in the tx fifo for the windowing parameters (512 Bytes)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_WIND_PARAMS;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_WIND_PARAMS;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if there is enough space in the tx fifo for the windowing parameters (512 Bytes / 128 32-bit FIFO words)
					if ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 128 - 4))) then
						s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_WIND_PARAMS;
						v_ftdi_tx_prot_payload_writer_state := WRITE_TX_WIND_PARAMS;
					end if;

				-- state "WRITE_TX_WIND_PARAMS"
				when WRITE_TX_WIND_PARAMS =>
					-- write the windowing parameters to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_WIND_PARAMS;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_WIND_PARAMS;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					s_windowing_parameters_cnt          <= 0;
					-- conditional state transition
					-- check if the windowing parameters write are over
					if (s_windowing_parameters_cnt < 512) then
						-- windowing parameters write are not over
						-- write more windowing parameters
						-- check if there is still payload to be writed
						if (unsigned(s_payload_length_cnt) >= 4) then
							-- decrement payload length cnt
							s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
							-- set write flag to write
							v_write_dword        := '1';
						else
							-- clear payload length cnt
							s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
							-- set write flag to not write
							v_write_dword        := '0';
						end if;
						-- update windowing parameters counter
						s_windowing_parameters_cnt <= s_windowing_parameters_cnt + 4;
					else
						-- windowing parameters write are over
						-- set write flag to not write
						v_write_dword := '0';
						-- check if there still payload to be written
						if (unsigned(s_payload_length_cnt) >= 4) then
							-- there is still payload to be written
							-- go to waiting tx ready
							s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
							v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
						else
							-- there is no more payload to be written
							-- go to waiting tx space crc
							s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
							v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
						end if;
					end if;

				-- state "WAITING_TX_READY"
				when WAITING_TX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					-- check (if the tx data buffer is ready and not empty) and (if there is enough space in the tx dc data fifo for the fetched qword) 
					if (((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) and ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8 - 4)))) then
						s_ftdi_tx_prot_payload_writer_state <= FETCH_TX_QQWORD;
						v_ftdi_tx_prot_payload_writer_state := FETCH_TX_QQWORD;
					end if;

				-- state "FETCH_TX_QQWORD"
				when FETCH_TX_QQWORD =>
					-- fetch tx qqword data (256b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= FETCH_DELAY;
					v_ftdi_tx_prot_payload_writer_state := FETCH_DELAY;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
				-- conditional state transition

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_0;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_0;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '1';
				-- conditional state transition

				-- state "WRITE_TX_DWORD_0"
				when WRITE_TX_DWORD_0 =>
					-- write tx dword data 0 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_1;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_1;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_2;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_2;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_2"
				when WRITE_TX_DWORD_2 =>
					-- write tx dword data 2 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_3;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_3;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_3"
				when WRITE_TX_DWORD_3 =>
					-- write tx dword data 3 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_4;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_4;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_4"
				when WRITE_TX_DWORD_4 =>
					-- write tx dword data 4 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_5;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_5;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_5"
				when WRITE_TX_DWORD_5 =>
					-- write tx dword data 5 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_6;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_6;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_6"
				when WRITE_TX_DWORD_6 =>
					-- write tx dword data 6 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_DWORD_7;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_DWORD_7;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;

				-- state "WRITE_TX_DWORD_7"
				when WRITE_TX_DWORD_7 =>
					-- write tx dword data 7 (32b)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_DELAY;
					v_ftdi_tx_prot_payload_writer_state := WRITE_DELAY;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					-- conditional state transition
					-- check if there is still payload to be writed
					if (unsigned(s_payload_length_cnt) > 4) then
						s_payload_length_cnt <= std_logic_vector(unsigned(s_payload_length_cnt) - 4);
						v_write_dword        := '1';
					else
						s_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_payload_length_cnt'length));
						v_write_dword        := '0';
					end if;
					-- check if a qqword delay was specified
					if (payload_qqword_delay_i /= std_logic_vector(to_unsigned(0, payload_qqword_delay_i'length))) then
						-- a qqword delay was specified
						s_qqword_delay_trigger              <= '1';
						s_ftdi_tx_prot_payload_writer_state <= WAITING_QQWORD_DELAY;
						v_ftdi_tx_prot_payload_writer_state := WAITING_QQWORD_DELAY;
					end if;

				-- state "WAITING_QQWORD_DELAY"
				when WAITING_QQWORD_DELAY =>
					-- wait until the qqword delay is finished
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_QQWORD_DELAY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_QQWORD_DELAY;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if the qqword delay is over
					if (s_qqword_delay_finished = '1') then
						-- delay finished
						s_ftdi_tx_prot_payload_writer_state <= WRITE_DELAY;
						v_ftdi_tx_prot_payload_writer_state := WRITE_DELAY;
					end if;

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if the tx data buffer is empty
					if (buffer_stat_empty_i = '1') then
						-- tx data buffer empty, change the buffer
						s_ftdi_tx_prot_payload_writer_state <= CHANGE_BUFFER;
						v_ftdi_tx_prot_payload_writer_state := CHANGE_BUFFER;
					else
						if (unsigned(s_payload_length_cnt) < 4) then
							s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
							v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
							s_payload_length_cnt                <= (others => '0');
						else
							-- check (if the tx data buffer is ready and not empty) and (if there is enough space in the tx dc data fifo for the fetched qword)
							if (((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) and ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8 - 4)))) then
								s_ftdi_tx_prot_payload_writer_state <= FETCH_TX_QQWORD;
								v_ftdi_tx_prot_payload_writer_state := FETCH_TX_QQWORD;
							end if;
						end if;
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_READY;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_READY;
					-- default internal signal values
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					if (unsigned(s_payload_length_cnt) < 4) then
						s_payload_length_cnt                <= (others => '0');
						s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
						v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
					end if;

				-- state "WAITING_TX_SPACE_CRC"
				when WAITING_TX_SPACE_CRC =>
					-- wait until there is enough space in the tx fifo for the crc and eop 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_CRC;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_CRC;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if there is enough space in the tx fifo for the crc and eop
					if ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 2 - 4))) then
						s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_PAYLOAD_CRC;
						v_ftdi_tx_prot_payload_writer_state := WRITE_TX_PAYLOAD_CRC;
					end if;

				-- state "WRITE_TX_PAYLOAD_CRC"
				when WRITE_TX_PAYLOAD_CRC =>
					-- write the payload crc to the tx fifo
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_END_OF_PAYLOAD;
					v_ftdi_tx_prot_payload_writer_state := WRITE_TX_END_OF_PAYLOAD;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
				-- conditional state transition

				-- state "WAITING_TX_SPACE_EOP"
				when WAITING_TX_SPACE_EOP =>
					-- wait until there is enough space in the tx fifo for the eop 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= WAITING_TX_SPACE_EOP;
					v_ftdi_tx_prot_payload_writer_state := WAITING_TX_SPACE_EOP;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					if (tx_dc_data_fifo_wrfull_i = '0') then
						s_ftdi_tx_prot_payload_writer_state <= WRITE_TX_PAYLOAD_CRC;
						v_ftdi_tx_prot_payload_writer_state := WRITE_TX_PAYLOAD_CRC;
					end if;

				-- state "WRITE_TX_END_OF_PAYLOAD"
				when WRITE_TX_END_OF_PAYLOAD =>
					-- write a end of payload to the tx fifo 
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= FINISH_PAYLOAD_TX;
					v_ftdi_tx_prot_payload_writer_state := FINISH_PAYLOAD_TX;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
				-- conditional state transition

				-- state "PAYLOAD_TX_ABORT"
				when PAYLOAD_TX_ABORT =>
					-- abort a payload transmission (consume all data in the tx buffer)
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= PAYLOAD_TX_ABORT;
					v_ftdi_tx_prot_payload_writer_state := PAYLOAD_TX_ABORT;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if the tx buffer is empty
					if ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
						-- tx buffer is empty, go to finish
						s_ftdi_tx_prot_payload_writer_state <= FINISH_PAYLOAD_TX;
						v_ftdi_tx_prot_payload_writer_state := FINISH_PAYLOAD_TX;
					end if;

				-- state "FINISH_PAYLOAD_TX"
				when FINISH_PAYLOAD_TX =>
					-- finish the payload write
					-- default state transition
					s_ftdi_tx_prot_payload_writer_state <= FINISH_PAYLOAD_TX;
					v_ftdi_tx_prot_payload_writer_state := FINISH_PAYLOAD_TX;
					-- default internal signal values
					s_payload_length_cnt                <= (others => '0');
					s_qqword_delay_clear                <= '0';
					s_qqword_delay_trigger              <= '0';
					v_write_dword                       := '0';
					-- conditional state transition
					-- check if a payload writer reset was issued
					if (payload_writer_reset_i = '1') then
						s_ftdi_tx_prot_payload_writer_state <= IDLE;
						v_ftdi_tx_prot_payload_writer_state := IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					s_ftdi_tx_prot_payload_writer_state <= STOPPED;
					v_ftdi_tx_prot_payload_writer_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_tx_stop_i = '1') then
				s_ftdi_tx_prot_payload_writer_state <= STOPPED;
				v_ftdi_tx_prot_payload_writer_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_tx_prot_payload_writer_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- payload writer stopped
					-- default output signals
					payload_writer_busy_o         <= '0';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- payload writer idle
					-- default output signals
					payload_writer_busy_o         <= '0';
					s_payload_crc32               <= c_FTDI_PROT_CRC32_START;
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WAITING_TX_DATA_SOP"
				when WAITING_TX_DATA_SOP =>
					-- wait until there is enough space in the tx fifo for the sop 
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_START_OF_PAYLOAD"
				when WRITE_TX_START_OF_PAYLOAD =>
					-- write a start of payload to the tx fifo
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= c_FTDI_PROT_START_OF_PAYLOAD;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WAITING_TX_WIND_PARAMS"
				when WAITING_TX_WIND_PARAMS =>
					-- wait until there is enough space in the tx fifo for the windowing parameters (512 Bytes)
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_WIND_PARAMS"
				when WRITE_TX_WIND_PARAMS =>
					-- write the windowing parameters to the tx fifo
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o     <= '1';
						tx_dc_data_fifo_wrdata_be_o <= (others => '1');
						-- set the correct windowing parameters according to the windowing parameters counter
						case (s_windowing_parameters_cnt) is
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_window_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_window_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_PKT_ORDER_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_packet_order_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_packet_order_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_LENGTH_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_window_list_length;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_window_list_length);
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_X_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_windows_size_x;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_windows_size_x);
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_Y_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_windows_size_y;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_windows_size_y);
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_E_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_last_e_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_last_e_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD0_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_F_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd1_wincfg_i.ccdx_last_f_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd1_wincfg_i.ccdx_last_f_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_window_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_window_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_PKT_ORDER_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_packet_order_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_packet_order_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_LENGTH_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_window_list_length;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_window_list_length);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_X_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_windows_size_x;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_windows_size_x);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_Y_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_windows_size_y;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_windows_size_y);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_E_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_last_e_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_last_e_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD1_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_F_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd2_wincfg_i.ccdx_last_f_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd2_wincfg_i.ccdx_last_f_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_window_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_window_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_PKT_ORDER_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_packet_order_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_packet_order_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_LENGTH_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_window_list_length;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_window_list_length);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_X_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_windows_size_x;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_windows_size_x);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_Y_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_windows_size_y;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_windows_size_y);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_E_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_last_e_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_last_e_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD2_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_F_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd3_wincfg_i.ccdx_last_f_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd3_wincfg_i.ccdx_last_f_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_window_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_window_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_PKT_ORDER_LIST_PRT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_packet_order_list_pointer;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_packet_order_list_pointer);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIN_LIST_LENGTH_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_window_list_length;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_window_list_length);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_X_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_windows_size_x;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_windows_size_x);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_WIND_SIZE_Y_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_windows_size_y;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_windows_size_y);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_E_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_last_e_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_last_e_packet);
							when (c_FTDI_LUT_WINPARAMS_CCD3_WINCFG_OFFSET + c_FTDI_LUT_WINPARAMS_CCDx_LAST_F_PKT_OFFSET) =>
								tx_dc_data_fifo_wrdata_data_o <= lut_winparams_ccd4_wincfg_i.ccdx_last_f_packet;
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, lut_winparams_ccd4_wincfg_i.ccdx_last_f_packet);
							when others =>
								tx_dc_data_fifo_wrdata_data_o <= x"00000000";
								s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, x"00000000");
						end case;
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WAITING_TX_READY"
				when WAITING_TX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "FETCH_TX_QQWORD"
				when FETCH_TX_QQWORD =>
					-- fetch tx qqword data (256b)
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '1';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_0"
				when WRITE_TX_DWORD_0 =>
					-- write tx dword data 0 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_0;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_0);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_1;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_1);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_2"
				when WRITE_TX_DWORD_2 =>
					-- write tx dword data 2 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_2;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_2);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_3"
				when WRITE_TX_DWORD_3 =>
					-- write tx dword data 3 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_3;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_3);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_4"
				when WRITE_TX_DWORD_4 =>
					-- write tx dword data 4 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_4;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_4);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_5"
				when WRITE_TX_DWORD_5 =>
					-- write tx dword data 5 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_5;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_5);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_6"
				when WRITE_TX_DWORD_6 =>
					-- write tx dword data 6 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_6;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_6);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WRITE_TX_DWORD_7"
				when WRITE_TX_DWORD_7 =>
					-- write tx dword data 7 (32b)
					-- default output signals
					payload_writer_busy_o <= '1';
					buffer_rdreq_o        <= '0';
					buffer_change_o       <= '0';
					-- conditional output signals
					-- check if the word need to be written
					if (v_write_dword = '1') then
						tx_dc_data_fifo_wrreq_o       <= '1';
						tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_7;
						tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
						s_payload_crc32               <= f_ftdi_protocol_calculate_crc32_dword(s_payload_crc32, s_tx_dword_7);
					else
						tx_dc_data_fifo_wrreq_o       <= '0';
						tx_dc_data_fifo_wrdata_data_o <= (others => '0');
						tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					end if;

				-- state "WAITING_QQWORD_DELAY"
				when WAITING_QQWORD_DELAY =>
					-- wait until the qqword delay is finished
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WAITING_TX_SPACE_CRC"
				when WAITING_TX_SPACE_CRC =>
					-- wait until there is enough space in the tx fifo for the crc and eop 
					-- default output signals
					payload_writer_busy_o         <= '1';
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_PAYLOAD_CRC"
				when WRITE_TX_PAYLOAD_CRC =>
					-- write the payload crc to the tx fifo
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= f_ftdi_protocol_finish_crc32(s_payload_crc32);
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WAITING_TX_SPACE_EOP"
				when WAITING_TX_SPACE_EOP =>
					-- wait until there is enough space in the tx fifo for the eop
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WRITE_TX_END_OF_PAYLOAD"
				when WRITE_TX_END_OF_PAYLOAD =>
					-- write a end of payload to the tx fifo
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= c_FTDI_PROT_END_OF_PAYLOAD;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "PAYLOAD_TX_ABORT"
				when PAYLOAD_TX_ABORT =>
					-- abort a payload transmission (consume all data in the tx buffer)
					-- default output signals
					payload_writer_busy_o         <= '1';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '1';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "FINISH_PAYLOAD_TX"
				when FINISH_PAYLOAD_TX =>
					-- finish the payload write
					-- default output signals
					payload_writer_busy_o         <= '0';
					s_payload_crc32               <= (others => '0');
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_tx_protocol_payload_writer;

	-- Signals Assingments
	-- qqword to dword 0 assigments and endianess correction 
	s_tx_dword_0(31 downto 24) <= buffer_rddata_i(7 downto 0);
	s_tx_dword_0(23 downto 16) <= buffer_rddata_i(15 downto 8);
	s_tx_dword_0(15 downto 8)  <= buffer_rddata_i(23 downto 16);
	s_tx_dword_0(7 downto 0)   <= buffer_rddata_i(31 downto 24);
	-- qqword to dword 1 assigments and endianess correction
	s_tx_dword_1(31 downto 24) <= buffer_rddata_i(39 downto 32);
	s_tx_dword_1(23 downto 16) <= buffer_rddata_i(47 downto 40);
	s_tx_dword_1(15 downto 8)  <= buffer_rddata_i(55 downto 48);
	s_tx_dword_1(7 downto 0)   <= buffer_rddata_i(63 downto 56);
	-- qqword to dword 2 assigments and endianess correction
	s_tx_dword_2(31 downto 24) <= buffer_rddata_i(71 downto 64);
	s_tx_dword_2(23 downto 16) <= buffer_rddata_i(79 downto 72);
	s_tx_dword_2(15 downto 8)  <= buffer_rddata_i(87 downto 80);
	s_tx_dword_2(7 downto 0)   <= buffer_rddata_i(95 downto 88);
	-- qqword to dword 3 assigments and endianess correction
	s_tx_dword_3(31 downto 24) <= buffer_rddata_i(103 downto 96);
	s_tx_dword_3(23 downto 16) <= buffer_rddata_i(111 downto 104);
	s_tx_dword_3(15 downto 8)  <= buffer_rddata_i(119 downto 112);
	s_tx_dword_3(7 downto 0)   <= buffer_rddata_i(127 downto 120);
	-- qqword to dword 4 assigments and endianess correction
	s_tx_dword_4(31 downto 24) <= buffer_rddata_i(135 downto 128);
	s_tx_dword_4(23 downto 16) <= buffer_rddata_i(143 downto 136);
	s_tx_dword_4(15 downto 8)  <= buffer_rddata_i(151 downto 144);
	s_tx_dword_4(7 downto 0)   <= buffer_rddata_i(159 downto 152);
	-- qqword to dword 5 assigments and endianess correction
	s_tx_dword_5(31 downto 24) <= buffer_rddata_i(167 downto 160);
	s_tx_dword_5(23 downto 16) <= buffer_rddata_i(175 downto 168);
	s_tx_dword_5(15 downto 8)  <= buffer_rddata_i(183 downto 176);
	s_tx_dword_5(7 downto 0)   <= buffer_rddata_i(191 downto 184);
	-- qqword to dword 6 assigments and endianess correction
	s_tx_dword_6(31 downto 24) <= buffer_rddata_i(199 downto 192);
	s_tx_dword_6(23 downto 16) <= buffer_rddata_i(207 downto 200);
	s_tx_dword_6(15 downto 8)  <= buffer_rddata_i(215 downto 208);
	s_tx_dword_6(7 downto 0)   <= buffer_rddata_i(223 downto 216);
	-- qqword to dword 7 assigments and endianess correction
	s_tx_dword_7(31 downto 24) <= buffer_rddata_i(231 downto 224);
	s_tx_dword_7(23 downto 16) <= buffer_rddata_i(239 downto 232);
	s_tx_dword_7(15 downto 8)  <= buffer_rddata_i(247 downto 240);
	s_tx_dword_7(7 downto 0)   <= buffer_rddata_i(255 downto 248);

end architecture RTL;
