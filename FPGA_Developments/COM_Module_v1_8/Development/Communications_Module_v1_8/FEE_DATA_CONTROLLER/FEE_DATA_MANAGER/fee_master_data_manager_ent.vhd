library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fee_master_data_manager_ent is
	port(
		clk_i                                : in  std_logic;
		rst_i                                : in  std_logic;
		-- fee data manager inputs --
		-- general inputs
		fee_clear_signal_i                   : in  std_logic;
		fee_stop_signal_i                    : in  std_logic;
		fee_start_signal_i                   : in  std_logic;
		sync_signal_i                        : in  std_logic;
		side_activated_i                     : in  std_logic;
		current_frame_number_i               : in  std_logic_vector(1 downto 0);
		current_frame_counter_i              : in  std_logic_vector(15 downto 0);
		-- fee data manager parameters
		fee_logical_addr_i                   : in  std_logic_vector(7 downto 0);
		fee_protocol_id_i                    : in  std_logic_vector(7 downto 0);
		fee_ccd_x_size_i                     : in  std_logic_vector(15 downto 0);
		--		fee_ccd_y_size_i                     : in  std_logic_vector(15 downto 0);
		fee_data_y_size_i                    : in  std_logic_vector(15 downto 0);
		fee_overscan_y_size_i                : in  std_logic_vector(15 downto 0);
		fee_packet_length_i                  : in  std_logic_vector(15 downto 0);
		fee_fee_mode_i                       : in  std_logic_vector(2 downto 0);
		fee_ccd_number_i                     : in  std_logic_vector(1 downto 0);
		fee_ccd_side_i                       : in  std_logic;
		-- header generator status
		--		header_gen_busy_i                    : in  std_logic;
		header_gen_finished_i                : in  std_logic;
		-- housekeeping writer status
		--		housekeeping_wr_busy_i               : in  std_logic;
		housekeeping_wr_finished_i           : in  std_logic;
		-- data writer status
		--		data_wr_busy_i                       : in  std_logic;
		data_wr_finished_i                   : in  std_logic;
		-- data transmitter status
		--		data_transmitter_busy_i              : in  std_logic;
		data_transmitter_finished_i          : in  std_logic;
		-- fee data manager outputs --
		-- general outputs
		-- masking machine control
		imgdata_start_o                      : out std_logic;
		masking_machine_hold_o               : out std_logic;
		--		masking_buffer_clear_o               : out std_logic;
		-- fee data manager status			
		fee_data_manager_busy_o              : out std_logic;
		-- header data
		headerdata_logical_address_o         : out std_logic_vector(7 downto 0);
		headerdata_protocol_id_o             : out std_logic_vector(7 downto 0);
		headerdata_length_field_o            : out std_logic_vector(15 downto 0);
		headerdata_type_field_mode_o         : out std_logic_vector(2 downto 0);
		headerdata_type_field_last_packet_o  : out std_logic;
		headerdata_type_field_ccd_side_o     : out std_logic;
		headerdata_type_field_ccd_number_o   : out std_logic_vector(1 downto 0);
		headerdata_type_field_frame_number_o : out std_logic_vector(1 downto 0);
		headerdata_type_field_packet_type_o  : out std_logic_vector(1 downto 0);
		headerdata_frame_counter_o           : out std_logic_vector(15 downto 0);
		headerdata_sequence_counter_o        : out std_logic_vector(15 downto 0);
		-- header generator control		
		header_gen_send_o                    : out std_logic;
		header_gen_reset_o                   : out std_logic;
		-- housekeeping writer control
		housekeeping_wr_start_o              : out std_logic;
		housekeeping_wr_reset_o              : out std_logic;
		-- data writer control
		data_wr_start_o                      : out std_logic;
		data_wr_reset_o                      : out std_logic;
		data_wr_length_o                     : out std_logic_vector(15 downto 0);
		-- send buffer control
		send_buffer_fee_data_loaded_o        : out std_logic
		--		send_buffer_clear_o                  : out std_logic
		-- data transmitter control
		--		data_transmitter_reset_o             : out std_logic
	);
end entity fee_master_data_manager_ent;

architecture RTL of fee_master_data_manager_ent is

	-- data packet header data --
	-- data packet header size [bytes]
	constant c_DATA_PKT_HEADER_SIZE    : natural                       := 10;
	-- hk packet data size [bytes]
	constant c_HK_PKT_DATA_SIZE        : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(128, 16));
	-- type field, mode bits
	constant c_FULL_IMAGE_MODE         : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(0, 3));
	constant c_FULL_IMAGE_PATTERN_MODE : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(1, 3));
	constant c_WINDOWING_MODE          : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(2, 3));
	constant c_WINDOWING_PATTERN_MODE  : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(3, 3));
	constant c_PARTIAL_READ_OUT_MODE   : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(4, 3));
	-- type field, packet type bits
	constant c_DATA_PACKET             : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(0, 2));
	constant c_OVERSCAN_DATA           : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(1, 2));
	constant c_HOUSEKEEPING_PACKET     : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(2, 2));

	-- fee data manager fsm type
	type t_fee_data_manager_fsm is (
		STOPPED,
		IDLE,
		HK_HEADER_START,
		WAITING_HK_HEADER_FINISH,
		HK_DATA_START,
		WAITING_HK_DATA_FINISH,
		WAITING_HK_TRANSMITTER_FINISH,
		WAITING_IMG_DATA_START,
		IMG_HEADER_START,
		WAITING_IMG_HEADER_FINISH,
		IMG_DATA_START,
		WAITING_IMG_DATA_FINISH,
		OVER_HEADER_START,
		WAITING_OVER_HEADER_FINISH,
		OVER_DATA_START,
		WAITING_OVER_DATA_FINISH,
		FINISH_FEE_OPERATION
	);

	-- fee data manager fsm state signal
	signal s_fee_data_manager_state : t_fee_data_manager_fsm;

	--
	-- F-FEE CCD parameters:
	-- ffee full-ccd          size: 4540 * (2295 + 2295)          pixels (image + parallel overscan) (Row [Y] * Column [X]) = 20,838,600 pixels = 41,677,200 bytes
	-- ffee full-ccd image    size: 4510 * (2295 + 2295) image    pixels (no parallel overscan)      (Row [Y] * Column [X]) = 20,700,900 pixels = 41,401,800 bytes
	-- ffee full-ccd overscan size:   30 * (2295 + 2295) overscan pixels (no image pixels)           (Row [Y] * Column [X]) =    137,700 pixels =    275,400 bytes
	-- ffee half-ccd          size: 4540 *          2295          pixels (image + parallel overscan) (Row [Y] * Column [X]) = 10,419,300 pixels = 20,838,600 bytes
	-- ffee half-ccd image    size: 4510 *          2295 image    pixels (no parallel overscan)      (Row [Y] * Column [X]) = 10,350,450 pixels = 20,700,900 bytes
	-- ffee half-ccd overscan size:   30 *          2295 overscan pixels (no image pixels)           (Row [Y] * Column [X]) =     68,850 pixels =    137,700 bytes
	--
	-- N-FEE CCD parameters:
	-- nfee full-ccd          size: 2560 * (2295 + 2295)          pixels (image + parallel overscan) (Row [Y] * Column [X]) = 11,750,400 pixels = 23,500,800 bytes
	-- nfee full-ccd image    size: 2555 * (2295 + 2295) image    pixels (no parallel overscan)      (Row [Y] * Column [X]) = 11,727,450 pixels = 23,454,900 bytes
	-- nfee full-ccd overscan size:    5 * (2295 + 2295) overscan pixels (no image pixels)           (Row [Y] * Column [X]) =     22,950 pixels =     45,900 bytes
	-- nfee half-ccd          size: 2560 *          2295          pixels (image + parallel overscan) (Row [Y] * Column [X]) =  5,875,200 pixels = 11,750,400 bytes
	-- nfee half-ccd image    size: 2555 *          2295 image    pixels (no parallel overscan)      (Row [Y] * Column [X]) =  5,863,725 pixels = 11,727,450 bytes
	-- nfee half-ccd overscan size:    5 *          2295 overscan pixels (no image pixels)           (Row [Y] * Column [X]) =     11,475 pixels =     22,950 bytes
	--
	-- Worst case scenario packet size = 20,700,900 bytes --> Minimum data counter width is 25b --> 2^24 = 33,554,432
	--

	-- packets control signals
	signal s_fee_remaining_data_bytes     : std_logic_vector(24 downto 0);
	signal s_fee_sequence_counter         : std_logic_vector(15 downto 0);
	signal s_fee_current_packet_data_size : std_logic_vector(15 downto 0);
	signal s_last_packet_flag             : std_logic;

	signal s_forced_sync : std_logic;

begin

	p_fee_data_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- signals
			s_fee_data_manager_state             <= STOPPED;
			s_fee_remaining_data_bytes           <= (others => '0');
			s_fee_sequence_counter               <= (others => '0');
			s_fee_current_packet_data_size       <= (others => '0');
			s_last_packet_flag                   <= '0';
			-- outputs
			fee_data_manager_busy_o              <= '0';
			masking_machine_hold_o               <= '1';
			headerdata_logical_address_o         <= (others => '0');
			headerdata_protocol_id_o             <= (others => '0');
			headerdata_length_field_o            <= (others => '0');
			headerdata_type_field_mode_o         <= (others => '0');
			headerdata_type_field_last_packet_o  <= '0';
			headerdata_type_field_ccd_side_o     <= '0';
			headerdata_type_field_ccd_number_o   <= (others => '0');
			headerdata_type_field_frame_number_o <= (others => '0');
			headerdata_type_field_packet_type_o  <= (others => '0');
			headerdata_frame_counter_o           <= (others => '0');
			headerdata_sequence_counter_o        <= (others => '0');
			header_gen_send_o                    <= '0';
			header_gen_reset_o                   <= '1';
			housekeeping_wr_start_o              <= '0';
			housekeeping_wr_reset_o              <= '1';
			data_wr_start_o                      <= '0';
			data_wr_reset_o                      <= '1';
			data_wr_length_o                     <= (others => '0');
			send_buffer_fee_data_loaded_o        <= '0';
			imgdata_start_o                      <= '0';
			s_forced_sync                        <= '0';
		elsif rising_edge(clk_i) then

			case (s_fee_data_manager_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset fee data manager
					s_fee_data_manager_state             <= STOPPED;
					s_fee_remaining_data_bytes           <= (others => '0');
					s_fee_sequence_counter               <= (others => '0');
					s_fee_current_packet_data_size       <= (others => '0');
					s_last_packet_flag                   <= '0';
					fee_data_manager_busy_o              <= '0';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					s_forced_sync                        <= '0';
					-- hold the masking machine
					masking_machine_hold_o               <= '1';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_fee_data_manager_state <= IDLE;
					end if;

				when IDLE =>
					-- do nothing until a sync signal is received
					s_fee_data_manager_state             <= IDLE;
					-- keep signals and outputs at the reset state
					s_fee_remaining_data_bytes           <= (others => '0');
					s_fee_sequence_counter               <= (others => '0');
					s_fee_current_packet_data_size       <= (others => '0');
					s_last_packet_flag                   <= '0';
					fee_data_manager_busy_o              <= '0';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					s_forced_sync                        <= '0';
					-- keep the masking machine on hold
					masking_machine_hold_o               <= '1';
					if (((sync_signal_i = '1') or (s_forced_sync = '1')) and (side_activated_i = '1')) then
						-- sync signal received
						-- release the masking machine
						masking_machine_hold_o   <= '0';
						-- go to hk header start
						s_fee_data_manager_state <= HK_HEADER_START;
					end if;

				when HK_HEADER_START =>
					-- start the hk header generation
					s_fee_data_manager_state             <= WAITING_HK_HEADER_FINISH;
					s_fee_remaining_data_bytes           <= (others => '0');
					s_fee_current_packet_data_size       <= (others => '0');
					s_last_packet_flag                   <= '0';
					fee_data_manager_busy_o              <= '1';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the hk header data
					headerdata_logical_address_o         <= fee_logical_addr_i;
					headerdata_protocol_id_o             <= fee_protocol_id_i;
					headerdata_length_field_o            <= c_HK_PKT_DATA_SIZE;
					--					headerdata_type_field_mode_o         <= c_FULL_IMAGE_PATTERN_MODE;
					headerdata_type_field_mode_o         <= fee_fee_mode_i;
					headerdata_type_field_last_packet_o  <= '1';
					headerdata_type_field_ccd_side_o     <= fee_ccd_side_i;
					headerdata_type_field_ccd_number_o   <= fee_ccd_number_i;
					headerdata_type_field_frame_number_o <= current_frame_number_i;
					headerdata_type_field_packet_type_o  <= c_HOUSEKEEPING_PACKET;
					headerdata_frame_counter_o           <= current_frame_counter_i;
					headerdata_sequence_counter_o        <= s_fee_sequence_counter;
					-- start the header generator
					header_gen_send_o                    <= '1';

				when WAITING_HK_HEADER_FINISH =>
					-- wait for the hk header generation to finish
					s_fee_data_manager_state       <= WAITING_HK_HEADER_FINISH;
					s_fee_remaining_data_bytes     <= (others => '0');
					s_fee_current_packet_data_size <= (others => '0');
					s_last_packet_flag             <= '0';
					fee_data_manager_busy_o        <= '1';
					header_gen_send_o              <= '0';
					header_gen_reset_o             <= '0';
					housekeeping_wr_start_o        <= '0';
					housekeeping_wr_reset_o        <= '0';
					data_wr_start_o                <= '0';
					data_wr_reset_o                <= '0';
					data_wr_length_o               <= (others => '0');
					send_buffer_fee_data_loaded_o  <= '0';
					imgdata_start_o                <= '0';
					-- keep the masking machine released
					masking_machine_hold_o         <= '0';
					-- check if the header generator is finished
					if (header_gen_finished_i = '1') then
						-- header generator finished
						-- reset the header generator
						header_gen_reset_o       <= '1';
						-- go to hk data start
						s_fee_data_manager_state <= HK_DATA_START;
					end if;

				when HK_DATA_START =>
					-- start the hk writer
					s_fee_data_manager_state             <= WAITING_HK_DATA_FINISH;
					s_fee_remaining_data_bytes           <= (others => '0');
					s_fee_current_packet_data_size       <= (others => '0');
					s_last_packet_flag                   <= '0';
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- start the hk writer
					housekeeping_wr_start_o              <= '1';

				when WAITING_HK_DATA_FINISH =>
					-- wait for the hk writer to finish
					s_fee_data_manager_state             <= WAITING_HK_DATA_FINISH;
					s_fee_remaining_data_bytes           <= (others => '0');
					s_fee_current_packet_data_size       <= (others => '0');
					s_last_packet_flag                   <= '0';
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- check if the hk writer is finished
					if (housekeeping_wr_finished_i = '1') then
						-- hk writer finished
						-- reset the hk writer
						housekeeping_wr_reset_o       <= '1';
						-- signal send buffer that all the current packet data is loaded
						send_buffer_fee_data_loaded_o <= '1';
						-- increment sequence counter
						s_fee_sequence_counter        <= std_logic_vector(unsigned(s_fee_sequence_counter) + 1);
						-- only packet, finish operation
						-- clear the last packet flag
						s_last_packet_flag            <= '0';
						-- set the remaining data bytes counter to the image data size 
						s_fee_remaining_data_bytes    <= (others => '0');
						-- go to img header start
						s_fee_data_manager_state      <= WAITING_HK_TRANSMITTER_FINISH;
					end if;

				when WAITING_HK_TRANSMITTER_FINISH =>
					-- wait for the data transmitter to finish, to release the slave fee data controller for operation
					s_fee_data_manager_state             <= WAITING_HK_TRANSMITTER_FINISH;
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- clear the last packet flag
					s_last_packet_flag                   <= '0';
					-- set the remaining data bytes counter to the image data size 
					s_fee_remaining_data_bytes           <= (others => '0');
					-- check if the data transmitter is finished
					if (data_transmitter_finished_i = '1') then
						-- data transmitter finished
						-- signal the start of the imgdata cycle
						imgdata_start_o          <= '1';
						-- go to img header start
						s_fee_data_manager_state <= WAITING_IMG_DATA_START;
					end if;

				when WAITING_IMG_DATA_START =>
					-- wait for a indication that the img data has started (sincronize the slave and master module)
					-- for master: go to img header state
					-- for slave: wait a img data started flag
					s_fee_data_manager_state             <= IMG_HEADER_START;
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- clear the last packet flag
					s_last_packet_flag                   <= '0';
					-- set the remaining data bytes counter to the image data size 
					s_fee_remaining_data_bytes           <= std_logic_vector(resize(unsigned(fee_ccd_x_size_i) * unsigned(fee_data_y_size_i) * 2, s_fee_remaining_data_bytes'length));

				when IMG_HEADER_START =>
					-- start the img header generation
					s_fee_data_manager_state             <= WAITING_IMG_HEADER_FINISH;
					fee_data_manager_busy_o              <= '1';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the img header data
					headerdata_logical_address_o         <= fee_logical_addr_i;
					headerdata_protocol_id_o             <= fee_protocol_id_i;
					-- check if the remaining data length is equal or smaller than the packet data size
					if (unsigned(s_fee_remaining_data_bytes) <= (unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE)) then
						-- remaining data length is equal or smaller, last packet
						-- packet data size is remaining data length
						headerdata_length_field_o           <= s_fee_remaining_data_bytes(15 downto 0);
						s_fee_current_packet_data_size      <= s_fee_remaining_data_bytes(15 downto 0);
						-- set the last packet flag
						headerdata_type_field_last_packet_o <= '1';
						s_last_packet_flag                  <= '1';
					else
						-- packet data size is smaller, not last packet
						-- packet data size is standart data length
						headerdata_length_field_o           <= std_logic_vector(unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE);
						s_fee_current_packet_data_size      <= std_logic_vector(unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE);
						-- keep the last packet flag cleared
						headerdata_type_field_last_packet_o <= '0';
						s_last_packet_flag                  <= '0';
					end if;
					--					headerdata_type_field_mode_o         <= c_FULL_IMAGE_PATTERN_MODE;
					headerdata_type_field_mode_o         <= fee_fee_mode_i;
					headerdata_type_field_ccd_side_o     <= fee_ccd_side_i;
					headerdata_type_field_ccd_number_o   <= fee_ccd_number_i;
					headerdata_type_field_frame_number_o <= current_frame_number_i;
					headerdata_type_field_packet_type_o  <= c_DATA_PACKET;
					headerdata_frame_counter_o           <= current_frame_counter_i;
					headerdata_sequence_counter_o        <= s_fee_sequence_counter;
					-- start the header generator
					header_gen_send_o                    <= '1';

				when WAITING_IMG_HEADER_FINISH =>
					-- wait for the img header generation to finish
					s_fee_data_manager_state      <= WAITING_IMG_HEADER_FINISH;
					fee_data_manager_busy_o       <= '1';
					header_gen_send_o             <= '0';
					header_gen_reset_o            <= '0';
					housekeeping_wr_start_o       <= '0';
					housekeeping_wr_reset_o       <= '0';
					data_wr_start_o               <= '0';
					data_wr_reset_o               <= '0';
					data_wr_length_o              <= (others => '0');
					send_buffer_fee_data_loaded_o <= '0';
					imgdata_start_o               <= '0';
					-- keep the masking machine released
					masking_machine_hold_o        <= '0';
					-- check if the header generator is finished
					if (header_gen_finished_i = '1') then
						-- header generator finished
						-- reset the header generator
						header_gen_reset_o       <= '1';
						-- go to img data start
						s_fee_data_manager_state <= IMG_DATA_START;
					end if;

				when IMG_DATA_START =>
					-- start the data writer
					s_fee_data_manager_state             <= WAITING_IMG_DATA_FINISH;
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_reset_o                      <= '0';
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- set the data writer length
					data_wr_length_o                     <= s_fee_current_packet_data_size;
					-- start the data writer
					data_wr_start_o                      <= '1';

				when WAITING_IMG_DATA_FINISH =>
					-- wait for the data writer to finish
					s_fee_data_manager_state             <= WAITING_IMG_DATA_FINISH;
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- check if the data writer is finished
					if (data_wr_finished_i = '1') then
						-- data writer finished
						-- reset the data writer
						data_wr_reset_o               <= '1';
						-- signal send buffer that all the current packet data is loaded
						send_buffer_fee_data_loaded_o <= '1';
						-- increment sequence counter
						s_fee_sequence_counter        <= std_logic_vector(unsigned(s_fee_sequence_counter) + 1);
						-- check if its the last packet
						if (s_last_packet_flag = '1') then
							-- last packet, finish operation
							-- clear the last packet flag
							s_last_packet_flag         <= '0';
							-- set the remaining data bytes counter to the overscan data size 
							s_fee_remaining_data_bytes <= std_logic_vector(resize(unsigned(fee_ccd_x_size_i) * unsigned(fee_overscan_y_size_i) * 2, s_fee_remaining_data_bytes'length));
							-- go to over header start
							s_fee_data_manager_state   <= OVER_HEADER_START;
						else
							-- not last packet, continue operation
							-- keep the last packet flag cleared
							s_last_packet_flag         <= '0';
							-- update the remaining data bytes counter 
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - unsigned(s_fee_current_packet_data_size));
							-- go to img header start
							s_fee_data_manager_state   <= IMG_HEADER_START;
						end if;
					end if;

				when OVER_HEADER_START =>
					-- start the over header generation
					s_fee_data_manager_state             <= WAITING_OVER_HEADER_FINISH;
					fee_data_manager_busy_o              <= '1';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the over header data
					headerdata_logical_address_o         <= fee_logical_addr_i;
					headerdata_protocol_id_o             <= fee_protocol_id_i;
					-- check if the remaining data length is equal or smaller than the packet data size
					if (unsigned(s_fee_remaining_data_bytes) <= (unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE)) then
						-- remaining data length is equal or smaller, last packet
						-- packet data size is remaining data length
						headerdata_length_field_o           <= s_fee_remaining_data_bytes(15 downto 0);
						s_fee_current_packet_data_size      <= s_fee_remaining_data_bytes(15 downto 0);
						-- set the last packet flag
						headerdata_type_field_last_packet_o <= '1';
						s_last_packet_flag                  <= '1';
					else
						-- packet data size is smaller, not last packet
						-- packet data size is standart data length
						headerdata_length_field_o           <= std_logic_vector(unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE);
						s_fee_current_packet_data_size      <= std_logic_vector(unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE);
						-- keep the last packet flag cleared
						headerdata_type_field_last_packet_o <= '0';
						s_last_packet_flag                  <= '0';
					end if;
					--					headerdata_type_field_mode_o         <= c_FULL_IMAGE_PATTERN_MODE;
					headerdata_type_field_mode_o         <= fee_fee_mode_i;
					headerdata_type_field_ccd_side_o     <= fee_ccd_side_i;
					headerdata_type_field_ccd_number_o   <= fee_ccd_number_i;
					headerdata_type_field_frame_number_o <= current_frame_number_i;
					headerdata_type_field_packet_type_o  <= c_OVERSCAN_DATA;
					headerdata_frame_counter_o           <= current_frame_counter_i;
					headerdata_sequence_counter_o        <= s_fee_sequence_counter;
					-- start the header generator
					header_gen_send_o                    <= '1';

				when WAITING_OVER_HEADER_FINISH =>
					-- wait for the over header generation to finish
					s_fee_data_manager_state      <= WAITING_OVER_HEADER_FINISH;
					fee_data_manager_busy_o       <= '1';
					header_gen_send_o             <= '0';
					header_gen_reset_o            <= '0';
					housekeeping_wr_start_o       <= '0';
					housekeeping_wr_reset_o       <= '0';
					data_wr_start_o               <= '0';
					data_wr_reset_o               <= '0';
					data_wr_length_o              <= (others => '0');
					send_buffer_fee_data_loaded_o <= '0';
					imgdata_start_o               <= '0';
					-- keep the masking machine released
					masking_machine_hold_o        <= '0';
					-- check if the header generator is finished
					if (header_gen_finished_i = '1') then
						-- header generator finished
						-- reset the header generator
						header_gen_reset_o       <= '1';
						-- go to over data start
						s_fee_data_manager_state <= OVER_DATA_START;
					end if;

				when OVER_DATA_START =>
					-- start the data writer
					s_fee_data_manager_state             <= WAITING_OVER_DATA_FINISH;
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_reset_o                      <= '0';
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- set the data writer length
					data_wr_length_o                     <= s_fee_current_packet_data_size;
					-- start the data writer
					data_wr_start_o                      <= '1';

				when WAITING_OVER_DATA_FINISH =>
					-- wait for the data writer to finish
					s_fee_data_manager_state             <= WAITING_OVER_DATA_FINISH;
					fee_data_manager_busy_o              <= '1';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- check if the data writer is finished
					if (data_wr_finished_i = '1') then
						-- data writer finished
						-- reset the data writer
						data_wr_reset_o               <= '1';
						-- signal send buffer that all the current packet data is loaded
						send_buffer_fee_data_loaded_o <= '1';
						-- increment sequence counter
						s_fee_sequence_counter        <= std_logic_vector(unsigned(s_fee_sequence_counter) + 1);
						-- check if its the last packet
						if (s_last_packet_flag = '1') then
							-- last packet, finish operation
							-- clear the last packet flag
							s_last_packet_flag         <= '0';
							-- clear the remaining data bytes counter 
							s_fee_remaining_data_bytes <= (others => '0');
							-- go to finish fee operation
							s_fee_data_manager_state   <= FINISH_FEE_OPERATION;
						else
							-- not last packet, continue operation
							-- keep the last packet flag cleared
							s_last_packet_flag         <= '0';
							-- update the remaining data bytes counter 
							s_fee_remaining_data_bytes <= std_logic_vector(unsigned(s_fee_remaining_data_bytes) - unsigned(s_fee_current_packet_data_size));
							-- go to over header start
							s_fee_data_manager_state   <= OVER_HEADER_START;
						end if;
					end if;

				when FINISH_FEE_OPERATION =>
					-- finish the fee operation
					s_fee_remaining_data_bytes           <= (others => '0');
					s_fee_sequence_counter               <= (others => '0');
					s_fee_current_packet_data_size       <= (others => '0');
					s_last_packet_flag                   <= '0';
					fee_data_manager_busy_o              <= '0';
					headerdata_logical_address_o         <= (others => '0');
					headerdata_protocol_id_o             <= (others => '0');
					headerdata_length_field_o            <= (others => '0');
					headerdata_type_field_mode_o         <= (others => '0');
					headerdata_type_field_last_packet_o  <= '0';
					headerdata_type_field_ccd_side_o     <= '0';
					headerdata_type_field_ccd_number_o   <= (others => '0');
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= (others => '0');
					headerdata_frame_counter_o           <= (others => '0');
					headerdata_sequence_counter_o        <= (others => '0');
					header_gen_send_o                    <= '0';
					header_gen_reset_o                   <= '0';
					housekeeping_wr_start_o              <= '0';
					housekeeping_wr_reset_o              <= '0';
					data_wr_start_o                      <= '0';
					data_wr_reset_o                      <= '0';
					data_wr_length_o                     <= (others => '0');
					send_buffer_fee_data_loaded_o        <= '0';
					imgdata_start_o                      <= '0';
					-- hold the masking machine
					masking_machine_hold_o               <= '1';
					-- return to idle to wait another sync
					s_fee_data_manager_state             <= IDLE;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_fee_data_manager_state <= STOPPED;
			end if;

			--			-- check if a sync was issued and is not in stopped or idle
			--			if ((sync_signal_i = '1') and (s_fee_data_manager_state /= IDLE) and (s_fee_data_manager_state /= STOPPED)) then
			--				-- sync arrived, force the idle state and set a forced sync
			--				s_fee_data_manager_state <= IDLE;
			--				s_forced_sync            <= '1';
			--			else
			--				s_forced_sync <= '0';
			--			end if;

		end if;
	end process p_fee_data_manager;

end architecture RTL;
