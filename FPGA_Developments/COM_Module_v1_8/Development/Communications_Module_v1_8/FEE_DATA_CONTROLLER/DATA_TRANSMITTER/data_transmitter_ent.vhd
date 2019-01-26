library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_transmitter_ent is
	port(
		clk_i                           : in  std_logic;
		rst_i                           : in  std_logic;
		data_transmitter_reset_i        : in  std_logic;
		send_buffer_stat_almost_empty_i : in  std_logic;
		send_buffer_stat_empty_i        : in  std_logic;
		send_buffer_rddata_i            : in  std_logic_vector(7 downto 0);
		send_buffer_rdready_i           : in  std_logic;
		spw_tx_ready_i                  : in  std_logic;
		data_transmitter_busy_o         : out std_logic;
		data_transmitter_finished_o     : out std_logic;
		send_buffer_rdreq_o             : out std_logic;
		spw_tx_write_o                  : out std_logic;
		spw_tx_flag_o                   : out std_logic;
		spw_tx_data_o                   : out std_logic_vector(7 downto 0)
	);
end entity data_transmitter_ent;

architecture RTL of data_transmitter_ent is

	type t_data_transmitter_fsm is (
		IDLE,
		WAITING_DATA_BUFFER_SPACE,
		FETCH_DATA,
		TRANSMIT_DATA,
		WAITING_EOP_BUFFER_SPACE,
		TRANSMIT_EOP,
		DATA_TRANSMITTER_FINISH
	);
	signal s_data_transmitter_state : t_data_transmitter_fsm; -- current state

begin

	p_data_transmitter_FSM : process(clk_i, reset_n_i)
		variable v_data_transmitter_state : t_data_transmitter_fsm := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_data_transmitter_state    <= IDLE;
			v_data_transmitter_state    := IDLE;
			-- Outputs Generation
			data_transmitter_busy_o     <= '0';
			data_transmitter_finished_o <= '0';
			send_buffer_rdreq_o         <= '0';
			spw_tx_write_o              <= '0';
			spw_tx_flag_o               <= '0';
			spw_tx_data_o               <= x"00";
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_transmitter_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the send buffer signals that is ready to be read
					-- default state transition
					s_data_transmitter_state <= IDLE;
					v_data_transmitter_state := IDLE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the send buffer is ready to be read and is not empty
					if (send_buffer_rdready_i = '1') then
						-- send buffer ready to be read
						-- go to fetch data, then waiting data buffer space 
						s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
						v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
					end if;

				-- state "WAITING_BUFFER_SPACE"
				when WAITING_DATA_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for data and there is data available
					-- default state transition
					s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data and send buffer is ready for read and is not empty
					if ((spw_tx_ready_i = '1') and (send_buffer_rdready_i = '1') and (send_buffer_stat_empty_i = '0')) then
						-- tx buffer can receive data
						-- go to transmit data
						s_data_transmitter_state <= FETCH_DATA;
						v_data_transmitter_state := FETCH_DATA;
					end if;

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the send buffer
					-- default state transition
					s_data_transmitter_state <= TRANSMIT_DATA;
					v_data_transmitter_state := TRANSMIT_DATA;
				-- default internal signal values
				-- conditional state transition

				-- state "TRANSMIT_DATA"
				when TRANSMIT_DATA =>
					-- transmit data from the send buffer to the spw codec
					-- default state transition
					s_data_transmitter_state <= WAITING_DATA_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_DATA_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if the send buffer is empty
					if (send_buffer_stat_empty_i = '1') then
						-- send buffer empty, go to waiting eop buffer space
						s_data_transmitter_state <= WAITING_EOP_BUFFER_SPACE;
						v_data_transmitter_state := WAITING_EOP_BUFFER_SPACE;
					end if;

				-- state "WAITING_EOP_BUFFER_SPACE"
				when WAITING_EOP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eop
					-- default state transition
					s_data_transmitter_state <= WAITING_EOP_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_EOP_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data
					if (spw_tx_ready_i = '1') then
						-- tx buffer can receive data
						-- go to transmit data
						s_data_transmitter_state <= TRANSMIT_EOP;
						v_data_transmitter_state := TRANSMIT_EOP;
					end if;

				-- state "TRANSMIT_EOP"
				when TRANSMIT_EOP =>
					-- transmit eop to the spw codec
					-- default state transition
					s_data_transmitter_state <= DATA_TRANSMITTER_FINISH;
					v_data_transmitter_state := DATA_TRANSMITTER_FINISH;
				-- default internal signal values
				-- conditional state transition and internal signal values

				-- state "DATA_TRANSMITTER_FINISH"
				when DATA_TRANSMITTER_FINISH =>
					-- finish data transmitter
					-- default state transition
					s_data_transmitter_state <= DATA_TRANSMITTER_FINISH;
					v_data_transmitter_state := DATA_TRANSMITTER_FINISH;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if a data transmitter reset was requested
					if (data_transmitter_reset_i = '1') then
						-- data transmitter reset requested, go back to idle
						s_data_transmitter_state <= IDLE;
						v_data_transmitter_state := IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_transmitter_state <= IDLE;
					v_data_transmitter_state := IDLE;

			end case;

			-- output generation
			case (v_data_transmitter_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until the send buffer signals that is ready to be read
					-- reset outputs
					-- default output signals
					data_transmitter_busy_o     <= '0';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- conditional output signals

				-- state "WAITING_DATA_BUFFER_SPACE"
				when WAITING_DATA_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for data and there is data available
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					-- clear spw tx write signal
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- conditional output signals

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the send buffer
					-- reset outputs
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					-- fetch data from send buffer
					send_buffer_rdreq_o         <= '1';
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- conditional output signals

				-- state "TRANSMIT_DATA"
				when TRANSMIT_DATA =>
					-- transmit data from the send buffer to the spw codec
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					-- clear spw flag (to indicate a data)
					spw_tx_flag_o               <= '0';
					-- fill spw data with field data
					spw_tx_data_o               <= send_buffer_rddata_i;
					-- write the spw data
					spw_tx_write_o              <= '1';
				-- conditional output signals

				-- state "WAITING_EOP_BUFFER_SPACE"
				when WAITING_EOP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eop
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					-- clear spw tx write signal
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- conditional output signals

				-- state "TRANSMIT_EOP"
				when TRANSMIT_EOP =>
					-- transmit eop to the spw codec
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					-- set spw flag (to indicate a package end)
					spw_tx_flag_o               <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_tx_data_o               <= x"00";
					-- write the spw data
					spw_tx_write_o              <= '1';
				-- conditional output signals

				-- state "DATA_TRANSMITTER_FINISH"
				when DATA_TRANSMITTER_FINISH =>
					-- finish data transmitter
					-- default output signals
					data_transmitter_busy_o     <= '1';
					-- indicate that the data transmitter is finished
					data_transmitter_finished_o <= '1';
					send_buffer_rdreq_o         <= '0';
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_data_transmitter_FSM;

end architecture RTL;
