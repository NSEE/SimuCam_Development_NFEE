
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

# ACDS 16.1 196 win32 2018.09.12.11:36:35

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
# This script provides commands to simulate the following IP detected in
# your Quartus project:
#     MebX_Qsys_Project_Burst
# 
# Altera recommends that you source this Quartus-generated IP simulation
# script from your own customized top-level script, and avoid editing this
# generated script.
# 
# To write a top-level shell script that compiles Altera simulation libraries 
# and the Quartus-generated IP in your project, along with your design and
# testbench files, copy the text from the TOP-LEVEL TEMPLATE section below
# into a new file, e.g. named "vcsmx_sim.sh", and modify text as directed.
# 
# You can also modify the simulation flow to suit your needs. Set the
# following variables to 1 to disable their corresponding processes:
# - SKIP_FILE_COPY: skip copying ROM/RAM initialization files
# - SKIP_DEV_COM: skip compiling the Quartus EDA simulation library
# - SKIP_COM: skip compiling Quartus-generated IP simulation files
# - SKIP_ELAB and SKIP_SIM: skip elaboration and simulation
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
# # the simulator. In this case, you must also copy the generated library
# # setup "synopsys_sim.setup" into the location from which you launch the
# # simulator, or incorporate into any existing library setup.
# #
# # Run Quartus-generated IP simulation script once to compile Quartus EDA
# # simulation libraries and Quartus-generated IP simulation files, and copy
# # any ROM/RAM initialization files to the simulation directory.
# #
# # - If necessary, specify USER_DEFINED_COMPILE_OPTIONS.
# source <script generation output directory>/synopsys/vcsmx/vcsmx_setup.sh \
# SKIP_ELAB=1 \
# SKIP_SIM=1 \
# USER_DEFINED_COMPILE_OPTIONS=<compilation options for your design> \
# QSYS_SIMDIR=<script generation output directory>
# #
# # Compile all design files and testbench files, including the top level.
# # (These are all the files required for simulation other than the files
# # compiled by the IP script)
# #
# vlogan <compilation options> <design and testbench files>
# #
# # TOP_LEVEL_NAME is used in this script to set the top-level simulation or
# # testbench module/entity name.
# #
# # Run the IP script again to elaborate and simulate the top level:
# # - Specify TOP_LEVEL_NAME and USER_DEFINED_ELAB_OPTIONS.
# # - Override the default USER_DEFINED_SIM_OPTIONS. For example, to run
# #   until $finish(), set to an empty string: USER_DEFINED_SIM_OPTIONS="".
# #
# source <script generation output directory>/synopsys/vcsmx/vcsmx_setup.sh \
# SKIP_FILE_COPY=1 \
# SKIP_DEV_COM=1 \
# SKIP_COM=1 \
# TOP_LEVEL_NAME="'-top <simulation top>'" \
# QSYS_SIMDIR=<script generation output directory> \
# USER_DEFINED_ELAB_OPTIONS=<elaboration options for your design> \
# USER_DEFINED_SIM_OPTIONS=<simulation options for your design>
# #
# # TOP-LEVEL TEMPLATE - END
# ----------------------------------------
# 
# IP SIMULATION SCRIPT
# ----------------------------------------
# If MebX_Qsys_Project_Burst is one of several IP cores in your
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
# ACDS 16.1 196 win32 2018.09.12.11:36:35
# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="MebX_Qsys_Project_Burst"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="C:/intelfpga/16.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `vcs -platform` != *"amd64"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/error_adapter_0/
mkdir -p ./libraries/avalon_st_adapter/
mkdir -p ./libraries/rsp_mux_001/
mkdir -p ./libraries/rsp_mux/
mkdir -p ./libraries/rsp_demux/
mkdir -p ./libraries/cmd_mux_001/
mkdir -p ./libraries/cmd_mux/
mkdir -p ./libraries/cmd_demux_001/
mkdir -p ./libraries/cmd_demux/
mkdir -p ./libraries/router_003/
mkdir -p ./libraries/router_002/
mkdir -p ./libraries/router_001/
mkdir -p ./libraries/router/
mkdir -p ./libraries/avalon_st_adapter_006/
mkdir -p ./libraries/dma_DDR_M_descriptor_slave_cmd_width_adapter/
mkdir -p ./libraries/rsp_demux_005/
mkdir -p ./libraries/cmd_mux_005/
mkdir -p ./libraries/nios2_gen2_0_debug_mem_slave_burst_adapter/
mkdir -p ./libraries/nios2_gen2_0_instruction_master_limiter/
mkdir -p ./libraries/router_008/
mkdir -p ./libraries/router_007/
mkdir -p ./libraries/jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo/
mkdir -p ./libraries/jtag_uart_0_avalon_jtag_slave_agent/
mkdir -p ./libraries/nios2_gen2_0_data_master_agent/
mkdir -p ./libraries/jtag_uart_0_avalon_jtag_slave_translator/
mkdir -p ./libraries/nios2_gen2_0_data_master_translator/
mkdir -p ./libraries/cpu/
mkdir -p ./libraries/write_mstr_internal/
mkdir -p ./libraries/read_mstr_internal/
mkdir -p ./libraries/dispatcher_internal/
mkdir -p ./libraries/rst_controller/
mkdir -p ./libraries/irq_synchronizer/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/mm_interconnect_2/
mkdir -p ./libraries/mm_interconnect_1/
mkdir -p ./libraries/mm_interconnect_0/
mkdir -p ./libraries/timer_1us/
mkdir -p ./libraries/timer_1ms/
mkdir -p ./libraries/sysid_qsys/
mkdir -p ./libraries/onchip_memory/
mkdir -p ./libraries/nios2_gen2_0/
mkdir -p ./libraries/jtag_uart_0/
mkdir -p ./libraries/dma_DDR_M/
mkdir -p ./libraries/descriptor_memory/
mkdir -p ./libraries/clock_bridge_afi_50/
mkdir -p ./libraries/Pattern_Generator_A/
mkdir -p ./libraries/Communication_Module_A/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/stratixiv_hssi_ver/
mkdir -p ./libraries/stratixiv_pcie_hip_ver/
mkdir -p ./libraries/stratixiv_ver/
mkdir -p ./libraries/altera/
mkdir -p ./libraries/lpm/
mkdir -p ./libraries/sgate/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim/
mkdir -p ./libraries/stratixiv_hssi/
mkdir -p ./libraries/stratixiv_pcie_hip/
mkdir -p ./libraries/stratixiv/

# ----------------------------------------
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_bht_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_bht_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_bht_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ic_tag_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ic_tag_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ic_tag_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_rf_ram_b.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_descriptor_memory.hex ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"               -work altera_ver            
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                        -work lpm_ver               
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                           -work sgate_ver             
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                       -work altera_mf_ver         
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                   -work altera_lnsim_ver      
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_atoms.v"            -work stratixiv_hssi_ver    
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_atoms.v"        -work stratixiv_pcie_hip_ver
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_atoms.v"                 -work stratixiv_ver         
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"         -work altera                
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"     -work altera                
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"        -work altera                
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"     -work altera                
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"  -work altera                
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"             -work altera                
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                       -work lpm                   
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                      -work lpm                   
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                    -work sgate                 
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                         -work sgate                 
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"          -work altera_mf             
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                     -work altera_mf             
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"       -work altera_lnsim          
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_components.vhd"     -work stratixiv_hssi        
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_atoms.vhd"          -work stratixiv_hssi        
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_components.vhd" -work stratixiv_pcie_hip    
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_atoms.vhd"      -work stratixiv_pcie_hip    
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_atoms.vhd"               -work stratixiv             
  vhdlan $USER_DEFINED_COMPILE_OPTIONS                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_components.vhd"          -work stratixiv             
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_avalon_st_adapter_error_adapter_0.sv"     -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter_006_error_adapter_0.sv" -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv"     -work error_adapter_0                             
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_avalon_st_adapter.vhd"                    -work avalon_st_adapter                           
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_rsp_mux_001.sv"                           -work rsp_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_rsp_mux.sv"                               -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_rsp_demux.sv"                             -work rsp_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_mux_001.sv"                           -work cmd_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_mux.sv"                               -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_demux_001.sv"                         -work cmd_demux_001                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_cmd_demux.sv"                             -work cmd_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router_003.sv"                            -work router_003                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router_002.sv"                            -work router_002                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router_001.sv"                            -work router_001                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2_router.sv"                                -work router                                      
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_rsp_mux.sv"                               -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_rsp_demux.sv"                             -work rsp_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_cmd_mux.sv"                               -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_cmd_demux.sv"                             -work cmd_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_router_001.sv"                            -work router_001                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1_router.sv"                                -work router                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter_006.vhd"                -work avalon_st_adapter_006                       
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_avalon_st_adapter.vhd"                    -work avalon_st_adapter                           
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_width_adapter.sv"                                                     -work dma_DDR_M_descriptor_slave_cmd_width_adapter
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                                 -work dma_DDR_M_descriptor_slave_cmd_width_adapter
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                -work dma_DDR_M_descriptor_slave_cmd_width_adapter
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_mux_001.sv"                           -work rsp_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_mux.sv"                               -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_demux_005.sv"                         -work rsp_demux_005                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_rsp_demux.sv"                             -work rsp_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_mux_005.sv"                           -work cmd_mux_005                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux_005                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_mux.sv"                               -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                        -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_demux_001.sv"                         -work cmd_demux_001                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_cmd_demux.sv"                             -work cmd_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                                                     -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_uncmpr.sv"                                              -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_13_1.sv"                                                -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_new.sv"                                                 -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_incr_burst_converter.sv"                                                     -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_wrap_burst_converter.sv"                                                     -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_default_burst_converter.sv"                                                  -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                                 -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_stage.sv"                                                 -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                   -work nios2_gen2_0_debug_mem_slave_burst_adapter  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv"                                                   -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_reorder_memory.sv"                                                    -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                            -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                   -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_008.sv"                            -work router_008                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_007.sv"                            -work router_007                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_002.sv"                            -work router_002                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router_001.sv"                            -work router_001                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0_router.sv"                                -work router                                      
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                            -work jtag_uart_0_avalon_jtag_slave_agent_rsp_fifo
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                       -work jtag_uart_0_avalon_jtag_slave_agent         
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                -work jtag_uart_0_avalon_jtag_slave_agent         
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                      -work nios2_gen2_0_data_master_agent              
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                  -work jtag_uart_0_avalon_jtag_slave_translator    
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                 -work nios2_gen2_0_data_master_translator         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu.vo"                                        -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_debug_slave_sysclk.v"                      -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_debug_slave_tck.v"                         -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_debug_slave_wrapper.v"                     -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_mult_cell.v"                               -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0_cpu_test_bench.v"                              -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/write_master.v"                                                                     -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/byte_enable_generator.v"                                                            -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/ST_to_MM_Adapter.v"                                                                 -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/write_burst_control.v"                                                              -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/read_master.v"                                                                      -work read_mstr_internal                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MM_to_ST_Adapter.v"                                                                 -work read_mstr_internal                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/read_burst_control.v"                                                               -work read_mstr_internal                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/dispatcher.v"                                                                       -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/descriptor_buffers.v"                                                               -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/csr_block.v"                                                                        -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/response_block.v"                                                                   -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/fifo_with_byteenables.v"                                                            -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/read_signal_breakout.v"                                                             -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/write_signal_breakout.v"                                                            -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                                          -work rst_controller                              
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                                        -work rst_controller                              
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_irq_clock_crosser.sv"                                                        -work irq_synchronizer                            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_irq_mapper.sv"                                              -work irq_mapper                                  
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_2.v"                                        -work mm_interconnect_2                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_1.v"                                        -work mm_interconnect_1                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_mm_interconnect_0.v"                                        -work mm_interconnect_0                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_timer_1us.v"                                                -work timer_1us                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_timer_1ms.v"                                                -work timer_1ms                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_sysid_qsys.v"                                               -work sysid_qsys                                  
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_onchip_memory.v"                                            -work onchip_memory                               
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_nios2_gen2_0.v"                                             -work nios2_gen2_0                                
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_jtag_uart_0.v"                                              -work jtag_uart_0                                 
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_dma_DDR_M.v"                                                -work dma_DDR_M                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_Burst_descriptor_memory.v"                                        -work descriptor_memory                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_avalon_mm_clock_crossing_bridge.v"                                           -work clock_bridge_afi_50                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_avalon_dc_fifo.v"                                                            -work clock_bridge_afi_50                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_dcfifo_synchronizer_bundle.v"                                                -work clock_bridge_afi_50                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                    -work clock_bridge_afi_50                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_AVALON_MM_PKG.vhd"                                                             -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_MM_REGISTERS_PKG.vhd"                                                          -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_AVALON_BURST_PKG.vhd"                                                          -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_BURST_REGISTERS_PKG.vhd"                                                       -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_PIPELINE_FIFO_PKG.vhd"                                                         -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_CONTROLLER_PKG.vhd"                                                            -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_PATTERN_PKG.vhd"                                                               -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_DATA_FIFO_PKG.vhd"                                                             -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_AVALON_MM_READ.vhd"                                                            -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_AVALON_MM_WRITE.vhd"                                                           -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/pipeline_sc_fifo.vhd"                                                               -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_AVALON_BURST_READ.vhd"                                                         -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/data_sc_fifo.vhd"                                                                   -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_CONTROLLER.vhd"                                                                -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/PGEN_TOPFILE.vhd"                                                                   -work Pattern_Generator_A                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_MM_REGISTERS_PKG.vhd"                                                          -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_RX_DATA_DC_FIFO_PKG.vhd"                                                       -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_TX_DATA_DC_FIFO_PKG.vhd"                                                       -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwc_dc_data_fifo.vhd"                                                              -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_DATA_DC_FIFO_INSTANTIATION.vhd"                                                -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_BUS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_RX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_TX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwpkg.vhd"                                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwlink.vhd"                                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwram.vhd"                                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwrecv.vhd"                                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwrecvfront_fast.vhd"                                                              -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwrecvfront_generic.vhd"                                                           -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwxmit.vhd"                                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwxmit_fast.vhd"                                                                   -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/streamtest.vhd"                                                                     -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/syncdff.vhd"                                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwstream.vhd"                                                                      -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_CODEC_PKG.vhd"                                                                 -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_CODEC.vhd"                                                                     -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spw_backdoor_dc_fifo.vhd"                                                           -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_CODEC_LOOPBACK.vhd"                                                            -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwc_clk100_codec_commands_dc_fifo.vhd"                                             -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/spwc_clk200_codec_commands_dc_fifo.vhd"                                             -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_CODEC_CONTROLLER.vhd"                                                          -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/SPWC_TOPFILE.vhd"                                                                   -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_MM_REGISTERS_PKG.vhd"                                                          -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_BURST_REGISTERS_PKG.vhd"                                                       -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_AVS_DATA_SC_FIFO_PKG.vhd"                                                      -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/tran_avs_sc_fifo.vhd"                                                               -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_AVS_DATA_SC_FIFO_INSTANTIATION.vhd"                                            -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/AVS_CONTROLLER_PKG.vhd"                                                             -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/AVS_RX_CONTROLLER.vhd"                                                              -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/AVS_TX_CONTROLLER.vhd"                                                              -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_BUS_SC_FIFO_PKG.vhd"                                                           -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/tran_bus_sc_fifo.vhd"                                                               -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_BUS_SC_FIFO_INSTANTIATION.vhd"                                                 -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_BUS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_RX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_TX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_RX_INTERFACE_CONTROLLER.vhd"                                                   -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_TX_INTERFACE_CONTROLLER.vhd"                                                   -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/TRAN_TOPFILE.vhd"                                                                   -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_MM_REGISTERS_PKG.vhd"                                                          -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_BURST_REGISTERS_PKG.vhd"                                                       -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVALON_MM_PKG.vhd"                                                             -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVALON_BURST_PKG.vhd"                                                          -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_PIPELINE_FIFO_PKG.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/comm_pipeline_sc_fifo.vhd"                                                          -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVALON_MM_READ.vhd"                                                            -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVALON_MM_WRITE.vhd"                                                           -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVALON_BURST_READ.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_AVALON_BURST_WRITE.vhd"                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_BUS_CONTROLLER_PKG.vhd"                                                        -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_RX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_TX_BUS_CONTROLLER.vhd"                                                         -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/submodules/COMM_TOPFILE.vhd"                                                                   -work Communication_Module_A                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/MebX_Qsys_Project_Burst.vhd"                                                                                                                     
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/mebx_qsys_project_burst_rst_controller.vhd"                                                                                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/mebx_qsys_project_burst_rst_controller_001.vhd"                                                                                                  
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS          "$QSYS_SIMDIR/mebx_qsys_project_burst_rst_controller_002.vhd"                                                                                                  
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
