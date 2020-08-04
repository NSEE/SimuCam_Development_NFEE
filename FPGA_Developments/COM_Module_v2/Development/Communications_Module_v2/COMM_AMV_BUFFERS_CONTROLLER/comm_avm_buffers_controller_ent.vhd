library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avm_buffers_pkg.all;
use work.windowing_dataset_pkg.all;

entity comm_avm_buffers_controller_ent is
	port(
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		fee_clear_signal_i           : in  std_logic;
		fee_stop_signal_i            : in  std_logic;
		fee_start_signal_i           : in  std_logic;
		controller_rd_start_i        : in  std_logic;
		controller_rd_reset_i        : in  std_logic;
		controller_rd_initial_addr_i : in  std_logic_vector(63 downto 0);
		controller_rd_length_bytes_i : in  std_logic_vector(31 downto 0);
		avm_master_rd_status_i       : in  t_comm_avm_buffers_master_rd_status;
		window_buffer_control_i      : in  t_windowing_buffer_control;
		controller_rd_busy_o         : out std_logic;
		controller_rd_finished_o     : out std_logic;
		avm_master_rd_control_o      : out t_comm_avm_buffers_master_rd_control;
		window_buffer_o              : out t_windowing_buffer
	);
end entity comm_avm_buffers_controller_ent;

architecture RTL of comm_avm_buffers_controller_ent is

	type t_comm_avm_buffers_controller_fsm is (
		STOPPED,                        -- avm buffers controller is stopped
		IDLE,                           -- avm buffers controller is in idle
		BUFFER_WAITING,                 -- waiting windowing buffer 
		READ_START,                     -- start of a avm read
		READ_WAITING,                   -- wait for avm read to finish
		BUFFER_WRITE,                   -- write windowing buffer
		FINISHED                        -- avm buffers controller is finished
	);

	signal s_comm_avm_buffers_controller_state : t_comm_avm_buffers_controller_fsm;

	signal s_rd_addr_cnt : unsigned(58 downto 0); -- 2^64 bytes of address / 32 bytes per word = 2^59 words of addr
	signal s_rd_data_cnt : unsigned(26 downto 0); -- 2^32 bytes of maximum length / 32 bytes per read = 2^27 maximum read length

	constant c_RD_ADDR_OVERFLOW_VAL : unsigned((s_rd_addr_cnt'length - 1) downto 0) := (others => '1');

begin

	p_comm_avm_buffers_controller : process(clk_i, rst_i) is
		variable v_comm_avm_buffers_controller_state : t_comm_avm_buffers_controller_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_comm_avm_buffers_controller_state <= STOPPED;
			v_comm_avm_buffers_controller_state := STOPPED;
			-- internal signals reset
			s_rd_addr_cnt                       <= to_unsigned(0, s_rd_addr_cnt'length);
			s_rd_data_cnt                       <= to_unsigned(0, s_rd_data_cnt'length);
			-- outputs reset
			controller_rd_busy_o                <= '0';
			controller_rd_finished_o            <= '0';
			avm_master_rd_control_o             <= c_COMM_AVM_BUFFERS_MASTER_RD_CONTROL_RST;
			window_buffer_o.wrdata              <= (others => '0');
			window_buffer_o.wrreq               <= '0';
			window_buffer_o.sclr                <= '1';
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_avm_buffers_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- avm buffers controller is stopped
					-- default state transition
					s_comm_avm_buffers_controller_state <= STOPPED;
					v_comm_avm_buffers_controller_state := STOPPED;
					-- default internal signal values
					s_rd_addr_cnt                       <= to_unsigned(0, s_rd_addr_cnt'length);
					s_rd_data_cnt                       <= to_unsigned(0, s_rd_data_cnt'length);
					-- conditional state transition
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_comm_avm_buffers_controller_state <= IDLE;
						v_comm_avm_buffers_controller_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- avm buffers controller is in idle
					-- default state transition
					s_comm_avm_buffers_controller_state <= IDLE;
					v_comm_avm_buffers_controller_state := IDLE;
					-- default internal signal values
					s_rd_addr_cnt                       <= to_unsigned(0, s_rd_addr_cnt'length);
					s_rd_data_cnt                       <= to_unsigned(0, s_rd_data_cnt'length);
					-- conditional state transition
					-- check if a read start was requested
					if (controller_rd_start_i = '1') then
						-- read start requested
						-- set read parameters
						-- set the read addr counter to the (read initial addr / 32)
						s_rd_addr_cnt                       <= unsigned(controller_rd_initial_addr_i(63 downto 5));
						-- set the read data counter to the (read data length / 32)
						s_rd_data_cnt                       <= unsigned(controller_rd_length_bytes_i(31 downto 5));
						-- check if the read data length is aligned to 32 bytes and is not already zero
						if ((controller_rd_length_bytes_i(4 downto 0) = "00000") and (s_rd_data_cnt /= 0)) then
							-- the read data length is aligned to 32 bytes and is not already zero
							-- decrement the read data counter
							s_rd_data_cnt <= s_rd_data_cnt - 1;
						end if;
						-- go to buffer waiting
						s_comm_avm_buffers_controller_state <= BUFFER_WAITING;
						v_comm_avm_buffers_controller_state := BUFFER_WAITING;
					end if;

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting windowing buffer
					-- default state transition
					s_comm_avm_buffers_controller_state <= BUFFER_WAITING;
					v_comm_avm_buffers_controller_state := BUFFER_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the windowing buffer is unlocked and the avm read can start
					if ((window_buffer_control_i.locked = '0') and (avm_master_rd_status_i.rd_able = '1')) then
						-- the windowing buffer is unlocked and the avm read can start
						-- go to read start
						s_comm_avm_buffers_controller_state <= READ_START;
						v_comm_avm_buffers_controller_state := READ_START;
					end if;

				-- state "READ_START"
				when READ_START =>
					-- start of a avm read
					-- default state transition
					s_comm_avm_buffers_controller_state <= READ_WAITING;
					v_comm_avm_buffers_controller_state := READ_WAITING;
				-- default internal signal values
				-- conditional state transition

				-- state "READ_WAITING"
				when READ_WAITING =>
					-- wait for avm read to finish
					-- default state transition
					s_comm_avm_buffers_controller_state <= READ_WAITING;
					v_comm_avm_buffers_controller_state := READ_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm read have valid data (is finished)
					if (avm_master_rd_status_i.rd_valid = '1') then
						-- avm read have valid data (is finished)
						-- update read addr counter
						-- check if the read addr counter will overflow
						if (s_rd_addr_cnt = c_RD_ADDR_OVERFLOW_VAL) then
							-- the read addr counter will overflow
							-- clear the read addr counter
							s_rd_addr_cnt <= to_unsigned(0, s_rd_addr_cnt'length);
						else
							-- the read addr counter will not overflow
							-- increment the read addr counter
							s_rd_addr_cnt <= s_rd_addr_cnt + 1;
						end if;
						-- go to write buffer
						s_comm_avm_buffers_controller_state <= BUFFER_WRITE;
						v_comm_avm_buffers_controller_state := BUFFER_WRITE;
					end if;

				-- state "BUFFER_WRITE"
				when BUFFER_WRITE =>
					-- write windowing buffer
					-- default state transition
					s_comm_avm_buffers_controller_state <= FINISHED;
					v_comm_avm_buffers_controller_state := FINISHED;
					-- default internal signal values
					-- conditional state transition
					-- check if there is more data to be read
					if (s_rd_data_cnt /= 0) then
						-- there is more data to be read
						-- decrement read data counter
						s_rd_data_cnt <= s_rd_data_cnt - 1;
						-- check if the windowing buffer is unlocked and the avm read can start
						if ((window_buffer_control_i.locked = '0') and (avm_master_rd_status_i.rd_able = '1')) then
							-- the windowing buffer is unlocked and the avm read can start
							-- go to read start
							s_comm_avm_buffers_controller_state <= READ_START;
							v_comm_avm_buffers_controller_state := READ_START;
						else
							-- the windowing buffer is locked
							-- go to buffer waiting
							s_comm_avm_buffers_controller_state <= BUFFER_WAITING;
							v_comm_avm_buffers_controller_state := BUFFER_WAITING;
						end if;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- avm buffers controller is finished
					-- default state transition
					s_comm_avm_buffers_controller_state <= IDLE;
					v_comm_avm_buffers_controller_state := IDLE;
					-- default internal signal values
					s_rd_addr_cnt                       <= to_unsigned(0, s_rd_addr_cnt'length);
					s_rd_data_cnt                       <= to_unsigned(0, s_rd_data_cnt'length);
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_comm_avm_buffers_controller_state <= STOPPED;
					v_comm_avm_buffers_controller_state := STOPPED;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- a stop was issued
				-- go to stopped
				s_comm_avm_buffers_controller_state <= STOPPED;
				v_comm_avm_buffers_controller_state := STOPPED;
			-- check if a reset was requested
			elsif (controller_rd_reset_i = '1') then
				-- a reset was requested
				-- go to idle
				s_comm_avm_buffers_controller_state <= IDLE;
				v_comm_avm_buffers_controller_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			controller_rd_busy_o     <= '0';
			controller_rd_finished_o <= '0';
			avm_master_rd_control_o  <= c_COMM_AVM_BUFFERS_MASTER_RD_CONTROL_RST;
			window_buffer_o.wrdata   <= (others => '0');
			window_buffer_o.wrreq    <= '0';
			window_buffer_o.sclr     <= '0';
			-- Output generation FSM
			case (v_comm_avm_buffers_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- avm buffers controller is stopped
					-- default output signals
					-- conditional output signals
					-- check if a clear was issued
					if (fee_clear_signal_i = '1') then
						-- clear issued
						-- clear windowing buffer
						window_buffer_o.sclr <= '1';
					end if;

				-- state "IDLE"
				when IDLE =>
					-- avm buffers controller is in idle
					-- default output signals
					-- conditional output signals

					-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting windowing buffer
					-- default output signals
					controller_rd_busy_o <= '1';
				-- conditional output signals

				-- state "READ_START"
				when READ_START =>
					-- start of a avm read
					-- default output signals
					controller_rd_busy_o                            <= '1';
					avm_master_rd_control_o.rd_req                  <= '1';
					avm_master_rd_control_o.rd_address(63 downto 5) <= std_logic_vector(s_rd_addr_cnt);
					avm_master_rd_control_o.rd_address(4 downto 0)  <= (others => '0');
				-- conditional output signals

				-- state "READ_WAITING"
				when READ_WAITING =>
					-- wait for avm read to finish
					-- default output signals
					controller_rd_busy_o <= '1';
				-- conditional output signals

				-- state "BUFFER_WRITE"
				when BUFFER_WRITE =>
					-- write windowing buffer
					-- default output signals
					controller_rd_busy_o   <= '1';
					window_buffer_o.wrdata <= avm_master_rd_status_i.rd_data;
					window_buffer_o.wrreq  <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- avm buffers controller is finished
					-- default output signals
					controller_rd_busy_o     <= '1';
					controller_rd_finished_o <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_comm_avm_buffers_controller;

end architecture RTL;
