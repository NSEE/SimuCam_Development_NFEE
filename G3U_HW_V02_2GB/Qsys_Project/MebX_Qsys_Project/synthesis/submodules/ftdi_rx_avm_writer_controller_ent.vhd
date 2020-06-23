library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_avm_usb3_pkg.all;

entity ftdi_rx_avm_writer_controller_ent is
	port(
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		ftdi_module_stop_i           : in  std_logic;
		ftdi_module_start_i          : in  std_logic;
		controller_wr_start_i        : in  std_logic;
		controller_wr_reset_i        : in  std_logic;
		controller_wr_initial_addr_i : in  std_logic_vector(63 downto 0);
		controller_wr_length_bytes_i : in  std_logic_vector(31 downto 0);
		controller_rd_busy_i         : in  std_logic;
		avm_master_wr_status_i       : in  t_ftdi_avm_usb3_master_wr_status;
		buffer_stat_empty_i          : in  std_logic;
		buffer_rddata_i              : in  std_logic_vector(255 downto 0);
		buffer_rdready_i             : in  std_logic;
		controller_wr_busy_o         : out std_logic;
		avm_master_wr_control_o      : out t_ftdi_avm_usb3_master_wr_control;
		buffer_rdreq_o               : out std_logic
	);
end entity ftdi_rx_avm_writer_controller_ent;

architecture RTL of ftdi_rx_avm_writer_controller_ent is

	type t_ftdi_rx_avm_writer_controller_fsm is (
		STOPPED,                        -- rx avm writer controller is stopped
		IDLE,                           -- rx avm writer controller is in idle
		AVM_WAITING,                    -- avm writer is waiting the avm bus be released
		BUFFER_WAITING,                 -- waiting data buffer to have data
		BUFFER_READ,                    -- read data from data buffer
		BUFFER_FETCH,                   -- fetch data from data buffer
		WRITE_START,                    -- start of a avm write
		WRITE_WAITING,                  -- wait for avm write to finish
		FINISHED                        -- rx avm writer controller is finished
	);

	signal s_ftdi_rx_avm_writer_controller_state : t_ftdi_rx_avm_writer_controller_fsm;

	signal s_wr_addr_cnt : unsigned(58 downto 0); -- 2^64 bytes of address / 32 bytes per word = 2^59 words of addr
	signal s_wr_data_cnt : unsigned(26 downto 0); -- 2^32 bytes of maximum length / 32 bytes per write = 2^27 maximum write length

	constant c_WR_ADDR_OVERFLOW_VAL : unsigned((s_wr_addr_cnt'length - 1) downto 0) := (others => '1');

begin

	p_ftdi_rx_avm_writer_controller : process(clk_i, rst_i) is
		variable v_ftdi_rx_avm_writer_controller_state : t_ftdi_rx_avm_writer_controller_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_rx_avm_writer_controller_state <= STOPPED;
			v_ftdi_rx_avm_writer_controller_state := STOPPED;
			-- internal signals reset
			s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
			s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
			-- outputs reset
			controller_wr_busy_o                  <= '0';
			avm_master_wr_control_o               <= c_FTDI_AVM_USB3_MASTER_WR_CONTROL_RST;
			buffer_rdreq_o                        <= '0';
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_ftdi_rx_avm_writer_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- rx avm writer controller is stopped
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= STOPPED;
					v_ftdi_rx_avm_writer_controller_state := STOPPED;
					-- default internal signal values
					s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
					-- conditional state transition
					-- check if a start was issued
					if (ftdi_module_start_i = '1') then
						-- start issued, go to idle
						s_ftdi_rx_avm_writer_controller_state <= IDLE;
						v_ftdi_rx_avm_writer_controller_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- rx avm writer controller is in idle
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= IDLE;
					v_ftdi_rx_avm_writer_controller_state := IDLE;
					-- default internal signal values
					s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
					-- conditional state transition
					-- check if a write start was requested
					if (controller_wr_start_i = '1') then
						-- write start requested
						-- set write parameters
						-- set the write addr counter to the (write initial addr / 32)
						s_wr_addr_cnt <= unsigned(controller_wr_initial_addr_i(63 downto 5));
						-- set the write data counter to the (write data length / 32)
						s_wr_data_cnt <= unsigned(controller_wr_length_bytes_i(31 downto 5));
						-- check if the write data length is aligned to 32 bytes and is not already zero
						if ((controller_wr_length_bytes_i(4 downto 0) = "00000") and (s_wr_data_cnt /= 0)) then
							-- the write data length is aligned to 32 bytes and is not already zero
							-- decrement the write data counter
							s_wr_data_cnt <= s_wr_data_cnt - 1;
						end if;
						-- check if the avm reader controller is busy (using the avm bus)
						if (controller_rd_busy_i = '1') then
							-- the avm reader controller is busy (using the avm bus)
							-- go to avm waiting
							s_ftdi_rx_avm_writer_controller_state <= AVM_WAITING;
							v_ftdi_rx_avm_writer_controller_state := AVM_WAITING;
						else
							-- the avm reader controller is free (not using the avm bus)
							-- go to buffer waiting
							s_ftdi_rx_avm_writer_controller_state <= BUFFER_WAITING;
							v_ftdi_rx_avm_writer_controller_state := BUFFER_WAITING;
						end if;
					end if;

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- avm writer is waiting the avm bus be released
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= AVM_WAITING;
					v_ftdi_rx_avm_writer_controller_state := AVM_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm reader controller is free (not using the avm bus)
					if (controller_rd_busy_i = '0') then
						-- the avm reader controller is free (not using the avm bus)
						-- go to buffer waiting
						s_ftdi_rx_avm_writer_controller_state <= BUFFER_WAITING;
						v_ftdi_rx_avm_writer_controller_state := BUFFER_WAITING;
					end if;

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting data buffer to have data
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= BUFFER_WAITING;
					v_ftdi_rx_avm_writer_controller_state := BUFFER_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the rx data buffer is ready to be read and not empty and the avm write can start
					if ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0') and (avm_master_wr_status_i.wr_ready = '1')) then
						-- the rx data buffer is ready to be read and not empty and the avm write can start
						-- go to buffer read
						s_ftdi_rx_avm_writer_controller_state <= BUFFER_READ;
						v_ftdi_rx_avm_writer_controller_state := BUFFER_READ;
					end if;

				-- state "BUFFER_READ"
				when BUFFER_READ =>
					-- read data from data buffer
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= BUFFER_FETCH;
					v_ftdi_rx_avm_writer_controller_state := BUFFER_FETCH;
				-- default internal signal values
				-- conditional state transition

				-- state "BUFFER_FETCH"
				when BUFFER_FETCH =>
					-- fetch data from data buffer
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= WRITE_START;
					v_ftdi_rx_avm_writer_controller_state := WRITE_START;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of a avm write
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= WRITE_WAITING;
					v_ftdi_rx_avm_writer_controller_state := WRITE_WAITING;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= WRITE_WAITING;
					v_ftdi_rx_avm_writer_controller_state := WRITE_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm write is done
					if (avm_master_wr_status_i.wr_done = '1') then
						-- avm write is done
						-- update write addr counter
						-- check if the write addr counter will overflow
						if (s_wr_addr_cnt = c_WR_ADDR_OVERFLOW_VAL) then
							-- the write addr counter will overflow
							-- clear the write addr counter
							s_wr_addr_cnt <= to_unsigned(0, s_wr_addr_cnt'length);
						else
							-- the write addr counter will not overflow
							-- increment the write addr counter
							s_wr_addr_cnt <= s_wr_addr_cnt + 1;
						end if;
						-- check if there is more data to be write
						if (s_wr_data_cnt = 0) then
							-- there is no more data to be write
							-- go to finished
							s_ftdi_rx_avm_writer_controller_state <= FINISHED;
							v_ftdi_rx_avm_writer_controller_state := FINISHED;
						else
							-- there is more data to be write
							-- decrement write data counter
							s_wr_data_cnt <= s_wr_data_cnt - 1;
							-- check if the rx data buffer is ready to be read and not empty and the avm write can start
							if ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0') and (avm_master_wr_status_i.wr_ready = '1')) then
								-- the rx data buffer is ready to be read and not empty and the avm write can start
								-- go to buffer read
								s_ftdi_rx_avm_writer_controller_state <= BUFFER_READ;
								v_ftdi_rx_avm_writer_controller_state := BUFFER_READ;
							else
								-- the rx data buffer is not ready to be read or not empty or the avm write cannot start
								-- go to buffer waiting
								s_ftdi_rx_avm_writer_controller_state <= BUFFER_WAITING;
								v_ftdi_rx_avm_writer_controller_state := BUFFER_WAITING;
							end if;
						end if;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- rx avm writer controller is finished
					-- default state transition
					s_ftdi_rx_avm_writer_controller_state <= IDLE;
					v_ftdi_rx_avm_writer_controller_state := IDLE;
					-- default internal signal values
					s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_ftdi_rx_avm_writer_controller_state <= STOPPED;
					v_ftdi_rx_avm_writer_controller_state := STOPPED;

			end case;

			-- check if a stop was issued
			if (ftdi_module_stop_i = '1') then
				-- a stop was issued
				-- go to stopped
				s_ftdi_rx_avm_writer_controller_state <= STOPPED;
				v_ftdi_rx_avm_writer_controller_state := STOPPED;
			-- check if a reset was requested
			elsif (controller_wr_reset_i = '1') then
				-- a reset was requested
				-- go to idle
				s_ftdi_rx_avm_writer_controller_state <= IDLE;
				v_ftdi_rx_avm_writer_controller_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			controller_wr_busy_o    <= '0';
			avm_master_wr_control_o <= c_FTDI_AVM_USB3_MASTER_WR_CONTROL_RST;
			buffer_rdreq_o          <= '0';
			-- Output generation FSM
			case (v_ftdi_rx_avm_writer_controller_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- rx avm writer controller is stopped
					-- default output signals
					null;
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- rx avm writer controller is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- avm writer is waiting the avm bus be released
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting data buffer to have data
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "BUFFER_READ"
				when BUFFER_READ =>
					-- read data from data buffer
					-- default output signals
					controller_wr_busy_o <= '1';
					buffer_rdreq_o       <= '1';
				-- conditional output signals

				-- state "BUFFER_FETCH"
				when BUFFER_FETCH =>
					-- fetch data from data buffer
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of a avm write
					-- default output signals
					controller_wr_busy_o                            <= '1';
					avm_master_wr_control_o.wr_req                  <= '1';
					avm_master_wr_control_o.wr_address(63 downto 5) <= std_logic_vector(s_wr_addr_cnt);
					avm_master_wr_control_o.wr_address(4 downto 0)  <= (others => '0');
					avm_master_wr_control_o.wr_data                 <= buffer_rddata_i;
				-- conditional output signals

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- rx avm writer controller is finished
					-- default output signals
					controller_wr_busy_o <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_rx_avm_writer_controller;

end architecture RTL;
