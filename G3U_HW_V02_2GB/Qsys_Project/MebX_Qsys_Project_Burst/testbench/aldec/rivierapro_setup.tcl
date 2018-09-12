
# (C) 2001-2018 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 16.1 196 win32 2018.09.12.11:35:09
# ----------------------------------------
# Auto-generated simulation script rivierapro_setup.tcl
# ----------------------------------------
# This script provides commands to simulate the following IP detected in
# your Quartus project:
#     MebX_Qsys_Project_Burst_tb
# 
# Altera recommends that you source this Quartus-generated IP simulation
# script from your own customized top-level script, and avoid editing this
# generated script.
# 
# To write a top-level script that compiles Altera simulation libraries and
# the Quartus-generated IP in your project, along with your design and
# testbench files, copy the text from the TOP-LEVEL TEMPLATE section below
# into a new file, e.g. named "aldec.do", and modify the text as directed.
# 
# ----------------------------------------
# # TOP-LEVEL TEMPLATE - BEGIN
# #
# # QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# # construct paths to the files required to simulate the IP in your Quartus
# # project. By default, the IP script assumes that you are launching the
# # simulator from the IP script location. If launching from another
# # location, set QSYS_SIMDIR to the output directory you specified when you
# # generated the IP script, relative to the directory from which you launch
# # the simulator.
# #
# set QSYS_SIMDIR <script generation output directory>
# #
# # Source the generated IP simulation script.
# source $QSYS_SIMDIR/aldec/rivierapro_setup.tcl
# #
# # Set any compilation options you require (this is unusual).
# set USER_DEFINED_COMPILE_OPTIONS <compilation options>
# #
# # Call command to compile the Quartus EDA simulation library.
# dev_com
# #
# # Call command to compile the Quartus-generated IP simulation files.
# com
# #
# # Add commands to compile all design files and testbench files, including
# # the top level. (These are all the files required for simulation other
# # than the files compiled by the Quartus-generated IP simulation script)
# #
# vlog -sv2k5 <your compilation options> <design and testbench files>
# #
# # Set the top-level simulation or testbench module/entity name, which is
# # used by the elab command to elaborate the top level.
# #
# set TOP_LEVEL_NAME <simulation top>
# #
# # Set any elaboration options you require.
# set USER_DEFINED_ELAB_OPTIONS <elaboration options>
# #
# # Call command to elaborate your design and testbench.
# elab
# #
# # Run the simulation.
# run
# #
# # Report success to the shell.
# exit -code 0
# #
# # TOP-LEVEL TEMPLATE - END
# ----------------------------------------
# 
# IP SIMULATION SCRIPT
# ----------------------------------------
# If MebX_Qsys_Project_Burst_tb is one of several IP cores in your
# Quartus project, you can generate a simulation script
# suitable for inclusion in your top-level simulation
# script by running the following command line:
# 
# ip-setup-simulation --quartus-project=<quartus project>
# 
# ip-setup-simulation will discover the Altera IP
# within the Quartus project, and generate a unified
# script which supports all the Altera IP within the design.
# ----------------------------------------

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "MebX_Qsys_Project_Burst_tb"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/intelfpga/16.1/quartus/"
}

if ![info exists USER_DEFINED_COMPILE_OPTIONS] { 
  set USER_DEFINED_COMPILE_OPTIONS ""
}
if ![info exists USER_DEFINED_ELAB_OPTIONS] { 
  set USER_DEFINED_ELAB_OPTIONS ""
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_bht_ram.dat ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_bht_ram.hex ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_bht_ram.mif ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ic_tag_ram.dat ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ic_tag_ram.hex ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ic_tag_ram.mif ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ociram_default_contents.dat ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ociram_default_contents.hex ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ociram_default_contents.mif ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_a.dat ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_a.hex ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_a.mif ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_b.dat ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_b.hex ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_b.mif ./
  file copy -force $QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_descriptor_memory.hex ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                        ./libraries/altera_ver            
vmap       altera_ver             ./libraries/altera_ver            
ensure_lib                        ./libraries/lpm_ver               
vmap       lpm_ver                ./libraries/lpm_ver               
ensure_lib                        ./libraries/sgate_ver             
vmap       sgate_ver              ./libraries/sgate_ver             
ensure_lib                        ./libraries/altera_mf_ver         
vmap       altera_mf_ver          ./libraries/altera_mf_ver         
ensure_lib                        ./libraries/altera_lnsim_ver      
vmap       altera_lnsim_ver       ./libraries/altera_lnsim_ver      
ensure_lib                        ./libraries/stratixiv_hssi_ver    
vmap       stratixiv_hssi_ver     ./libraries/stratixiv_hssi_ver    
ensure_lib                        ./libraries/stratixiv_pcie_hip_ver
vmap       stratixiv_pcie_hip_ver ./libraries/stratixiv_pcie_hip_ver
ensure_lib                        ./libraries/stratixiv_ver         
vmap       stratixiv_ver          ./libraries/stratixiv_ver         
ensure_lib                        ./libraries/altera                
vmap       altera                 ./libraries/altera                
ensure_lib                        ./libraries/lpm                   
vmap       lpm                    ./libraries/lpm                   
ensure_lib                        ./libraries/sgate                 
vmap       sgate                  ./libraries/sgate                 
ensure_lib                        ./libraries/altera_mf             
vmap       altera_mf              ./libraries/altera_mf             
ensure_lib                        ./libraries/altera_lnsim          
vmap       altera_lnsim           ./libraries/altera_lnsim          
ensure_lib                        ./libraries/stratixiv_hssi        
vmap       stratixiv_hssi         ./libraries/stratixiv_hssi        
ensure_lib                        ./libraries/stratixiv_pcie_hip    
vmap       stratixiv_pcie_hip     ./libraries/stratixiv_pcie_hip    
ensure_lib                        ./libraries/stratixiv             
vmap       stratixiv              ./libraries/stratixiv             
ensure_lib                                                          ./libraries/error_adapter_0                                         
vmap       error_adapter_0                                          ./libraries/error_adapter_0                                         
ensure_lib                                                          ./libraries/avalon_st_adapter                                       
vmap       avalon_st_adapter                                        ./libraries/avalon_st_adapter                                       
ensure_lib                                                          ./libraries/rsp_mux_001                                             
vmap       rsp_mux_001                                              ./libraries/rsp_mux_001                                             
ensure_lib                                                          ./libraries/rsp_mux                                                 
vmap       rsp_mux                                                  ./libraries/rsp_mux                                                 
ensure_lib                                                          ./libraries/rsp_demux                                               
vmap       rsp_demux                                                ./libraries/rsp_demux                                               
ensure_lib                                                          ./libraries/cmd_mux_001                                             
vmap       cmd_mux_001                                              ./libraries/cmd_mux_001                                             
ensure_lib                                                          ./libraries/cmd_mux                                                 
vmap       cmd_mux                                                  ./libraries/cmd_mux                                                 
ensure_lib                                                          ./libraries/cmd_demux_001                                           
vmap       cmd_demux_001                                            ./libraries/cmd_demux_001                                           
ensure_lib                                                          ./libraries/cmd_demux                                               
vmap       cmd_demux                                                ./libraries/cmd_demux                                               
ensure_lib                                                          ./libraries/router_003                                              
vmap       router_003                                               ./libraries/router_003                                              
ensure_lib                                                          ./libraries/router_002                                              
vmap       router_002                                               ./libraries/router_002                                              
ensure_lib                                                          ./libraries/router_001                                              
vmap       router_001                                               ./libraries/router_001                                              
ensure_lib                                                          ./libraries/router                                                  
vmap       router                                                   ./libraries/router                                                  
ensure_lib                                                          ./libraries/avalon_st_adapter_006                                   
vmap       avalon_st_adapter_006                                    ./libraries/avalon_st_adapter_006                                   
ensure_lib                                                          ./libraries/dma_DDR_M_descriptor_slave_cmd_width_adapter            
vmap       dma_DDR_M_descriptor_slave_cmd_width_adapter             ./libraries/dma_DDR_M_descriptor_slave_cmd_width_adapter            
ensure_lib                                                          ./libraries/rsp_demux_005                                           
vmap       rsp_demux_005                                            ./libraries/rsp_demux_005                                           
ensure_lib                                                          ./libraries/cmd_mux_005                                             
vmap       cmd_mux_005                                              ./libraries/cmd_mux_005                                             
ensure_lib                                                          ./libraries/nios2_gen2_0_debug_mem_slave_burst_adapter              
vmap       nios2_gen2_0_debug_mem_slave_burst_adapter               ./libraries/nios2_gen2_0_debug_mem_slave_burst_adapter              
ensure_lib                                                          ./libraries/nios2_gen2_0_instruction_master_limiter                 
vmap       nios2_gen2_0_instruction_master_limiter                  ./libraries/nios2_gen2_0_instruction_master_limiter                 
ensure_lib                                                          ./libraries/router_008                                              
vmap       router_008                                               ./libraries/router_008                                              
ensure_lib                                                          ./libraries/router_007                                              
vmap       router_007                                               ./libraries/router_007                                              
ensure_lib                                                          ./libraries/jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo            
vmap       jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo             ./libraries/jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo            
ensure_lib                                                          ./libraries/jtag_uart_0_avalon_jtag_slave_agent                     
vmap       jtag_uart_0_avalon_jtag_slave_agent                      ./libraries/jtag_uart_0_avalon_jtag_slave_agent                     
ensure_lib                                                          ./libraries/nios2_gen2_0_data_master_agent                          
vmap       nios2_gen2_0_data_master_agent                           ./libraries/nios2_gen2_0_data_master_agent                          
ensure_lib                                                          ./libraries/jtag_uart_0_avalon_jtag_slave_translator                
vmap       jtag_uart_0_avalon_jtag_slave_translator                 ./libraries/jtag_uart_0_avalon_jtag_slave_translator                
ensure_lib                                                          ./libraries/nios2_gen2_0_data_master_translator                     
vmap       nios2_gen2_0_data_master_translator                      ./libraries/nios2_gen2_0_data_master_translator                     
ensure_lib                                                          ./libraries/cpu                                                     
vmap       cpu                                                      ./libraries/cpu                                                     
ensure_lib                                                          ./libraries/write_mstr_internal                                     
vmap       write_mstr_internal                                      ./libraries/write_mstr_internal                                     
ensure_lib                                                          ./libraries/read_mstr_internal                                      
vmap       read_mstr_internal                                       ./libraries/read_mstr_internal                                      
ensure_lib                                                          ./libraries/dispatcher_internal                                     
vmap       dispatcher_internal                                      ./libraries/dispatcher_internal                                     
ensure_lib                                                          ./libraries/rst_controller                                          
vmap       rst_controller                                           ./libraries/rst_controller                                          
ensure_lib                                                          ./libraries/irq_synchronizer                                        
vmap       irq_synchronizer                                         ./libraries/irq_synchronizer                                        
ensure_lib                                                          ./libraries/irq_mapper                                              
vmap       irq_mapper                                               ./libraries/irq_mapper                                              
ensure_lib                                                          ./libraries/mm_interconnect_2                                       
vmap       mm_interconnect_2                                        ./libraries/mm_interconnect_2                                       
ensure_lib                                                          ./libraries/mm_interconnect_1                                       
vmap       mm_interconnect_1                                        ./libraries/mm_interconnect_1                                       
ensure_lib                                                          ./libraries/mm_interconnect_0                                       
vmap       mm_interconnect_0                                        ./libraries/mm_interconnect_0                                       
ensure_lib                                                          ./libraries/timer_1us                                               
vmap       timer_1us                                                ./libraries/timer_1us                                               
ensure_lib                                                          ./libraries/timer_1ms                                               
vmap       timer_1ms                                                ./libraries/timer_1ms                                               
ensure_lib                                                          ./libraries/sysid_qsys                                              
vmap       sysid_qsys                                               ./libraries/sysid_qsys                                              
ensure_lib                                                          ./libraries/onchip_memory                                           
vmap       onchip_memory                                            ./libraries/onchip_memory                                           
ensure_lib                                                          ./libraries/nios2_gen2_0                                            
vmap       nios2_gen2_0                                             ./libraries/nios2_gen2_0                                            
ensure_lib                                                          ./libraries/jtag_uart_0                                             
vmap       jtag_uart_0                                              ./libraries/jtag_uart_0                                             
ensure_lib                                                          ./libraries/dma_DDR_M                                               
vmap       dma_DDR_M                                                ./libraries/dma_DDR_M                                               
ensure_lib                                                          ./libraries/descriptor_memory                                       
vmap       descriptor_memory                                        ./libraries/descriptor_memory                                       
ensure_lib                                                          ./libraries/clock_bridge_afi_50                                     
vmap       clock_bridge_afi_50                                      ./libraries/clock_bridge_afi_50                                     
ensure_lib                                                          ./libraries/Pattern_Generator_A                                     
vmap       Pattern_Generator_A                                      ./libraries/Pattern_Generator_A                                     
ensure_lib                                                          ./libraries/Communication_Module_A                                  
vmap       Communication_Module_A                                   ./libraries/Communication_Module_A                                  
ensure_lib                                                          ./libraries/MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm
vmap       MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm ./libraries/MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm
ensure_lib                                                          ./libraries/MebX_Qsys_Project_Burst_inst_rst_bfm                    
vmap       MebX_Qsys_Project_Burst_inst_rst_bfm                     ./libraries/MebX_Qsys_Project_Burst_inst_rst_bfm                    
ensure_lib                                                          ./libraries/MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm     
vmap       MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm      ./libraries/MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm     
ensure_lib                                                          ./libraries/MebX_Qsys_Project_Burst_inst_clk100_bfm                 
vmap       MebX_Qsys_Project_Burst_inst_clk100_bfm                  ./libraries/MebX_Qsys_Project_Burst_inst_clk100_bfm                 
ensure_lib                                                          ./libraries/MebX_Qsys_Project_Burst_inst                            
vmap       MebX_Qsys_Project_Burst_inst                             ./libraries/MebX_Qsys_Project_Burst_inst                            

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  eval vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"               -work altera_ver            
  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                        -work lpm_ver               
  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                           -work sgate_ver             
  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                       -work altera_mf_ver         
  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                   -work altera_lnsim_ver      
  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_atoms.v"            -work stratixiv_hssi_ver    
  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_atoms.v"        -work stratixiv_pcie_hip_ver
  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_atoms.v"                 -work stratixiv_ver         
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"         -work altera                
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"     -work altera                
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"        -work altera                
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"     -work altera                
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"  -work altera                
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"             -work altera                
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                       -work lpm                   
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                      -work lpm                   
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                    -work sgate                 
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                         -work sgate                 
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"          -work altera_mf             
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                     -work altera_mf             
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"       -work altera_lnsim          
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_components.vhd"     -work stratixiv_hssi        
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_atoms.vhd"          -work stratixiv_hssi        
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_components.vhd" -work stratixiv_pcie_hip    
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_atoms.vhd"      -work stratixiv_pcie_hip    
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_atoms.vhd"               -work stratixiv             
  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_components.vhd"          -work stratixiv             
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_avalon_st_adapter_error_adapter_0.sv"     -work error_adapter_0                                         
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter_006_error_adapter_0.sv" -work error_adapter_0                                         
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv"     -work error_adapter_0                                         
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_avalon_st_adapter.vhd"                    -work avalon_st_adapter                                       
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_rsp_mux_001.sv"                           -work rsp_mux_001                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux_001                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_rsp_mux.sv"                               -work rsp_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_rsp_demux.sv"                             -work rsp_demux                                               
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_mux_001.sv"                           -work cmd_mux_001                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux_001                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_mux.sv"                               -work cmd_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_demux_001.sv"                         -work cmd_demux_001                                           
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_demux.sv"                             -work cmd_demux                                               
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router_003.sv"                            -work router_003                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router_002.sv"                            -work router_002                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router_001.sv"                            -work router_001                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router.sv"                                -work router                                                  
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_rsp_mux.sv"                               -work rsp_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_rsp_demux.sv"                             -work rsp_demux                                               
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_cmd_mux.sv"                               -work cmd_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_cmd_demux.sv"                             -work cmd_demux                                               
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_router_001.sv"                            -work router_001                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_router.sv"                                -work router                                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter_006.vhd"                -work avalon_st_adapter_006                                   
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter.vhd"                    -work avalon_st_adapter                                       
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_width_adapter.sv"                                                     -work dma_DDR_M_descriptor_slave_cmd_width_adapter            
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                                 -work dma_DDR_M_descriptor_slave_cmd_width_adapter            
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                                -work dma_DDR_M_descriptor_slave_cmd_width_adapter            
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_mux_001.sv"                           -work rsp_mux_001                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux_001                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_mux.sv"                               -work rsp_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_demux_005.sv"                         -work rsp_demux_005                                           
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_demux.sv"                             -work rsp_demux                                               
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_mux_005.sv"                           -work cmd_mux_005                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux_005                                             
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_mux.sv"                               -work cmd_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux                                                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_demux_001.sv"                         -work cmd_demux_001                                           
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_demux.sv"                             -work cmd_demux                                               
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_burst_adapter.sv"                                                     -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_burst_adapter_uncmpr.sv"                                              -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_burst_adapter_13_1.sv"                                                -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_burst_adapter_new.sv"                                                 -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_incr_burst_converter.sv"                                                     -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_wrap_burst_converter.sv"                                                     -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_default_burst_converter.sv"                                                  -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                                 -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_st_pipeline_stage.sv"                                                 -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_st_pipeline_base.v"                                                   -work nios2_gen2_0_debug_mem_slave_burst_adapter              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_traffic_limiter.sv"                                                   -work nios2_gen2_0_instruction_master_limiter                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_reorder_memory.sv"                                                    -work nios2_gen2_0_instruction_master_limiter                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                            -work nios2_gen2_0_instruction_master_limiter                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_st_pipeline_base.v"                                                   -work nios2_gen2_0_instruction_master_limiter                 
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_008.sv"                            -work router_008                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_007.sv"                            -work router_007                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_002.sv"                            -work router_002                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_001.sv"                            -work router_001                                              
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router.sv"                                -work router                                                  
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                            -work jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo            
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_slave_agent.sv"                                                       -work jtag_uart_0_avalon_jtag_slave_agent                     
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                                -work jtag_uart_0_avalon_jtag_slave_agent                     
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_master_agent.sv"                                                      -work nios2_gen2_0_data_master_agent                          
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_slave_translator.sv"                                                  -work jtag_uart_0_avalon_jtag_slave_translator                
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_merlin_master_translator.sv"                                                 -work nios2_gen2_0_data_master_translator                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu.vo"                                        -work cpu                                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_debug_slave_sysclk.v"                      -work cpu                                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_debug_slave_tck.v"                         -work cpu                                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_debug_slave_wrapper.v"                     -work cpu                                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_mult_cell.v"                               -work cpu                                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_test_bench.v"                              -work cpu                                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/write_master.v"                                                                     -work write_mstr_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/byte_enable_generator.v"                                                            -work write_mstr_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/ST_to_MM_Adapter.v"                                                                 -work write_mstr_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/write_burst_control.v"                                                              -work write_mstr_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/read_master.v"                                                                      -work read_mstr_internal                                      
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MM_to_ST_Adapter.v"                                                                 -work read_mstr_internal                                      
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/read_burst_control.v"                                                               -work read_mstr_internal                                      
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/dispatcher.v"                                                                       -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/descriptor_buffers.v"                                                               -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/csr_block.v"                                                                        -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/response_block.v"                                                                   -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/fifo_with_byteenables.v"                                                            -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/read_signal_breakout.v"                                                             -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/write_signal_breakout.v"                                                            -work dispatcher_internal                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_reset_controller.v"                                                          -work rst_controller                                          
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_reset_synchronizer.v"                                                        -work rst_controller                                          
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_irq_clock_crosser.sv"                                                        -work irq_synchronizer                                        
  eval  vlog  $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_irq_mapper.sv"                                              -work irq_mapper                                              
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2.v"                                        -work mm_interconnect_2                                       
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1.v"                                        -work mm_interconnect_1                                       
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0.v"                                        -work mm_interconnect_0                                       
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_timer_1us.v"                                                -work timer_1us                                               
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_timer_1ms.v"                                                -work timer_1ms                                               
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_sysid_qsys.v"                                               -work sysid_qsys                                              
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_onchip_memory.v"                                            -work onchip_memory                                           
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0.v"                                             -work nios2_gen2_0                                            
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_jtag_uart_0.v"                                              -work jtag_uart_0                                             
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_dma_DDR_M.v"                                                -work dma_DDR_M                                               
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst_descriptor_memory.v"                                        -work descriptor_memory                                       
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_mm_clock_crossing_bridge.v"                                           -work clock_bridge_afi_50                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_dc_fifo.v"                                                            -work clock_bridge_afi_50                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_dcfifo_synchronizer_bundle.v"                                                -work clock_bridge_afi_50                                     
  eval  vlog -v2k5 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_std_synchronizer_nocut.v"                                                    -work clock_bridge_afi_50                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_AVALON_MM_PKG.vhd"                                                             -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_MM_REGISTERS_PKG.vhd"                                                          -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_AVALON_BURST_PKG.vhd"                                                          -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_BURST_REGISTERS_PKG.vhd"                                                       -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_PIPELINE_FIFO_PKG.vhd"                                                         -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_CONTROLLER_PKG.vhd"                                                            -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_PATTERN_PKG.vhd"                                                               -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_DATA_FIFO_PKG.vhd"                                                             -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_AVALON_MM_READ.vhd"                                                            -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_AVALON_MM_WRITE.vhd"                                                           -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/pipeline_sc_fifo.vhd"                                                               -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_AVALON_BURST_READ.vhd"                                                         -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/data_sc_fifo.vhd"                                                                   -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_CONTROLLER.vhd"                                                                -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/PGEN_TOPFILE.vhd"                                                                   -work Pattern_Generator_A                                     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_MM_REGISTERS_PKG.vhd"                                                          -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_RX_DATA_DC_FIFO_PKG.vhd"                                                       -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_TX_DATA_DC_FIFO_PKG.vhd"                                                       -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwc_dc_data_fifo.vhd"                                                              -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_DATA_DC_FIFO_INSTANTIATION.vhd"                                                -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_BUS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_RX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_TX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwpkg.vhd"                                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwlink.vhd"                                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwram.vhd"                                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwrecv.vhd"                                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwrecvfront_fast.vhd"                                                              -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwrecvfront_generic.vhd"                                                           -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwxmit.vhd"                                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwxmit_fast.vhd"                                                                   -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/streamtest.vhd"                                                                     -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/syncdff.vhd"                                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwstream.vhd"                                                                      -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_CODEC_PKG.vhd"                                                                 -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_CODEC.vhd"                                                                     -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spw_backdoor_dc_fifo.vhd"                                                           -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_CODEC_LOOPBACK.vhd"                                                            -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwc_clk100_codec_commands_dc_fifo.vhd"                                             -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/spwc_clk200_codec_commands_dc_fifo.vhd"                                             -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_CODEC_CONTROLLER.vhd"                                                          -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/SPWC_TOPFILE.vhd"                                                                   -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_MM_REGISTERS_PKG.vhd"                                                          -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_BURST_REGISTERS_PKG.vhd"                                                       -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_AVS_DATA_SC_FIFO_PKG.vhd"                                                      -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/tran_avs_sc_fifo.vhd"                                                               -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_AVS_DATA_SC_FIFO_INSTANTIATION.vhd"                                            -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/AVS_CONTROLLER_PKG.vhd"                                                             -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/AVS_RX_CONTROLLER.vhd"                                                              -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/AVS_TX_CONTROLLER.vhd"                                                              -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_BUS_SC_FIFO_PKG.vhd"                                                           -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/tran_bus_sc_fifo.vhd"                                                               -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_BUS_SC_FIFO_INSTANTIATION.vhd"                                                 -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_BUS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_RX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_TX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_RX_INTERFACE_CONTROLLER.vhd"                                                   -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_TX_INTERFACE_CONTROLLER.vhd"                                                   -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/TRAN_TOPFILE.vhd"                                                                   -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_MM_REGISTERS_PKG.vhd"                                                          -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_BURST_REGISTERS_PKG.vhd"                                                       -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVALON_MM_PKG.vhd"                                                             -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVALON_BURST_PKG.vhd"                                                          -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_PIPELINE_FIFO_PKG.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/comm_pipeline_sc_fifo.vhd"                                                          -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVALON_MM_READ.vhd"                                                            -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVALON_MM_WRITE.vhd"                                                           -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVALON_BURST_READ.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_AVALON_BURST_WRITE.vhd"                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_BUS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_RX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_TX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/COMM_TOPFILE.vhd"                                                                   -work Communication_Module_A                                  
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_conduit_bfm_0002_vhdl_pkg.vhd"                                               -work MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_conduit_bfm_0002.vhd"                                                        -work MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_reset_source.vhd"                                                     -work MebX_Qsys_Project_Burst_inst_rst_bfm                    
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_conduit_bfm_vhdl_pkg.vhd"                                                    -work MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_conduit_bfm.vhd"                                                             -work MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/altera_avalon_clock_source.vhd"                                                     -work MebX_Qsys_Project_Burst_inst_clk100_bfm                 
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/MebX_Qsys_Project_Burst.vhd"                                                        -work MebX_Qsys_Project_Burst_inst                            
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/mebx_qsys_project_burst_rst_controller.vhd"                                         -work MebX_Qsys_Project_Burst_inst                            
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/mebx_qsys_project_burst_rst_controller_001.vhd"                                     -work MebX_Qsys_Project_Burst_inst                            
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/submodules/mebx_qsys_project_burst_rst_controller_002.vhd"                                     -work MebX_Qsys_Project_Burst_inst                            
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS       "$QSYS_SIMDIR/MebX_Qsys_Project_Burst_tb/simulation/MebX_Qsys_Project_Burst_tb.vhd"                                                                                                                              
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim +access +r -t ps $ELAB_OPTIONS -L work -L error_adapter_0 -L avalon_st_adapter -L rsp_mux_001 -L rsp_mux -L rsp_demux -L cmd_mux_001 -L cmd_mux -L cmd_demux_001 -L cmd_demux -L router_003 -L router_002 -L router_001 -L router -L avalon_st_adapter_006 -L dma_DDR_M_descriptor_slave_cmd_width_adapter -L rsp_demux_005 -L cmd_mux_005 -L nios2_gen2_0_debug_mem_slave_burst_adapter -L nios2_gen2_0_instruction_master_limiter -L router_008 -L router_007 -L jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo -L jtag_uart_0_avalon_jtag_slave_agent -L nios2_gen2_0_data_master_agent -L jtag_uart_0_avalon_jtag_slave_translator -L nios2_gen2_0_data_master_translator -L cpu -L write_mstr_internal -L read_mstr_internal -L dispatcher_internal -L rst_controller -L irq_synchronizer -L irq_mapper -L mm_interconnect_2 -L mm_interconnect_1 -L mm_interconnect_0 -L timer_1us -L timer_1ms -L sysid_qsys -L onchip_memory -L nios2_gen2_0 -L jtag_uart_0 -L dma_DDR_M -L descriptor_memory -L clock_bridge_afi_50 -L Pattern_Generator_A -L Communication_Module_A -L MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm -L MebX_Qsys_Project_Burst_inst_rst_bfm -L MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm -L MebX_Qsys_Project_Burst_inst_clk100_bfm -L MebX_Qsys_Project_Burst_inst -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiv_hssi_ver -L stratixiv_pcie_hip_ver -L stratixiv_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L stratixiv_hssi -L stratixiv_pcie_hip -L stratixiv $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -dbg -O2 +access +r -t ps $ELAB_OPTIONS -L work -L error_adapter_0 -L avalon_st_adapter -L rsp_mux_001 -L rsp_mux -L rsp_demux -L cmd_mux_001 -L cmd_mux -L cmd_demux_001 -L cmd_demux -L router_003 -L router_002 -L router_001 -L router -L avalon_st_adapter_006 -L dma_DDR_M_descriptor_slave_cmd_width_adapter -L rsp_demux_005 -L cmd_mux_005 -L nios2_gen2_0_debug_mem_slave_burst_adapter -L nios2_gen2_0_instruction_master_limiter -L router_008 -L router_007 -L jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo -L jtag_uart_0_avalon_jtag_slave_agent -L nios2_gen2_0_data_master_agent -L jtag_uart_0_avalon_jtag_slave_translator -L nios2_gen2_0_data_master_translator -L cpu -L write_mstr_internal -L read_mstr_internal -L dispatcher_internal -L rst_controller -L irq_synchronizer -L irq_mapper -L mm_interconnect_2 -L mm_interconnect_1 -L mm_interconnect_0 -L timer_1us -L timer_1ms -L sysid_qsys -L onchip_memory -L nios2_gen2_0 -L jtag_uart_0 -L dma_DDR_M -L descriptor_memory -L clock_bridge_afi_50 -L Pattern_Generator_A -L Communication_Module_A -L MebX_Qsys_Project_Burst_inst_timer_1ms_external_port_bfm -L MebX_Qsys_Project_Burst_inst_rst_bfm -L MebX_Qsys_Project_Burst_inst_comm_a_conduit_end_bfm -L MebX_Qsys_Project_Burst_inst_clk100_bfm -L MebX_Qsys_Project_Burst_inst -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiv_hssi_ver -L stratixiv_pcie_hip_ver -L stratixiv_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L stratixiv_hssi -L stratixiv_pcie_hip -L stratixiv $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo "                                 For most designs, this should be overridden"
  echo "                                 to enable the elab/elab_debug aliases."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
  echo
  echo "USER_DEFINED_COMPILE_OPTIONS  -- User-defined compile options, added to com/dev_com aliases."
  echo
  echo "USER_DEFINED_ELAB_OPTIONS     -- User-defined elaboration options, added to elab/elab_debug aliases."
}
file_copy
h
