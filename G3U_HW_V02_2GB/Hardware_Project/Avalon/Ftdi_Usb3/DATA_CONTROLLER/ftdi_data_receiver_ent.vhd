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
		rx_dc_data_fifo_rdfull_i      : in  std_logic;
		rx_dc_data_fifo_rdusedw_i     : in  std_logic_vector(11 downto 0);
		buffer_stat_full_i            : in  std_logic;
		buffer_wrready_i              : in  std_logic;
		rx_dc_data_fifo_rdreq_o       : out std_logic;
		buffer_data_loaded_o          : out std_logic;
		buffer_wrdata_o               : out std_logic_vector(255 downto 0);
		buffer_wrreq_o                : out std_logic
	);
end entity ftdi_data_receiver_ent;

-- (Rx: FTDI => FPGA)

architecture RTL of ftdi_data_receiver_ent is

	type t_ftdi_data_receiver_fsm is (
		STOPPED,                        -- data receiver stopped
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
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER                   -- change rx buffer
	);
	signal s_ftdi_data_receiver_state : t_ftdi_data_receiver_fsm;

	signal s_rx_dword_0 : std_logic_vector(31 downto 0);
	signal s_rx_dword_1 : std_logic_vector(31 downto 0);
	signal s_rx_dword_2 : std_logic_vector(31 downto 0);
	signal s_rx_dword_3 : std_logic_vector(31 downto 0);
	signal s_rx_dword_4 : std_logic_vector(31 downto 0);
	signal s_rx_dword_5 : std_logic_vector(31 downto 0);
	signal s_rx_dword_6 : std_logic_vector(31 downto 0);
	signal s_rx_dword_7 : std_logic_vector(31 downto 0);

begin

	p_ftdi_data_receiver : process(clk_i, rst_i) is
		variable v_ftdi_data_receiver_state : t_ftdi_data_receiver_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_data_receiver_state <= STOPPED;
			v_ftdi_data_receiver_state := STOPPED;
			-- internal signals reset
			-- outputs reset
			rx_dc_data_fifo_rdreq_o    <= '0';
			buffer_data_loaded_o       <= '0';
			buffer_wrdata_o            <= (others => '0');
			buffer_wrreq_o             <= '0';
			s_rx_dword_0               <= (others => '0');
			s_rx_dword_1               <= (others => '0');
			s_rx_dword_2               <= (others => '0');
			s_rx_dword_3               <= (others => '0');
			s_rx_dword_4               <= (others => '0');
			s_rx_dword_5               <= (others => '0');
			s_rx_dword_6               <= (others => '0');
			s_rx_dword_7               <= (others => '0');
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_data_receiver_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data receiver stopped
					-- default state transition
					s_ftdi_data_receiver_state <= STOPPED;
					v_ftdi_data_receiver_state := STOPPED;
					-- default internal signal values
					-- conditional state transition
					-- check if a start command was issued
					if (data_rx_start_i = '1') then
						s_ftdi_data_receiver_state <= WAITING_RX_READY;
						v_ftdi_data_receiver_state := WAITING_RX_READY;
					end if;

				-- state "WAITING_RX_READY"
				when WAITING_RX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default state transition
					s_ftdi_data_receiver_state <= WAITING_RX_READY;
					v_ftdi_data_receiver_state := WAITING_RX_READY;
					-- default internal signal values
					-- conditional state transition
					-- check (if the rx dc data fifo have at least eight dwords available) and (if the rx data buffer is ready to be written and not full) 
					if (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 8)) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
						s_ftdi_data_receiver_state <= PRE_FETCH_DELAY;
						v_ftdi_data_receiver_state := PRE_FETCH_DELAY;
					end if;

				-- state "PRE_FETCH_DELAY"
				when PRE_FETCH_DELAY =>
					-- pre fetch delay
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_0;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_0;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_0"
				when FETCH_RX_DWORD_0 =>
					-- fetch rx dword data 0 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_1;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_1;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_1"
				when FETCH_RX_DWORD_1 =>
					-- fetch rx dword data 1 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_2;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_2;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_2"
				when FETCH_RX_DWORD_2 =>
					-- fetch rx dword data 2 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_3;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_3;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_3"
				when FETCH_RX_DWORD_3 =>
					-- fetch rx dword data 3 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_4;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_4;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_4"
				when FETCH_RX_DWORD_4 =>
					-- fetch rx dword data 4 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_5;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_5;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_5"
				when FETCH_RX_DWORD_5 =>
					-- fetch rx dword data 5 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_6;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_6;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_6"
				when FETCH_RX_DWORD_6 =>
					-- fetch rx dword data 6 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= FETCH_RX_DWORD_7;
					v_ftdi_data_receiver_state := FETCH_RX_DWORD_7;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_RX_DWORD_7"
				when FETCH_RX_DWORD_7 =>
					-- fetch rx dword data 7 (32b)
					-- default state transition
					s_ftdi_data_receiver_state <= WRITE_RX_QQWORD;
					v_ftdi_data_receiver_state := WRITE_RX_QQWORD;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_RX_QQWORD"
				when WRITE_RX_QQWORD =>
					-- write rx qqword data (256b)
					s_ftdi_data_receiver_state <= WRITE_DELAY;
					v_ftdi_data_receiver_state := WRITE_DELAY;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default state transition
					s_ftdi_data_receiver_state <= WAITING_RX_READY;
					v_ftdi_data_receiver_state := WAITING_RX_READY;
					-- default internal signal values
					-- conditional state transition
					-- check if the rx data buffer is full
					if (buffer_stat_full_i = '1') then
						s_ftdi_data_receiver_state <= CHANGE_BUFFER;
						v_ftdi_data_receiver_state := CHANGE_BUFFER;
					-- check (if the rx dc data fifo have at least eight dwords available) and (if the rx data buffer is ready to be written and not full) 
					elsif (((rx_dc_data_fifo_rdfull_i = '1') or (to_integer(unsigned(rx_dc_data_fifo_rdusedw_i)) >= 8)) and ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0'))) then
						s_ftdi_data_receiver_state <= PRE_FETCH_DELAY;
						v_ftdi_data_receiver_state := PRE_FETCH_DELAY;
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change rx buffer
					-- default state transition
					s_ftdi_data_receiver_state <= WAITING_RX_READY;
					v_ftdi_data_receiver_state := WAITING_RX_READY;
				-- default internal signal values
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_ftdi_data_receiver_state <= STOPPED;
					v_ftdi_data_receiver_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_rx_stop_i = '1') then
				s_ftdi_data_receiver_state <= STOPPED;
				v_ftdi_data_receiver_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_data_receiver_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data receiver stopped
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
					s_rx_dword_2            <= (others => '0');
					s_rx_dword_3            <= (others => '0');
					s_rx_dword_4            <= (others => '0');
					s_rx_dword_5            <= (others => '0');
					s_rx_dword_6            <= (others => '0');
					s_rx_dword_7            <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_READY"
				when WAITING_RX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
					s_rx_dword_2            <= (others => '0');
					s_rx_dword_3            <= (others => '0');
					s_rx_dword_4            <= (others => '0');
					s_rx_dword_5            <= (others => '0');
					s_rx_dword_6            <= (others => '0');
					s_rx_dword_7            <= (others => '0');
				-- conditional output signals

				-- state "PRE_FETCH_DELAY"
				when PRE_FETCH_DELAY =>
					-- pre fetch delay
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
					s_rx_dword_2            <= (others => '0');
					s_rx_dword_3            <= (others => '0');
					s_rx_dword_4            <= (others => '0');
					s_rx_dword_5            <= (others => '0');
					s_rx_dword_6            <= (others => '0');
					s_rx_dword_7            <= (others => '0');
				-- conditional output signals

				-- state "FETCH_RX_DWORD_0"
				when FETCH_RX_DWORD_0 =>
					-- fetch rx dword data 0 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_1"
				when FETCH_RX_DWORD_1 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_1            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_2"
				when FETCH_RX_DWORD_2 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_2            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_3"
				when FETCH_RX_DWORD_3 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_3            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_4"
				when FETCH_RX_DWORD_4 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_4            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_5"
				when FETCH_RX_DWORD_5 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_5            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_6"
				when FETCH_RX_DWORD_6 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '1';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_6            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "FETCH_RX_DWORD_7"
				when FETCH_RX_DWORD_7 =>
					-- fetch rx dword data 1 (32b)
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_7            <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "WRITE_RX_QQWORD"
				when WRITE_RX_QQWORD =>
					-- write rx qqword data (256b)
					-- default output signals
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
					s_rx_dword_2            <= (others => '0');
					s_rx_dword_3            <= (others => '0');
					s_rx_dword_4            <= (others => '0');
					s_rx_dword_5            <= (others => '0');
					s_rx_dword_6            <= (others => '0');
					s_rx_dword_7            <= (others => '0');
				-- conditional output signals

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change rx buffer
					-- default output signals
					rx_dc_data_fifo_rdreq_o <= '0';
					buffer_data_loaded_o    <= '0';
					buffer_wrdata_o         <= (others => '0');
					buffer_wrreq_o          <= '0';
					s_rx_dword_0            <= (others => '0');
					s_rx_dword_1            <= (others => '0');
					s_rx_dword_2            <= (others => '0');
					s_rx_dword_3            <= (others => '0');
					s_rx_dword_4            <= (others => '0');
					s_rx_dword_5            <= (others => '0');
					s_rx_dword_6            <= (others => '0');
					s_rx_dword_7            <= (others => '0');
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_data_receiver;

end architecture RTL;
