library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_packet_data_writer_ent is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		-- general inputs
		fee_clear_signal_i             : in  std_logic;
		fee_stop_signal_i              : in  std_logic;
		fee_start_signal_i             : in  std_logic;
		-- others
		data_wr_start_i                : in  std_logic;
		data_wr_reset_i                : in  std_logic;
		data_wr_length_i               : in  std_logic_vector(15 downto 0);
		masking_buffer_almost_empty_i  : in  std_logic;
		masking_buffer_empty_i         : in  std_logic;
		masking_buffer_rddata_i        : in  std_logic_vector(7 downto 0);
		send_buffer_stat_almost_full_i : in  std_logic;
		send_buffer_stat_full_i        : in  std_logic;
		send_buffer_wrready_i          : in  std_logic;
		data_wr_busy_o                 : out std_logic;
		data_wr_finished_o             : out std_logic;
		masking_buffer_rdreq_o         : out std_logic;
		send_buffer_wrdata_o           : out std_logic_vector(7 downto 0);
		send_buffer_wrreq_o            : out std_logic
	);
end entity data_packet_data_writer_ent;

architecture RTL of data_packet_data_writer_ent is

	type t_data_writer_fsm is (
		STOPPED,
		IDLE,
		WAITING_SEND_BUFFER_SPACE,
		FETCH_DATA,
		WRITE_DATA,
		DATA_WRITER_FINISH
	);
	signal s_data_writer_state : t_data_writer_fsm; -- current state

	signal s_data_cnt : std_logic_vector(15 downto 0);

begin

	p_data_packet_data_writer_FSM_state : process(clk_i, rst_i)
		variable v_data_writer_state : t_data_writer_fsm := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_data_writer_state    <= STOPPED;
			v_data_writer_state    := STOPPED;
			s_data_cnt             <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
			-- Outputs Generation
			data_wr_busy_o         <= '0';
			data_wr_finished_o     <= '0';
			masking_buffer_rdreq_o <= '0';
			send_buffer_wrdata_o   <= x"00";
			send_buffer_wrreq_o    <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_data_writer_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_data_writer_state    <= STOPPED;
					v_data_writer_state    := STOPPED;
					s_data_cnt             <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
					-- Outputs Generation
					data_wr_busy_o         <= '0';
					data_wr_finished_o     <= '0';
					masking_buffer_rdreq_o <= '0';
					send_buffer_wrdata_o   <= x"00";
					send_buffer_wrreq_o    <= '0';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_data_writer_state <= IDLE;
						v_data_writer_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a data write is requested
					-- default state transition
					s_data_writer_state <= IDLE;
					v_data_writer_state := IDLE;
					-- default internal signal values
					s_data_cnt          <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
					-- conditional state transition and internal signal values
					-- check if a data write was requested
					if (data_wr_start_i = '1') then
						-- data write requested
						-- set the data counter
						-- TODO: acerter data length para ler a quantidade correta de dados
						s_data_cnt          <= data_wr_length_i;
						-- go to wating buffer space
						s_data_writer_state <= WAITING_SEND_BUFFER_SPACE;
						v_data_writer_state := WAITING_SEND_BUFFER_SPACE;
					end if;

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default state transition
					s_data_writer_state <= WAITING_SEND_BUFFER_SPACE;
					v_data_writer_state := WAITING_SEND_BUFFER_SPACE;
					-- default internal signal values
					-- conditional state transition
					-- check if the masking buffer is not empty and the send buffer is ready and is not full
					if ((masking_buffer_empty_i = '0') and (send_buffer_wrready_i = '1') and (send_buffer_stat_full_i = '0')) then
						-- masking buffer is not empty and send buffer is ready and is not full
						-- go to fetch data
						s_data_writer_state <= FETCH_DATA;
						v_data_writer_state := FETCH_DATA;
					end if;

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the masking buffer
					-- default state transition
					s_data_writer_state <= WRITE_DATA;
					v_data_writer_state := WRITE_DATA;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_DATA"
				when WRITE_DATA =>
					-- write data to send buffer
					-- default state transition
					s_data_writer_state <= WAITING_SEND_BUFFER_SPACE;
					v_data_writer_state := WAITING_SEND_BUFFER_SPACE;
					-- default internal signal values
					s_data_cnt          <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
					-- conditional state transition and internal signal values
					-- check if all the sata was written
					if (s_data_cnt = std_logic_vector(to_unsigned(0, s_data_cnt'length))) then
						-- all data written
						-- go to data writter finish
						s_data_writer_state <= DATA_WRITER_FINISH;
						v_data_writer_state := DATA_WRITER_FINISH;
					else
						-- decrement data counter
						s_data_cnt <= std_logic_vector(unsigned(s_data_cnt) - 1);
					end if;

				-- state "DATA_WRITER_FINISH"
				when DATA_WRITER_FINISH =>
					-- finish data writer unit operation
					-- default state transition
					s_data_writer_state <= DATA_WRITER_FINISH;
					v_data_writer_state := DATA_WRITER_FINISH;
					-- default internal signal values
					s_data_cnt          <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
					-- conditional state transition and internal signal values
					-- check if a data writter reset was requested
					if (data_wr_reset_i = '1') then
						-- reply reset commanded, go back to idle
						s_data_writer_state <= IDLE;
						v_data_writer_state := IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_data_writer_state <= IDLE;
					v_data_writer_state := IDLE;

			end case;

			-- output generation

			case (v_data_writer_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a data write is requested
					-- reset outputs
					-- default output signals
					data_wr_busy_o         <= '0';
					data_wr_finished_o     <= '0';
					masking_buffer_rdreq_o <= '0';
					send_buffer_wrdata_o   <= x"00";
					send_buffer_wrreq_o    <= '0';
				-- conditional output signals

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default output signals
					data_wr_busy_o         <= '1';
					data_wr_finished_o     <= '0';
					masking_buffer_rdreq_o <= '0';
					-- clear send buffer write signal
					send_buffer_wrdata_o   <= x"00";
					send_buffer_wrreq_o    <= '0';
				-- conditional output signals

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the masking buffer
					-- reset outputs
					-- default output signals
					data_wr_busy_o         <= '1';
					data_wr_finished_o     <= '0';
					-- fetch data from masking buffer
					masking_buffer_rdreq_o <= '1';
					send_buffer_wrdata_o   <= x"00";
					send_buffer_wrreq_o    <= '0';
				-- conditional output signals

				-- state "WRITE_DATA"
				when WRITE_DATA =>
					-- write data to send buffer
					-- default output signals
					data_wr_busy_o         <= '1';
					data_wr_finished_o     <= '0';
					masking_buffer_rdreq_o <= '0';
					-- fill send buffer data with masking data
					send_buffer_wrdata_o   <= masking_buffer_rddata_i;
					-- write the send buffer data
					send_buffer_wrreq_o    <= '1';
				-- conditional output signals

				-- state "DATA_WRITER_FINISH"
				when DATA_WRITER_FINISH =>
					-- finish data writer unit operation
					-- default output signals
					data_wr_busy_o         <= '1';
					-- indicate that the data writer is finished
					data_wr_finished_o     <= '1';
					masking_buffer_rdreq_o <= '0';
					send_buffer_wrreq_o    <= '0';
					send_buffer_wrdata_o   <= x"00";
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_data_writer_state <= STOPPED;
				v_data_writer_state := STOPPED;
			end if;

		end if;
	end process p_data_packet_data_writer_FSM_state;

end architecture RTL;
