library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mfil_avm_data_pkg.all;

entity mfil_avm_data_writer_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avm_master_wr_control_i : in  t_mfil_avm_data_master_wr_control;
		avm_slave_wr_status_i   : in  t_mfil_avm_data_slave_wr_status;
		avm_master_wr_status_o  : out t_mfil_avm_data_master_wr_status;
		avm_slave_wr_control_o  : out t_mfil_avm_data_slave_wr_control
	);
end entity mfil_avm_data_writer_ent;

architecture RTL of mfil_avm_data_writer_ent is

	signal s_avm_slave_wr_registered_control : t_mfil_avm_data_slave_wr_control;

	type t_mfil_avm_data_writer_fsm is (
		IDLE,                           -- avalon master writer in idle
		WRITING,                        -- avalon master writer writing
		WAITING,                        -- avalon master writer waiting
		DONE                            -- avalon master writer done
	);

	signal s_mfil_avm_data_writer_state : t_mfil_avm_data_writer_fsm;

begin

	p_mfil_avm_data_writer : process(clk_i, rst_i) is
		variable v_mfil_avm_data_writer_state : t_mfil_avm_data_writer_fsm := IDLE;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_mfil_avm_data_writer_state      <= IDLE;
			v_mfil_avm_data_writer_state      := IDLE;
			-- internal signals reset
			s_avm_slave_wr_registered_control <= c_MFIL_AVM_DATA_SLAVE_WR_CONTROL_RST;
			-- outputs reset
			avm_master_wr_status_o            <= c_MFIL_AVM_DATA_MASTER_WR_STATUS_RST;
			avm_slave_wr_control_o            <= c_MFIL_AVM_DATA_SLAVE_WR_CONTROL_RST;
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_mfil_avm_data_writer_state) is

				-- state "IDLE"
				when IDLE =>
					-- avalon master writer in idle
					-- default state transition
					s_mfil_avm_data_writer_state      <= IDLE;
					v_mfil_avm_data_writer_state      := IDLE;
					-- default internal signal values
					s_avm_slave_wr_registered_control <= c_MFIL_AVM_DATA_SLAVE_WR_CONTROL_RST;
					-- conditional state transition
					-- check if a write request was issued
					if (avm_master_wr_control_i.wr_req = '1') then
						-- a write request was issued, go to writing
						s_mfil_avm_data_writer_state                <= WRITING;
						v_mfil_avm_data_writer_state                := WRITING;
						s_avm_slave_wr_registered_control.address   <= avm_master_wr_control_i.wr_address;
						s_avm_slave_wr_registered_control.write     <= '1';
						s_avm_slave_wr_registered_control.writedata <= avm_master_wr_control_i.wr_data;
					end if;

				-- state "WRITING"
				when WRITING =>
					-- avalon master writer writing
					-- default state transition
					s_mfil_avm_data_writer_state <= DONE;
					v_mfil_avm_data_writer_state := DONE;
					-- default internal signal values
					-- conditional state transition
					-- check if the slave need the master to wait
					if (avm_slave_wr_status_i.waitrequest = '1') then
						-- the slave need the master to wait, go to waiting
						s_mfil_avm_data_writer_state <= WAITING;
						v_mfil_avm_data_writer_state := WAITING;
					end if;

				-- state "WAITING"
				when WAITING =>
					-- avalon master writer waiting
					-- default state transition
					s_mfil_avm_data_writer_state <= WAITING;
					v_mfil_avm_data_writer_state := WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the slave does not need the master to wait anymore
					if (avm_slave_wr_status_i.waitrequest = '0') then
						-- the slave does not need the master to wait anymore, go to done
						s_mfil_avm_data_writer_state <= DONE;
						v_mfil_avm_data_writer_state := DONE;
					-- check if an abort command was received
					elsif (avm_master_wr_control_i.wr_abort = '1') then
						-- an abort command was received
						s_mfil_avm_data_writer_state <= DONE;
						v_mfil_avm_data_writer_state := DONE;
					end if;

				-- state "DONE"
				when DONE =>
					-- avalon master writer done
					-- default state transition
					s_mfil_avm_data_writer_state      <= IDLE;
					v_mfil_avm_data_writer_state      := IDLE;
					-- default internal signal values
					s_avm_slave_wr_registered_control <= c_MFIL_AVM_DATA_SLAVE_WR_CONTROL_RST;
					-- conditional state transition
					-- check if a write request was issued
					if (avm_master_wr_control_i.wr_req = '1') then
						-- a write request was issued, go to writing
						s_mfil_avm_data_writer_state                <= WRITING;
						v_mfil_avm_data_writer_state                := WRITING;
						s_avm_slave_wr_registered_control.address   <= avm_master_wr_control_i.wr_address;
						s_avm_slave_wr_registered_control.write     <= '1';
						s_avm_slave_wr_registered_control.writedata <= avm_master_wr_control_i.wr_data;
					end if;

				-- all the other states (not defined)
				when others =>
					s_mfil_avm_data_writer_state <= IDLE;
					v_mfil_avm_data_writer_state := IDLE;

			end case;

			-- Output Generation --
			-- Default output generation
			avm_master_wr_status_o <= c_MFIL_AVM_DATA_MASTER_WR_STATUS_RST;
			avm_slave_wr_control_o <= c_MFIL_AVM_DATA_SLAVE_WR_CONTROL_RST;
			-- Output generation FSM
			case (v_mfil_avm_data_writer_state) is

				-- state "IDLE"
				when IDLE =>
					-- avalon master writer in idle
					-- default output signals
					avm_master_wr_status_o.wr_ready <= '1';
				-- conditional output signals

				-- state "WRITING"
				when WRITING =>
					-- avalon master writer writing
					-- default output signals
					avm_slave_wr_control_o.address   <= avm_master_wr_control_i.wr_address;
					avm_slave_wr_control_o.write     <= '1';
					avm_slave_wr_control_o.writedata <= avm_master_wr_control_i.wr_data;
				-- conditional output signals

				-- state "WAITING"
				when WAITING =>
					-- avalon master writer waiting
					-- default output signals
					avm_slave_wr_control_o <= s_avm_slave_wr_registered_control;
				-- conditional output signals

				-- state "DONE"
				when DONE =>
					-- avalon master writer done
					-- default output signals
					avm_master_wr_status_o.wr_ready <= '1';
					avm_master_wr_status_o.wr_done  <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_mfil_avm_data_writer;

end architecture RTL;
