library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rmap_mem_area_nfee_pkg is

	-- Config Area Regs
	type t_rmap_memory_reg_ccd_seq_1_config is record
		tri_level_clock_control               : std_logic;
		image_clock_direction_control         : std_logic;
		register_clock_direction_control      : std_logic;
		image_clock_transfer_count_control    : std_logic_vector(15 downto 0);
		register_clock_transfer_count_control : std_logic_vector(11 downto 0);
	end record t_rmap_memory_reg_ccd_seq_1_config;

	type t_rmap_memory_reg_ccd_seq_2_config is record
		slow_read_out_pause_count : std_logic_vector(19 downto 0);
	end record t_rmap_memory_reg_ccd_seq_2_config;

	type t_rmap_memory_reg_spw_packet_1_config is record
		digitise_control                             : std_logic;
		ccd_port_data_transmission_selection_control : std_logic_vector(1 downto 0);
		packet_size_control                          : std_logic_vector(15 downto 0);
	end record t_rmap_memory_reg_spw_packet_1_config;

	--	type t_rmap_memory_reg_spw_packet_2_config is record
	--	end record t_rmap_memory_reg_spw_packet_2_config;

	type t_rmap_memory_reg_CCD_1_windowing_1_config is record
		window_list_pointer_initial_address_ccd1 : std_logic_vector(31 downto 0);
	end record t_rmap_memory_reg_CCD_1_windowing_1_config;

	type t_rmap_memory_reg_CCD_1_windowing_2_config is record
		window_width_ccd1       : std_logic_vector(5 downto 0);
		window_height_ccd1      : std_logic_vector(5 downto 0);
		window_list_length_ccd1 : std_logic_vector(15 downto 0);
	end record t_rmap_memory_reg_CCD_1_windowing_2_config;

	type t_rmap_memory_reg_CCD_2_windowing_1_config is record
		window_list_pointer_initial_address_ccd2 : std_logic_vector(31 downto 0);
	end record t_rmap_memory_reg_CCD_2_windowing_1_config;

	type t_rmap_memory_reg_CCD_2_windowing_2_config is record
		window_width_ccd2       : std_logic_vector(5 downto 0);
		window_height_ccd2      : std_logic_vector(5 downto 0);
		window_list_length_ccd2 : std_logic_vector(15 downto 0);
	end record t_rmap_memory_reg_CCD_2_windowing_2_config;

	type t_rmap_memory_reg_CCD_3_windowing_1_config is record
		window_list_pointer_initial_address_ccd3 : std_logic_vector(31 downto 0);
	end record t_rmap_memory_reg_CCD_3_windowing_1_config;

	type t_rmap_memory_reg_CCD_3_windowing_2_config is record
		window_width_ccd3       : std_logic_vector(5 downto 0);
		window_height_ccd3      : std_logic_vector(5 downto 0);
		window_list_length_ccd3 : std_logic_vector(15 downto 0);
	end record t_rmap_memory_reg_CCD_3_windowing_2_config;

	type t_rmap_memory_reg_CCD_4_windowing_1_config is record
		window_list_pointer_initial_address_ccd4 : std_logic_vector(31 downto 0);
	end record t_rmap_memory_reg_CCD_4_windowing_1_config;

	type t_rmap_memory_reg_CCD_4_windowing_2_config is record
		window_width_ccd4       : std_logic_vector(5 downto 0);
		window_height_ccd4      : std_logic_vector(5 downto 0);
		window_list_length_ccd4 : std_logic_vector(15 downto 0);
	end record t_rmap_memory_reg_CCD_4_windowing_2_config;

	type t_rmap_memory_reg_operation_mode_config is record
		mode_selection_control : std_logic_vector(3 downto 0);
	end record t_rmap_memory_reg_operation_mode_config;

	type t_rmap_memory_reg_sync_config is record
		sync_configuration   : std_logic_vector(1 downto 0);
		self_trigger_control : std_logic;
	end record t_rmap_memory_reg_sync_config;

	--	type t_rmap_memory_reg_dac_control is record
	--	end record t_rmap_memory_reg_dac_control;

	--	type t_rmap_memory_reg_clock_source_control is record
	--	end record t_rmap_memory_reg_clock_source_control;

	type t_rmap_memory_reg_frame_number is record
		frame_number : std_logic_vector(1 downto 0);
	end record t_rmap_memory_reg_frame_number;

	type t_rmap_memory_reg_current_mode is record
		current_mode : std_logic_vector(3 downto 0);
	end record t_rmap_memory_reg_current_mode;

	type t_rmap_memory_config_area is record
		ccd_seq_1_config         : t_rmap_memory_reg_ccd_seq_1_config;
		ccd_seq_2_config         : t_rmap_memory_reg_ccd_seq_2_config;
		spw_packet_1_config      : t_rmap_memory_reg_spw_packet_1_config;
		--		spw_packet_2_config      : t_rmap_memory_reg_spw_packet_2_config;
		CCD_1_windowing_1_config : t_rmap_memory_reg_CCD_1_windowing_1_config;
		CCD_1_windowing_2_config : t_rmap_memory_reg_CCD_1_windowing_2_config;
		CCD_2_windowing_1_config : t_rmap_memory_reg_CCD_2_windowing_1_config;
		CCD_2_windowing_2_config : t_rmap_memory_reg_CCD_2_windowing_2_config;
		CCD_3_windowing_1_config : t_rmap_memory_reg_CCD_3_windowing_1_config;
		CCD_3_windowing_2_config : t_rmap_memory_reg_CCD_3_windowing_2_config;
		CCD_4_windowing_1_config : t_rmap_memory_reg_CCD_4_windowing_1_config;
		CCD_4_windowing_2_config : t_rmap_memory_reg_CCD_4_windowing_2_config;
		operation_mode_config    : t_rmap_memory_reg_operation_mode_config;
		sync_config              : t_rmap_memory_reg_sync_config;
		--		dac_control              : t_rmap_memory_reg_dac_control;
		--		clock_source_control     : t_rmap_memory_reg_clock_source_control;
		frame_number             : t_rmap_memory_reg_frame_number;
		current_mode             : t_rmap_memory_reg_current_mode;
	end record t_rmap_memory_config_area;

	-- HK Area Regs
	type t_rmap_memory_hk_area is record
		hk_ccd1_vod_e    : std_logic_vector(15 downto 0);
		hk_ccd1_vod_f    : std_logic_vector(15 downto 0);
		hk_ccd1_vrd_mon  : std_logic_vector(15 downto 0);
		hk_ccd2_vod_e    : std_logic_vector(15 downto 0);
		hk_ccd2_vod_f    : std_logic_vector(15 downto 0);
		hk_ccd2_vrd_mon  : std_logic_vector(15 downto 0);
		hk_ccd3_vod_e    : std_logic_vector(15 downto 0);
		hk_ccd3_vod_f    : std_logic_vector(15 downto 0);
		hk_ccd3_vrd_mon  : std_logic_vector(15 downto 0);
		hk_ccd4_vod_e    : std_logic_vector(15 downto 0);
		hk_ccd4_vod_f    : std_logic_vector(15 downto 0);
		hk_ccd4_vrd_mon  : std_logic_vector(15 downto 0);
		hk_vccd          : std_logic_vector(15 downto 0);
		hk_vrclk         : std_logic_vector(15 downto 0);
		hk_viclk         : std_logic_vector(15 downto 0);
		hk_vrclk_low     : std_logic_vector(15 downto 0);
		hk_5vb_pos       : std_logic_vector(15 downto 0);
		hk_5vb_neg       : std_logic_vector(15 downto 0);
		hk_3_3vb_pos     : std_logic_vector(15 downto 0);
		hk_2_5va_pos     : std_logic_vector(15 downto 0);
		hk_3_3vd_pos     : std_logic_vector(15 downto 0);
		hk_2_5vd_pos     : std_logic_vector(15 downto 0);
		hk_1_5vd_pos     : std_logic_vector(15 downto 0);
		hk_5vref         : std_logic_vector(15 downto 0);
		hk_vccd_pos_raw  : std_logic_vector(15 downto 0);
		hk_vclk_pos_raw  : std_logic_vector(15 downto 0);
		hk_van1_pos_raw  : std_logic_vector(15 downto 0);
		hk_van3_neg_raw  : std_logic_vector(15 downto 0);
		hk_van2_pos_raw  : std_logic_vector(15 downto 0);
		hk_vdig_fpga_raw : std_logic_vector(15 downto 0);
		hk_vdig_spw_raw  : std_logic_vector(15 downto 0);
		hk_viclk_low     : std_logic_vector(15 downto 0);
		hk_adc_temp_a_e  : std_logic_vector(15 downto 0);
		hk_adc_temp_a_f  : std_logic_vector(15 downto 0);
		hk_ccd1_temp     : std_logic_vector(15 downto 0);
		hk_ccd2_temp     : std_logic_vector(15 downto 0);
		hk_ccd3_temp     : std_logic_vector(15 downto 0);
		hk_ccd4_temp     : std_logic_vector(15 downto 0);
		hk_wp605_spare   : std_logic_vector(15 downto 0);
		lowres_prt_a_0   : std_logic_vector(15 downto 0);
		lowres_prt_a_1   : std_logic_vector(15 downto 0);
		lowres_prt_a_2   : std_logic_vector(15 downto 0);
		lowres_prt_a_3   : std_logic_vector(15 downto 0);
		lowres_prt_a_4   : std_logic_vector(15 downto 0);
		lowres_prt_a_5   : std_logic_vector(15 downto 0);
		lowres_prt_a_6   : std_logic_vector(15 downto 0);
		lowres_prt_a_7   : std_logic_vector(15 downto 0);
		lowres_prt_a_8   : std_logic_vector(15 downto 0);
		lowres_prt_a_9   : std_logic_vector(15 downto 0);
		lowres_prt_a_10  : std_logic_vector(15 downto 0);
		lowres_prt_a_11  : std_logic_vector(15 downto 0);
		lowres_prt_a_12  : std_logic_vector(15 downto 0);
		lowres_prt_a_13  : std_logic_vector(15 downto 0);
		lowres_prt_a_14  : std_logic_vector(15 downto 0);
		lowres_prt_a_15  : std_logic_vector(15 downto 0);
		sel_hires_prt0   : std_logic_vector(15 downto 0);
		sel_hires_prt1   : std_logic_vector(15 downto 0);
		sel_hires_prt2   : std_logic_vector(15 downto 0);
		sel_hires_prt3   : std_logic_vector(15 downto 0);
		sel_hires_prt4   : std_logic_vector(15 downto 0);
		sel_hires_prt5   : std_logic_vector(15 downto 0);
		sel_hires_prt6   : std_logic_vector(15 downto 0);
		sel_hires_prt7   : std_logic_vector(15 downto 0);
		zero_hires_amp   : std_logic_vector(15 downto 0);
	end record t_rmap_memory_hk_area;

end package rmap_mem_area_nfee_pkg;

package body rmap_mem_area_nfee_pkg is

end package body rmap_mem_area_nfee_pkg;
