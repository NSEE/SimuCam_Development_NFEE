# TCL File Generated by Component Editor 18.1
# Fri Mar 27 03:47:42 BRT 2020
# DO NOT MODIFY


# 
# SpaceWire_Glutton "SpaceWire_Glutton" v1.2
#  2020.03.27.03:47:42
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module SpaceWire_Glutton
# 
set_module_property DESCRIPTION ""
set_module_property NAME SpaceWire_Glutton
set_module_property VERSION 1.2
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME SpaceWire_Glutton
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL spwg_spw_glutton_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file spwg_spw_glutton_top.vhd VHDL PATH SpaceWire_Glutton/spwg_spw_glutton_top.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL spwg_spw_glutton_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file spwg_spw_glutton_top.vhd VHDL PATH SpaceWire_Glutton/spwg_spw_glutton_top.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink_100mhz
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink reset_i reset Input 1


# 
# connection point clock_sink_100mhz
# 
add_interface clock_sink_100mhz clock end
set_interface_property clock_sink_100mhz clockRate 100000000
set_interface_property clock_sink_100mhz ENABLED true
set_interface_property clock_sink_100mhz EXPORT_OF ""
set_interface_property clock_sink_100mhz PORT_NAME_MAP ""
set_interface_property clock_sink_100mhz CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_100mhz SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_100mhz clk_100_i clk Input 1


# 
# connection point conduit_end_spacewire_controller
# 
add_interface conduit_end_spacewire_controller conduit end
set_interface_property conduit_end_spacewire_controller associatedClock clock_sink_100mhz
set_interface_property conduit_end_spacewire_controller associatedReset reset_sink
set_interface_property conduit_end_spacewire_controller ENABLED true
set_interface_property conduit_end_spacewire_controller EXPORT_OF ""
set_interface_property conduit_end_spacewire_controller PORT_NAME_MAP ""
set_interface_property conduit_end_spacewire_controller CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_spacewire_controller SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_spacewire_controller spw_link_status_started_i spw_link_status_started_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_status_connecting_i spw_link_status_connecting_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_status_running_i spw_link_status_running_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_errdisc_i spw_link_error_errdisc_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_errpar_i spw_link_error_errpar_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_erresc_i spw_link_error_erresc_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_errcred_i spw_link_error_errcred_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_timecode_rx_tick_out_i spw_timecode_rx_tick_out_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_timecode_rx_ctrl_out_i spw_timecode_rx_ctrl_out_signal Input 2
add_interface_port conduit_end_spacewire_controller spw_timecode_rx_time_out_i spw_timecode_rx_time_out_signal Input 6
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxvalid_i spw_data_rx_status_rxvalid_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxhalff_i spw_data_rx_status_rxhalff_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxflag_i spw_data_rx_status_rxflag_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxdata_i spw_data_rx_status_rxdata_signal Input 8
add_interface_port conduit_end_spacewire_controller spw_data_tx_status_txrdy_i spw_data_tx_status_txrdy_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_status_txhalff_i spw_data_tx_status_txhalff_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_errinj_ctrl_errinj_busy_i spw_errinj_ctrl_errinj_busy_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_errinj_ctrl_errinj_ready_i spw_errinj_ctrl_errinj_ready_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_command_enable_o spw_link_command_enable_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_autostart_o spw_link_command_autostart_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_linkstart_o spw_link_command_linkstart_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_linkdis_o spw_link_command_linkdis_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_txdivcnt_o spw_link_command_txdivcnt_signal Output 8
add_interface_port conduit_end_spacewire_controller spw_timecode_tx_tick_in_o spw_timecode_tx_tick_in_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_timecode_tx_ctrl_in_o spw_timecode_tx_ctrl_in_signal Output 2
add_interface_port conduit_end_spacewire_controller spw_timecode_tx_time_in_o spw_timecode_tx_time_in_signal Output 6
add_interface_port conduit_end_spacewire_controller spw_data_rx_command_rxread_o spw_data_rx_command_rxread_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_command_txwrite_o spw_data_tx_command_txwrite_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_command_txflag_o spw_data_tx_command_txflag_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_command_txdata_o spw_data_tx_command_txdata_signal Output 8
add_interface_port conduit_end_spacewire_controller spw_errinj_ctrl_start_errinj_o spw_errinj_ctrl_start_errinj_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_errinj_ctrl_reset_errinj_o spw_errinj_ctrl_reset_errinj_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_errinj_ctrl_errinj_code_o spw_errinj_ctrl_errinj_code_signal Output 4

