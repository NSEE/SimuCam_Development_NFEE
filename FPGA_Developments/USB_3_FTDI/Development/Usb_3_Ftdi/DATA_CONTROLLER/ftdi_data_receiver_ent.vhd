library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_data_receiver_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_rx_stop_i                : in  std_logic;
		data_rx_start_i               : in  std_logic;
		rx_dc_data_fifo_rddata_data_i : in  std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_i   : in  std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_i     : in  std_logic;
		rx_dc_data_fifo_rdusedw_i     : in  std_logic_vector(11 downto 0);
		buffer_stat_full_i            : in  std_logic;
		buffer_wrready_i              : in  std_logic;
		rx_dc_data_fifo_rdreq_o       : out std_logic;
		buffer_data_loaded_o          : out std_logic;
		buffer_wrdata_o               : out std_logic_vector(63 downto 0);
		buffer_wrreq_o                : out std_logic
	);
end entity ftdi_data_receiver_ent;

-- (Rx: FTDI => FPGA)

architecture RTL of ftdi_data_receiver_ent is

	type t_ftdi_data_receiver_fsm is (
		STOPPED,                        -- data receiver stopped
		IDLE,                           -- data receiver in idle
		FETCH_RX_DWORD_0,               -- fetch rx dword data 0 (32b)
		FETCH_RX_DWORD_1,               -- fetch rx dword data 1 (32b)
		FETCH_DELAY,                    -- fetch delay
		WRITE_RX_QWORD,                 -- write rx qword data (64b)
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER                   -- change tx buffer
	);
	signal s_ftdi_data_receiver_state : t_ftdi_data_receiver_fsm;

	signal s_rx_dword_0 : std_logic_vector(31 downto 0);
	signal s_rx_dword_1 : std_logic_vector(31 downto 0);

begin

	p_ftdi_data_receiver : process(clk_i, rst_i) is
		variable v_ftdi_data_receiver_state : t_ftdi_data_receiver_fsm := STOPPED;
	begin
		if (rst_i = '1') then

		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_data_receiver_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter stopped
					s_ftdi_data_receiver_state <= STOPPED;
					v_ftdi_data_receiver_state := STOPPED;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if a start command was issued
					if (data_tx_start_i = '1') then
						s_ftdi_data_receiver_state <= IDLE;
						v_ftdi_data_receiver_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- data receiver in idle
					s_ftdi_data_receiver_state <= IDLE;
					v_ftdi_data_receiver_state := IDLE;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if the rx dc data fifo have at least two dwords available 
					if (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 2) then
						s_ftdi_data_receiver_state <= FETCH_RX_DWORD_0;
						v_ftdi_data_receiver_state := FETCH_RX_DWORD_0;
					end if;

				-- state "FETCH_RX_DWORD_0"
				when FETCH_RX_DWORD_0 =>
					-- fetch rx dword data 0 (32b)
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_1;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_1;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_1"
				when FETCH_RX_DWORD_1 =>
					-- fetch rx dword data 1 (32b)
					s_ftdi_data_receiver_state <= FETCH_DELAY;
					v_ftdi_data_receiver_state := FETCH_DELAY;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					s_ftdi_data_receiver_state <= FETCH_DELAY;
					v_ftdi_data_receiver_state := FETCH_DELAY;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if the rx data buffer is ready to be written and not full
					if ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0')) then
						s_ftdi_data_receiver_state <= WRITE_RX_QWORD;
						v_ftdi_data_receiver_state := WRITE_RX_QWORD;
					end if;

				-- state "WRITE_RX_QWORD"
				when WRITE_RX_QWORD =>
					-- write rx qword data (64b)
					s_ftdi_data_receiver_state <= WRITE_DELAY;
					v_ftdi_data_receiver_state := WRITE_DELAY;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					s_ftdi_data_receiver_state <= IDLE;
					v_ftdi_data_receiver_state := IDLE;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if the rx data buffer is full
					if (buffer_stat_full_i = '1') then
						s_ftdi_data_receiver_state <= CHANGE_BUFFER;
						v_ftdi_data_receiver_state := CHANGE_BUFFER;
					-- check if the rx dc data fifo have at least two dwords available 
					elsif (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 2) then
						s_ftdi_data_receiver_state <= FETCH_RX_DWORD_0;
						v_ftdi_data_receiver_state := FETCH_RX_DWORD_0;
						-- check if the rx 
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					s_ftdi_data_receiver_state <= IDLE;
					v_ftdi_data_receiver_state := IDLE;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_ftdi_data_receiver_state <= STOPPED;
					v_ftdi_data_receiver_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_tx_stop_i = '1') then
				s_ftdi_data_receiver_state <= STOPPED;
				v_ftdi_data_receiver_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_data_receiver_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter stopped
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- data receiver in idle
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
				-- conditional output signals

				-- state "FETCH_RX_DWORD_0"
				when FETCH_RX_DWORD_0 =>
					-- fetch rx dword data 0 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
				-- conditional output signals

				-- state "FETCH_RX_DWORD_1"
				when FETCH_RX_DWORD_1 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_1            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "WRITE_RX_QWORD"
				when WRITE_RX_QWORD =>
					-- write rx qword data (64b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o       <= '0';
					buffer_data_loaded_o          <= '0';
					buffer_wrdata_o(31 downto 0)  <= s_rx_dword_0;
					buffer_wrdata_o(63 downto 32) <= s_rx_dword_1;
					buffer_wrreq_o                <= '1';
				-- conditional output signals

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
				-- conditional output signals

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '1';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_data_receiver;

end architecture RTL;
