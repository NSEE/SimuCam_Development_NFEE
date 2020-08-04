library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_machine_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		-- general inputs
		sync_signal_i         : in  std_logic;
		fee_clear_signal_i    : in  std_logic;
		fee_stop_signal_i     : in  std_logic;
		fee_start_signal_i    : in  std_logic;
		-- others
		fee_ccd_x_size_i      : in  std_logic_vector(15 downto 0);
		fee_ccd_y_size_i      : in  std_logic_vector(15 downto 0);
		fee_data_y_size_i     : in  std_logic_vector(15 downto 0);
		fee_overscan_y_size_i : in  std_logic_vector(15 downto 0);
		fee_ccd_v_start_i     : in  std_logic_vector(15 downto 0);
		fee_ccd_v_end_i       : in  std_logic_vector(15 downto 0);
		fee_ccd_img_v_end_i   : in  std_logic_vector(15 downto 0);
		fee_ccd_ovs_v_end_i   : in  std_logic_vector(15 downto 0);
		fee_ccd_h_start_i     : in  std_logic_vector(15 downto 0);
		fee_ccd_h_end_i       : in  std_logic_vector(15 downto 0);
		fee_start_delay_i     : in  std_logic_vector(31 downto 0);
		fee_skip_lin_delay_i  : in  std_logic_vector(31 downto 0);
		fee_skip_col_delay_i  : in  std_logic_vector(31 downto 0);
		fee_line_delay_i      : in  std_logic_vector(31 downto 0);
		fee_adc_delay_i       : in  std_logic_vector(31 downto 0);
		current_ccd_row_o     : out std_logic_vector(15 downto 0);
		current_ccd_column_o  : out std_logic_vector(15 downto 0);
		current_ccd_pixel_o   : out std_logic_vector(31 downto 0)
	);
end entity delay_machine_ent;

architecture RTL of delay_machine_ent is

	-- delay machine fsm type
	type t_delay_machine_fsm is (
		STOPPED,
		NOT_STARTED,
		CCD_START_DLY,
		IMG_LINE_SKIP_DLY,
		IMG_LINE_READ_DLY,
		IMG_PIXEL_SKIP_DLY,
		IMG_PIXEL_READ_DLY,
		OVS_LINE_SKIP_DLY,
		OVS_LINE_READ_DLY,
		OVS_PIXEL_SKIP_DLY,
		OVS_PIXEL_READ_DLY,
		CCD_FINISHED
	);

	-- delay machine fsm state
	signal s_delay_machine_state : t_delay_machine_fsm;

	-- delay signals
	signal s_delay_cnt        : std_logic_vector((fee_start_delay_i'length - 1) downto 0);
	constant c_DELAY_FINISHED : std_logic_vector((fee_start_delay_i'length - 1) downto 0) := (others => '0');

	-- column counter
	constant c_CCD_FIRST_PIXEL : std_logic_vector((fee_ccd_x_size_i'length - 1) downto 0) := (others => '0');
	signal s_ccd_column_cnt    : std_logic_vector((fee_ccd_x_size_i'length - 1) downto 0);
	-- row counter
	constant c_CCD_FIRST_LINE  : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0) := (others => '0');
	signal s_ccd_row_cnt       : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0);
	signal s_ccd_img_row_cnt   : std_logic_vector((fee_data_y_size_i'length - 1) downto 0);
	signal s_ccd_ovs_row_cnt   : std_logic_vector((fee_overscan_y_size_i'length - 1) downto 0);
	-- pixels counter
	signal s_ccd_pixels_cnt    : unsigned(31 downto 0);
	signal s_ccd_x_size_val    : unsigned(31 downto 0);

begin

	p_delay_machine : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_delay_machine_state <= STOPPED;
			s_delay_cnt           <= (others => '0');
			s_ccd_column_cnt      <= (others => '0');
			s_ccd_row_cnt         <= (others => '0');
			s_ccd_img_row_cnt     <= (others => '0');
			s_ccd_ovs_row_cnt     <= (others => '0');
			s_ccd_pixels_cnt      <= (others => '0');
			s_ccd_x_size_val      <= (others => '0');
		elsif rising_edge(clk_i) then

			case (s_delay_machine_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					s_delay_machine_state <= STOPPED;
					s_delay_cnt           <= (others => '0');
					s_ccd_column_cnt      <= (others => '0');
					s_ccd_row_cnt         <= (others => '0');
					s_ccd_img_row_cnt     <= (others => '0');
					s_ccd_ovs_row_cnt     <= (others => '0');
					s_ccd_pixels_cnt      <= (others => '0');
					s_ccd_x_size_val      <= (others => '0');
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
					s_ccd_img_row_cnt     <= (others => '0');
					s_ccd_ovs_row_cnt     <= (others => '0');
					s_ccd_pixels_cnt      <= (others => '0');
					s_ccd_x_size_val      <= (others => '0');
					-- check if the fee requested the start of the delay (sync arrived)
					if (sync_signal_i = '1') then
						-- set start delay counter
						if (fee_start_delay_i /= c_DELAY_FINISHED) then
							s_delay_cnt <= std_logic_vector(unsigned(fee_start_delay_i) - 1);
						else
							s_delay_cnt <= (others => '0');
						end if;
						-- go to start delay
						s_delay_machine_state <= CCD_START_DLY;
					end if;

				when CCD_START_DLY =>
					s_delay_machine_state          <= CCD_START_DLY;
					s_ccd_column_cnt               <= (others => '0');
					s_ccd_row_cnt                  <= (others => '0');
					s_ccd_img_row_cnt              <= (others => '0');
					s_ccd_ovs_row_cnt              <= (others => '0');
					s_ccd_pixels_cnt               <= (others => '0');
					s_ccd_x_size_val(31 downto 16) <= (others => '0');
					s_ccd_x_size_val(15 downto 0)  <= unsigned(fee_ccd_x_size_i);
					-- check if the start delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- start delay ended
						-- check if the first line is to be skipped
						if (fee_ccd_v_start_i /= c_CCD_FIRST_LINE) then
							-- first line is to be skipped
							-- set column counter to last pixel
							s_ccd_column_cnt      <= fee_ccd_x_size_i;
							-- set delay counter
							if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to line skip delay
							s_delay_machine_state <= IMG_LINE_SKIP_DLY;
						else
							-- first line is not to be skipped
							-- set delay counter
							if (fee_line_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to read line delay
							s_delay_machine_state <= IMG_LINE_READ_DLY;
						end if;
					else
						-- start delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when IMG_LINE_SKIP_DLY =>
					s_delay_machine_state <= IMG_LINE_SKIP_DLY;
					-- check if the line skip delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- line skip delay ended
						-- set column counter to last pixel
						s_ccd_column_cnt  <= fee_ccd_x_size_i;
						-- update the pixel counter
						s_ccd_pixels_cnt  <= s_ccd_pixels_cnt + s_ccd_x_size_val;
						-- increment row counter
						s_ccd_row_cnt     <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
						s_ccd_img_row_cnt <= std_logic_vector(unsigned(s_ccd_img_row_cnt) + 1);
						-- check if the next line is to be skipped
						if (((unsigned(s_ccd_row_cnt) + 1) < unsigned(fee_ccd_v_start_i)) or ((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) or ((unsigned(s_ccd_img_row_cnt) + 1) > unsigned(fee_ccd_img_v_end_i))) then
							-- next line is to be skipped
							-- set delay counter
							if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- check if the line was the last of the img area
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
								-- the line was the last of the img area
								-- check if the fist overscan line will be skipped
								if ((unsigned(s_ccd_row_cnt) + 1) < unsigned(fee_ccd_v_start_i) or (unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) then
									-- the fist overscan line will be skipped
									-- go to ovs skip delay
									s_delay_machine_state <= OVS_LINE_SKIP_DLY;
								else
									-- the fist overscan line will not be skipped
									-- clear the ccd column count
									s_ccd_column_cnt      <= (others => '0');
									-- set delay counter
									if (fee_line_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to ovs read line delay
									s_delay_machine_state <= OVS_LINE_READ_DLY;
								end if;
							else
								-- the line was not the last of the img area
								-- go to img skip delay
								s_delay_machine_state <= IMG_LINE_SKIP_DLY;
							end if;
						else
							-- next line is not to be skipped
							-- clear column counter
							s_ccd_column_cnt <= (others => '0');
							-- set delay counter
							if (fee_line_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- check if the line was the last of the img area
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
								-- the line was the last of the img area
								-- go to ovs read line delay
								s_delay_machine_state <= OVS_LINE_READ_DLY;
							else
								-- the line was not the last of the img area
								-- go to img read line delay
								s_delay_machine_state <= IMG_LINE_READ_DLY;
							end if;
						end if;
					else
						-- skip line delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when IMG_LINE_READ_DLY =>
					s_delay_machine_state <= IMG_LINE_READ_DLY;
					-- check if the read line delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- read line delay ended
						-- check if the first pixel is to be skipped
						if (fee_ccd_h_start_i /= c_CCD_FIRST_PIXEL) then
							-- first pixel is to be skipped
							-- clear column counter
							s_ccd_column_cnt      <= (others => '0');
							-- set skip pixel delay counter
							if (fee_skip_col_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_skip_col_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to pixel skip delay
							s_delay_machine_state <= IMG_PIXEL_SKIP_DLY;
						else
							-- first pixel is not to be skipped
							-- set column counter to first pixel
							s_ccd_column_cnt      <= c_CCD_FIRST_PIXEL;
							-- set read pixel delay counter
							if (fee_adc_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to read pixel delay
							s_delay_machine_state <= IMG_PIXEL_READ_DLY;
						end if;
					else
						-- read line delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when IMG_PIXEL_SKIP_DLY =>
					s_delay_machine_state <= IMG_PIXEL_SKIP_DLY;
					-- check if the skip pixel delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- skip pixel delay ended
						-- increment column counter
						s_ccd_column_cnt <= std_logic_vector(unsigned(s_ccd_column_cnt) + 1);
						-- increment pixel counter
						s_ccd_pixels_cnt <= s_ccd_pixels_cnt + 1;
						-- check if the pixel was the last of the line
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- pixel was the last of the line
							-- check if the line was the last of the ccd
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- line was the last of the ccd
								-- increment row counter
								s_ccd_row_cnt         <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_img_row_cnt     <= std_logic_vector(unsigned(s_ccd_img_row_cnt) + 1);
								-- go to ccd finished
								s_delay_machine_state <= CCD_FINISHED;
							else
								-- line was not the last of the ccd
								-- clear column counter
								s_ccd_column_cnt  <= (others => '0');
								-- increment row counter
								s_ccd_row_cnt     <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_img_row_cnt <= std_logic_vector(unsigned(s_ccd_img_row_cnt) + 1);
								-- check if the next line is to be skipped
								if (((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) or ((unsigned(s_ccd_img_row_cnt) + 1) > unsigned(fee_ccd_img_v_end_i))) then
									-- next line is to be skipped
									-- set line skip delay counter
									if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- check if the line was the last of the img area
									if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
										-- the line was the last of the img area
										-- check if the fist overscan line will be skipped
										if ((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) then
											-- the fist overscan line will be skipped
											-- go to ovs skip delay
											s_delay_machine_state <= OVS_LINE_SKIP_DLY;
										else
											-- the fist overscan line will not be skipped
											-- clear the ccd column count
											s_ccd_column_cnt      <= (others => '0');
											-- set delay counter
											if (fee_line_delay_i /= c_DELAY_FINISHED) then
												s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
											else
												s_delay_cnt <= (others => '0');
											end if;
											-- go to ovs read line delay
											s_delay_machine_state <= OVS_LINE_READ_DLY;
										end if;
									else
										-- the line was not the last of the img area
										-- go to img skip delay
										s_delay_machine_state <= IMG_LINE_SKIP_DLY;
									end if;
								else
									-- next line is not to be skipped
									-- set read line delay counter
									if (fee_line_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- check if the line was the last of the img area
									if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
										-- the line was the last of the img area
										-- go to ovs read line delay
										s_delay_machine_state <= OVS_LINE_READ_DLY;
									else
										-- the line was not the last of the img area
										-- go to img read line delay
										s_delay_machine_state <= IMG_LINE_READ_DLY;
									end if;
								end if;
							end if;
						else
							-- pixel was not the last of the line
							-- check if the next pixel is to be skipped
							if (((unsigned(s_ccd_column_cnt) + 1) < unsigned(fee_ccd_h_start_i)) or ((unsigned(s_ccd_column_cnt) + 1) > unsigned(fee_ccd_h_end_i))) then
								-- next pixel is to be skipped
								-- set pixel skip delay counter
								if (fee_skip_col_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_skip_col_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to pixel skip delay
								s_delay_machine_state <= IMG_PIXEL_SKIP_DLY;
							else
								-- next pixel is not to be skipped
								-- set read pixel delay counter
								if (fee_adc_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to read pixel delay
								s_delay_machine_state <= IMG_PIXEL_READ_DLY;
							end if;
						end if;
					else
						-- skip pixel delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when IMG_PIXEL_READ_DLY =>
					s_delay_machine_state <= IMG_PIXEL_READ_DLY;
					-- check if the read pixel delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- read pixel delay ended
						-- increment column counter
						s_ccd_column_cnt <= std_logic_vector(unsigned(s_ccd_column_cnt) + 1);
						-- increment pixel counter
						s_ccd_pixels_cnt <= s_ccd_pixels_cnt + 1;
						-- check if the pixel was the last of the line
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- pixel was the last of the line
							-- check if the line was the last of the ccd
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- line was the last of the ccd
								-- increment row counter
								s_ccd_row_cnt         <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_img_row_cnt     <= std_logic_vector(unsigned(s_ccd_img_row_cnt) + 1);
								-- go to ccd finished
								s_delay_machine_state <= CCD_FINISHED;
							else
								-- line was not the last of the ccd
								-- clear column counter
								s_ccd_column_cnt  <= (others => '0');
								-- increment row counter
								s_ccd_row_cnt     <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_img_row_cnt <= std_logic_vector(unsigned(s_ccd_img_row_cnt) + 1);
								-- check if the next line is to be skipped
								if (((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) or ((unsigned(s_ccd_img_row_cnt) + 1) > unsigned(fee_ccd_img_v_end_i))) then
									-- next line is to be skipped
									-- set line skip delay counter
									if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to line skip delay
									-- check if the line was the last of the img area
									if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
										-- the line was the last of the img area
										if ((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) then
											-- the fist overscan line will be skipped
											-- go to ovs skip delay
											s_delay_machine_state <= OVS_LINE_SKIP_DLY;
										else
											-- the fist overscan line will not be skipped
											-- clear the ccd column count
											s_ccd_column_cnt      <= (others => '0');
											-- set delay counter
											if (fee_line_delay_i /= c_DELAY_FINISHED) then
												s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
											else
												s_delay_cnt <= (others => '0');
											end if;
											-- go to ovs read line delay
											s_delay_machine_state <= OVS_LINE_READ_DLY;
										end if;
									else
										-- the line was not the last of the img area
										-- go to img skip delay
										s_delay_machine_state <= IMG_LINE_SKIP_DLY;
									end if;
								else
									-- next line is not to be skipped
									-- set read line delay counter
									if (fee_line_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- check if the line was the last of the img area
									if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
										-- the line was the last of the img area
										-- go to ovs read line delay
										s_delay_machine_state <= OVS_LINE_READ_DLY;
									else
										-- the line was not the last of the img area
										-- go to img read line delay
										s_delay_machine_state <= IMG_LINE_READ_DLY;
									end if;
								end if;
							end if;
						else
							-- pixel was not the last of the line
							-- check if the next pixel is to be skipped
							if (((unsigned(s_ccd_column_cnt) + 1) < unsigned(fee_ccd_h_start_i)) or ((unsigned(s_ccd_column_cnt) + 1) > unsigned(fee_ccd_h_end_i))) then
								-- next pixel is to be skipped
								-- set pixel skip delay counter
								if (fee_skip_col_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_skip_col_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to pixel skip delay
								s_delay_machine_state <= IMG_PIXEL_SKIP_DLY;
							else
								-- next pixel is not to be skipped
								-- set read pixel delay counter
								if (fee_adc_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to read pixel delay
								s_delay_machine_state <= IMG_PIXEL_READ_DLY;
							end if;
						end if;
					else
						-- read pixel delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when OVS_LINE_SKIP_DLY =>
					s_delay_machine_state <= OVS_LINE_SKIP_DLY;
					-- check if the line skip delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- line skip delay ended
						-- set column counter to last pixel
						s_ccd_column_cnt <= fee_ccd_x_size_i;
						-- update the pixel counter
						s_ccd_pixels_cnt <= s_ccd_pixels_cnt + s_ccd_x_size_val;
						-- check if the line was the last of the ccd
						if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
							-- the line was the last of the ccd
							-- go to ccd finished
							s_delay_machine_state <= CCD_FINISHED;
						else
							-- the line was not the last of the ccd
							-- increment row counter
							s_ccd_row_cnt     <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
							s_ccd_ovs_row_cnt <= std_logic_vector(unsigned(s_ccd_ovs_row_cnt) + 1);
							-- check if the next line is to be skipped
							if (((unsigned(s_ccd_row_cnt) + 1) < unsigned(fee_ccd_v_start_i)) or ((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) or ((unsigned(s_ccd_ovs_row_cnt) + 1) > unsigned(fee_ccd_ovs_v_end_i))) then
								-- next line is to be skipped
								-- set delay counter
								if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to skip delay
								s_delay_machine_state <= OVS_LINE_SKIP_DLY;
							else
								-- next line is not to be skipped
								-- clear column counter
								s_ccd_column_cnt      <= (others => '0');
								-- set delay counter
								if (fee_line_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to read line delay
								s_delay_machine_state <= OVS_LINE_READ_DLY;
							end if;
						end if;
					else
						-- skip line delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when OVS_LINE_READ_DLY =>
					s_delay_machine_state <= OVS_LINE_READ_DLY;
					-- check if the read line delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- read line delay ended
						-- check if the first pixel is to be skipped
						if (fee_ccd_h_start_i /= c_CCD_FIRST_PIXEL) then
							-- first pixel is to be skipped
							-- clear column counter
							s_ccd_column_cnt      <= (others => '0');
							-- set skip pixel delay counter
							if (fee_skip_col_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_skip_col_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to pixel skip delay
							s_delay_machine_state <= OVS_PIXEL_SKIP_DLY;
						else
							-- first pixel is not to be skipped
							-- set column counter to first pixel
							s_ccd_column_cnt      <= c_CCD_FIRST_PIXEL;
							-- set read pixel delay counter
							if (fee_adc_delay_i /= c_DELAY_FINISHED) then
								s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
							else
								s_delay_cnt <= (others => '0');
							end if;
							-- go to read pixel delay
							s_delay_machine_state <= OVS_PIXEL_READ_DLY;
						end if;

					else
						-- read line delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when OVS_PIXEL_SKIP_DLY =>
					s_delay_machine_state <= OVS_PIXEL_SKIP_DLY;
					-- check if the skip pixel delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- skip pixel delay ended
						-- increment column counter
						s_ccd_column_cnt <= std_logic_vector(unsigned(s_ccd_column_cnt) + 1);
						-- increment pixel counter
						s_ccd_pixels_cnt <= s_ccd_pixels_cnt + 1;
						-- check if the pixel was the last of the line
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- pixel was the last of the line
							-- check if the line was the last of the ccd
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- line was the last of the ccd
								-- increment row counter
								s_ccd_row_cnt         <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_ovs_row_cnt     <= std_logic_vector(unsigned(s_ccd_ovs_row_cnt) + 1);
								-- go to ccd finished
								s_delay_machine_state <= CCD_FINISHED;
							else
								-- line was not the last of the ccd
								-- clear column counter
								s_ccd_column_cnt  <= (others => '0');
								-- increment row counter
								s_ccd_row_cnt     <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_ovs_row_cnt <= std_logic_vector(unsigned(s_ccd_ovs_row_cnt) + 1);
								-- check if the next line is to be skipped
								if (((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) or ((unsigned(s_ccd_ovs_row_cnt) + 1) > unsigned(fee_ccd_ovs_v_end_i))) then
									-- next line is to be skipped
									-- set line skip delay counter
									if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to line skip delay
									s_delay_machine_state <= OVS_LINE_SKIP_DLY;
								else
									-- next line is not to be skipped
									-- set read line delay counter
									if (fee_line_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to read line delay
									s_delay_machine_state <= OVS_LINE_READ_DLY;
								end if;
							end if;
						else
							-- pixel was not the last of the line
							-- check if the next pixel is to be skipped
							if (((unsigned(s_ccd_column_cnt) + 1) < unsigned(fee_ccd_h_start_i)) or ((unsigned(s_ccd_column_cnt) + 1) > unsigned(fee_ccd_h_end_i))) then
								-- next pixel is to be skipped
								-- set pixel skip delay counter
								if (fee_skip_col_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_skip_col_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to pixel skip delay
								s_delay_machine_state <= OVS_PIXEL_SKIP_DLY;
							else
								-- next pixel is not to be skipped
								-- set read pixel delay counter
								if (fee_adc_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to read pixel delay
								s_delay_machine_state <= OVS_PIXEL_READ_DLY;
							end if;

						end if;
					else
						-- skip pixel delay not ended
						-- decrement delay counter
						s_delay_cnt <= std_logic_vector(unsigned(s_delay_cnt) - 1);
					end if;

				when OVS_PIXEL_READ_DLY =>
					s_delay_machine_state <= OVS_PIXEL_READ_DLY;
					-- check if the read pixel delay ended
					if (s_delay_cnt = c_DELAY_FINISHED) then
						-- read pixel delay ended
						-- increment column counter
						s_ccd_column_cnt <= std_logic_vector(unsigned(s_ccd_column_cnt) + 1);
						-- increment pixel counter
						s_ccd_pixels_cnt <= s_ccd_pixels_cnt + 1;
						-- check if the pixel was the last of the line
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- pixel was the last of the line
							-- check if the line was the last of the ccd
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- line was the last of the ccd
								-- increment row counter
								s_ccd_row_cnt         <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_ovs_row_cnt     <= std_logic_vector(unsigned(s_ccd_ovs_row_cnt) + 1);
								-- go to ccd finished
								s_delay_machine_state <= CCD_FINISHED;
							else
								-- line was not the last of the ccd
								-- clear column counter
								s_ccd_column_cnt  <= (others => '0');
								-- increment row counter
								s_ccd_row_cnt     <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								s_ccd_ovs_row_cnt <= std_logic_vector(unsigned(s_ccd_ovs_row_cnt) + 1);
								-- check if the next line is to be skipped
								if (((unsigned(s_ccd_row_cnt) + 1) > unsigned(fee_ccd_v_end_i)) or ((unsigned(s_ccd_ovs_row_cnt) + 1) > unsigned(fee_ccd_ovs_v_end_i))) then
									-- next line is to be skipped
									-- set line skip delay counter
									if (fee_skip_lin_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_skip_lin_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to line skip delay
									s_delay_machine_state <= OVS_LINE_SKIP_DLY;
								else
									-- next line is not to be skipped
									-- set read line delay counter
									if (fee_line_delay_i /= c_DELAY_FINISHED) then
										s_delay_cnt <= std_logic_vector(unsigned(fee_line_delay_i) - 1);
									else
										s_delay_cnt <= (others => '0');
									end if;
									-- go to read line delay
									s_delay_machine_state <= OVS_LINE_READ_DLY;
								end if;
							end if;
						else
							-- pixel was not the last of the line
							-- check if the next pixel is to be skipped
							if (((unsigned(s_ccd_column_cnt) + 1) < unsigned(fee_ccd_h_start_i)) or ((unsigned(s_ccd_column_cnt) + 1) > unsigned(fee_ccd_h_end_i))) then
								-- next pixel is to be skipped
								-- set pixel skip delay counter
								if (fee_skip_col_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_skip_col_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to pixel skip delay
								s_delay_machine_state <= OVS_PIXEL_SKIP_DLY;
							else
								-- next pixel is not to be skipped
								-- set read pixel delay counter
								if (fee_adc_delay_i /= c_DELAY_FINISHED) then
									s_delay_cnt <= std_logic_vector(unsigned(fee_adc_delay_i) - 1);
								else
									s_delay_cnt <= (others => '0');
								end if;
								-- go to read pixel delay
								s_delay_machine_state <= OVS_PIXEL_READ_DLY;
							end if;

						end if;
					else
						-- read pixel delay not ended
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
	current_ccd_pixel_o  <= std_logic_vector(s_ccd_pixels_cnt);

end architecture RTL;
