library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity masking_machine_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		-- general inputs
		sync_signal_i                 : in  std_logic;
		fee_clear_signal_i            : in  std_logic;
		fee_stop_signal_i             : in  std_logic;
		fee_start_signal_i            : in  std_logic;
		fee_windowing_en_i            : in  std_logic;
		fee_pattern_en_i              : in  std_logic;
		-- others
		masking_machine_hold_i        : in  std_logic;
		masking_buffer_overflow_i     : in  std_logic;
		fee_ccd_x_size_i              : in  std_logic_vector(15 downto 0);
		fee_ccd_y_size_i              : in  std_logic_vector(15 downto 0);
		fee_data_y_size_i             : in  std_logic_vector(15 downto 0);
		fee_overscan_y_size_i         : in  std_logic_vector(15 downto 0);
		fee_ccd_v_start_i             : in  std_logic_vector(15 downto 0);
		fee_ccd_v_end_i               : in  std_logic_vector(15 downto 0);
		fee_ccd_img_v_end_i           : in  std_logic_vector(15 downto 0);
		fee_ccd_ovs_v_end_i           : in  std_logic_vector(15 downto 0);
		fee_ccd_h_start_i             : in  std_logic_vector(15 downto 0);
		fee_ccd_h_end_i               : in  std_logic_vector(15 downto 0);
		fee_ccd_img_en_i              : in  std_logic;
		fee_ccd_ovs_en_i              : in  std_logic;
		fee_start_delay_i             : in  std_logic_vector(31 downto 0);
		fee_skip_delay_i              : in  std_logic_vector(31 downto 0);
		fee_line_delay_i              : in  std_logic_vector(31 downto 0);
		fee_adc_delay_i               : in  std_logic_vector(31 downto 0);
		current_timecode_i            : in  std_logic_vector(7 downto 0);
		current_ccd_i                 : in  std_logic_vector(1 downto 0);
		current_side_i                : in  std_logic;
		window_data_i                 : in  std_logic_vector(15 downto 0);
		window_mask_i                 : in  std_logic;
		window_data_valid_i           : in  std_logic;
		window_mask_valid_i           : in  std_logic;
		window_data_ready_i           : in  std_logic;
		window_mask_ready_i           : in  std_logic;
		--		masking_buffer_clear_i        : in  std_logic;
		masking_buffer_rdreq_i        : in  std_logic;
		send_double_buffer_wrable_i   : in  std_logic;
		masking_machine_finished_o    : out std_logic;
		masking_buffer_overflowed_o   : out std_logic;
		window_data_read_o            : out std_logic;
		window_mask_read_o            : out std_logic;
		masking_buffer_almost_empty_o : out std_logic;
		masking_buffer_empty_o        : out std_logic;
		masking_buffer_rddata_o       : out std_logic_vector(9 downto 0)
	);
end entity masking_machine_ent;

architecture RTL of masking_machine_ent is

	-- function to generate the msb pixel pattern
	function f_pixel_msb_generate_pattern(timecode_i : in std_logic_vector; ccd_i : in std_logic_vector; side_i : in std_logic; row_i : in std_logic_vector; column_i : in std_logic_vector) return std_logic_vector is
		variable v_pixel_msb : std_logic_vector(7 downto 0);
	begin

		-- generic pixel pattern (according to PLATO-DLR-PL-ICD-0002, issue 1.2):
		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
		-- |  15 downto 13  |  12 downto 11  |       10       |   9 downto  5  |   4 downto  0  |
		--
		-- pixel msb pattern:
		-- |  timecode[2:0] |       ccd      |      side      |    row[4:3]    |
		-- |   7 downto  5  |   4 downto  3  |        2       |   1 downto  0  |
		--
		-- pixel lsb pattern:
		-- |    row[2:0]    |   column[4:0]  |
		-- |   7 downto  5  |   4 downto  0  |

		-- pattern pixel msb set:
		v_pixel_msb(7 downto 5) := timecode_i(2 downto 0);
		v_pixel_msb(4 downto 3) := ccd_i(1 downto 0);
		v_pixel_msb(2)          := side_i;
		v_pixel_msb(1 downto 0) := row_i(4 downto 3);

		return v_pixel_msb;
	end function f_pixel_msb_generate_pattern;

	-- function to generate the msb pixel pattern
	function f_pixel_lsb_generate_pattern(timecode_i : in std_logic_vector; ccd_i : in std_logic_vector; side_i : in std_logic; row_i : in std_logic_vector; column_i : in std_logic_vector) return std_logic_vector is
		variable v_pixel_lsb : std_logic_vector(7 downto 0);
	begin

		-- generic pixel pattern (according to PLATO-DLR-PL-ICD-0002, issue 1.2):
		-- |  timecode[2:0] |       ccd      |      side      |    row[4:0]    |   column[4:0]  |
		-- |  15 downto 13  |  12 downto 11  |       10       |   9 downto  5  |   4 downto  0  |
		--
		-- pixel msb pattern:
		-- |  timecode[2:0] |       ccd      |      side      |    row[4:3]    |
		-- |   7 downto  5  |   4 downto  3  |        2       |   1 downto  0  |
		--
		-- pixel lsb pattern:
		-- |    row[2:0]    |   column[4:0]  |
		-- |   7 downto  5  |   4 downto  0  |

		-- pattern pixel msb set:
		v_pixel_lsb(7 downto 5) := row_i(2 downto 0);
		v_pixel_lsb(4 downto 0) := column_i(4 downto 0);

		return v_pixel_lsb;
	end function f_pixel_lsb_generate_pattern;

	-- masking fifo record type
	type t_masking_fifo is record
		data_imgbyte   : std_logic_vector(7 downto 0);
		data_imgchange : std_logic;
		data_imgend    : std_logic;
		sclr           : std_logic;
		wrreq          : std_logic;
		full           : std_logic;
		usedw          : std_logic_vector(7 downto 0);
	end record t_masking_fifo;

	-- masking fifo signals
	signal s_masking_fifo : t_masking_fifo;

	-- masking machine fsm type
	type t_masking_machine_fsm is (
		STOPPED,
		NOT_STARTED,
		WAITING_DATA,
		FETCH_DATA,
		PIXEL_BYTE_MSB,
		PIXEL_BYTE_LSB,
		WRITE_CHANGE_CMD,
		CCD_FINISHED
	);

	-- masking machine fsm state
	signal s_masking_machine_state        : t_masking_machine_fsm;
	signal s_masking_machine_return_state : t_masking_machine_fsm;

	signal s_registered_window_data : std_logic_vector(15 downto 0);
	signal s_registered_window_mask : std_logic;

	-- delay machine signals
	signal s_delay_machine_current_ccd_row    : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0);
	signal s_delay_machine_current_ccd_column : std_logic_vector((fee_ccd_x_size_i'length - 1) downto 0);

	-- first pixel flag
	signal s_first_pixel : std_logic;

	-- column counter
	signal s_ccd_column_cnt  : std_logic_vector((fee_ccd_x_size_i'length - 1) downto 0);
	-- row counter
	signal s_ccd_row_cnt     : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0);
	signal s_ccd_img_row_cnt : std_logic_vector((fee_data_y_size_i'length - 1) downto 0);
	signal s_ccd_ovs_row_cnt : std_logic_vector((fee_overscan_y_size_i'length - 1) downto 0);

	-- pixels bytes alias
	alias a_pixel_msb is s_registered_window_data(7 downto 0);
	alias a_pixel_lsb is s_registered_window_data(15 downto 8);

	-- data fetched flag
	signal s_data_fetched : std_logic;

	-- fisrt row constant
	constant c_CCD_FIRST_ROW : std_logic_vector((fee_ccd_y_size_i'length - 1) downto 0) := (others => '0');

	-- image area flag
	signal s_image_area : std_logic;

begin

	-- delay machine instantiation
	delay_machine_ent_inst : entity work.delay_machine_ent
		port map(
			clk_i                 => clk_i,
			rst_i                 => rst_i,
			sync_signal_i         => sync_signal_i,
			fee_clear_signal_i    => fee_clear_signal_i,
			fee_stop_signal_i     => fee_stop_signal_i,
			fee_start_signal_i    => fee_start_signal_i,
			fee_ccd_x_size_i      => fee_ccd_x_size_i,
			fee_ccd_y_size_i      => fee_ccd_y_size_i,
			fee_data_y_size_i     => fee_data_y_size_i,
			fee_overscan_y_size_i => fee_overscan_y_size_i,
			fee_ccd_v_start_i     => fee_ccd_v_start_i,
			fee_ccd_v_end_i       => fee_ccd_v_end_i,
			fee_ccd_img_v_end_i   => fee_ccd_img_v_end_i,
			fee_ccd_ovs_v_end_i   => fee_ccd_ovs_v_end_i,
			fee_ccd_h_start_i     => fee_ccd_h_start_i,
			fee_ccd_h_end_i       => fee_ccd_h_end_i,
			fee_start_delay_i     => fee_start_delay_i,
			fee_skip_lin_delay_i  => fee_skip_delay_i,
			fee_skip_col_delay_i  => (others => '0'),
			fee_line_delay_i      => fee_line_delay_i,
			fee_adc_delay_i       => fee_adc_delay_i,
			current_ccd_row_o     => s_delay_machine_current_ccd_row,
			current_ccd_column_o  => s_delay_machine_current_ccd_column
		);

	-- masking buffer instantiation
	masking_machine_sc_fifo_inst : entity work.masking_machine_sc_fifo
		port map(
			aclr             => rst_i,
			clock            => clk_i,
			data(7 downto 0) => s_masking_fifo.data_imgbyte,
			data(8)          => s_masking_fifo.data_imgchange,
			data(9)          => s_masking_fifo.data_imgend,
			rdreq            => masking_buffer_rdreq_i,
			sclr             => s_masking_fifo.sclr,
			wrreq            => s_masking_fifo.wrreq,
			empty            => masking_buffer_empty_o,
			full             => s_masking_fifo.full,
			q                => masking_buffer_rddata_o,
			usedw            => s_masking_fifo.usedw
		);

	p_masking_machine : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			window_data_read_o             <= '0';
			window_mask_read_o             <= '0';
			masking_machine_finished_o     <= '0';
			masking_buffer_overflowed_o    <= '0';
			s_masking_fifo.data_imgbyte    <= (others => '0');
			s_masking_fifo.data_imgchange  <= '0';
			s_masking_fifo.data_imgend     <= '0';
			s_masking_fifo.wrreq           <= '0';
			s_masking_machine_state        <= STOPPED;
			s_masking_machine_return_state <= STOPPED;
			s_registered_window_data       <= (others => '0');
			s_registered_window_mask       <= '0';
			s_first_pixel                  <= '0';
			s_ccd_column_cnt               <= (others => '0');
			s_ccd_row_cnt                  <= (others => '0');
			s_ccd_img_row_cnt              <= (others => '0');
			s_ccd_ovs_row_cnt              <= (others => '0');
			s_data_fetched                 <= '0';
			s_image_area                   <= '0';
		elsif rising_edge(clk_i) then

			case (s_masking_machine_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_masking_machine_state        <= STOPPED;
					s_masking_machine_return_state <= STOPPED;
					s_registered_window_data       <= (others => '0');
					s_registered_window_mask       <= '0';
					s_first_pixel                  <= '0';
					s_ccd_column_cnt               <= (others => '0');
					s_ccd_row_cnt                  <= (others => '0');
					s_ccd_img_row_cnt              <= (others => '0');
					s_ccd_ovs_row_cnt              <= (others => '0');
					s_data_fetched                 <= '0';
					s_image_area                   <= '0';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_masking_machine_state <= NOT_STARTED;
					end if;

				when NOT_STARTED =>
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_masking_machine_state        <= NOT_STARTED;
					s_masking_machine_return_state <= NOT_STARTED;
					s_registered_window_data       <= (others => '0');
					s_registered_window_mask       <= '0';
					s_first_pixel                  <= '0';
					s_ccd_column_cnt               <= (others => '0');
					s_ccd_row_cnt                  <= (others => '0');
					s_ccd_img_row_cnt              <= (others => '0');
					s_ccd_ovs_row_cnt              <= (others => '0');
					s_data_fetched                 <= '0';
					s_image_area                   <= '0';
					-- check if the fee requested the start of the masking (sync arrived)
					if (sync_signal_i = '1') then
						-- set first pixel
						s_first_pixel                  <= '1';
						-- set ccd column counter to execute the first ccd line
						s_ccd_column_cnt               <= (others => '0');
						s_ccd_row_cnt                  <= (others => '0');
						s_ccd_img_row_cnt              <= (others => '0');
						s_ccd_ovs_row_cnt              <= (others => '0');
						-- set the image area flag
						s_image_area                   <= '1';
						-- go to idle
						s_masking_machine_state        <= WAITING_DATA;
						s_masking_machine_return_state <= WAITING_DATA;

					end if;

				when WAITING_DATA =>
					s_masking_machine_state        <= WAITING_DATA;
					s_masking_machine_return_state <= WAITING_DATA;
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_registered_window_data       <= (others => '0');
					s_registered_window_mask       <= '0';
					s_data_fetched                 <= '0';
					-- check if the necessary delay for the current pixel has passed
					if ((unsigned(s_ccd_row_cnt) < unsigned(s_delay_machine_current_ccd_row)) or ((unsigned(s_ccd_row_cnt) = unsigned(s_delay_machine_current_ccd_row)) and (unsigned(s_ccd_column_cnt) < unsigned(s_delay_machine_current_ccd_column)))) then
						-- necessary delay for the current pixel has passed
						-- check if the windowing machine is released and the windowing buffer is ready
						if ((masking_machine_hold_i = '0') and (window_data_ready_i = '1') and (window_mask_ready_i = '1')) then
							-- fetch mask and data
							window_mask_read_o             <= '1';
							window_data_read_o             <= '1';
							-- go to fetch data
							s_masking_machine_state        <= FETCH_DATA;
							s_masking_machine_return_state <= FETCH_DATA;
						end if;
					end if;

				when FETCH_DATA =>
					s_masking_machine_state        <= FETCH_DATA;
					s_masking_machine_return_state <= FETCH_DATA;
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_registered_window_data       <= (others => '0');
					s_registered_window_mask       <= '0';
					s_data_fetched                 <= '0';
					-- check if the window and mask data are valid
					if ((window_data_valid_i = '1') and (window_mask_valid_i = '1')) then
						-- register buffer mask data
						s_registered_window_mask       <= window_mask_i;
						s_registered_window_data       <= window_data_i;
						-- go to pixel byte msb
						s_masking_machine_state        <= PIXEL_BYTE_MSB;
						s_masking_machine_return_state <= PIXEL_BYTE_MSB;
					end if;

				when PIXEL_BYTE_MSB =>
					s_masking_machine_state        <= PIXEL_BYTE_MSB;
					s_masking_machine_return_state <= PIXEL_BYTE_MSB;
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_first_pixel                  <= '0';
					s_data_fetched                 <= '0';
					-- check if masking fifo is not full or if the masking fifo overflow is enabled and the send double buffer is full
					if ((unsigned(s_masking_fifo.usedw) < (2**s_masking_fifo.usedw'length - 2)) or ((masking_buffer_overflow_i = '1') and (send_double_buffer_wrable_i = '0'))) then
						-- check if the masking fifo overflow is enabled and the send double buffer is full (an overflow ocurred)
						if ((masking_buffer_overflow_i = '1') and (send_double_buffer_wrable_i = '0')) then
							-- the masking fifo overflow is enabled and the send double buffer is full (an overflow ocurred)
							masking_buffer_overflowed_o <= '1';
						end if;
						-- masking fifo has space or the masking fifo overflow is enabled and the send double buffer is full
						s_masking_machine_state        <= PIXEL_BYTE_LSB;
						s_masking_machine_return_state <= PIXEL_BYTE_LSB;
						-- check if the ccd part (image or overscan) is enabled
						if (((fee_ccd_img_en_i = '1') and (s_image_area = '1')) or ((fee_ccd_ovs_en_i = '1') and (s_image_area = '0'))) then
							-- the ccd part (image or overscan) is enabled, digitalise data
							-- check if the data need to be transmitted
							--							if ((unsigned(s_ccd_row_cnt) >= unsigned(fee_ccd_v_start_i)) and (unsigned(s_ccd_row_cnt) <= unsigned(fee_ccd_v_end_i)) and (fee_ccd_v_end_i /= c_CCD_FIRST_ROW)) then
							if ((unsigned(s_ccd_row_cnt) >= unsigned(fee_ccd_v_start_i)) and (unsigned(s_ccd_row_cnt) <= unsigned(fee_ccd_v_end_i)) and (unsigned(s_ccd_img_row_cnt) <= unsigned(fee_ccd_img_v_end_i)) and (unsigned(s_ccd_ovs_row_cnt) <= unsigned(fee_ccd_ovs_v_end_i)) and (unsigned(s_ccd_column_cnt) >= unsigned(fee_ccd_h_start_i)) and (unsigned(s_ccd_column_cnt) <= unsigned(fee_ccd_h_end_i))) then
								-- data need to be transmitted
								-- check if (the windowing is disabled) or (the windowing is enabled and the pixel is transmitted)
								if ((fee_windowing_en_i = '0') or ((fee_windowing_en_i = '1') and (s_registered_window_mask = '1'))) then
									-- windowing disabled or is enabled and pixel is transmitted
									s_masking_fifo.wrreq <= '1';
									-- check if the pattern is enabled
									if (fee_pattern_en_i = '1') then
										-- pattern enabled, generate pattern
										s_masking_fifo.data_imgbyte <= f_pixel_msb_generate_pattern(current_timecode_i, current_ccd_i, current_side_i, s_ccd_row_cnt, s_ccd_column_cnt);
									else
										-- pattern disabled, use window data
										s_masking_fifo.data_imgbyte <= a_pixel_msb;
									end if;
								end if;
							end if;
						end if;
					end if;

				when PIXEL_BYTE_LSB =>
					s_masking_machine_state        <= PIXEL_BYTE_LSB;
					s_masking_machine_return_state <= PIXEL_BYTE_LSB;
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_first_pixel                  <= '0';
					s_data_fetched                 <= '0';
					-- check if masking fifo is not full or if the masking fifo overflow is enabled and the send double buffer is full
					if ((unsigned(s_masking_fifo.usedw) < (2**s_masking_fifo.usedw'length - 2)) or ((masking_buffer_overflow_i = '1') and (send_double_buffer_wrable_i = '0'))) then
						-- check if the masking fifo overflow is enabled and the send double buffer is full (an overflow ocurred)
						if ((masking_buffer_overflow_i = '1') and (send_double_buffer_wrable_i = '0')) then
							-- the masking fifo overflow is enabled and the send double buffer is full (an overflow ocurred)
							masking_buffer_overflowed_o <= '1';
						end if;
						-- masking fifo has space or the masking fifo overflow is enabled and the send double buffer is full
						s_masking_machine_state        <= WAITING_DATA;
						s_masking_machine_return_state <= WAITING_DATA;
						-- check if the ccd part (image or overscan) is enabled
						if (((fee_ccd_img_en_i = '1') and (s_image_area = '1')) or ((fee_ccd_ovs_en_i = '1') and (s_image_area = '0'))) then
							-- the ccd part (image or overscan) is enabled, digitalise data
							-- check if the data need to be transmitted
							--							if ((unsigned(s_ccd_row_cnt) >= unsigned(fee_ccd_v_start_i)) and (unsigned(s_ccd_row_cnt) <= unsigned(fee_ccd_v_end_i)) and (fee_ccd_v_end_i /= c_CCD_FIRST_ROW)) then
							if ((unsigned(s_ccd_row_cnt) >= unsigned(fee_ccd_v_start_i)) and (unsigned(s_ccd_row_cnt) <= unsigned(fee_ccd_v_end_i)) and (unsigned(s_ccd_img_row_cnt) <= unsigned(fee_ccd_img_v_end_i)) and (unsigned(s_ccd_ovs_row_cnt) <= unsigned(fee_ccd_ovs_v_end_i)) and (unsigned(s_ccd_column_cnt) >= unsigned(fee_ccd_h_start_i)) and (unsigned(s_ccd_column_cnt) <= unsigned(fee_ccd_h_end_i))) then
								-- data need to be transmitted
								-- check if (the windowing is disabled) or (the windowing is enabled and the pixel is transmitted)
								if ((fee_windowing_en_i = '0') or ((fee_windowing_en_i = '1') and (s_registered_window_mask = '1'))) then
									-- windowing disabled or is enabled and pixel is transmitted
									s_masking_fifo.wrreq <= '1';
									-- check if the pattern is enabled
									if (fee_pattern_en_i = '1') then
										-- pattern enabled, generate pattern
										s_masking_fifo.data_imgbyte <= f_pixel_lsb_generate_pattern(current_timecode_i, current_ccd_i, current_side_i, s_ccd_row_cnt, s_ccd_column_cnt);
									else
										-- pattern disabled, use window data
										s_masking_fifo.data_imgbyte <= a_pixel_lsb;
									end if;
								end if;
							end if;
						end if;
						-- check if a full line was processed
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- full line processed, clear column counter
							s_ccd_column_cnt <= (others => '0');
							-- check if the entire ccd was processed
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- ccd ended, clear row counter
								s_ccd_row_cnt     <= (others => '0');
								s_ccd_img_row_cnt <= (others => '0');
								s_ccd_ovs_row_cnt <= (others => '0');
							else
								-- ccd not ended, update row counter
								s_ccd_row_cnt <= std_logic_vector(unsigned(s_ccd_row_cnt) + 1);
								-- check if the ccd is in the image area
								if (s_image_area = '1') then
									-- the ccd is in the image area
									s_ccd_img_row_cnt <= std_logic_vector(unsigned(s_ccd_img_row_cnt) + 1);
								else
									-- the ccd is in the overscan area
									s_ccd_ovs_row_cnt <= std_logic_vector(unsigned(s_ccd_ovs_row_cnt) + 1);
								end if;
								-- check if the last line to be transmitted was reached
								if ((s_ccd_row_cnt = fee_ccd_v_end_i) or ((s_ccd_img_row_cnt = fee_ccd_img_v_end_i) and (s_image_area = '1')) or ((s_ccd_ovs_row_cnt = fee_ccd_ovs_v_end_i) and (s_image_area = '0'))) then
									-- last line to be transmitted was reached
									-- write img end flag
									s_masking_fifo.data_imgend <= '1';
								end if;
							end if;
						else
							-- middle of a line, update column counter
							-- check if it is the first pixel
							if (s_first_pixel = '1') then
								-- first pixel, clear flag and do not increment column counter
								s_first_pixel <= '0';
							else
								-- not first pixel, increment column counter
								s_ccd_column_cnt <= std_logic_vector(unsigned(s_ccd_column_cnt) + 1);
							end if;
						end if;
						-- check if the processed pixel is the last pixel of a line
						if (s_ccd_column_cnt = std_logic_vector(unsigned(fee_ccd_x_size_i) - 1)) then
							-- full line processed
							-- check if it was the last ccd data line or the last ccd line
							if (s_ccd_row_cnt = std_logic_vector(unsigned(fee_data_y_size_i) - 1)) then
								-- the processed line was the last ccd data line
								-- write img end flag
								s_masking_fifo.data_imgend     <= '1';
								-- write change command and return to waiting data
								s_masking_machine_state        <= WRITE_CHANGE_CMD;
								s_masking_machine_return_state <= WAITING_DATA;
							elsif (s_ccd_row_cnt = std_logic_vector(unsigned(fee_ccd_y_size_i) - 1)) then
								-- the processed line was the last ccd line
								-- write img end flag
								s_masking_fifo.data_imgend     <= '1';
								-- write change command and return to not started
								s_masking_machine_state        <= WRITE_CHANGE_CMD;
								s_masking_machine_return_state <= CCD_FINISHED;
								-- set masking machine as finished
								masking_machine_finished_o     <= '1';
							end if;
						end if;
					end if;

				when WRITE_CHANGE_CMD =>
					s_masking_machine_state       <= WRITE_CHANGE_CMD;
					window_data_read_o            <= '0';
					window_mask_read_o            <= '0';
					masking_machine_finished_o    <= '0';
					masking_buffer_overflowed_o   <= '0';
					s_masking_fifo.data_imgbyte   <= (others => '0');
					s_masking_fifo.data_imgchange <= '0';
					s_masking_fifo.data_imgend    <= '0';
					s_masking_fifo.wrreq          <= '0';
					s_first_pixel                 <= '0';
					s_data_fetched                <= '0';
					-- clear the image area flag
					s_image_area                  <= '0';
					-- clear the image and overscan counters
					s_ccd_img_row_cnt             <= (others => '0');
					s_ccd_ovs_row_cnt             <= (others => '0');
					-- check if masking fifo is not almost full
					if (unsigned(s_masking_fifo.usedw) < (2**s_masking_fifo.usedw'length - 2)) then
						-- masking fifo has space
						-- write change command
						s_masking_fifo.data_imgchange <= '1';
						s_masking_fifo.wrreq          <= '1';
						-- return state
						s_masking_machine_state       <= s_masking_machine_return_state;
					end if;

				when CCD_FINISHED =>
					s_masking_machine_state        <= CCD_FINISHED;
					s_masking_machine_return_state <= CCD_FINISHED;
					window_data_read_o             <= '0';
					window_mask_read_o             <= '0';
					masking_machine_finished_o     <= '0';
					masking_buffer_overflowed_o    <= '0';
					s_masking_fifo.data_imgbyte    <= (others => '0');
					s_masking_fifo.data_imgchange  <= '0';
					s_masking_fifo.data_imgend     <= '0';
					s_masking_fifo.wrreq           <= '0';
					s_registered_window_data       <= (others => '0');
					s_registered_window_mask       <= '0';
					s_first_pixel                  <= '0';
					s_ccd_column_cnt               <= (others => '0');
					s_ccd_row_cnt                  <= (others => '0');
					s_image_area                   <= '0';
					-- check if a data was already fetched
					if (s_data_fetched = '1') then
						-- data was already fetched
						-- check if the window and mask data are valid
						if ((window_data_valid_i = '1') and (window_mask_valid_i = '1')) then
							-- discard the data
							s_data_fetched <= '0';
						end if;
					else
						-- data not fetched
						-- check if there is still data in then windowing buffer
						if ((window_data_ready_i = '1') and (window_mask_ready_i = '1')) then
							-- fetch data
							window_data_read_o <= '1';
							window_mask_read_o <= '1';
							s_data_fetched     <= '1';
						end if;
					end if;

				when others =>
					s_masking_machine_state        <= STOPPED;
					s_masking_machine_return_state <= STOPPED;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_masking_machine_state        <= STOPPED;
				s_masking_machine_return_state <= STOPPED;
			end if;

		end if;
	end process p_masking_machine;

	-- masking fifo sclear signal reset
	s_masking_fifo.sclr <= ('1') when (rst_i = '1') else (fee_clear_signal_i);

	-- masking fifo almost empty signal
	masking_buffer_almost_empty_o <= ('0') when (rst_i = '1')
	                                 else ('1') when (s_masking_fifo.usedw = std_logic_vector(to_unsigned(1, s_masking_fifo.usedw'length)))
	                                 else ('0');

end architecture RTL;
