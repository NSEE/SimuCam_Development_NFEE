library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity data_packet_hk_writer_ent is
	port(
		clk_i                          : in  std_logic;
		rst_i                          : in  std_logic;
		-- general inputs
		fee_clear_signal_i             : in  std_logic;
		fee_stop_signal_i              : in  std_logic;
		fee_start_signal_i             : in  std_logic;
		-- others
		housekeeping_wr_start_i        : in  std_logic;
		housekeeping_wr_reset_i        : in  std_logic;
		hk_mem_waitrequest_i           : in  std_logic;
		hk_mem_data_i                  : in  std_logic_vector(7 downto 0);
		send_buffer_stat_almost_full_i : in  std_logic;
		send_buffer_stat_full_i        : in  std_logic;
		send_buffer_wrready_i          : in  std_logic;
		housekeeping_wr_busy_o         : out std_logic;
		housekeeping_wr_finished_o     : out std_logic;
		hk_mem_byte_address_o          : out std_logic_vector(31 downto 0);
		hk_mem_read_o                  : out std_logic;
		send_buffer_wrdata_o           : out std_logic_vector(7 downto 0);
		send_buffer_wrreq_o            : out std_logic
	);
end entity data_packet_hk_writer_ent;

architecture RTL of data_packet_hk_writer_ent is

	constant c_HK_RESET_BYTE_ADDR : std_logic_vector(31 downto 0) := x"00000000";
	constant c_HK_FIRST_BYTE_ADDR : std_logic_vector(31 downto 0) := x"00000700";
	constant c_HK_LAST_BYTE_ADDR  : std_logic_vector(31 downto 0) := x"0000078F";

	type t_housekeeping_writer_fsm is (
		STOPPED,
		IDLE,
		WAITING_SEND_BUFFER_SPACE,
		READ_HOUSEKEEPING,
		WRITE_HOUSEKEEPING,
		HOUSEKEEPING_WRITER_FINISH
	);
	signal s_housekeeping_writer_state : t_housekeeping_writer_fsm; -- current state

	signal s_housekepping_addr : std_logic_vector(31 downto 0);

	signal s_overflow_send_buffer : std_logic;

begin

	p_data_packet_housekeeping_writer_FSM_state : process(clk_i, rst_i)
		variable v_housekeeping_writer_state : t_housekeeping_writer_fsm := IDLE; -- current state
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_housekeeping_writer_state <= STOPPED;
			v_housekeeping_writer_state := STOPPED;
			s_housekepping_addr         <= c_HK_RESET_BYTE_ADDR;
			s_overflow_send_buffer      <= '0';
			-- Outputs Generation
			housekeeping_wr_busy_o      <= '0';
			housekeeping_wr_finished_o  <= '0';
			hk_mem_byte_address_o       <= c_HK_RESET_BYTE_ADDR;
			hk_mem_read_o               <= '0';
			send_buffer_wrdata_o        <= x"00";
			send_buffer_wrreq_o         <= '0';
		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then
			case (s_housekeeping_writer_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_housekeeping_writer_state <= STOPPED;
					v_housekeeping_writer_state := STOPPED;
					s_housekepping_addr         <= c_HK_RESET_BYTE_ADDR;
					s_overflow_send_buffer      <= '0';
					-- Outputs Generation
					housekeeping_wr_busy_o      <= '0';
					housekeeping_wr_finished_o  <= '0';
					hk_mem_byte_address_o       <= c_HK_RESET_BYTE_ADDR;
					hk_mem_read_o               <= '0';
					send_buffer_wrdata_o        <= x"00";
					send_buffer_wrreq_o         <= '0';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_housekeeping_writer_state <= IDLE;
						v_housekeeping_writer_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a housekeeping write is requested
					-- default state transition
					s_housekeeping_writer_state <= IDLE;
					v_housekeeping_writer_state := IDLE;
					s_overflow_send_buffer      <= '0';
					-- default internal signal values
					s_housekepping_addr         <= c_HK_RESET_BYTE_ADDR;
					-- conditional state transition and internal signal values
					-- check if a housekeeping write was requested
					if (housekeeping_wr_start_i = '1') then
						-- housekeeping write requested
						-- set the housekeeping first byte address
						s_housekepping_addr         <= c_HK_FIRST_BYTE_ADDR;
						-- go to wating buffer space
						s_housekeeping_writer_state <= WAITING_SEND_BUFFER_SPACE;
						v_housekeeping_writer_state := WAITING_SEND_BUFFER_SPACE;
					end if;

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default state transition
					s_housekeeping_writer_state <= WAITING_SEND_BUFFER_SPACE;
					v_housekeeping_writer_state := WAITING_SEND_BUFFER_SPACE;
					s_overflow_send_buffer      <= '0';
					-- default internal signal values
					-- conditional state transition
					-- check if the send buffer is ready and is not full
					if ((send_buffer_wrready_i = '1') and (send_buffer_stat_full_i = '0')) then
						-- send buffer is ready and is not full
						s_overflow_send_buffer      <= '0';
						-- go to read housekeeping
						s_housekeeping_writer_state <= READ_HOUSEKEEPING;
						v_housekeeping_writer_state := READ_HOUSEKEEPING;
					-- check if the send buffer overflow is enabled
					elsif (c_SEND_BUFFER_OVERFLOW_ENABLE = '1') then
						-- send buffer overflow is enabled
						s_overflow_send_buffer      <= '1';
						-- go to read housekeeping
						s_housekeeping_writer_state <= READ_HOUSEKEEPING;
						v_housekeeping_writer_state := READ_HOUSEKEEPING;
					end if;

				-- state "READ_HOUSEKEEPING"
				when READ_HOUSEKEEPING =>
					-- fetch hk memory data, wait for valid data in memory
					-- default state transition
					s_housekeeping_writer_state <= READ_HOUSEKEEPING;
					v_housekeeping_writer_state := READ_HOUSEKEEPING;
					-- default internal signal values
					-- conditional state transition and internal signal values
					-- check if housekeeping memory has valid data
					if (hk_mem_waitrequest_i = '0') then
						-- memory has valid data
						-- go to write housekeeping
						s_housekeeping_writer_state <= WRITE_HOUSEKEEPING;
						v_housekeeping_writer_state := WRITE_HOUSEKEEPING;
					end if;

				-- state "WRITE_HOUSEKEEPING"
				when WRITE_HOUSEKEEPING =>
					-- write housekeeping data to send buffer
					-- default state transition
					s_housekeeping_writer_state <= WAITING_SEND_BUFFER_SPACE;
					v_housekeeping_writer_state := WAITING_SEND_BUFFER_SPACE;
					-- default internal signal values
					s_housekepping_addr         <= c_HK_RESET_BYTE_ADDR;
					-- conditional state transition and internal signal values
					-- check if all the housekeeping data was written
					if (s_housekepping_addr = c_HK_LAST_BYTE_ADDR) then
						-- all housekeeping data written
						-- go to housekeeping writter finish
						s_housekeeping_writer_state <= HOUSEKEEPING_WRITER_FINISH;
						v_housekeeping_writer_state := HOUSEKEEPING_WRITER_FINISH;
					else
						-- increment housekeeping address
						s_housekepping_addr <= std_logic_vector(unsigned(s_housekepping_addr) + 1);
					end if;

				-- state "HOUSEKEEPING_WRITER_FINISH"
				when HOUSEKEEPING_WRITER_FINISH =>
					-- finish housekeeping writer unit operation
					-- default state transition
					s_housekeeping_writer_state <= HOUSEKEEPING_WRITER_FINISH;
					v_housekeeping_writer_state := HOUSEKEEPING_WRITER_FINISH;
					-- default internal signal values
					s_housekepping_addr         <= c_HK_RESET_BYTE_ADDR;
					s_overflow_send_buffer      <= '0';
					-- conditional state transition and internal signal values
					-- check if a housekeeping writter reset was requested
					if (housekeeping_wr_reset_i = '1') then
						-- reply reset commanded, go back to idle
						s_housekeeping_writer_state <= IDLE;
						v_housekeeping_writer_state := IDLE;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to save state (ERROR?!)
					s_housekeeping_writer_state <= IDLE;
					v_housekeeping_writer_state := IDLE;

			end case;

			-- output generation

			case (v_housekeeping_writer_state) is

				-- state "IDLE"
				when IDLE =>
					-- does nothing until a housekeeping write is requested
					-- reset outputs
					-- default output signals
					housekeeping_wr_busy_o     <= '0';
					housekeeping_wr_finished_o <= '0';
					hk_mem_byte_address_o      <= c_HK_RESET_BYTE_ADDR;
					hk_mem_read_o              <= '0';
					send_buffer_wrdata_o       <= x"00";
					send_buffer_wrreq_o        <= '0';
				-- conditional output signals

				-- state "WAITING_SEND_BUFFER_SPACE"
				when WAITING_SEND_BUFFER_SPACE =>
					-- wait until the send buffer have available space
					-- default output signals
					housekeeping_wr_busy_o     <= '1';
					housekeeping_wr_finished_o <= '0';
					hk_mem_byte_address_o      <= c_HK_RESET_BYTE_ADDR;
					hk_mem_read_o              <= '0';
					-- clear send buffer write signal
					send_buffer_wrdata_o       <= x"00";
					send_buffer_wrreq_o        <= '0';
				-- conditional output signals

				-- state "READ_HOUSEKEEPING"
				when READ_HOUSEKEEPING =>
					-- fetch hk memory data, wait for valid data in memory
					-- reset outputs
					-- default output signals
					housekeeping_wr_busy_o     <= '1';
					housekeeping_wr_finished_o <= '0';
					-- fetch data from masking buffer
					hk_mem_byte_address_o      <= s_housekepping_addr;
					hk_mem_read_o              <= '1';
					send_buffer_wrdata_o       <= x"00";
					send_buffer_wrreq_o        <= '0';
				-- conditional output signals

				-- state "WRITE_HOUSEKEEPING"
				when WRITE_HOUSEKEEPING =>
					-- write housekeeping data to send buffer
					-- default output signals
					housekeeping_wr_busy_o     <= '1';
					housekeeping_wr_finished_o <= '0';
					hk_mem_byte_address_o      <= c_HK_RESET_BYTE_ADDR;
					hk_mem_read_o              <= '0';
					-- fill send buffer data with masking data
					send_buffer_wrdata_o       <= hk_mem_data_i;
					-- write the send buffer data
					-- check if the send buffer is being overflow (no need to write)
					if (s_overflow_send_buffer = '1') then
						send_buffer_wrreq_o <= '0';
					else
						send_buffer_wrreq_o <= '1';
					end if;
				-- conditional output signals

				-- state "HOUSEKEEPING_WRITER_FINISH"
				when HOUSEKEEPING_WRITER_FINISH =>
					-- finish housekeeping writer unit operation
					-- default output signals
					housekeeping_wr_busy_o     <= '1';
					-- indicate that the housekeeping writer is finished
					housekeeping_wr_finished_o <= '1';
					hk_mem_byte_address_o      <= c_HK_RESET_BYTE_ADDR;
					hk_mem_read_o              <= '0';
					send_buffer_wrreq_o        <= '0';
					send_buffer_wrdata_o       <= x"00";
				-- conditional output signals

				-- all the other states (not defined)
				when others =>
					null;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_housekeeping_writer_state <= STOPPED;
				v_housekeeping_writer_state := STOPPED;
			end if;

		end if;
	end process p_data_packet_housekeeping_writer_FSM_state;

end architecture RTL;
