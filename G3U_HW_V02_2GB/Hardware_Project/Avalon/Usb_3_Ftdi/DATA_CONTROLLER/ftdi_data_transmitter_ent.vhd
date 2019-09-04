library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_data_transmitter_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_tx_stop_i                : in  std_logic;
		data_tx_start_i               : in  std_logic;
		buffer_stat_empty_i           : in  std_logic;
		buffer_rddata_i               : in  std_logic_vector(255 downto 0);
		buffer_rdready_i              : in  std_logic;
		tx_dc_data_fifo_wrempty_i     : in  std_logic;
		tx_dc_data_fifo_wrfull_i      : in  std_logic;
		tx_dc_data_fifo_wrusedw_i     : in  std_logic_vector(11 downto 0);
		buffer_rdreq_o                : out std_logic;
		buffer_change_o               : out std_logic;
		tx_dc_data_fifo_wrdata_data_o : out std_logic_vector(31 downto 0);
		tx_dc_data_fifo_wrdata_be_o   : out std_logic_vector(3 downto 0);
		tx_dc_data_fifo_wrreq_o       : out std_logic
	);
end entity ftdi_data_transmitter_ent;

-- (Tx: FPGA => FTDI)

architecture RTL of ftdi_data_transmitter_ent is

	type t_ftdi_data_transmitter_fsm is (
		STOPPED,                        -- data transmitter stopped
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
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER                   -- change tx buffer
	);
	signal s_ftdi_data_transmitter_state : t_ftdi_data_transmitter_fsm;

	signal s_tx_dword_0 : std_logic_vector(31 downto 0);
	signal s_tx_dword_1 : std_logic_vector(31 downto 0);
	signal s_tx_dword_2 : std_logic_vector(31 downto 0);
	signal s_tx_dword_3 : std_logic_vector(31 downto 0);
	signal s_tx_dword_4 : std_logic_vector(31 downto 0);
	signal s_tx_dword_5 : std_logic_vector(31 downto 0);
	signal s_tx_dword_6 : std_logic_vector(31 downto 0);
	signal s_tx_dword_7 : std_logic_vector(31 downto 0);

begin

	p_ftdi_data_transmitter : process(clk_i, rst_i) is
		variable v_ftdi_data_transmitter_state : t_ftdi_data_transmitter_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_data_transmitter_state <= STOPPED;
			v_ftdi_data_transmitter_state := STOPPED;
			-- internal signals reset
			-- outputs reset
			buffer_rdreq_o                <= '0';
			buffer_change_o               <= '0';
			tx_dc_data_fifo_wrdata_data_o <= (others => '0');
			tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
			tx_dc_data_fifo_wrreq_o       <= '0';
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_data_transmitter_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter stopped
					-- default state transition
					s_ftdi_data_transmitter_state <= STOPPED;
					v_ftdi_data_transmitter_state := STOPPED;
					-- default internal signal values
					-- conditional state transition
					-- check if a start command was issued
					if (data_tx_start_i = '1') then
						s_ftdi_data_transmitter_state <= WAITING_TX_READY;
						v_ftdi_data_transmitter_state := WAITING_TX_READY;
					end if;

				-- state "WAITING_TX_READY"
				when WAITING_TX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default state transition
					s_ftdi_data_transmitter_state <= WAITING_TX_READY;
					v_ftdi_data_transmitter_state := WAITING_TX_READY;
					-- default internal signal values
					-- conditional state transition
					-- check (if the tx data buffer is ready and not empty) and (if there is enough space in the tx dc data fifo for the fetched qword) 
					if (((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) and ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8)))) then
						s_ftdi_data_transmitter_state <= FETCH_TX_QQWORD;
						v_ftdi_data_transmitter_state := FETCH_TX_QQWORD;
					end if;

				-- state "FETCH_TX_QQWORD"
				when FETCH_TX_QQWORD =>
					-- fetch tx qqword data (256b)
					-- default state transition
					s_ftdi_data_transmitter_state <= FETCH_DELAY;
					v_ftdi_data_transmitter_state := FETCH_DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					-- default state transition
					s_ftdi_data_transmitter_state <= FETCH_DELAY;
					v_ftdi_data_transmitter_state := FETCH_DELAY;
					-- default internal signal values
					-- conditional state transition
					-- check if there is enough space in the tx dc data fifo for the fetched qword
					if ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8))) then
						s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_0;
						v_ftdi_data_transmitter_state := WRITE_TX_DWORD_0;
					end if;

				-- state "WRITE_TX_DWORD_0"
				when WRITE_TX_DWORD_0 =>
					-- write tx dword data 0 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_1;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_1;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_2;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_2;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_2"
				when WRITE_TX_DWORD_2 =>
					-- write tx dword data 2 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_3;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_3;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_3"
				when WRITE_TX_DWORD_3 =>
					-- write tx dword data 3 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_4;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_4;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_4"
				when WRITE_TX_DWORD_4 =>
					-- write tx dword data 4 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_5;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_5;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_5"
				when WRITE_TX_DWORD_5 =>
					-- write tx dword data 5 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_6;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_6;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_6"
				when WRITE_TX_DWORD_6 =>
					-- write tx dword data 6 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_7;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_7;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_7"
				when WRITE_TX_DWORD_7 =>
					-- write tx dword data 7 (32b)
					-- default state transition
					s_ftdi_data_transmitter_state <= WRITE_DELAY;
					v_ftdi_data_transmitter_state := WRITE_DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default state transition
					s_ftdi_data_transmitter_state <= WAITING_TX_READY;
					v_ftdi_data_transmitter_state := WAITING_TX_READY;
					-- default internal signal values
					-- conditional state transition
					-- check if the tx data buffer is empty
					if (buffer_stat_empty_i = '1') then
						s_ftdi_data_transmitter_state <= CHANGE_BUFFER;
						v_ftdi_data_transmitter_state := CHANGE_BUFFER;
					-- check (if the tx data buffer is ready and not empty) and (if there is enough space in the tx dc data fifo for the fetched qword)
					elsif (((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) and ((tx_dc_data_fifo_wrfull_i = '0') and (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 8)))) then
						s_ftdi_data_transmitter_state <= FETCH_TX_QQWORD;
						v_ftdi_data_transmitter_state := FETCH_TX_QQWORD;
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					-- default state transition
					s_ftdi_data_transmitter_state <= WAITING_TX_READY;
					v_ftdi_data_transmitter_state := WAITING_TX_READY;
				-- default internal signal values
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_ftdi_data_transmitter_state <= STOPPED;
					v_ftdi_data_transmitter_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_tx_stop_i = '1') then
				s_ftdi_data_transmitter_state <= STOPPED;
				v_ftdi_data_transmitter_state := STOPPED;
			end if;

			-- Output generation FSM
			case (v_ftdi_data_transmitter_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter stopped
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
				-- conditional output signals

				-- state "WAITING_TX_READY"
				when WAITING_TX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default output signals
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
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_0;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_1;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_2"
				when WRITE_TX_DWORD_2 =>
					-- write tx dword data 2 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_2;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_3"
				when WRITE_TX_DWORD_3 =>
					-- write tx dword data 3 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_3;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_4"
				when WRITE_TX_DWORD_4 =>
					-- write tx dword data 4 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_4;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_5"
				when WRITE_TX_DWORD_5 =>
					-- write tx dword data 5 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_5;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_6"
				when WRITE_TX_DWORD_6 =>
					-- write tx dword data 6 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_6;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_TX_DWORD_7"
				when WRITE_TX_DWORD_7 =>
					-- write tx dword data 7 (32b)
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= s_tx_dword_7;
					tx_dc_data_fifo_wrdata_be_o   <= (others => '1');
					tx_dc_data_fifo_wrreq_o       <= '1';
				-- conditional output signals

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
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
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '1';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_data_transmitter;

	-- Signals Assingments
	s_tx_dword_0 <= buffer_rddata_i(31 downto 0);
	s_tx_dword_1 <= buffer_rddata_i(63 downto 32);
	s_tx_dword_2 <= buffer_rddata_i(95 downto 64);
	s_tx_dword_3 <= buffer_rddata_i(127 downto 96);
	s_tx_dword_4 <= buffer_rddata_i(159 downto 128);
	s_tx_dword_5 <= buffer_rddata_i(191 downto 160);
	s_tx_dword_6 <= buffer_rddata_i(223 downto 192);
	s_tx_dword_7 <= buffer_rddata_i(255 downto 224);

end architecture RTL;

