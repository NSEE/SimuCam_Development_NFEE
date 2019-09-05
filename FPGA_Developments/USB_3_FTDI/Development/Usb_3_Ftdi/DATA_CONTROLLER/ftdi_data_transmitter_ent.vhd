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
		buffer_rddata_i               : in  std_logic_vector(63 downto 0);
		buffer_rdready_i              : in  std_logic;
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
		IDLE,                           -- data transmitter in idle
		FETCH_TX_QWORD,                 -- fetch tx qword data (64b)
		FETCH_DELAY,                    -- fetch delay
		WRITE_TX_DWORD_0,               -- write tx dword data 0 (32b)
		WRITE_TX_DWORD_1,               -- write tx dword data 1 (32b)
		WRITE_DELAY,                    -- write delay
		CHANGE_BUFFER                   -- change tx buffer
	);
	signal s_ftdi_data_transmitter_state : t_ftdi_data_transmitter_fsm;

	signal s_tx_dword_0 : std_logic_vector(31 downto 0);
	signal s_tx_dword_1 : std_logic_vector(31 downto 0);

begin

	p_ftdi_data_transmitter : process(clk_i, rst_i) is
		variable v_ftdi_data_transmitter_state : t_ftdi_data_transmitter_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			s_ftdi_data_transmitter_state <= STOPPED;
			v_ftdi_data_transmitter_state := STOPPED;
			buffer_rdreq_o                <= '0';
			buffer_change_o               <= '0';
			tx_dc_data_fifo_wrdata_data_o <= (others => '0');
			tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
			tx_dc_data_fifo_wrreq_o       <= '0';
			s_tx_dword_0                  <= (others => '0');
			s_tx_dword_1                  <= (others => '0');
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_data_transmitter_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter stopped
					s_ftdi_data_transmitter_state <= STOPPED;
					v_ftdi_data_transmitter_state := STOPPED;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if a start command was issued
					if (data_tx_start_i = '1') then
						s_ftdi_data_transmitter_state <= IDLE;
						v_ftdi_data_transmitter_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- data transmitter in idle
					s_ftdi_data_transmitter_state <= IDLE;
					v_ftdi_data_transmitter_state := IDLE;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if the tx data buffer is ready and not empty
					if ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
						s_ftdi_data_transmitter_state <= FETCH_TX_QWORD;
						v_ftdi_data_transmitter_state := FETCH_TX_QWORD;
					end if;

				-- state "FETCH_TX_QWORD"
				when FETCH_TX_QWORD =>
					-- fetch tx qword data (64b)
					s_ftdi_data_transmitter_state <= FETCH_DELAY;
					v_ftdi_data_transmitter_state := FETCH_DELAY;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "FETCH_DELAY"
				when FETCH_DELAY =>
					-- fetch delay
					s_ftdi_data_transmitter_state <= FETCH_DELAY;
					v_ftdi_data_transmitter_state := FETCH_DELAY;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if there is enough space in the tx dc data fifo for the fetched qword
					if (to_integer(unsigned(tx_dc_data_fifo_wrusedw_i)) <= ((2 ** tx_dc_data_fifo_wrusedw_i'length) - 2)) then
						s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_0;
						v_ftdi_data_transmitter_state := WRITE_TX_DWORD_0;
					end if;

				-- state "WRITE_TX_DWORD_0"
				when WRITE_TX_DWORD_0 =>
					-- write tx dword data 0 (32b)
					s_ftdi_data_transmitter_state <= WRITE_TX_DWORD_1;
					v_ftdi_data_transmitter_state := WRITE_TX_DWORD_1;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_TX_DWORD_1"
				when WRITE_TX_DWORD_1 =>
					-- write tx dword data 1 (32b)
					s_ftdi_data_transmitter_state <= WRITE_DELAY;
					v_ftdi_data_transmitter_state := WRITE_DELAY;
				-- default state transition
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					s_ftdi_data_transmitter_state <= IDLE;
					v_ftdi_data_transmitter_state := IDLE;
					-- default state transition
					-- default internal signal values
					-- conditional state transition
					-- check if the tx data buffer is empty
					if (buffer_stat_empty_i = '1') then
						s_ftdi_data_transmitter_state <= CHANGE_BUFFER;
						v_ftdi_data_transmitter_state := CHANGE_BUFFER;
					-- check if the tx data buffer is ready and not empty
					elsif ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
						s_ftdi_data_transmitter_state <= FETCH_TX_QWORD;
						v_ftdi_data_transmitter_state := FETCH_TX_QWORD;
					end if;

				-- state "CHANGE_BUFFER"
				when CHANGE_BUFFER =>
					-- change tx buffer
					s_ftdi_data_transmitter_state <= IDLE;
					v_ftdi_data_transmitter_state := IDLE;
				-- default state transition
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
					s_tx_dword_0                  <= (others => '0');
					s_tx_dword_1                  <= (others => '0');
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- data transmitter in idle
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					s_tx_dword_0                  <= (others => '0');
					s_tx_dword_1                  <= (others => '0');
				-- conditional output signals

				-- state "FETCH_TX_QWORD"
				when FETCH_TX_QWORD =>
					-- fetch tx qword data (64b)
					-- default output signals
					buffer_rdreq_o                <= '1';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					s_tx_dword_0                  <= (others => '0');
					s_tx_dword_1                  <= (others => '0');
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
					s_tx_dword_0                  <= buffer_rddata_i(31 downto 0);
					s_tx_dword_1                  <= buffer_rddata_i(63 downto 32);
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

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
					buffer_rdreq_o                <= '0';
					buffer_change_o               <= '0';
					tx_dc_data_fifo_wrdata_data_o <= (others => '0');
					tx_dc_data_fifo_wrdata_be_o   <= (others => '0');
					tx_dc_data_fifo_wrreq_o       <= '0';
					s_tx_dword_0                  <= (others => '0');
					s_tx_dword_1                  <= (others => '0');
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
					s_tx_dword_0                  <= (others => '0');
					s_tx_dword_1                  <= (others => '0');
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_data_transmitter;

end architecture RTL;

