library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_transmitter_ent is
	port(
		clk_i                           : in  std_logic;
		rst_i                           : in  std_logic;
		-- general inputs
		fee_clear_signal_i              : in  std_logic;
		fee_stop_signal_i               : in  std_logic;
		fee_start_signal_i              : in  std_logic;
		-- others
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
		STOPPED,
		IDLE,
		WAITING_DATA_BUFFER_SPACE,
		FETCH_DATA,
		DELAY,
		TRANSMIT_DATA,
		WAITING_EOP_BUFFER_SPACE,
		TRANSMIT_EOP,
		DATA_TRANSMITTER_FINISH,
		WAITING_EEP_BUFFER_SPACE,
		TRANSMIT_EEP
	);
	signal s_data_transmitter_state : t_data_transmitter_fsm; -- current state

begin

	p_data_transmitter_FSM : process(clk_i, rst_i)
		variable v_data_transmitter_state : t_data_transmitter_fsm := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_data_transmitter_state    <= STOPPED;
			v_data_transmitter_state    := STOPPED;
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

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_transmitter_state    <= STOPPED;
					v_data_transmitter_state    := STOPPED;
					-- Outputs Generation
					data_transmitter_busy_o     <= '0';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_data_transmitter_state <= IDLE;
						v_data_transmitter_state := IDLE;
					end if;

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
					s_data_transmitter_state <= DELAY;
					v_data_transmitter_state := DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "DELAY"
				when DELAY =>
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
					s_data_transmitter_state <= IDLE;
					v_data_transmitter_state := IDLE;

				-- state "WAITING_EEP_BUFFER_SPACE"
				when WAITING_EEP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eep
					-- default state transition
					s_data_transmitter_state <= WAITING_EEP_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_EEP_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if tx buffer can receive data
					if (spw_tx_ready_i = '1') then
						-- tx buffer can receive data
						-- go to transmit data
						s_data_transmitter_state <= TRANSMIT_EEP;
						v_data_transmitter_state := TRANSMIT_EEP;
					end if;

				-- state "TRANSMIT_EEP"
				when TRANSMIT_EEP =>
					-- transmit eep to the spw codec
					-- default state transition
					s_data_transmitter_state <= STOPPED;
					v_data_transmitter_state := STOPPED;
				-- default internal signal values
				-- conditional state transition and internal signal values

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

				-- state "DELAY"
				when DELAY =>
					-- default state transition
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					-- fetch data from send buffer
					send_buffer_rdreq_o         <= '0';
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- default internal signal values
				-- conditional state transition

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

				-- state "WAITING_EEP_BUFFER_SPACE"
				when WAITING_EEP_BUFFER_SPACE =>
					-- wait until the spacewire tx buffer has space for an eep
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					-- clear spw tx write signal
					spw_tx_write_o              <= '0';
					spw_tx_flag_o               <= '0';
					spw_tx_data_o               <= x"00";
				-- conditional output signals

				-- state "TRANSMIT_EEP"
				when TRANSMIT_EEP =>
					-- transmit eep to the spw codec
					-- default output signals
					data_transmitter_busy_o     <= '1';
					data_transmitter_finished_o <= '0';
					send_buffer_rdreq_o         <= '0';
					-- set spw flag (to indicate a package end)
					spw_tx_flag_o               <= '1';
					-- fill spw data with the eop identifier (0x00)
					spw_tx_data_o               <= x"01";
					-- write the spw data
					spw_tx_write_o              <= '1';
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				-- check if the transmitter is in the middle of a transmission (have the spw mux access rights)
				if ((s_data_transmitter_state /= STOPPED) and (s_data_transmitter_state /= IDLE) and (s_data_transmitter_state /= DATA_TRANSMITTER_FINISH)) then
					-- transmit and eep to release the spw mux and indicate an error
					s_data_transmitter_state <= WAITING_EEP_BUFFER_SPACE;
					v_data_transmitter_state := WAITING_EEP_BUFFER_SPACE;
				else
					-- no need to release the spw mux and indicate an erro, go to stopped
					s_data_transmitter_state <= STOPPED;
					v_data_transmitter_state := STOPPED;
				end if;
			end if;

		end if;
	end process p_data_transmitter_FSM;

end architecture RTL;