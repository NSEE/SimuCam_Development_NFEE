library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mfil_avm_data_pkg.all;

entity mfil_avm_writer_controller_ent is
	generic(
		g_DELAY_TIMEOUT_CLKDIV : natural range 0 to 65535 := 49999 -- [100 MHz / 50000 = 2 kHz = 0,5 ms]
	);
	port(
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		controller_wr_start_i        : in  std_logic;
		controller_wr_reset_i        : in  std_logic;
		controller_wr_initial_addr_i : in  std_logic_vector(63 downto 0);
		controller_wr_length_bytes_i : in  std_logic_vector(31 downto 0);
		controller_wr_data_i         : in  std_logic_vector(255 downto 0);
		controller_wr_timeout_i      : in  std_logic_vector(15 downto 0);
		avm_master_wr_status_i       : in  t_mfil_avm_data_master_wr_status;
		controller_wr_busy_o         : out std_logic;
		controller_wr_timeout_err_o  : out std_logic;
		avm_master_wr_control_o      : out t_mfil_avm_data_master_wr_control
	);
end entity mfil_avm_writer_controller_ent;

architecture RTL of mfil_avm_writer_controller_ent is

	type t_mfil_avm_writer_controller_fsm is (
		IDLE,                           -- avm writer controller is in idle
		BUFFER_WAITING,                 -- waiting data buffer to have data
		BUFFER_FETCH,                   -- fetch data from data buffer
		WRITE_START,                    -- start of a avm write
		WRITE_WAITING,                  -- wait for avm write to finish
		FINISHED                        -- avm writer controller is finished
	);

	signal s_mfil_avm_writer_controller_state : t_mfil_avm_writer_controller_fsm;

	signal s_wr_addr_cnt : unsigned(58 downto 0); -- 2^64 bytes of address / 32 bytes per word = 2^59 words of addr
	signal s_wr_data_cnt : unsigned(26 downto 0); -- 2^32 bytes of maximum length / 32 bytes per write = 2^27 maximum write length

	signal s_wr_timeout_error : std_logic;

	signal s_timeout_delay_clear    : std_logic;
	signal s_timeout_delay_trigger  : std_logic;
	signal s_timeout_delay_timer    : std_logic_vector(15 downto 0);
	signal s_timeout_delay_busy     : std_logic;
	signal s_timeout_delay_finished : std_logic;

	constant c_WR_ADDR_OVERFLOW_VAL : unsigned((s_wr_addr_cnt'length - 1) downto 0) := (others => '1');

begin

	timeout_delay_block_ent_inst : entity work.delay_block_ent
		generic map(
			g_CLKDIV      => std_logic_vector(to_unsigned(g_DELAY_TIMEOUT_CLKDIV, 16)),
			g_TIMER_WIDTH => s_timeout_delay_timer'length
		)
		port map(
			clk_i            => clk_i,
			rst_i            => rst_i,
			clr_i            => s_timeout_delay_clear,
			delay_trigger_i  => s_timeout_delay_trigger,
			delay_timer_i    => s_timeout_delay_timer,
			delay_busy_o     => s_timeout_delay_busy,
			delay_finished_o => s_timeout_delay_finished
		);

	p_mfil_avm_writer_controller : process(clk_i, rst_i) is
		variable v_mfil_avm_writer_controller_state : t_mfil_avm_writer_controller_fsm := IDLE;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_mfil_avm_writer_controller_state <= IDLE;
			v_mfil_avm_writer_controller_state := IDLE;
			-- internal signals reset
			s_wr_addr_cnt                      <= to_unsigned(0, s_wr_addr_cnt'length);
			s_wr_data_cnt                      <= to_unsigned(0, s_wr_data_cnt'length);
			s_wr_timeout_error                 <= '0';
			s_timeout_delay_clear              <= '0';
			s_timeout_delay_trigger            <= '0';
			s_timeout_delay_timer              <= (others => '0');
			-- outputs reset
			controller_wr_busy_o               <= '0';
			controller_wr_timeout_err_o        <= '0';
			avm_master_wr_control_o            <= c_MFIL_AVM_DATA_MASTER_WR_CONTROL_RST;
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_mfil_avm_writer_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- avm writer controller is in idle
					-- default state transition
					s_mfil_avm_writer_controller_state <= IDLE;
					v_mfil_avm_writer_controller_state := IDLE;
					-- default internal signal values
					s_wr_addr_cnt                      <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                      <= to_unsigned(0, s_wr_data_cnt'length);
					s_wr_timeout_error                 <= '0';
					s_timeout_delay_clear              <= '0';
					s_timeout_delay_trigger            <= '0';
					s_timeout_delay_timer              <= (others => '0');
					-- conditional state transition
					-- check if a write start was requested
					if (controller_wr_start_i = '1') then
						-- write start requested
						-- set write parameters
						-- set the write addr counter to the (write initial addr / 32)
						s_wr_addr_cnt                      <= unsigned(controller_wr_initial_addr_i(63 downto 5));
						-- set the write data counter to the (write data length / 32)
						s_wr_data_cnt                      <= unsigned(controller_wr_length_bytes_i(31 downto 5));
						-- check if the write data length is aligned to 32 bytes and is not already zero
						if ((controller_wr_length_bytes_i(4 downto 0) = "00000") and (s_wr_data_cnt /= 0)) then
							-- the write data length is aligned to 32 bytes and is not already zero
							-- decrement the write data counter
							s_wr_data_cnt <= s_wr_data_cnt - 1;
						end if;
						-- check if a timeout was requested
						if (controller_wr_timeout_i /= std_logic_vector(to_unsigned(0, controller_wr_timeout_i'length))) then
							s_timeout_delay_trigger <= '1';
							s_timeout_delay_timer   <= controller_wr_timeout_i;
						end if;
						-- go to buffer waiting
						s_mfil_avm_writer_controller_state <= BUFFER_WAITING;
						v_mfil_avm_writer_controller_state := BUFFER_WAITING;
					end if;

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting data buffer to have data
					-- default state transition
					s_mfil_avm_writer_controller_state <= BUFFER_WAITING;
					v_mfil_avm_writer_controller_state := BUFFER_WAITING;
					-- default internal signal values
					s_timeout_delay_trigger            <= '0';
					-- conditional state transition
					-- check if the avm write can start
					if (avm_master_wr_status_i.wr_ready = '1') then
						-- the avm write can start
						-- go to buffer read
						s_mfil_avm_writer_controller_state <= BUFFER_FETCH;
						v_mfil_avm_writer_controller_state := BUFFER_FETCH;
					end if;

				-- state "BUFFER_FETCH"
				when BUFFER_FETCH =>
					-- fetch data from data buffer
					-- default state transition
					s_mfil_avm_writer_controller_state <= WRITE_START;
					v_mfil_avm_writer_controller_state := WRITE_START;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of a avm write
					-- default state transition
					s_mfil_avm_writer_controller_state <= WRITE_WAITING;
					v_mfil_avm_writer_controller_state := WRITE_WAITING;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default state transition
					s_mfil_avm_writer_controller_state <= WRITE_WAITING;
					v_mfil_avm_writer_controller_state := WRITE_WAITING;
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
							s_mfil_avm_writer_controller_state <= FINISHED;
							v_mfil_avm_writer_controller_state := FINISHED;
						else
							-- there is more data to be write
							-- decrement write data counter
							s_wr_data_cnt <= s_wr_data_cnt - 1;
							-- check if the avm write can start
							if (avm_master_wr_status_i.wr_ready = '1') then
								-- the avm write can start
								-- go to buffer read
								s_mfil_avm_writer_controller_state <= BUFFER_FETCH;
								v_mfil_avm_writer_controller_state := BUFFER_FETCH;
							else
								-- the data buffer is not ready to be read or not empty or the avm write cannot start
								-- go to buffer waiting
								s_mfil_avm_writer_controller_state <= BUFFER_WAITING;
								v_mfil_avm_writer_controller_state := BUFFER_WAITING;
							end if;
						end if;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- avm writer controller is finished
					-- default state transition
					s_mfil_avm_writer_controller_state <= FINISHED;
					v_mfil_avm_writer_controller_state := FINISHED;
					-- default internal signal values
					s_wr_addr_cnt                      <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                      <= to_unsigned(0, s_wr_data_cnt'length);
					s_timeout_delay_clear              <= '1';
					s_timeout_delay_trigger            <= '0';
					s_timeout_delay_timer              <= (others => '0');
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_mfil_avm_writer_controller_state <= IDLE;
					v_mfil_avm_writer_controller_state := IDLE;

			end case;

			-- check if a reset was requested
			if (controller_wr_reset_i = '1') then
				-- a reset was requested
				-- go to idle
				s_mfil_avm_writer_controller_state <= IDLE;
				v_mfil_avm_writer_controller_state := IDLE;
			-- check if the timeout delay is finished	
			elsif (s_timeout_delay_finished = '1') then
				-- the timeout delay is finished
				-- set the timeout error flag
				s_wr_timeout_error                 <= '1';
				-- go to finished
				s_mfil_avm_writer_controller_state <= FINISHED;
				v_mfil_avm_writer_controller_state := FINISHED;
			end if;

			-- Output Generation --
			-- Default output generation
			controller_wr_busy_o        <= '0';
			controller_wr_timeout_err_o <= '0';
			avm_master_wr_control_o     <= c_MFIL_AVM_DATA_MASTER_WR_CONTROL_RST;
			-- Output generation FSM
			case (v_mfil_avm_writer_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- avm writer controller is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting data buffer to have data
					-- default output signals
					controller_wr_busy_o <= '1';
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
					avm_master_wr_control_o.wr_data                 <= controller_wr_data_i;
				-- conditional output signals

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- avm writer controller is finished
					-- default output signals
					controller_wr_timeout_err_o      <= s_wr_timeout_error;
					avm_master_wr_control_o.wr_abort <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_mfil_avm_writer_controller;

end architecture RTL;
