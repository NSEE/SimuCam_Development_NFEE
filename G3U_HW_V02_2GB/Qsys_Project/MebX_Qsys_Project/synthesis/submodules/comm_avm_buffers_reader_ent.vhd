library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avm_buffers_pkg.all;

entity comm_avm_buffers_reader_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avm_master_rd_control_i : in  t_comm_avm_buffers_master_rd_control;
		avm_slave_rd_status_i   : in  t_comm_avm_buffers_slave_rd_status;
		avm_master_rd_status_o  : out t_comm_avm_buffers_master_rd_status;
		avm_slave_rd_control_o  : out t_comm_avm_buffers_slave_rd_control
	);
end entity comm_avm_buffers_reader_ent;

architecture RTL of comm_avm_buffers_reader_ent is

	signal s_avm_slave_rd_registered_control : t_comm_avm_buffers_slave_rd_control;

	type t_comm_avm_buffers_reader_fsm is (
		IDLE,                           -- avalon master reader in idle
		READING,                        -- avalon master reader reading
		WAITING,                        -- avalon master reader waiting
		DONE                            -- avalon master reader done
	);

	signal s_comm_avm_buffers_reader_state : t_comm_avm_buffers_reader_fsm;

begin

	p_comm_avm_buffers_reader : process(clk_i, rst_i) is
		variable v_comm_avm_buffers_reader_state : t_comm_avm_buffers_reader_fsm := IDLE;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_comm_avm_buffers_reader_state   <= IDLE;
			v_comm_avm_buffers_reader_state   := IDLE;
			-- internal signals reset
			s_avm_slave_rd_registered_control <= c_COMM_AVM_BUFFERS_SLAVE_RD_CONTROL_RST;
			-- outputs reset
			avm_master_rd_status_o            <= c_COMM_AVM_BUFFERS_MASTER_RD_STATUS_RST;
			avm_slave_rd_control_o            <= c_COMM_AVM_BUFFERS_SLAVE_RD_CONTROL_RST;
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_avm_buffers_reader_state) is

				-- state "IDLE"
				when IDLE =>
					-- avalon master reader in idle
					-- default state transition
					s_comm_avm_buffers_reader_state   <= IDLE;
					v_comm_avm_buffers_reader_state   := IDLE;
					-- default internal signal values
					s_avm_slave_rd_registered_control <= c_COMM_AVM_BUFFERS_SLAVE_RD_CONTROL_RST;
					-- conditional state transition
					-- check if a read request was issued
					if (avm_master_rd_control_i.rd_req = '1') then
						-- a read request was issued, go to reading
						s_comm_avm_buffers_reader_state           <= READING;
						v_comm_avm_buffers_reader_state           := READING;
						s_avm_slave_rd_registered_control.address <= avm_master_rd_control_i.rd_address;
						s_avm_slave_rd_registered_control.read    <= '1';
					end if;

				-- state "READING"
				when READING =>
					-- avalon master reader reading
					-- default state transition
					s_comm_avm_buffers_reader_state <= DONE;
					v_comm_avm_buffers_reader_state := DONE;
					-- default internal signal values
					-- conditional state transition
					-- check if the slave need the master to wait
					if (avm_slave_rd_status_i.waitrequest = '1') then
						-- the slave need the master to wait, go to waiting
						s_comm_avm_buffers_reader_state <= WAITING;
						v_comm_avm_buffers_reader_state := WAITING;
					end if;

				-- state "WAITING"
				when WAITING =>
					-- avalon master reader waiting
					-- default state transition
					s_comm_avm_buffers_reader_state <= WAITING;
					v_comm_avm_buffers_reader_state := WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the slave does not need the master to wait anymore
					if (avm_slave_rd_status_i.waitrequest = '0') then
						-- the slave does not need the master to wait anymore, go to done
						s_comm_avm_buffers_reader_state <= DONE;
						v_comm_avm_buffers_reader_state := DONE;
					end if;

				-- state "DONE"
				when DONE =>
					-- avalon master reader done
					-- default state transition
					s_comm_avm_buffers_reader_state   <= IDLE;
					v_comm_avm_buffers_reader_state   := IDLE;
					-- default internal signal values
					s_avm_slave_rd_registered_control <= c_COMM_AVM_BUFFERS_SLAVE_RD_CONTROL_RST;
					-- conditional state transition
					-- check if a read request was issued
					if (avm_master_rd_control_i.rd_req = '1') then
						-- a read request was issued, go to reading
						s_comm_avm_buffers_reader_state           <= READING;
						v_comm_avm_buffers_reader_state           := READING;
						s_avm_slave_rd_registered_control.address <= avm_master_rd_control_i.rd_address;
						s_avm_slave_rd_registered_control.read    <= '1';
					end if;

				-- all the other states (not defined)
				when others =>
					s_comm_avm_buffers_reader_state <= IDLE;
					v_comm_avm_buffers_reader_state := IDLE;

			end case;

			-- Output Generation --
			-- Default output generation
			avm_master_rd_status_o <= c_COMM_AVM_BUFFERS_MASTER_RD_STATUS_RST;
			avm_slave_rd_control_o <= c_COMM_AVM_BUFFERS_SLAVE_RD_CONTROL_RST;
			-- Output generation FSM
			case (v_comm_avm_buffers_reader_state) is

				-- state "IDLE"
				when IDLE =>
					-- avalon master reader in idle
					-- default output signals
					avm_master_rd_status_o.rd_able <= '1';
				-- conditional output signals

				-- state "READING"
				when READING =>
					-- avalon master reader reading
					-- default output signals
					avm_slave_rd_control_o.address <= avm_master_rd_control_i.rd_address;
					avm_slave_rd_control_o.read    <= '1';
				-- conditional output signals

				-- state "WAITING"
				when WAITING =>
					-- avalon master reader waiting
					-- default output signals
					avm_slave_rd_control_o <= s_avm_slave_rd_registered_control;
				-- conditional output signals

				-- state "DONE"
				when DONE =>
					-- avalon master reader done
					-- default output signals
					avm_master_rd_status_o.rd_able  <= '1';
					avm_master_rd_status_o.rd_data  <= avm_slave_rd_status_i.readdata;
					avm_master_rd_status_o.rd_valid <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_comm_avm_buffers_reader;

end architecture RTL;
