-- megafunction wizard: %ALTLVDS_RX%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: ALTLVDS_RX 

-- ============================================================
-- File Name: RX_LVDS.vhd
-- Megafunction Name(s):
-- 			ALTLVDS_RX
--
-- Simulation Library Files(s):
-- 			
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 15.1.0 Build 185 10/21/2015 SJ Standard Edition
-- ************************************************************


--Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, the Altera Quartus Prime License Agreement,
--the Altera MegaCore Function License Agreement, or other 
--applicable license agreement, including, without limitation, 
--that your use is for the sole purpose of programming logic 
--devices manufactured by Altera and sold by Altera or its 
--authorized distributors.  Please refer to the applicable 
--agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY RX_LVDS IS
	PORT
	(
		rx_in		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		rx_out		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END RX_LVDS;


ARCHITECTURE SYN OF rx_lvds IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (0 DOWNTO 0);



	COMPONENT altlvds_rx
	GENERIC (
		buffer_implementation		: STRING;
		cds_mode		: STRING;
		common_rx_tx_pll		: STRING;
		data_align_rollover		: NATURAL;
		data_rate		: STRING;
		deserialization_factor		: NATURAL;
		dpa_initial_phase_value		: NATURAL;
		dpll_lock_count		: NATURAL;
		dpll_lock_window		: NATURAL;
		enable_clock_pin_mode		: STRING;
		enable_dpa_align_to_rising_edge_only		: STRING;
		enable_dpa_calibration		: STRING;
		enable_dpa_fifo		: STRING;
		enable_dpa_initial_phase_selection		: STRING;
		enable_dpa_mode		: STRING;
		enable_dpa_pll_calibration		: STRING;
		enable_soft_cdr_mode		: STRING;
		implement_in_les		: STRING;
		inclock_boost		: NATURAL;
		inclock_data_alignment		: STRING;
		inclock_period		: NATURAL;
		inclock_phase_shift		: NATURAL;
		input_data_rate		: NATURAL;
		intended_device_family		: STRING;
		lose_lock_on_one_change		: STRING;
		lpm_hint		: STRING;
		lpm_type		: STRING;
		number_of_channels		: NATURAL;
		outclock_resource		: STRING;
		pll_operation_mode		: STRING;
		pll_self_reset_on_loss_lock		: STRING;
		port_rx_channel_data_align		: STRING;
		port_rx_data_align		: STRING;
		refclk_frequency		: STRING;
		registered_data_align_input		: STRING;
		registered_output		: STRING;
		reset_fifo_at_first_lock		: STRING;
		rx_align_data_reg		: STRING;
		sim_dpa_is_negative_ppm_drift		: STRING;
		sim_dpa_net_ppm_variation		: NATURAL;
		sim_dpa_output_clock_phase_shift		: NATURAL;
		use_coreclock_input		: STRING;
		use_dpll_rawperror		: STRING;
		use_external_pll		: STRING;
		use_no_phase_shift		: STRING;
		x_on_bitslip		: STRING;
		clk_src_is_pll		: STRING
	);
	PORT (
			rx_in	: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
			rx_out	: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	rx_out    <= sub_wire0(0 DOWNTO 0);

	ALTLVDS_RX_component : ALTLVDS_RX
	GENERIC MAP (
		buffer_implementation => "RAM",
		cds_mode => "UNUSED",
		common_rx_tx_pll => "OFF",
		data_align_rollover => 4,
		data_rate => "800.0 Mbps",
		deserialization_factor => 1,
		dpa_initial_phase_value => 0,
		dpll_lock_count => 0,
		dpll_lock_window => 0,
		enable_clock_pin_mode => "UNUSED",
		enable_dpa_align_to_rising_edge_only => "OFF",
		enable_dpa_calibration => "ON",
		enable_dpa_fifo => "UNUSED",
		enable_dpa_initial_phase_selection => "OFF",
		enable_dpa_mode => "OFF",
		enable_dpa_pll_calibration => "OFF",
		enable_soft_cdr_mode => "OFF",
		implement_in_les => "OFF",
		inclock_boost => 0,
		inclock_data_alignment => "EDGE_ALIGNED",
		inclock_period => 5000,
		inclock_phase_shift => 0,
		input_data_rate => 800,
		intended_device_family => "Stratix IV",
		lose_lock_on_one_change => "UNUSED",
		lpm_hint => "CBX_MODULE_PREFIX=RX_LVDS",
		lpm_type => "altlvds_rx",
		number_of_channels => 1,
		outclock_resource => "AUTO",
		pll_operation_mode => "UNUSED",
		pll_self_reset_on_loss_lock => "UNUSED",
		port_rx_channel_data_align => "PORT_UNUSED",
		port_rx_data_align => "PORT_UNUSED",
		refclk_frequency => "UNUSED",
		registered_data_align_input => "UNUSED",
		registered_output => "OFF",
		reset_fifo_at_first_lock => "UNUSED",
		rx_align_data_reg => "UNUSED",
		sim_dpa_is_negative_ppm_drift => "OFF",
		sim_dpa_net_ppm_variation => 0,
		sim_dpa_output_clock_phase_shift => 0,
		use_coreclock_input => "OFF",
		use_dpll_rawperror => "OFF",
		use_external_pll => "OFF",
		use_no_phase_shift => "ON",
		x_on_bitslip => "ON",
		clk_src_is_pll => "off"
	)
	PORT MAP (
		rx_in => rx_in,
		rx_out => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: PRIVATE: Bitslip NUMERIC "4"
-- Retrieval info: PRIVATE: Clock_Choices STRING "tx_coreclock"
-- Retrieval info: PRIVATE: Clock_Mode NUMERIC "0"
-- Retrieval info: PRIVATE: Data_rate STRING "800.0"
-- Retrieval info: PRIVATE: Deser_Factor NUMERIC "1"
-- Retrieval info: PRIVATE: Dpll_Lock_Count NUMERIC "0"
-- Retrieval info: PRIVATE: Dpll_Lock_Window NUMERIC "0"
-- Retrieval info: PRIVATE: Enable_DPA_Mode STRING "OFF"
-- Retrieval info: PRIVATE: Enable_FIFO_DPA_Channels NUMERIC "0"
-- Retrieval info: PRIVATE: Ext_PLL STRING "OFF"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix IV"
-- Retrieval info: PRIVATE: Le_Serdes STRING "OFF"
-- Retrieval info: PRIVATE: Num_Channel NUMERIC "1"
-- Retrieval info: PRIVATE: Outclock_Divide_By NUMERIC "0"
-- Retrieval info: PRIVATE: pCNX_OUTCLK_ALIGN NUMERIC "0"
-- Retrieval info: PRIVATE: pINCLOCK_PHASE_SHIFT STRING "0.00"
-- Retrieval info: PRIVATE: PLL_Enable NUMERIC "0"
-- Retrieval info: PRIVATE: PLL_Freq STRING "100.00"
-- Retrieval info: PRIVATE: PLL_Period NUMERIC "5"
-- Retrieval info: PRIVATE: pOUTCLOCK_PHASE_SHIFT NUMERIC "0"
-- Retrieval info: PRIVATE: Reg_InOut NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Cda_Reset NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Clock_Resc STRING "AUTO"
-- Retrieval info: PRIVATE: Use_Common_Rx_Tx_Plls NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Data_Align NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Lock NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Pll_Areset NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Rawperror NUMERIC "0"
-- Retrieval info: PRIVATE: Use_Tx_Out_Phase NUMERIC "0"
-- Retrieval info: CONSTANT: BUFFER_IMPLEMENTATION STRING "RAM"
-- Retrieval info: CONSTANT: CDS_MODE STRING "UNUSED"
-- Retrieval info: CONSTANT: COMMON_RX_TX_PLL STRING "OFF"
-- Retrieval info: CONSTANT: clk_src_is_pll STRING "off"
-- Retrieval info: CONSTANT: DATA_ALIGN_ROLLOVER NUMERIC "4"
-- Retrieval info: CONSTANT: DATA_RATE STRING "800.0 Mbps"
-- Retrieval info: CONSTANT: DESERIALIZATION_FACTOR NUMERIC "1"
-- Retrieval info: CONSTANT: DPA_INITIAL_PHASE_VALUE NUMERIC "0"
-- Retrieval info: CONSTANT: DPLL_LOCK_COUNT NUMERIC "0"
-- Retrieval info: CONSTANT: DPLL_LOCK_WINDOW NUMERIC "0"
-- Retrieval info: CONSTANT: ENABLE_CLOCK_PIN_MODE STRING "UNUSED"
-- Retrieval info: CONSTANT: ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY STRING "OFF"
-- Retrieval info: CONSTANT: ENABLE_DPA_CALIBRATION STRING "ON"
-- Retrieval info: CONSTANT: ENABLE_DPA_FIFO STRING "UNUSED"
-- Retrieval info: CONSTANT: ENABLE_DPA_INITIAL_PHASE_SELECTION STRING "OFF"
-- Retrieval info: CONSTANT: ENABLE_DPA_MODE STRING "OFF"
-- Retrieval info: CONSTANT: ENABLE_DPA_PLL_CALIBRATION STRING "OFF"
-- Retrieval info: CONSTANT: ENABLE_SOFT_CDR_MODE STRING "OFF"
-- Retrieval info: CONSTANT: IMPLEMENT_IN_LES STRING "OFF"
-- Retrieval info: CONSTANT: INCLOCK_BOOST NUMERIC "0"
-- Retrieval info: CONSTANT: INCLOCK_DATA_ALIGNMENT STRING "EDGE_ALIGNED"
-- Retrieval info: CONSTANT: INCLOCK_PERIOD NUMERIC "5000"
-- Retrieval info: CONSTANT: INCLOCK_PHASE_SHIFT NUMERIC "0"
-- Retrieval info: CONSTANT: INPUT_DATA_RATE NUMERIC "800"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix IV"
-- Retrieval info: CONSTANT: LOSE_LOCK_ON_ONE_CHANGE STRING "UNUSED"
-- Retrieval info: CONSTANT: LPM_HINT STRING "UNUSED"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altlvds_rx"
-- Retrieval info: CONSTANT: NUMBER_OF_CHANNELS NUMERIC "1"
-- Retrieval info: CONSTANT: OUTCLOCK_RESOURCE STRING "AUTO"
-- Retrieval info: CONSTANT: PLL_OPERATION_MODE STRING "UNUSED"
-- Retrieval info: CONSTANT: PLL_SELF_RESET_ON_LOSS_LOCK STRING "UNUSED"
-- Retrieval info: CONSTANT: PORT_RX_CHANNEL_DATA_ALIGN STRING "PORT_UNUSED"
-- Retrieval info: CONSTANT: PORT_RX_DATA_ALIGN STRING "PORT_UNUSED"
-- Retrieval info: CONSTANT: REFCLK_FREQUENCY STRING "UNUSED"
-- Retrieval info: CONSTANT: REGISTERED_DATA_ALIGN_INPUT STRING "UNUSED"
-- Retrieval info: CONSTANT: REGISTERED_OUTPUT STRING "OFF"
-- Retrieval info: CONSTANT: RESET_FIFO_AT_FIRST_LOCK STRING "UNUSED"
-- Retrieval info: CONSTANT: RX_ALIGN_DATA_REG STRING "UNUSED"
-- Retrieval info: CONSTANT: SIM_DPA_IS_NEGATIVE_PPM_DRIFT STRING "OFF"
-- Retrieval info: CONSTANT: SIM_DPA_NET_PPM_VARIATION NUMERIC "0"
-- Retrieval info: CONSTANT: SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT NUMERIC "0"
-- Retrieval info: CONSTANT: USE_CORECLOCK_INPUT STRING "OFF"
-- Retrieval info: CONSTANT: USE_DPLL_RAWPERROR STRING "OFF"
-- Retrieval info: CONSTANT: USE_EXTERNAL_PLL STRING "OFF"
-- Retrieval info: CONSTANT: USE_NO_PHASE_SHIFT STRING "ON"
-- Retrieval info: CONSTANT: X_ON_BITSLIP STRING "ON"
-- Retrieval info: USED_PORT: rx_in 0 0 1 0 INPUT NODEFVAL "rx_in[0..0]"
-- Retrieval info: CONNECT: @rx_in 0 0 1 0 rx_in 0 0 1 0
-- Retrieval info: USED_PORT: rx_out 0 0 1 0 OUTPUT NODEFVAL "rx_out[0..0]"
-- Retrieval info: CONNECT: rx_out 0 0 1 0 @rx_out 0 0 1 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS.vhd TRUE FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS.qip TRUE FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS.bsf TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS_inst.vhd TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS.inc TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS.cmp TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RX_LVDS.ppf TRUE FALSE
-- Retrieval info: CBX_MODULE_PREFIX: ON