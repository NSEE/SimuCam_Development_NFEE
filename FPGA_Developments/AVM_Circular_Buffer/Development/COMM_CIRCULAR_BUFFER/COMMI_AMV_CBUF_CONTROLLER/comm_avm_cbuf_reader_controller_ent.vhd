library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avm_cbuf_pkg.all;
use work.comm_cbuf_pkg.all;

entity comm_avm_cbuf_reader_controller_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		cbuf_rd_control_i       : in  t_comm_cbuf_rd_control;
		cbuf_wr_busy_i          : in  std_logic;
		avm_master_rd_status_i  : in  t_comm_avm_cbuf_master_rd_status;
		cbuf_rd_status_o        : out t_comm_cbuf_rd_status;
		avm_master_rd_control_o : out t_comm_avm_cbuf_master_rd_control
	);
end entity comm_avm_cbuf_reader_controller_ent;

architecture RTL of comm_avm_cbuf_reader_controller_ent is

	type t_comm_avm_cbuf_reader_controller_fsm is (
		IDLE,                           -- avm cbuf reader controller is in idle
		AVM_WAITING,                    -- avm reader is waiting the avm bus be released
		READ_START,                     -- start of a avm read
		READ_WAITING,                   -- wait for avm read to finish
		FINISHED                        -- avm cbuf reader controller is finished
	);

	signal s_comm_avm_cbuf_reader_controller_state : t_comm_avm_cbuf_reader_controller_fsm;

begin

	p_comm_avm_cbuf_reader_controller : process(clk_i, rst_i) is
		variable v_comm_avm_cbuf_reader_controller_state : t_comm_avm_cbuf_reader_controller_fsm := IDLE;
		variable v_rd_word_addr                          : std_logic_vector(63 downto 0); -- 2^64 bytes of address / 2 bytes per word = 2^63 words of addr + overflow bit
		variable v_rd_word_data                          : std_logic_vector(15 downto 0);
		variable v_rd_addr_offset                        : std_logic_vector(63 downto 0); -- 2^64 bytes of address / 2 bytes per word = 2^63 words of addr + overflow bit 
		variable v_rd_head_offset                        : std_logic_vector(63 downto 0); -- 2^64 bytes of address / 2 bytes per word = 2^63 words of addr + overflow bit
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_comm_avm_cbuf_reader_controller_state <= IDLE;
			v_comm_avm_cbuf_reader_controller_state := IDLE;
			-- internal signals reset
			v_rd_word_addr                          := (others => '0');
			v_rd_word_data                          := (others => '0');
			v_rd_addr_offset                        := (others => '0');
			v_rd_head_offset                        := (others => '0');
			-- outputs reset
			cbuf_rd_status_o                        <= c_COMM_CBUF_RD_STATUS_RST;
			avm_master_rd_control_o                 <= c_COMM_AVM_CBUF_MASTER_RD_CONTROL_RST;
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_avm_cbuf_reader_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- avm cbuf reader controller is in idle
					-- default state transition
					s_comm_avm_cbuf_reader_controller_state <= IDLE;
					v_comm_avm_cbuf_reader_controller_state := IDLE;
					-- default internal signal values
					v_rd_word_addr                          := (others => '0');
					v_rd_addr_offset                        := (others => '0');
					v_rd_head_offset                        := (others => '0');
					-- conditional state transition
					-- check if a read was requested
					if (cbuf_rd_control_i.read = '1') then
						-- read requested
						-- set the read addr offset variable
						v_rd_addr_offset(63)           := '0';
						v_rd_addr_offset(62 downto 0)  := cbuf_rd_control_i.addr_offset(63 downto 1);
						-- set the read head offset variable
						v_rd_head_offset(63 downto 24) := (others => '0');
						v_rd_head_offset(23 downto 0)  := cbuf_rd_control_i.tail_offset;
						-- set the word addr signal
						v_rd_word_addr                 := std_logic_vector(unsigned(v_rd_addr_offset) + unsigned(v_rd_head_offset));
						-- check if the cbuffer is already empty
						if (cbuf_rd_control_i.empty = '1') then
							-- cbuffer is already empty
							-- skip the read to avoid underflow issues
							-- go to finished
							s_comm_avm_cbuf_reader_controller_state <= FINISHED;
							v_comm_avm_cbuf_reader_controller_state := FINISHED;
						-- check if the avm writer controller is busy (using the avm bus)
						elsif (cbuf_wr_busy_i = '1') then
							-- the avm writer controller is busy (using the avm bus)
							-- go to avm waiting
							s_comm_avm_cbuf_reader_controller_state <= AVM_WAITING;
							v_comm_avm_cbuf_reader_controller_state := AVM_WAITING;
						else
							-- the avm writer controller is free (not using the avm bus)
							-- go to read start
							s_comm_avm_cbuf_reader_controller_state <= READ_START;
							v_comm_avm_cbuf_reader_controller_state := READ_START;
						end if;
					end if;

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- avm reader is waiting the avm bus be released
					-- default state transition
					s_comm_avm_cbuf_reader_controller_state <= AVM_WAITING;
					v_comm_avm_cbuf_reader_controller_state := AVM_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm writer controller is free (not using the avm bus)
					if (cbuf_wr_busy_i = '0') then
						-- the avm writer controller is free (not using the avm bus)
						-- go to read start
						s_comm_avm_cbuf_reader_controller_state <= READ_START;
						v_comm_avm_cbuf_reader_controller_state := READ_START;
					end if;

				-- state "READ_START"
				when READ_START =>
					-- start of a avm read
					-- default state transition
					s_comm_avm_cbuf_reader_controller_state <= READ_WAITING;
					v_comm_avm_cbuf_reader_controller_state := READ_WAITING;
				-- default internal signal values
				-- conditional state transition

				-- state "READ_WAITING"
				when READ_WAITING =>
					-- wait for avm read to finish
					-- default state transition
					s_comm_avm_cbuf_reader_controller_state <= READ_WAITING;
					v_comm_avm_cbuf_reader_controller_state := READ_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm read have valid data (is finished)
					if (avm_master_rd_status_i.rd_valid = '1') then
						-- avm read have valid data (is finished)
						-- latch read data
						v_rd_word_data                          := avm_master_rd_status_i.rd_data;
						-- go to finished
						s_comm_avm_cbuf_reader_controller_state <= FINISHED;
						v_comm_avm_cbuf_reader_controller_state := FINISHED;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- avm cbuf reader controller is finished
					-- default state transition
					s_comm_avm_cbuf_reader_controller_state <= IDLE;
					v_comm_avm_cbuf_reader_controller_state := IDLE;
					-- default internal signal values
					v_rd_word_addr                          := (others => '0');
					v_rd_addr_offset                        := (others => '0');
					v_rd_head_offset                        := (others => '0');
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_comm_avm_cbuf_reader_controller_state <= IDLE;
					v_comm_avm_cbuf_reader_controller_state := IDLE;

			end case;

			-- check if a flush was issued
			if (cbuf_rd_control_i.flush = '1') then
				-- a flush was issued
				-- go to idle
				s_comm_avm_cbuf_reader_controller_state <= IDLE;
				v_comm_avm_cbuf_reader_controller_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			cbuf_rd_status_o           <= c_COMM_CBUF_RD_STATUS_RST;
			cbuf_rd_status_o.data_word <= v_rd_word_data;
			avm_master_rd_control_o    <= c_COMM_AVM_CBUF_MASTER_RD_CONTROL_RST;
			-- Output generation FSM
			case (v_comm_avm_cbuf_reader_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- avm cbuf reader controller is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- avm reader is waiting the avm bus be released
					-- default output signals
					cbuf_rd_status_o.busy <= '1';
				-- conditional output signals

				-- state "READ_START"
				when READ_START =>
					-- start of a avm read
					-- default output signals
					cbuf_rd_status_o.busy                           <= '1';
					avm_master_rd_control_o.rd_req                  <= '1';
					avm_master_rd_control_o.rd_address(63 downto 1) <= v_rd_word_addr(62 downto 0);
					avm_master_rd_control_o.rd_address(0)           <= '0';
				-- conditional output signals

				-- state "READ_WAITING"
				when READ_WAITING =>
					-- wait for avm read to finish
					-- default output signals
					cbuf_rd_status_o.busy <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- avm cbuf reader controller is finished
					-- default output signals
					cbuf_rd_status_o.busy      <= '1';
					cbuf_rd_status_o.datavalid <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_comm_avm_cbuf_reader_controller;

end architecture RTL;
