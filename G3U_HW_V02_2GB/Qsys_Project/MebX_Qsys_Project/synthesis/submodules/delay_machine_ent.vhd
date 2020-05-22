library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_machine_ent is
	port(
		clk_i                : in  std_logic;
		rst_i                : in  std_logic;
		-- general inputs
		sync_signal_i        : in  std_logic;
		fee_clear_signal_i   : in  std_logic;
		fee_stop_signal_i    : in  std_logic;
		fee_start_signal_i   : in  std_logic;
		-- others
		fee_ccd_x_size_i     : in  std_logic_vector(15 downto 0);
		fee_ccd_y_size_i     : in  std_logic_vector(15 downto 0);
		fee_ccd_v_start_i    : in  std_logic_vector(15 downto 0);
		fee_ccd_v_end_i      : in  std_logic_vector(15 downto 0);
		fee_start_delay_i    : in  std_logic_vector(31 downto 0);
		fee_skip_delay_i     : in  std_logic_vector(31 downto 0);
		fee_line_delay_i     : in  std_logic_vector(31 downto 0);
		fee_adc_delay_i      : in  std_logic_vector(31 downto 0);
		current_ccd_row_o    : out std_logic_vector(15 downto 0);
		current_ccd_column_o : out std_logic_vector(15 downto 0)
	);
end entity delay_machine_ent;

architecture RTL of delay_machine_ent is

	-- delay machine fsm type
	type t_delay_machine_fsm is (
		STOPPED,
		NOT_STARTED,
		START_DELAY,
		SKIP_DELAY,
		LINE_DELAY,
		ADC_DELAY,
		CCD_FINISHED
	);

	-- delay machine fsm state
	signal s_delay_machine_state : t_delay_machine_fsm;

	-- delay signals
	signal s_delay_cnt        : std_logic_vector((fee_start_delay_i'length - 1) downto 0);
	constant c_DELAY_FINISHED : std_logic_vector((fee_start_delay_i'length - 1) downto 0) := (others => '0');

	-- column counter
	signal s_ccd_column_cnt  : std_logic_vector((fee_ccd_x_size_i'length - 1) downto 0);
	-- row counter
	constant c_CCD_FIRST_ROW : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0) := (others => '0');
	signal s_ccd_row_cnt     : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0);

begin

	p_delay_machine : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_delay_machine_state <= STOPPED;
			s_delay_cnt           <= (others => '0');
			s_ccd_column_cnt      <= (others => '0');
			s_ccd_row_cnt         <= (others => '0');
		elsif rising_edge(clk_i) then

			case (s_delay_machine_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_delay_machine_state <= STOPPED;
					s_delay_cnt           <= (others => '0');
					s_ccd_column_cnt      <= (others => '0');
					s_ccd_row_cnt         <= (others => '0');
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_delay_machine_state <= NOT_STARTED;
					end if;

				when NOT_STARTED =>
					s_delay_machine_state <= NOT_STARTED;
					s_delay_cnt           <= (others => '0');
					s_ccd_column_cnt      <= (others => '0');
					s_ccd_row_cnt         <= (others => '0');
					-- check if the fee requested the start of the delay (sync arrived)
					if (sync_signal_i = '1') then
						-- set delay counter
						if (fee_start_delay_i /= c_DELAY_FINISHED) then
							s_delay_cnt <= std_logic_vector(unsigned(fee_start_delay_i) - 1);
						else
							s_delay_cnt <= (others => '0');
						end if;
						-- go to start delay
						s_delay_machine_state <= START_DELAY;
					end if;

				when START_DELAY =>
					s_delay_machine_state <= START_DELAY;
					s_ccd_column_cnt      <= (others => '0');
					s_ccd_row_cnt         <= (others => '0');
					-- check if the start delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- start delay ended
						-- check if the first row is to be skipped
--						if ((fee_ccd_v_start_i /= c_CCD_FIRST_ROW) or (fee_ccd_v_end_i = c_CCD_FIRST_ROW)) then
						if (fee_ccd_v_start_i /= c_CCD_FIRST_ROW) then
							-- first row is to be skipped
							-- set column counter
							s_ccd_column_cnt      <= fee_ccd_x_size_i;
							-- set delay counter
							if (fee_skip_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_skip_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to skip delay
							s_delay_machine_state <= SKIP_DELAY;
						else
							-- first row is not to be skipped
							-- set delay counter
							if (fee_line_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to line delay
							s_delay_machine_state <= LINE_DELAY;
						end if;
					else
						-- start delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when SKIP_DELAY =>
					s_delay_machine_state <= SKIP_DELAY;
					-- check if the skip delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- skip delay ended
						-- set column counter
						s_ccd_column_cnt <= fee_ccd_x_size_i;
						-- increment row counter
						s_ccd_row_cnt    <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
						-- check if the column was the last of the row
						-- check if the row was the last of the ccd
						if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
							-- row was the last of the ccd
							-- go to ccd finished
							s_delay_machine_state <= CCD_FINISHED;
						else
							-- row was not the last of the ccd
							-- check if the next row is to be skipped
							if (((unsigned(s_ccd_row_cnt) + 1) < unsigned(fee_ccd_v_start_i)) or ((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i))) then
								-- next row is to be skipped
								-- set delay counter
								if (fee_skip_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_skip_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to skip delay
								s_delay_machine_state <= SKIP_DELAY;
							else
								-- first row is not to be skipped
								-- clear column counter
								s_ccd_column_cnt      <= (others => '0');
								-- set delay counter
								if (fee_line_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to line delay
								s_delay_machine_state <= LINE_DELAY;
							end if;
						end if;
					else
						-- skip delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when LINE_DELAY =>
					s_delay_machine_state <= LINE_DELAY;
					-- check if the line delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- line delay ended
						-- set delay counter
						if (fee_adc_delay_i /= c_DELAY_FINISHED) then
							s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
						else
							s_delay_cnt <= (others => '0');
						end if;
						-- go to adc delay
						s_delay_machine_state <= ADC_DELAY;
					else
						-- line delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when ADC_DELAY =>
					s_delay_machine_state <= ADC_DELAY;
					-- check if the adc delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- adc delay ended
						-- increment column counter
						s_ccd_column_cnt <= std_logic_vector(unsigned(s_ccd_column_cnt) + 1);
						-- check if the column was the last of the row
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- column was the last of the row
							-- check if the row was the last of the ccd
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- row was the last of the ccd
								-- increment row counter
								s_ccd_row_cnt         <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								-- go to ccd finished
								s_delay_machine_state <= CCD_FINISHED;
							else
								-- row was not the last of the ccd
								-- clear column counter
								s_ccd_column_cnt <= (others => '0');
								-- increment row counter
								s_ccd_row_cnt    <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								-- check if the next row is to be skipped
								if ((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) then
									-- next row is to be skipped
									-- set delay counter
									if (fee_skip_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_skip_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to skip delay
									s_delay_machine_state <= SKIP_DELAY;
								else
									-- next row is not to be skipped
									-- set delay counter
									if (fee_line_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to line delay
									s_delay_machine_state <= LINE_DELAY;
								end if;
							end if;
						else
							-- column was not the last of the row
							-- set delay counter
							if (fee_adc_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to adc delay
							s_delay_machine_state <= ADC_DELAY;
						end if;
					else
						-- adc delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when CCD_FINISHED =>
					s_delay_machine_state <= CCD_FINISHED;
					s_delay_cnt           <= (others => '0');
					s_ccd_column_cnt      <= fee_ccd_x_size_i;
					s_ccd_row_cnt         <= fee_ccd_y_size_i;

				when others =>
					s_delay_machine_state <= STOPPED;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_delay_machine_state <= STOPPED;
			end if;

		end if;
	end process p_delay_machine;

	-- Signals Assingments --

	-- Outputs Generation --
	current_ccd_row_o    <= s_ccd_row_cnt;
	current_ccd_column_o <= s_ccd_column_cnt;

end architecture RTL;
