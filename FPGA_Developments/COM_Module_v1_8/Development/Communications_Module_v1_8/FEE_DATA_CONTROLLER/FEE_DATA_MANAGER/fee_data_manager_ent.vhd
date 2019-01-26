library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fee_data_manager_ent is
	port(
		clk_i                                : in  std_logic;
		rst_i                                : in  std_logic;
		-- fee data manager inputs --
		-- general inputs
		sync_signal_i                        : in  std_logic;
		current_timecode_i                   : in  std_logic_vector(7 downto 0);
		-- fee data manager parameters
		fee_ccd_x_size_i                     : in  std_logic_vector(15 downto 0);
		fee_ccd_y_size_i                     : in  std_logic_vector(15 downto 0);
		fee_data_y_size_i                    : in  std_logic_vector(15 downto 0);
		fee_overscan_y_size_i                : in  std_logic_vector(15 downto 0);
		fee_packet_length_i                  : in  std_logic_vector(15 downto 0);
		fee_fee_mode_i                       : in  std_logic_vector(7 downto 0);
		fee_ccd_number_i                     : in  std_logic_vector(7 downto 0);
		fee_ccd_side_i                       : in  std_logic;
		-- header generator status
		header_gen_busy_i                    : in  std_logic;
		header_gen_finished_i                : in  std_logic;
		-- housekeeping writer status
		housekeeping_wr_busy_i               : in  std_logic;
		housekeeping_wr_finished_i           : in  std_logic;
		-- data writer status
		data_wr_busy_i                       : in  std_logic;
		data_wr_finished_i                   : in  std_logic;
		-- data transmitter status
		data_transmitter_busy_i              : in  std_logic;
		data_transmitter_finished_i          : in  std_logic;
		-- fee data manager outputs --
		-- general outputs
		-- masking machine control
		masking_machine_hold_o               : out std_logic;
		masking_buffer_clear_o               : out std_logic;
		-- header data
		headerdata_logical_address_o         : out std_logic_vector(7 downto 0);
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
		send_buffer_fee_data_loaded_o        : out std_logic;
		send_buffer_clear_o                  : out std_logic;
		-- data transmitter control
		data_transmitter_reset_o             : out std_logic
	);
end entity fee_data_manager_ent;

architecture RTL of fee_data_manager_ent is

	-- data packet header data --
	-- dpu logical address
	constant c_DPU_LOGICAL_ADDR        : std_logic_vector(7 downto 0) := x"50";
	-- type field, mode bits
	constant c_FULL_IMAGE_MODE         : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(0, 3));
	constant c_FULL_IMAGE_PATTERN_MODE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(1, 3));
	constant c_WINDOWING_MODE          : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(2, 3));
	constant c_WINDOWING_PATTERN_MODE  : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(3, 3));
	constant c_PARTIAL_READ_OUT_MODE   : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(4, 3));
	-- type field, packet type bits
	constant c_DATA_PACKET             : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(0, 2));
	constant c_OVERSCAN_DATA           : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(1, 2));
	constant c_HOUSEKEEPING_PACKET     : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(2, 2));

	-- fee data manager fsm type
	type t_fee_data_manager_fsm is (
		IDLE,
		HK_HEADER_START,
		WAITING_HK_HEADER_FINISH,
		HK_DATA_START,
		WAITING_HK_DATA_FINISH,
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

begin

	p_fee_data_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_fee_data_manager_state             <= IDLE;
			masking_machine_hold_o               <= '1';
			masking_buffer_clear_o               <= '1';
			headerdata_logical_address_o         <= (others => '0');
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
			send_buffer_clear_o                  <= '1';
			data_transmitter_reset_o             <= '1';
		elsif rising_edge(clk_i) then

			case (s_fee_data_manager_state) is

				when IDLE =>
					-- do nothing until a sync signal is received
					s_fee_data_manager_state <= IDLE;
					-- keep the masking machine on hold
					masking_machine_hold_o   <= '1';
					if (sync_signal_i = '1') then
						-- sync signal received
						-- release the masking machine
						masking_machine_hold_o   <= '0';
						-- go to hk header start
						s_fee_data_manager_state <= HK_HEADER_START;
					end if;

				when HK_HEADER_START =>
					-- start the hk header generation
					s_fee_data_manager_state             <= WAITING_HK_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the hk header data
					headerdata_logical_address_o         <= c_DPU_LOGICAL_ADDR;
					-- TODO: corrigir o length field
					headerdata_length_field_o            <= fee_packet_length_i;
					headerdata_type_field_mode_o         <= c_FULL_IMAGE_PATTERN_MODE;
					--					headerdata_type_field_mode_o         <= fee_fee_mode_i(2 downto 0);
					headerdata_type_field_last_packet_o  <= '1';
					headerdata_type_field_ccd_side_o     <= fee_ccd_side_i;
					headerdata_type_field_ccd_number_o   <= fee_ccd_number_i(1 downto 0);
					-- TODO: atualizar frame number
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= c_HOUSEKEEPING_PACKET;
					-- TODO: atualizar frame counter
					headerdata_frame_counter_o           <= (others => '0');
					-- TODO: atualizar sequence counter
					headerdata_sequence_counter_o        <= (others => '0');
					-- start the header generator
					header_gen_send_o                    <= '1';

				when WAITING_HK_HEADER_FINISH =>
					-- wait for the hk header generation to finish
					s_fee_data_manager_state <= WAITING_HK_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
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
					s_fee_data_manager_state <= WAITING_HK_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- start the hk writer
					housekeeping_wr_start_o  <= '1';

				when WAITING_HK_DATA_FINISH =>
					-- wait for the hk writer to finish
					s_fee_data_manager_state <= WAITING_HK_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- check if the hk writer is finished
					if (housekeeping_wr_finished_i = '1') then
						-- hk writer finished
						-- reset the hk writer
						housekeeping_wr_reset_o       <= '1';
						-- signal send buffer that all the current packet data is loaded
						send_buffer_fee_data_loaded_o <= '1';
						-- go to img header start
						s_fee_data_manager_state      <= IMG_HEADER_START;
					end if;

				when IMG_HEADER_START =>
					-- start the img header generation
					s_fee_data_manager_state             <= WAITING_IMG_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the img header data
					headerdata_logical_address_o         <= c_DPU_LOGICAL_ADDR;
					-- TODO: corrigir o length field
					headerdata_length_field_o            <= fee_packet_length_i;
					headerdata_type_field_mode_o         <= c_FULL_IMAGE_PATTERN_MODE;
					--					headerdata_type_field_mode_o         <= fee_fee_mode_i(2 downto 0);
					headerdata_type_field_last_packet_o  <= '1';
					headerdata_type_field_ccd_side_o     <= fee_ccd_side_i;
					headerdata_type_field_ccd_number_o   <= fee_ccd_number_i(1 downto 0);
					-- TODO: atualizar frame number
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= c_DATA_PACKET;
					-- TODO: atualizar frame counter
					headerdata_frame_counter_o           <= (others => '0');
					-- TODO: atualizar sequence counter
					headerdata_sequence_counter_o        <= (others => '0');
					-- start the header generator
					header_gen_send_o                    <= '1';

				when WAITING_IMG_HEADER_FINISH =>
					-- wait for the img header generation to finish
					s_fee_data_manager_state <= WAITING_IMG_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
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
					s_fee_data_manager_state <= WAITING_IMG_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- set the data writer length
					-- TODO: acertar o data write length
					data_wr_length_o         <= (others => '1');
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
						-- go to over header start
						s_fee_data_manager_state      <= OVER_HEADER_START;
					end if;

				when OVER_HEADER_START =>
					-- start the over header generation
					s_fee_data_manager_state             <= WAITING_OVER_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o               <= '0';
					-- configure the over header data
					headerdata_logical_address_o         <= c_DPU_LOGICAL_ADDR;
					-- TODO: corrigir o length field
					headerdata_length_field_o            <= fee_packet_length_i;
					headerdata_type_field_mode_o         <= c_FULL_IMAGE_PATTERN_MODE;
					--					headerdata_type_field_mode_o         <= fee_fee_mode_i(2 downto 0);
					headerdata_type_field_last_packet_o  <= '1';
					headerdata_type_field_ccd_side_o     <= fee_ccd_side_i;
					headerdata_type_field_ccd_number_o   <= fee_ccd_number_i(1 downto 0);
					-- TODO: atualizar frame number
					headerdata_type_field_frame_number_o <= (others => '0');
					headerdata_type_field_packet_type_o  <= c_OVERSCAN_DATA;
					-- TODO: atualizar frame counter
					headerdata_frame_counter_o           <= (others => '0');
					-- TODO: atualizar sequence counter
					headerdata_sequence_counter_o        <= (others => '0');
					-- start the header generator
					header_gen_send_o                    <= '1';

				when WAITING_OVER_HEADER_FINISH =>
					-- wait for the over header generation to finish
					s_fee_data_manager_state <= WAITING_OVER_HEADER_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
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
					s_fee_data_manager_state <= WAITING_OVER_DATA_FINISH;
					-- keep the masking machine released
					masking_machine_hold_o   <= '0';
					-- set the data writer length
					-- TODO: acertar o data write length
					data_wr_length_o         <= (others => '1');
					-- start the data writer
					data_wr_start_o          <= '1';

				when WAITING_OVER_DATA_FINISH =>
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
						-- go to finish fee operation
						s_fee_data_manager_state      <= FINISH_FEE_OPERATION;
					end if;

				when FINISH_FEE_OPERATION =>
					null;

			end case;

		end if;
	end process p_fee_data_manager;

end architecture RTL;
