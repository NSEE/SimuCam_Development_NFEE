library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_imgdata_manager_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		-- image data manager inputs --
		-- general inputs
		fee_clear_signal_i            : in  std_logic;
		fee_stop_signal_i             : in  std_logic;
		fee_start_signal_i            : in  std_logic;
		fee_digitalise_en_i           : in  std_logic;
		current_frame_number_i        : in  std_logic_vector(1 downto 0);
		current_frame_counter_i       : in  std_logic_vector(15 downto 0);
		-- image data manager parameters
		fee_logical_addr_i            : in  std_logic_vector(7 downto 0);
		fee_protocol_id_i             : in  std_logic_vector(7 downto 0);
		fee_packet_length_i           : in  std_logic_vector(15 downto 0);
		fee_fee_mode_i                : in  std_logic_vector(3 downto 0);
		fee_ccd_number_i              : in  std_logic_vector(1 downto 0);
		fee_ccd_side_i                : in  std_logic;
		-- image data manager control
		imgdata_manager_start_i       : in  std_logic;
		imgdata_manager_reset_i       : in  std_logic;
		-- masking machine status
		-- header generator status
		header_gen_i                  : in  t_fee_dpkt_general_status;
		-- data writer status
		data_wr_finished_i            : in  std_logic;
		data_wr_data_changed_i        : in  std_logic;
		-- image data manager outputs --
		-- general outputs
		-- masking machine control
		masking_machine_hold_o        : out std_logic;
		-- image data manager status			
		imgdata_manager_finished_o    : out std_logic;
		-- header data
		headerdata_o                  : out t_fee_dpkt_headerdata;
		-- header generator control		
		header_gen_o                  : out t_fee_dpkt_general_control;
		-- data writer control
		data_wr_start_o               : out std_logic;
		data_wr_reset_o               : out std_logic;
		data_wr_length_o              : out std_logic_vector(15 downto 0);
		-- send buffer control
		send_buffer_fee_data_loaded_o : out std_logic
		-- data transmitter control
	);
end entity fee_imgdata_manager_ent;

architecture RTL of fee_imgdata_manager_ent is

	-- fee data manager fsm type
	type t_fee_data_manager_fsm is (
		STOPPED,
		IDLE,
		IMG_HEADER_START,
		WAITING_IMG_HEADER_FINISH,
		IMG_DATA_START,
		WAITING_IMG_DATA_FINISH,
		OVER_HEADER_START,
		WAITING_OVER_HEADER_FINISH,
		OVER_DATA_START,
		WAITING_OVER_DATA_FINISH,
		FINISH_IMGDATA_OPERATION
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

begin

	p_fee_data_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			-- signals
			s_fee_data_manager_state             <= STOPPED;
			-- outputs
			imgdata_manager_finished_o           <= '0';
			masking_machine_hold_o               <= '1';
			headerdata_o.logical_address         <= (others => '0');
			headerdata_o.protocol_id             <= (others => '0');
			headerdata_o.length_field            <= (others => '0');
			headerdata_o.type_field.mode         <= (others => '0');
			headerdata_o.type_field.last_packet  <= '0';
			headerdata_o.type_field.ccd_side     <= '0';
			headerdata_o.type_field.ccd_number   <= (others => '0');
			headerdata_o.type_field.frame_number <= (others => '0');
			headerdata_o.type_field.packet_type  <= (others => '0');
			headerdata_o.frame_counter           <= (others => '0');
			headerdata_o.sequence_counter        <= (others => '0');
			header_gen_o.start                   <= '0';
			header_gen_o.reset                   <= '1';
			data_wr_start_o                      <= '0';
			data_wr_reset_o                      <= '1';
			data_wr_length_o                     <= (others => '0');
			send_buffer_fee_data_loaded_o        <= '0';
		--			s_forced_sync                        <= '0';
		elsif rising_edge(clk_i) then

			-- standart signal/outputs values
			imgdata_manager_finished_o           <= '0';
			masking_machine_hold_o               <= '0';
			headerdata_o.logical_address         <= (others => '0');
			headerdata_o.protocol_id             <= (others => '0');
			headerdata_o.length_field            <= (others => '0');
			headerdata_o.type_field.mode         <= (others => '0');
			headerdata_o.type_field.last_packet  <= '0';
			headerdata_o.type_field.ccd_side     <= '0';
			headerdata_o.type_field.ccd_number   <= (others => '0');
			headerdata_o.type_field.frame_number <= (others => '0');
			headerdata_o.type_field.packet_type  <= (others => '0');
			headerdata_o.frame_counter           <= (others => '0');
			headerdata_o.sequence_counter        <= (others => '0');
			header_gen_o.start                   <= '0';
			header_gen_o.reset                   <= '0';
			data_wr_start_o                      <= '0';
			data_wr_reset_o                      <= '0';
			data_wr_length_o                     <= (others => '0');
			send_buffer_fee_data_loaded_o        <= '0';

			case (s_fee_data_manager_state) is

				when STOPPED =>
					-- stopped state. do nothing and reset fee data manager
					s_fee_data_manager_state <= STOPPED;
					-- keep masking machine on hold
					masking_machine_hold_o   <= '1';
					-- check if a start was issued
					if (fee_start_signal_i = '1') then
						-- start issued, go to idle
						s_fee_data_manager_state <= IDLE;
					end if;

				when IDLE =>
					-- do nothing until a sync signal is received
					s_fee_data_manager_state <= IDLE;
					-- check if a masking machine start was issued
					if (imgdata_manager_start_i = '1') then
						-- image data manager start signal received
						-- release the masking machine
						masking_machine_hold_o   <= '0';
						-- go to hk header start
						s_fee_data_manager_state <= IMG_HEADER_START;
					end if;

				when IMG_HEADER_START =>
					-- start the img header generation
					s_fee_data_manager_state             <= WAITING_IMG_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the img header data
					headerdata_o.logical_address         <= fee_logical_addr_i;
					headerdata_o.protocol_id             <= fee_protocol_id_i;
					-- packet data size is remaining data length
					headerdata_o.length_field            <= fee_packet_length_i;
					-- keep the last packet flag cleared
					headerdata_o.type_field.last_packet  <= '0';
					headerdata_o.type_field.mode         <= fee_fee_mode_i;
					headerdata_o.type_field.ccd_side     <= fee_ccd_side_i;
					headerdata_o.type_field.ccd_number   <= fee_ccd_number_i;
					headerdata_o.type_field.frame_number <= current_frame_number_i;
					headerdata_o.type_field.packet_type  <= c_DATA_PACKET;
					headerdata_o.frame_counter           <= current_frame_counter_i;
					headerdata_o.sequence_counter        <= (others => '0');
					-- start the header generator
					header_gen_o.start                   <= '1';

				when WAITING_IMG_HEADER_FINISH =>
					-- wait for the img header generation to finish
					s_fee_data_manager_state             <= WAITING_IMG_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the img header data
					headerdata_o.logical_address         <= fee_logical_addr_i;
					headerdata_o.protocol_id             <= fee_protocol_id_i;
					-- packet data size is remaining data length
					headerdata_o.length_field            <= fee_packet_length_i;
					-- keep the last packet flag cleared
					headerdata_o.type_field.last_packet  <= '0';
					headerdata_o.type_field.mode         <= fee_fee_mode_i;
					headerdata_o.type_field.ccd_side     <= fee_ccd_side_i;
					headerdata_o.type_field.ccd_number   <= fee_ccd_number_i;
					headerdata_o.type_field.frame_number <= current_frame_number_i;
					headerdata_o.type_field.packet_type  <= c_DATA_PACKET;
					headerdata_o.frame_counter           <= current_frame_counter_i;
					headerdata_o.sequence_counter        <= (others => '0');
					-- check if the header generator is finished
					if (header_gen_i.finished = '1') then
						-- header generator finished
						-- reset the header generator
						header_gen_o.reset       <= '1';
						-- go to img data start
						s_fee_data_manager_state <= IMG_DATA_START;
					end if;

				when IMG_DATA_START =>
					-- start the data writer
					s_fee_data_manager_state <= WAITING_IMG_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- set the data writer length
					data_wr_length_o         <= std_logic_vector(unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE);
					-- start the data writer
					data_wr_start_o          <= '1';

				when WAITING_IMG_DATA_FINISH =>
					-- wait for the data writer to finish
					s_fee_data_manager_state <= WAITING_IMG_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- check if the data writer is finished
					if (data_wr_finished_i = '1') then
						-- data writer finished
						-- reset the data writer
						data_wr_reset_o               <= '1';
						-- signal send buffer that all the current packet data is loaded
						send_buffer_fee_data_loaded_o <= '1';
						-- check if a change command was received
						if (data_wr_data_changed_i = '1') then
							-- change command received
							-- go to over header start
							s_fee_data_manager_state <= OVER_HEADER_START;
						else
							-- change command not received
							-- go to img header start
							s_fee_data_manager_state <= IMG_HEADER_START;
						end if;
					end if;

				when OVER_HEADER_START =>
					-- start the over header generation
					s_fee_data_manager_state             <= WAITING_OVER_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the over header data
					headerdata_o.logical_address         <= fee_logical_addr_i;
					headerdata_o.protocol_id             <= fee_protocol_id_i;
					-- packet data size is standart data length
					headerdata_o.length_field            <= fee_packet_length_i;
					-- keep the last packet flag cleared
					headerdata_o.type_field.last_packet  <= '0';
					headerdata_o.type_field.mode         <= fee_fee_mode_i;
					headerdata_o.type_field.ccd_side     <= fee_ccd_side_i;
					headerdata_o.type_field.ccd_number   <= fee_ccd_number_i;
					headerdata_o.type_field.frame_number <= current_frame_number_i;
					headerdata_o.type_field.packet_type  <= c_OVERSCAN_DATA;
					headerdata_o.frame_counter           <= current_frame_counter_i;
					headerdata_o.sequence_counter        <= (others => '0');
					-- start the header generator
					header_gen_o.start                   <= '1';

				when WAITING_OVER_HEADER_FINISH =>
					-- wait for the over header generation to finish
					s_fee_data_manager_state             <= WAITING_OVER_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the over header data
					headerdata_o.logical_address         <= fee_logical_addr_i;
					headerdata_o.protocol_id             <= fee_protocol_id_i;
					-- packet data size is standart data length
					headerdata_o.length_field            <= fee_packet_length_i;
					-- keep the last packet flag cleared
					headerdata_o.type_field.last_packet  <= '0';
					headerdata_o.type_field.mode         <= fee_fee_mode_i;
					headerdata_o.type_field.ccd_side     <= fee_ccd_side_i;
					headerdata_o.type_field.ccd_number   <= fee_ccd_number_i;
					headerdata_o.type_field.frame_number <= current_frame_number_i;
					headerdata_o.type_field.packet_type  <= c_OVERSCAN_DATA;
					headerdata_o.frame_counter           <= current_frame_counter_i;
					headerdata_o.sequence_counter        <= (others => '0');
					-- check if the header generator is finished
					if (header_gen_i.finished = '1') then
						-- header generator finished
						-- reset the header generator
						header_gen_o.reset       <= '1';
						-- go to over data start
						s_fee_data_manager_state <= OVER_DATA_START;
					end if;

				when OVER_DATA_START =>
					-- start the data writer
					s_fee_data_manager_state <= WAITING_OVER_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- set the data writer length
					data_wr_length_o         <= std_logic_vector(unsigned(fee_packet_length_i) - c_DATA_PKT_HEADER_SIZE);
					-- start the data writer
					data_wr_start_o          <= '1';

				when WAITING_OVER_DATA_FINISH =>
					-- wait for the data writer to finish
					s_fee_data_manager_state <= WAITING_OVER_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- check if the data writer is finished
					if (data_wr_finished_i = '1') then
						-- data writer finished
						-- reset the data writer
						data_wr_reset_o               <= '1';
						-- signal send buffer that all the current packet data is loaded
						send_buffer_fee_data_loaded_o <= '1';
						-- check if a change command was received
						if (data_wr_data_changed_i = '1') then
							-- change command received
							-- go to over header start
							s_fee_data_manager_state <= FINISH_IMGDATA_OPERATION;
						else
							-- change command not received
							-- go to img header start
							s_fee_data_manager_state <= OVER_HEADER_START;
						end if;
					end if;

				when FINISH_IMGDATA_OPERATION =>
					-- finish the image data operation
					s_fee_data_manager_state   <= FINISH_IMGDATA_OPERATION;
					imgdata_manager_finished_o <= '1';
					-- hold the masking machine
					masking_machine_hold_o     <= '1';
					-- check if a image data manager reset was requested
					if (imgdata_manager_reset_i = '1') then
						-- reset commanded, go back to idle
						s_fee_data_manager_state <= IDLE;
					end if;

			end case;

			-- check if a stop was issued
			if (fee_stop_signal_i = '1') then
				-- stop issued, go to stopped
				s_fee_data_manager_state <= STOPPED;
			end if;

		end if;
	end process p_fee_data_manager;

end architecture RTL;
