# TCL File Generated by Component Editor 16.1
# Tue Nov 27 16:37:25 BRST 2018
# DO NOT MODIFY


# 
# Sync "Sync" v1.1
# Franca/Cassio 2018.11.27.16:37:25
# Synchronism module - Plato Simucam - R0
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Sync
# 
set_module_property DESCRIPTION "Synchronism module - Plato Simucam - R0"
set_module_property NAME Sync
set_module_property VERSION 1.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR Franca/Cassio
set_module_property DISPLAY_NAME Sync
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sync_ent
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file sync_topfile.vhd VHDL PATH sync/sync_topfile.vhd TOP_LEVEL_FILE
add_fileset_file sync_mm_registers_pkg.vhd VHDL PATH sync/registers/sync_mm_registers_pkg.vhd
add_fileset_file sync_outen.vhd VHDL PATH sync/outen/sync_outen.vhd
add_fileset_file sync_outen_pkg.vhd VHDL PATH sync/outen/sync_outen_pkg.vhd
add_fileset_file sync_int.vhd VHDL PATH sync/int/sync_int.vhd
add_fileset_file sync_int_pkg.vhd VHDL PATH sync/int/sync_int_pkg.vhd
add_fileset_file sync_gen.vhd VHDL PATH sync/gen/sync_gen.vhd
add_fileset_file sync_gen_pkg.vhd VHDL PATH sync/gen/sync_gen_pkg.vhd
add_fileset_file sync_common_pkg.vhd VHDL PATH sync/common/sync_common_pkg.vhd
add_fileset_file sync_avalon_mm_pkg.vhd VHDL PATH sync/avalon/sync_avalon_mm_pkg.vhd
add_fileset_file sync_avalon_mm_read.vhd VHDL PATH sync/avalon/sync_avalon_mm_read.vhd
add_fileset_file sync_avalon_mm_write.vhd VHDL PATH sync/avalon/sync_avalon_mm_write.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL sync_ent
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file sync_topfile.vhd VHDL PATH sync/sync_topfile.vhd
add_fileset_file sync_mm_registers_pkg.vhd VHDL PATH sync/registers/sync_mm_registers_pkg.vhd
add_fileset_file sync_outen.vhd VHDL PATH sync/outen/sync_outen.vhd
add_fileset_file sync_outen_pkg.vhd VHDL PATH sync/outen/sync_outen_pkg.vhd
add_fileset_file sync_int.vhd VHDL PATH sync/int/sync_int.vhd
add_fileset_file sync_int_pkg.vhd VHDL PATH sync/int/sync_int_pkg.vhd
add_fileset_file sync_gen.vhd VHDL PATH sync/gen/sync_gen.vhd
add_fileset_file sync_gen_pkg.vhd VHDL PATH sync/gen/sync_gen_pkg.vhd
add_fileset_file sync_common_pkg.vhd VHDL PATH sync/common/sync_common_pkg.vhd
add_fileset_file sync_avalon_mm_pkg.vhd VHDL PATH sync/avalon/sync_avalon_mm_pkg.vhd
add_fileset_file sync_avalon_mm_read.vhd VHDL PATH sync/avalon/sync_avalon_mm_read.vhd
add_fileset_file sync_avalon_mm_write.vhd VHDL PATH sync/avalon/sync_avalon_mm_write.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 50000000
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock_sink_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_sink_reset reset Input 1


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint avalon_mm_slave
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset reset
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender interrupt_sender_irq irq Output 1


# 
# connection point avalon_mm_slave
# 
add_interface avalon_mm_slave avalon end
set_interface_property avalon_mm_slave addressUnits WORDS
set_interface_property avalon_mm_slave associatedClock clock
set_interface_property avalon_mm_slave associatedReset reset
set_interface_property avalon_mm_slave bitsPerSymbol 8
set_interface_property avalon_mm_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_slave burstcountUnits WORDS
set_interface_property avalon_mm_slave explicitAddressSpan 0
set_interface_property avalon_mm_slave holdTime 0
set_interface_property avalon_mm_slave linewrapBursts false
set_interface_property avalon_mm_slave maximumPendingReadTransactions 0
set_interface_property avalon_mm_slave maximumPendingWriteTransactions 0
set_interface_property avalon_mm_slave readLatency 0
set_interface_property avalon_mm_slave readWaitTime 1
set_interface_property avalon_mm_slave setupTime 0
set_interface_property avalon_mm_slave timingUnits Cycles
set_interface_property avalon_mm_slave writeWaitTime 0
set_interface_property avalon_mm_slave ENABLED true
set_interface_property avalon_mm_slave EXPORT_OF ""
set_interface_property avalon_mm_slave PORT_NAME_MAP ""
set_interface_property avalon_mm_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_slave avalon_slave_address address Input 8
add_interface_port avalon_mm_slave avalon_slave_read read Input 1
add_interface_port avalon_mm_slave avalon_slave_write write Input 1
add_interface_port avalon_mm_slave avalon_slave_writedata writedata Input 32
add_interface_port avalon_mm_slave avalon_slave_readdata readdata Output 32
add_interface_port avalon_mm_slave avalon_slave_waitrequest waitrequest Output 1
set_interface_assignment avalon_mm_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point sync_in
# 
add_interface sync_in conduit end
set_interface_property sync_in associatedClock clock
set_interface_property sync_in associatedReset ""
set_interface_property sync_in ENABLED true
set_interface_property sync_in EXPORT_OF ""
set_interface_property sync_in PORT_NAME_MAP ""
set_interface_property sync_in CMSIS_SVD_VARIABLES ""
set_interface_property sync_in SVD_ADDRESS_GROUP ""

add_interface_port sync_in conduit_sync_signal_syncin conduit Input 1


# 
# connection point sync_spwa
# 
add_interface sync_spwa conduit end
set_interface_property sync_spwa associatedClock clock
set_interface_property sync_spwa associatedReset ""
set_interface_property sync_spwa ENABLED true
set_interface_property sync_spwa EXPORT_OF ""
set_interface_property sync_spwa PORT_NAME_MAP ""
set_interface_property sync_spwa CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwa SVD_ADDRESS_GROUP ""

add_interface_port sync_spwa conduit_sync_signal_spwa conduit Output 1


# 
# connection point sync_spwb
# 
add_interface sync_spwb conduit end
set_interface_property sync_spwb associatedClock clock
set_interface_property sync_spwb associatedReset ""
set_interface_property sync_spwb ENABLED true
set_interface_property sync_spwb EXPORT_OF ""
set_interface_property sync_spwb PORT_NAME_MAP ""
set_interface_property sync_spwb CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwb SVD_ADDRESS_GROUP ""

add_interface_port sync_spwb conduit_sync_signal_spwb conduit Output 1


# 
# connection point sync_spwc
# 
add_interface sync_spwc conduit end
set_interface_property sync_spwc associatedClock clock
set_interface_property sync_spwc associatedReset ""
set_interface_property sync_spwc ENABLED true
set_interface_property sync_spwc EXPORT_OF ""
set_interface_property sync_spwc PORT_NAME_MAP ""
set_interface_property sync_spwc CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwc SVD_ADDRESS_GROUP ""

add_interface_port sync_spwc conduit_sync_signal_spwc conduit Output 1


# 
# connection point sync_spwd
# 
add_interface sync_spwd conduit end
set_interface_property sync_spwd associatedClock clock
set_interface_property sync_spwd associatedReset ""
set_interface_property sync_spwd ENABLED true
set_interface_property sync_spwd EXPORT_OF ""
set_interface_property sync_spwd PORT_NAME_MAP ""
set_interface_property sync_spwd CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwd SVD_ADDRESS_GROUP ""

add_interface_port sync_spwd conduit_sync_signal_spwd conduit Output 1


# 
# connection point sync_spwe
# 
add_interface sync_spwe conduit end
set_interface_property sync_spwe associatedClock clock
set_interface_property sync_spwe associatedReset ""
set_interface_property sync_spwe ENABLED true
set_interface_property sync_spwe EXPORT_OF ""
set_interface_property sync_spwe PORT_NAME_MAP ""
set_interface_property sync_spwe CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwe SVD_ADDRESS_GROUP ""

add_interface_port sync_spwe conduit_sync_signal_spwe conduit Output 1


# 
# connection point sync_spwf
# 
add_interface sync_spwf conduit end
set_interface_property sync_spwf associatedClock clock
set_interface_property sync_spwf associatedReset ""
set_interface_property sync_spwf ENABLED true
set_interface_property sync_spwf EXPORT_OF ""
set_interface_property sync_spwf PORT_NAME_MAP ""
set_interface_property sync_spwf CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwf SVD_ADDRESS_GROUP ""

add_interface_port sync_spwf conduit_sync_signal_spwf conduit Output 1


# 
# connection point sync_spwg
# 
add_interface sync_spwg conduit end
set_interface_property sync_spwg associatedClock clock
set_interface_property sync_spwg associatedReset ""
set_interface_property sync_spwg ENABLED true
set_interface_property sync_spwg EXPORT_OF ""
set_interface_property sync_spwg PORT_NAME_MAP ""
set_interface_property sync_spwg CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwg SVD_ADDRESS_GROUP ""

add_interface_port sync_spwg conduit_sync_signal_spwg conduit Output 1


# 
# connection point sync_spwh
# 
add_interface sync_spwh conduit end
set_interface_property sync_spwh associatedClock clock
set_interface_property sync_spwh associatedReset ""
set_interface_property sync_spwh ENABLED true
set_interface_property sync_spwh EXPORT_OF ""
set_interface_property sync_spwh PORT_NAME_MAP ""
set_interface_property sync_spwh CMSIS_SVD_VARIABLES ""
set_interface_property sync_spwh SVD_ADDRESS_GROUP ""

add_interface_port sync_spwh conduit_sync_signal_spwh conduit Output 1


# 
# connection point sync_out
# 
add_interface sync_out conduit end
set_interface_property sync_out associatedClock clock
set_interface_property sync_out associatedReset ""
set_interface_property sync_out ENABLED true
set_interface_property sync_out EXPORT_OF ""
set_interface_property sync_out PORT_NAME_MAP ""
set_interface_property sync_out CMSIS_SVD_VARIABLES ""
set_interface_property sync_out SVD_ADDRESS_GROUP ""

add_interface_port sync_out conduit_sync_signal_syncout conduit Output 1
