library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

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
		masking_buffer_rddata_i        : in  std_logic_vector(9 downto 0);
		send_buffer_stat_almost_full_i : in  std_logic;
		send_buffer_stat_full_i        : in  std_logic;
		send_buffer_wrready_i          : in  std_logic;
		data_wr_busy_o                 : out std_logic;
		data_wr_finished_o             : out std_logic;
		data_wr_data_changed_o         : out std_logic;
		masking_buffer_rdreq_o         : out std_logic;
		send_buffer_wrdata_o           : out std_logic_vector(7 downto 0);
		send_buffer_wrreq_o            : out std_logic;
		send_buffer_data_end_wrdata_o  : out std_logic;
		send_buffer_data_end_wrreq_o   : out std_logic
	);
end entity data_packet_data_writer_ent;

architecture RTL of data_packet_data_writer_ent is

	type t_data_writer_fsm is (
		STOPPED,
		IDLE,
		WAITING_SEND_BUFFER_SPACE,
		FETCH_DATA,
		DELAY,
		WRITE_DATA,
		DATA_WRITER_FINISH
	);
	signal s_data_writer_state : t_data_writer_fsm; -- current state

	signal s_data_cnt : std_logic_vector(15 downto 0);

	signal s_overflow_send_buffer : std_logic;

	signal s_first_write : std_logic;

	alias a_masking_buffer_rddata_imgbyte is masking_buffer_rddata_i(7 downto 0);
	alias a_masking_buffer_rddata_imgchange is masking_buffer_rddata_i(8);
	alias a_masking_buffer_rddata_imgend is masking_buffer_rddata_i(9);

begin

	p_data_packet_data_writer_FSM_state : process(clk_i, rst_i)
		variable v_data_writer_state : t_data_writer_fsm := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_data_writer_state    <= STOPPED;
			v_data_writer_state    := STOPPED;
			s_data_cnt             <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
			s_overflow_send_buffer <= '0';
			s_first_write          <= '0';
			-- Outputs Generation
			data_wr_busy_o         <= '0';
			data_wr_finished_o     <= '0';
			data_wr_data_changed_o <= '0';
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
					s_overflow_send_buffer <= '0';
					s_first_write          <= '0';
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
					s_data_writer_state    <= IDLE;
					v_data_writer_state    := IDLE;
					-- default internal signal values
					s_data_cnt             <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
					s_overflow_send_buffer <= '0';
					s_first_write          <= '0';
					-- conditional state transition and internal signal values
					-- check if a data write was requested
					if (data_wr_start_i = '1') then
						-- data write requested
						-- set the first write flag
						s_first_write       <= '1';
						-- set the data counter
						s_data_cnt          <= std_logic_vector(unsigned(data_wr_length_i) - 1);
						-- go to wating buffer space
						s_data_writer_state <= WAITING_SEND_BUFFER_SPACE;
						v_data_writer_state := WAITING_SEND_BUFFER_SPACE;
					end if;

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default state transition
					s_data_writer_state    <= WAITING_SEND_BUFFER_SPACE;
					v_data_writer_state    := WAITING_SEND_BUFFER_SPACE;
					s_overflow_send_buffer <= '0';
					-- default internal signal values
					-- conditional state transition
					-- check if the masking buffer is not empty
					if (masking_buffer_empty_i = '0') then
						-- masking buffer is not empty
						-- check if the send buffer is ready and is not full
						if ((send_buffer_wrready_i = '1') and (send_buffer_stat_full_i = '0')) then
							-- send buffer is ready and is not full
							s_overflow_send_buffer <= '0';
							-- go to fetch data
							s_data_writer_state    <= FETCH_DATA;
							v_data_writer_state    := FETCH_DATA;
						-- check if the send buffer overflow is enabled
						elsif (c_SEND_BUFFER_OVERFLOW_ENABLE = '1') then
							-- send buffer overflow is enabled
							s_overflow_send_buffer <= '1';
							-- go to fetch data
							s_data_writer_state    <= FETCH_DATA;
							v_data_writer_state    := FETCH_DATA;
						end if;
					end if;

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the masking buffer
					-- default state transition
					s_data_writer_state <= DELAY;
					v_data_writer_state := DELAY;
				-- default internal signal values
				-- conditional state transition

				-- state "DELAY"
				when DELAY =>
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
					s_first_write       <= '0';
					-- conditional state transition and internal signal values
					-- check if all the data was written or if a change command was read
					if ((s_data_cnt = std_logic_vector(to_unsigned(0, s_data_cnt'length))) or (a_masking_buffer_rddata_imgchange = '1')) then
						-- all data written or a change command was read
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
					s_data_writer_state    <= DATA_WRITER_FINISH;
					v_data_writer_state    := DATA_WRITER_FINISH;
					-- default internal signal values
					s_data_cnt             <= std_logic_vector(to_unsigned(0, s_data_cnt'length));
					s_overflow_send_buffer <= '0';
					s_first_write          <= '0';
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
					data_wr_busy_o                <= '0';
					data_wr_finished_o            <= '0';
					data_wr_data_changed_o        <= '0';
					masking_buffer_rdreq_o        <= '0';
					send_buffer_wrdata_o          <= x"00";
					send_buffer_wrreq_o           <= '0';
					send_buffer_data_end_wrreq_o  <= '0';
					send_buffer_data_end_wrdata_o <= '0';
				-- conditional output signals

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default output signals
					data_wr_busy_o                <= '1';
					data_wr_finished_o            <= '0';
					data_wr_data_changed_o        <= '0';
					masking_buffer_rdreq_o        <= '0';
					-- clear send buffer write signal
					send_buffer_wrdata_o          <= x"00";
					send_buffer_wrreq_o           <= '0';
					send_buffer_data_end_wrreq_o  <= '0';
					send_buffer_data_end_wrdata_o <= '0';
				-- conditional output signals

				-- state "FETCH_DATA"
				when FETCH_DATA =>
					-- fetch data from the masking buffer
					-- reset outputs
					-- default output signals
					data_wr_busy_o                <= '1';
					data_wr_finished_o            <= '0';
					data_wr_data_changed_o        <= '0';
					-- fetch data from masking buffer
					masking_buffer_rdreq_o        <= '1';
					send_buffer_wrdata_o          <= x"00";
					send_buffer_wrreq_o           <= '0';
					send_buffer_data_end_wrreq_o  <= '0';
					send_buffer_data_end_wrdata_o <= '0';
				-- conditional output signals

				-- state "DELAY"
				when DELAY =>
					-- default state transition
					-- default output signals
					data_wr_busy_o                <= '1';
					data_wr_finished_o            <= '0';
					-- fetch data from masking buffer
					masking_buffer_rdreq_o        <= '0';
					send_buffer_wrdata_o          <= x"00";
					send_buffer_wrreq_o           <= '0';
					send_buffer_data_end_wrreq_o  <= '0';
					send_buffer_data_end_wrdata_o <= '0';

				-- state "WRITE_DATA"
				when WRITE_DATA =>
					-- write data to send buffer
					-- default output signals
					data_wr_busy_o         <= '1';
					data_wr_finished_o     <= '0';
					data_wr_data_changed_o <= '0';
					masking_buffer_rdreq_o <= '0';
					-- fill send buffer data with masking data
					send_buffer_wrdata_o   <= a_masking_buffer_rddata_imgbyte;
					-- check if it is the first write
					if (s_first_write = '1') then
						-- it is the first write
						-- need to clear the img end on the send buffer
						send_buffer_data_end_wrreq_o  <= '1';
						send_buffer_data_end_wrdata_o <= '0';
					-- check if need to write a img end to the send buffer
					elsif (a_masking_buffer_rddata_imgend = '1') then
						-- need to write a img end to the send buffer
						send_buffer_data_end_wrreq_o  <= '1';
						send_buffer_data_end_wrdata_o <= '1';
					else
						send_buffer_data_end_wrreq_o  <= '0';
						send_buffer_data_end_wrdata_o <= '0';
					end if;
					-- write the send buffer data
					-- check if a change command was read or the send buffer is being overflow (no need to write)
					if ((a_masking_buffer_rddata_imgchange = '1') or (s_overflow_send_buffer = '1')) then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;

				-- conditional output signals

				-- state "DATA_WRITER_FINISH"
				when DATA_WRITER_FINISH =>
					-- finish data writer unit operation
					-- default output signals
					data_wr_busy_o                <= '1';
					-- indicate that the data writer is finished
					data_wr_finished_o            <= '1';
					-- check if the finish was because of a change command
					if (a_masking_buffer_rddata_imgchange = '1') then
						-- finish was because of a change command
						data_wr_data_changed_o <= '1';
					else
						-- finish was not because of a change command
						data_wr_data_changed_o <= '0';
					end if;
					masking_buffer_rdreq_o        <= '0';
					send_buffer_wrreq_o           <= '0';
					send_buffer_wrdata_o          <= x"00";
					send_buffer_data_end_wrreq_o  <= '0';
					send_buffer_data_end_wrdata_o <= '0';
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
