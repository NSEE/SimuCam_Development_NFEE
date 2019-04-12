library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_pattern_generator_pkg.all;
use work.pgen_data_controller_pkg.all;

entity pgen_pattern_generator is
	port(
		clk_i                           : in  std_logic;
		rst_i                           : in  std_logic;
		control_i                       : in  t_pgen_pattern_generator_control;
		config_i                        : in  t_pgen_pattern_generator_config;
		data_controller_write_status_i  : in  t_pgen_data_controller_write_status;
		status_o                        : out t_pgen_pattern_generator_status;
		data_o                          : out t_pgen_pattern_generator_write_data;
		data_controller_write_control_o : out t_pgen_data_controller_write_control
	);
end entity pgen_pattern_generator;

architecture rtl of pgen_pattern_generator is

	type t_pattern_control_pointers is record
		pattern_finished : std_logic;
		ccd_row          : std_logic_vector(15 downto 0);
		ccd_column       : std_logic_vector(15 downto 0);
	end record t_pattern_control_pointers;

	------------------------------------------------------------------------------------------------------------------------
	function f_generate_pattern_pixel(
		pattern_seed_i             : t_pgen_pattern_generator_config;
		pattern_control_pointers_i : t_pattern_control_pointers
	) return std_logic_vector is
		variable v_pattern_pixel : std_logic_vector(15 downto 0) := (others => '0');
	begin
		-- check if the next pixel is pattern pixel or fixed data
		if (pattern_control_pointers_i.pattern_finished = '0') then
			-- pattern pixel
			v_pattern_pixel(15 downto 13) := pattern_seed_i.timecode(2 downto 0);
			v_pattern_pixel(12 downto 11) := pattern_seed_i.ccd_number;
			v_pattern_pixel(10)           := pattern_seed_i.ccd_side;
			v_pattern_pixel(9 downto 5)   := pattern_control_pointers_i.ccd_row(4 downto 0);
			v_pattern_pixel(4 downto 0)   := pattern_control_pointers_i.ccd_column(4 downto 0);
		else
			-- fixed data
			v_pattern_pixel := c_PATTERN_DUMB_DATA;
		end if;
		-- Return pixel
		return v_pattern_pixel;
	end function f_generate_pattern_pixel;
	------------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------------------------
	function f_update_pattern_pointers(
		pattern_seed_i             : t_pgen_pattern_generator_config;
		pattern_control_pointers_i : t_pattern_control_pointers
	) return t_pattern_control_pointers is
		variable v_pattern_control_pointers : t_pattern_control_pointers;
	begin
		v_pattern_control_pointers := pattern_control_pointers_i;
		-- check if pattern has not finished
		if (pattern_control_pointers_i.pattern_finished = '0') then
			-- pattern not finished
			-- update column
			v_pattern_control_pointers.ccd_column := std_logic_vector(unsigned(v_pattern_control_pointers.ccd_column) + 1);
			-- check if reached the end of the columns
			if (v_pattern_control_pointers.ccd_column >= pattern_seed_i.columns_quantity) then
				-- end of columns reached. Update row
				v_pattern_control_pointers.ccd_column := (others => '0');
				v_pattern_control_pointers.ccd_row    := std_logic_vector(unsigned(v_pattern_control_pointers.ccd_row) + 1);
				-- check if reached the end of the rows
				if (v_pattern_control_pointers.ccd_row >= pattern_seed_i.rows_quantity) then
					-- end of rows reached. Update image finished flag
					v_pattern_control_pointers.ccd_row          := (others => '0');
					v_pattern_control_pointers.pattern_finished := '1';
				end if;
			end if;
		end if;
		return v_pattern_control_pointers;
	end function f_update_pattern_pointers;
	------------------------------------------------------------------------------------------------------------------------

	type t_pgen_pattern_generator_state is (
		RESETTING,
		STOPPED,
		RUNNING
	);

	type t_pgen_run_state is (
		RUN_PH1,
		RUN_PH2,
		RUN_PH3
	);

	-- current state
	signal s_pgen_pattern_generator_state : t_pgen_pattern_generator_state;

	signal s_pattern_seed        : t_pgen_pattern_generator_config;
	signal s_pattern_pixels      : t_pgen_pattern_generator_write_data;
	signal sf_write_pattern_data : std_logic;

begin
	p_pgen_pattern_generator_FSM_state : process(clk_i, rst_i)
		variable v_pattern_control_pointers     : t_pattern_control_pointers;
		variable v_pgen_pattern_generator_state : t_pgen_pattern_generator_state;
		-- Counter to mask insertion mode
		variable v_counter_mask                 : natural range 0 to 68 := 0;
		-- Run substate machine
		variable v_pgen_run_state : t_pgen_run_state;
	begin
		-- on asynchronous reset in any state we jump to the idle state
		if (rst_i = '1') then
			s_pgen_pattern_generator_state              <= RESETTING;
			v_pgen_pattern_generator_state              := RESETTING;
			v_pattern_control_pointers.ccd_row          := (others => '0');
			v_pattern_control_pointers.ccd_column       := (others => '0');
			v_pattern_control_pointers.pattern_finished := '0';
			v_counter_mask                              := 0;
			s_pattern_seed                              <= config_i;
			s_pattern_pixels.pattern_pixel              <= (others => '0');
			sf_write_pattern_data                       <= '0';
			-- Outputs generation - reset
			status_o.resetted                           <= '1';
			status_o.stopped                            <= '0';
			data_o.pattern_pixel                        <= (others => '0');
			data_controller_write_control_o.data_erase  <= '1';
			data_controller_write_control_o.data_write  <= '0';
			-- Run substate machine default
			v_pgen_run_state := RUN_PH1;

		-- state transitions are always synchronous to the clock
		elsif (rising_edge(clk_i)) then

			case (s_pgen_pattern_generator_state) is

				-- state "RESETTING"
				when RESETTING =>
					-- Reset all the values and go to stopped
					-- default state transition
					s_pgen_pattern_generator_state              <= STOPPED;
					v_pgen_pattern_generator_state              := STOPPED;
					-- default internal signal values
					v_pattern_control_pointers.ccd_row          := (others => '0');
					v_pattern_control_pointers.ccd_column       := (others => '0');
					v_pattern_control_pointers.pattern_finished := '0';
					v_counter_mask                              := 0;
					s_pattern_seed                              <= config_i;
					s_pattern_pixels.pattern_pixel              <= (others => '0');
					sf_write_pattern_data                       <= '0';
					-- Run substate machine default
					v_pgen_run_state := RUN_PH1;
				-- conditional state transition and internal signal values

				-- state "STOPPED"
				when STOPPED =>
					-- Keep the pattern generator stopped and on hold
					-- default state transition
					s_pgen_pattern_generator_state <= STOPPED;
					v_pgen_pattern_generator_state := STOPPED;
					-- default internal signal values
					sf_write_pattern_data          <= '0';
					-- Run substate machine default
					v_pgen_run_state := RUN_PH1;
					-- conditional state transition and internal signal values
					-- check if a command to reset was received
					if (control_i.reset = '1') then
						-- command to reset received, go to resetting
						s_pgen_pattern_generator_state <= RESETTING;
						v_pgen_pattern_generator_state := RESETTING;
					else
						-- command to reset not received
						-- check if a command to start was received
						if (control_i.start = '1') then
							-- command to start received, go to running
							s_pgen_pattern_generator_state <= RUNNING;
							v_pgen_pattern_generator_state := RUNNING;
						end if;
					end if;

				-- state "RUNNING"
				when RUNNING =>
					-- Pattern generator is running and generating pattern pixels
					-- default state transition
					s_pgen_pattern_generator_state <= RUNNING;
					v_pgen_pattern_generator_state := RUNNING;
					-- default internal signal values
					sf_write_pattern_data          <= '0';
					-- conditional state transition and internal signal values
					-- check if a command to stop was received
					-- check if a command to reset was received
					if (control_i.reset = '1') then
						-- command to reset received, go to resetting
						s_pgen_pattern_generator_state <= RESETTING;
						v_pgen_pattern_generator_state := RESETTING;
					else
						-- command to reset not received
						-- check if a command to stop was received
						if (control_i.stop = '1') then
							-- command to stop received, go to stopped
							s_pgen_pattern_generator_state <= STOPPED;
							v_pgen_pattern_generator_state := STOPPED;
						else
							-- command to stop or reset not received, keep running
							-- Running substate machine: double check of fifo full condition!!!
							case (v_pgen_run_state) is
							
								when RUN_PH1 =>
									-- check if the data controller can receive data
									if (data_controller_write_status_i.full = '0') then
										v_pgen_run_state := RUN_PH2;
								 	end if;

								when RUN_PH2 =>
									-- check if the data controller can receive data
									if (data_controller_write_status_i.full = '0') then
										v_pgen_run_state := RUN_PH3;
								 	end if;
	
								when RUN_PH3 => 
									-- check if the data controller can receive data
									if (data_controller_write_status_i.full = '0') then
										-- data controller can receive data, generate next pattern data
										-- Check if mask field bit is off/on
										if (s_pattern_seed.mask_field = '0') then
											-- No mask field (4 pixels = 0xffff) should be inserted ("free running mode")
											-- Reset mask counter
											v_counter_mask                 := 0;
											-- create pattern pixel and update pointers for next pattern
											s_pattern_pixels.pattern_pixel <= f_generate_pattern_pixel(s_pattern_seed, v_pattern_control_pointers);
											v_pattern_control_pointers     := f_update_pattern_pointers(s_pattern_seed, v_pattern_control_pointers);
										else
											-- After 64 pixels generated, it must insert 4 "mask" pixels = 0xffff
											-- Inc mask counter
											v_counter_mask := v_counter_mask + 1;
											-- "Normal pixels" --> v_counter_mask = 1 to 64
											if (v_counter_mask <= 64) then
												-- create pattern pixel and update pointers for next pattern
												s_pattern_pixels.pattern_pixel <= f_generate_pattern_pixel(s_pattern_seed, v_pattern_control_pointers);
												v_pattern_control_pointers     := f_update_pattern_pointers(s_pattern_seed, v_pattern_control_pointers);
											-- "Mask pixels" --> v_counter_mask = 65 to 68
											else
												-- Four "mask" pixels
												s_pattern_pixels.pattern_pixel <= x"ffff";
												if (v_counter_mask = 68) then
													v_counter_mask := 0;
												end if;
											end if;
										end if;
										sf_write_pattern_data <= '1';
										v_pgen_run_state := RUN_PH1;
									end if;
								
								when others =>
									null;
							
							end case;
						end if;
					end if;

				-- all the other states (not defined)
				when others =>
					-- jump to reset state (ERROR?!)
					s_pgen_pattern_generator_state <= RESETTING;
					v_pgen_pattern_generator_state := RESETTING;

			end case;

			-- Output generation
			case (v_pgen_pattern_generator_state) is

				-- state "RESETTING"
				when RESETTING =>
					-- Reset all the values and go to stopped
					-- default output signals
					status_o.resetted <= '1';
					status_o.stopped  <= '0';

					data_o.pattern_pixel <= (others => '0');

					data_controller_write_control_o.data_erase <= '1';
					data_controller_write_control_o.data_write <= '0';
				-- conditional output signals

				-- state "STOPPED"
				when STOPPED =>
					-- Keep the pattern generator stopped and on hold
					-- default output signals
					status_o.resetted                          <= '0';
					status_o.stopped                           <= '1';
					data_o                                     <= s_pattern_pixels;
					data_controller_write_control_o.data_erase <= '0';
					data_controller_write_control_o.data_write <= '0';
				-- conditional output signals

				-- state "RUNNING"
				when RUNNING =>
					-- Pattern generator is running and generating pattern pixels
					-- default output signals
					status_o.resetted                          <= '0';
					status_o.stopped                           <= '0';
					data_o                                     <= s_pattern_pixels;
					data_controller_write_control_o.data_erase <= '0';
					data_controller_write_control_o.data_write <= '0';
					-- conditional output signals
					-- check if the data controller can receive data
					if (sf_write_pattern_data = '1') then
						data_controller_write_control_o.data_write <= '1';
					end if;

				-- all the other states (not defined)
				when others =>
					null;

			end case;
		end if;
	end process p_pgen_pattern_generator_FSM_state;

end architecture rtl;
