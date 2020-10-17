# TCL File Generated by Component Editor 18.1
# Wed Aug 07 15:22:07 BRT 2019
# DO NOT MODIFY


# 
# AvsTap64 "AvsTap64" v1.0
#  2019.08.07.15:22:07
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module AvsTap64
# 
set_module_property DESCRIPTION ""
set_module_property NAME AvsTap64
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME AvsTap64
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avstap64_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avalon_mm_32_pkg.vhd VHDL PATH AvsTap64/AVALON_32/avalon_mm_32_pkg.vhd
add_fileset_file avalon_mm_32_registers_pkg.vhd VHDL PATH AvsTap64/REGISTERS/avalon_mm_32_registers_pkg.vhd
add_fileset_file avalon_mm_32_read_ent.vhd VHDL PATH AvsTap64/AVALON_32/avalon_mm_32_read_ent.vhd
add_fileset_file avalon_mm_32_write_ent.vhd VHDL PATH AvsTap64/AVALON_32/avalon_mm_32_write_ent.vhd
add_fileset_file avalon_mm_64_pkg.vhd VHDL PATH AvsTap64/AVALON_64/avalon_mm_64_pkg.vhd
add_fileset_file avalon_mm_64_write_ent.vhd VHDL PATH AvsTap64/AVALON_64/avalon_mm_64_write_ent.vhd
add_fileset_file avstap64_top.vhd VHDL PATH AvsTap64/avstap64_top.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL avstap64_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avalon_mm_32_pkg.vhd VHDL PATH AvsTap64/AVALON_32/avalon_mm_32_pkg.vhd
add_fileset_file avalon_mm_32_registers_pkg.vhd VHDL PATH AvsTap64/REGISTERS/avalon_mm_32_registers_pkg.vhd
add_fileset_file avalon_mm_32_read_ent.vhd VHDL PATH AvsTap64/AVALON_32/avalon_mm_32_read_ent.vhd
add_fileset_file avalon_mm_32_write_ent.vhd VHDL PATH AvsTap64/AVALON_32/avalon_mm_32_write_ent.vhd
add_fileset_file avalon_mm_64_pkg.vhd VHDL PATH AvsTap64/AVALON_64/avalon_mm_64_pkg.vhd
add_fileset_file avalon_mm_64_write_ent.vhd VHDL PATH AvsTap64/AVALON_64/avalon_mm_64_write_ent.vhd
add_fileset_file avstap64_top.vhd VHDL PATH AvsTap64/avstap64_top.vhd TOP_LEVEL_FILE


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
set_interface_property reset_sink associatedClock clock_sink_100
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink reset_sink_reset reset Input 1


# 
# connection point clock_sink_100
# 
add_interface clock_sink_100 clock end
set_interface_property clock_sink_100 clockRate 100000000
set_interface_property clock_sink_100 ENABLED true
set_interface_property clock_sink_100 EXPORT_OF ""
set_interface_property clock_sink_100 PORT_NAME_MAP ""
set_interface_property clock_sink_100 CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_100 SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_100 clock_sink_100_clk clk Input 1


# 
# connection point avalon_slave_64
# 
add_interface avalon_slave_64 avalon end
set_interface_property avalon_slave_64 addressUnits WORDS
set_interface_property avalon_slave_64 associatedClock clock_sink_100
set_interface_property avalon_slave_64 associatedReset reset_sink
set_interface_property avalon_slave_64 bitsPerSymbol 8
set_interface_property avalon_slave_64 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_64 burstcountUnits WORDS
set_interface_property avalon_slave_64 explicitAddressSpan 0
set_interface_property avalon_slave_64 holdTime 0
set_interface_property avalon_slave_64 linewrapBursts false
set_interface_property avalon_slave_64 maximumPendingReadTransactions 0
set_interface_property avalon_slave_64 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_64 readLatency 0
set_interface_property avalon_slave_64 readWaitTime 1
set_interface_property avalon_slave_64 setupTime 0
set_interface_property avalon_slave_64 timingUnits Cycles
set_interface_property avalon_slave_64 writeWaitTime 0
set_interface_property avalon_slave_64 ENABLED true
set_interface_property avalon_slave_64 EXPORT_OF ""
set_interface_property avalon_slave_64 PORT_NAME_MAP ""
set_interface_property avalon_slave_64 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_64 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_64 avalon_slave_64_address address Input 11
add_interface_port avalon_slave_64 avalon_slave_64_write write Input 1
add_interface_port avalon_slave_64 avalon_slave_64_writedata writedata Input 64
add_interface_port avalon_slave_64 avalon_slave_64_waitrequest waitrequest Output 1
set_interface_assignment avalon_slave_64 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_64 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_64 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_64 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_slave_32
# 
add_interface avalon_slave_32 avalon end
set_interface_property avalon_slave_32 addressUnits WORDS
set_interface_property avalon_slave_32 associatedClock clock_sink_100
set_interface_property avalon_slave_32 associatedReset reset_sink
set_interface_property avalon_slave_32 bitsPerSymbol 8
set_interface_property avalon_slave_32 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_32 burstcountUnits WORDS
set_interface_property avalon_slave_32 explicitAddressSpan 0
set_interface_property avalon_slave_32 holdTime 0
set_interface_property avalon_slave_32 linewrapBursts false
set_interface_property avalon_slave_32 maximumPendingReadTransactions 0
set_interface_property avalon_slave_32 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_32 readLatency 0
set_interface_property avalon_slave_32 readWaitTime 1
set_interface_property avalon_slave_32 setupTime 0
set_interface_property avalon_slave_32 timingUnits Cycles
set_interface_property avalon_slave_32 writeWaitTime 0
set_interface_property avalon_slave_32 ENABLED true
set_interface_property avalon_slave_32 EXPORT_OF ""
set_interface_property avalon_slave_32 PORT_NAME_MAP ""
set_interface_property avalon_slave_32 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_32 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_32 avalon_slave_32_address address Input 12
add_interface_port avalon_slave_32 avalon_slave_32_write write Input 1
add_interface_port avalon_slave_32 avalon_slave_32_read read Input 1
add_interface_port avalon_slave_32 avalon_slave_32_readdata readdata Output 32
add_interface_port avalon_slave_32 avalon_slave_32_writedata writedata Input 32
add_interface_port avalon_slave_32 avalon_slave_32_waitrequest waitrequest Output 1
set_interface_assignment avalon_slave_32 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_32 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_32 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_32 embeddedsw.configuration.isPrintableDevice 0
