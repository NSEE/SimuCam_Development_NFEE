
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

# ACDS 16.1 196 win32 2018.11.27.16:49:23

# ----------------------------------------
# ncsim - auto-generated simulation script

# ----------------------------------------
# This script provides commands to simulate the following IP detected in
# your Quartus project:
#     MebX_Qsys_Project
# 
# Altera recommends that you source this Quartus-generated IP simulation
# script from your own customized top-level script, and avoid editing this
# generated script.
# 
# To write a top-level shell script that compiles Altera simulation libraries
# and the Quartus-generated IP in your project, along with your design and
# testbench files, copy the text from the TOP-LEVEL TEMPLATE section below
# into a new file, e.g. named "ncsim.sh", and modify text as directed.
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
# # the simulator. In this case, you must also copy the generated files
# # "cds.lib" and "hdl.var" - plus the directory "cds_libs" if generated - 
# # into the location from which you launch the simulator, or incorporate
# # into any existing library setup.
# #
# # Run Quartus-generated IP simulation script once to compile Quartus EDA
# # simulation libraries and Quartus-generated IP simulation files, and copy
# # any ROM/RAM initialization files to the simulation directory.
# # - If necessary, specify USER_DEFINED_COMPILE_OPTIONS.
# #
# source <script generation output directory>/cadence/ncsim_setup.sh \
# SKIP_ELAB=1 \
# SKIP_SIM=1 \
# USER_DEFINED_COMPILE_OPTIONS=<compilation options for your design> \
# QSYS_SIMDIR=<script generation output directory>
# #
# # Compile all design files and testbench files, including the top level.
# # (These are all the files required for simulation other than the files
# # compiled by the IP script)
# #
# ncvlog <compilation options> <design and testbench files>
# #
# # TOP_LEVEL_NAME is used in this script to set the top-level simulation or
# # testbench module/entity name.
# #
# # Run the IP script again to elaborate and simulate the top level:
# # - Specify TOP_LEVEL_NAME and USER_DEFINED_ELAB_OPTIONS.
# # - Override the default USER_DEFINED_SIM_OPTIONS. For example, to run
# #   until $finish(), set to an empty string: USER_DEFINED_SIM_OPTIONS="".
# #
# source <script generation output directory>/cadence/ncsim_setup.sh \
# SKIP_FILE_COPY=1 \
# SKIP_DEV_COM=1 \
# SKIP_COM=1 \
# TOP_LEVEL_NAME=<simulation top> \
# USER_DEFINED_ELAB_OPTIONS=<elaboration options for your design> \
# USER_DEFINED_SIM_OPTIONS=<simulation options for your design>
# #
# # TOP-LEVEL TEMPLATE - END
# ----------------------------------------
# 
# IP SIMULATION SCRIPT
# ----------------------------------------
# If MebX_Qsys_Project is one of several IP cores in your
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
# ACDS 16.1 196 win32 2018.11.27.16:49:23
# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="MebX_Qsys_Project"
QSYS_SIMDIR="./../"
QUARTUS_INSTALL_DIR="C:/intelfpga/16.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="-input \"@run 100; exit\""

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
if [[ `ncsim -version` != *"ncsim(64)"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/cpu/
mkdir -p ./libraries/s0/
mkdir -p ./libraries/p0/
mkdir -p ./libraries/pll0/
mkdir -p ./libraries/dll0/
mkdir -p ./libraries/oct0/
mkdir -p ./libraries/c0/
mkdir -p ./libraries/m0/
mkdir -p ./libraries/tda/
mkdir -p ./libraries/slave_translator/
mkdir -p ./libraries/tdt/
mkdir -p ./libraries/write_mstr_internal/
mkdir -p ./libraries/read_mstr_internal/
mkdir -p ./libraries/dispatcher_internal/
mkdir -p ./libraries/rst_controller/
mkdir -p ./libraries/avalon_st_adapter_001/
mkdir -p ./libraries/avalon_st_adapter/
mkdir -p ./libraries/irq_synchronizer/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/mm_interconnect_3/
mkdir -p ./libraries/mm_interconnect_2/
mkdir -p ./libraries/mm_interconnect_1/
mkdir -p ./libraries/mm_interconnect_0/
mkdir -p ./libraries/tse_mac/
mkdir -p ./libraries/tristate_conduit_bridge_0/
mkdir -p ./libraries/timer_1us/
mkdir -p ./libraries/timer_1ms/
mkdir -p ./libraries/sysid_qsys/
mkdir -p ./libraries/sync/
mkdir -p ./libraries/sgdma_tx/
mkdir -p ./libraries/sgdma_rx/
mkdir -p ./libraries/sd_dat/
mkdir -p ./libraries/pio_LED_painel/
mkdir -p ./libraries/pio_LED/
mkdir -p ./libraries/pio_EXT/
mkdir -p ./libraries/pio_DIP/
mkdir -p ./libraries/pio_BUTTON/
mkdir -p ./libraries/onchip_memory/
mkdir -p ./libraries/nios2_gen2_0/
mkdir -p ./libraries/m2_ddr2_memory/
mkdir -p ./libraries/m1_ddr2_memory/
mkdir -p ./libraries/m1_ddr2_i2c_sda/
mkdir -p ./libraries/jtag_uart_0/
mkdir -p ./libraries/ext_flash/
mkdir -p ./libraries/dma_DDR_M/
mkdir -p ./libraries/descriptor_memory/
mkdir -p ./libraries/ddr2_address_span_extender/
mkdir -p ./libraries/csense_sdo/
mkdir -p ./libraries/csense_cs_n/
mkdir -p ./libraries/csense_adc_fo/
mkdir -p ./libraries/clock_bridge_afi_50/
mkdir -p ./libraries/SEVEN_SEGMENT_CONTROLLER_0/
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
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_bht_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_bht_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_bht_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_ic_tag_ram.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_ic_tag_ram.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_ic_tag_ram.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_rf_ram_b.mif ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_AC_ROM.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_inst_ROM.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_sequencer_mem.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_AC_ROM.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_inst_ROM.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_sequencer_mem.hex ./
  cp -f $QSYS_SIMDIR/submodules/MebX_Qsys_Project_descriptor_memory.hex ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"               -work altera_ver            
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                        -work lpm_ver               
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                           -work sgate_ver             
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                       -work altera_mf_ver         
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                   -work altera_lnsim_ver      
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_atoms.v"            -work stratixiv_hssi_ver    
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_atoms.v"        -work stratixiv_pcie_hip_ver
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_atoms.v"                 -work stratixiv_ver         
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"         -work altera                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"     -work altera                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"        -work altera                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"     -work altera                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"  -work altera                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"             -work altera                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                       -work lpm                   
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                      -work lpm                   
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                    -work sgate                 
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                         -work sgate                 
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"          -work altera_mf             
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                     -work altera_mf             
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"       -work altera_lnsim          
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_components.vhd"     -work stratixiv_hssi        
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_hssi_atoms.vhd"          -work stratixiv_hssi        
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_components.vhd" -work stratixiv_pcie_hip    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_pcie_hip_atoms.vhd"      -work stratixiv_pcie_hip    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_atoms.vhd"               -work stratixiv             
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixiv_components.vhd"          -work stratixiv             
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_sysclk.v"                                    -work cpu                        -cdslib ./cds_libs/cpu.cds.lib                       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck.v"                                       -work cpu                        -cdslib ./cds_libs/cpu.cds.lib                       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper.v"                                   -work cpu                        -cdslib ./cds_libs/cpu.cds.lib                       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_mult_cell.v"                                             -work cpu                        -cdslib ./cds_libs/cpu.cds.lib                       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_test_bench.v"                                            -work cpu                        -cdslib ./cds_libs/cpu.cds.lib                       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0.v"                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst.v"                                 -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst_test_bench.v"                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv"                                             -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_rst.sv"                                                             -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                              -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                         -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                               -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_irq_mapper.sv"                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0.v"                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter.v"                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv" -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_demux.sv"                         -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_demux_001.sv"                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_mux.sv"                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_mux_003.sv"                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router.sv"                            -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router_001.sv"                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router_002.sv"                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router_005.sv"                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_rsp_demux_003.sv"                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_rsp_mux.sv"                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_rsp_mux_001.sv"                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_no_ifdef_params.v"                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_reg.v"                                                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_bitcheck.v"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/rw_manager_core.sv"                                                                         -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_datamux.v"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_data_broadcast.v"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_data_decoder.v"                                                                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ddr2.v"                                                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_di_buffer.v"                                                                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_di_buffer_wrap.v"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_dm_decoder.v"                                                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/rw_manager_generic.sv"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_no_ifdef_params.v"                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_reg.v"                                                                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_jumplogic.v"                                                                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_lfsr12.v"                                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_lfsr36.v"                                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_lfsr72.v"                                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_pattern_fifo.v"                                                                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ram.v"                                                                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ram_csr.v"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_read_datapath.v"                                                                 -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_write_decoder.v"                                                                 -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_data_mgr.sv"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_phy_mgr.sv"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_reg_file.sv"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_acv_phase_decode.v"                                                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_acv_wrapper.sv"                                                               -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_mgr.sv"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_reg_file.v"                                                                   -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_siii_phase_decode.v"                                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_siii_wrapper.sv"                                                              -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_sv_phase_decode.v"                                                            -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_sv_wrapper.sv"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_clock_pair_generator.v"                                 -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_read_valid_selector.v"                                  -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_addr_cmd_datapath.v"                                    -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_reset.v"                                                -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_acv_ldc.v"                                              -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_memphy.sv"                                              -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_reset_sync.v"                                           -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_new_io_pads.v"                                          -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_fr_cycle_shifter.v"                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_fr_cycle_extender.v"                                    -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_read_datapath.sv"                                       -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_write_datapath.v"                                       -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_simple_ddio_out.sv"                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_phy_csr.sv"                                             -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_iss_probe.v"                                            -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_addr_cmd_pads.v"                                        -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_flop_mem.v"                                             -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0.sv"                                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_altdqdqs.v"                                             -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altdq_dqs2_ddio_3reg_stratixiv.sv"                                                          -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altdq_dqs2_abstract.sv"                                                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altdq_dqs2_cal_delays.sv"                                                                   -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_pll0.sv"                                                   -work pll0                       -cdslib ./cds_libs/pll0.cds.lib                      
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_mem_if_dll_stratixiv.sv"                                                             -work dll0                       -cdslib ./cds_libs/dll0.cds.lib                      
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_mem_if_oct_stratixiv.sv"                                                             -work oct0                       -cdslib ./cds_libs/oct0.cds.lib                      
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_c0.v"                                                      -work c0                         -cdslib ./cds_libs/c0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0.v"                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst.v"                                 -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst_test_bench.v"                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv"                                             -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_rst.sv"                                                             -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                              -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                         -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                               -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_irq_mapper.sv"                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0.v"                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter.v"                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv" -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_demux.sv"                         -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_demux_001.sv"                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_mux.sv"                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_mux_003.sv"                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router.sv"                            -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router_001.sv"                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router_002.sv"                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router_005.sv"                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_rsp_demux_003.sv"                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_rsp_mux.sv"                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_rsp_mux_001.sv"                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_no_ifdef_params.v"                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_reg.v"                                                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_bitcheck.v"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/rw_manager_core.sv"                                                                         -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_datamux.v"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_data_broadcast.v"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_data_decoder.v"                                                                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ddr2.v"                                                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_di_buffer.v"                                                                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_di_buffer_wrap.v"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_dm_decoder.v"                                                                    -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/rw_manager_generic.sv"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_no_ifdef_params.v"                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_reg.v"                                                                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_jumplogic.v"                                                                     -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_lfsr12.v"                                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_lfsr36.v"                                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_lfsr72.v"                                                                        -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_pattern_fifo.v"                                                                  -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ram.v"                                                                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_ram_csr.v"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_read_datapath.v"                                                                 -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/rw_manager_write_decoder.v"                                                                 -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_data_mgr.sv"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_phy_mgr.sv"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_reg_file.sv"                                                                      -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_acv_phase_decode.v"                                                           -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_acv_wrapper.sv"                                                               -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_mgr.sv"                                                                       -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_reg_file.v"                                                                   -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_siii_phase_decode.v"                                                          -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_siii_wrapper.sv"                                                              -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/sequencer_scc_sv_phase_decode.v"                                                            -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/sequencer_scc_sv_wrapper.sv"                                                                -work s0                         -cdslib ./cds_libs/s0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/afi_mux_ddrx.v"                                                                             -work m0                         -cdslib ./cds_libs/m0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_clock_pair_generator.v"                                 -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_read_valid_selector.v"                                  -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_addr_cmd_datapath.v"                                    -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_reset.v"                                                -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_acv_ldc.v"                                              -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_memphy.sv"                                              -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_reset_sync.v"                                           -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_new_io_pads.v"                                          -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_fr_cycle_shifter.v"                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_fr_cycle_extender.v"                                    -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_read_datapath.sv"                                       -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_write_datapath.v"                                       -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_simple_ddio_out.sv"                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_phy_csr.sv"                                             -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_iss_probe.v"                                            -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_addr_cmd_pads.v"                                        -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_flop_mem.v"                                             -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0.sv"                                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_altdqdqs.v"                                             -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altdq_dqs2_ddio_3reg_stratixiv.sv"                                                          -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altdq_dqs2_abstract.sv"                                                                     -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altdq_dqs2_cal_delays.sv"                                                                   -work p0                         -cdslib ./cds_libs/p0.cds.lib                        
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_pll0.sv"                                                   -work pll0                       -cdslib ./cds_libs/pll0.cds.lib                      
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_tristate_controller_aggregator.sv"                                                   -work tda                        -cdslib ./cds_libs/tda.cds.lib                       
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                          -work slave_translator           -cdslib ./cds_libs/slave_translator.cds.lib          
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_tristate_controller_translator.sv"                                                   -work tdt                        -cdslib ./cds_libs/tdt.cds.lib                       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/write_master.v"                                                                             -work write_mstr_internal        -cdslib ./cds_libs/write_mstr_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/byte_enable_generator.v"                                                                    -work write_mstr_internal        -cdslib ./cds_libs/write_mstr_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/ST_to_MM_Adapter.v"                                                                         -work write_mstr_internal        -cdslib ./cds_libs/write_mstr_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/write_burst_control.v"                                                                      -work write_mstr_internal        -cdslib ./cds_libs/write_mstr_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/read_master.v"                                                                              -work read_mstr_internal         -cdslib ./cds_libs/read_mstr_internal.cds.lib        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MM_to_ST_Adapter.v"                                                                         -work read_mstr_internal         -cdslib ./cds_libs/read_mstr_internal.cds.lib        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/read_burst_control.v"                                                                       -work read_mstr_internal         -cdslib ./cds_libs/read_mstr_internal.cds.lib        
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/dispatcher.v"                                                                               -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/descriptor_buffers.v"                                                                       -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/csr_block.v"                                                                                -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/response_block.v"                                                                           -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/fifo_with_byteenables.v"                                                                    -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/read_signal_breakout.v"                                                                     -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/write_signal_breakout.v"                                                                    -work dispatcher_internal        -cdslib ./cds_libs/dispatcher_internal.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                                                  -work rst_controller             -cdslib ./cds_libs/rst_controller.cds.lib            
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                                                -work rst_controller             -cdslib ./cds_libs/rst_controller.cds.lib            
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter_001.vhd"                                                -work avalon_st_adapter_001      -cdslib ./cds_libs/avalon_st_adapter_001.cds.lib     
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter.vhd"                                                    -work avalon_st_adapter          -cdslib ./cds_libs/avalon_st_adapter.cds.lib         
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_irq_clock_crosser.sv"                                                                -work irq_synchronizer           -cdslib ./cds_libs/irq_synchronizer.cds.lib          
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_irq_mapper.sv"                                                            -work irq_mapper                 -cdslib ./cds_libs/irq_mapper.cds.lib                
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_3.v"                                                      -work mm_interconnect_3          -cdslib ./cds_libs/mm_interconnect_3.cds.lib         
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2.v"                                                      -work mm_interconnect_2          -cdslib ./cds_libs/mm_interconnect_2.cds.lib         
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1.v"                                                      -work mm_interconnect_1          -cdslib ./cds_libs/mm_interconnect_1.cds.lib         
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0.v"                                                      -work mm_interconnect_0          -cdslib ./cds_libs/mm_interconnect_0.cds.lib         
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_tse_mac.v"                                                                -work tse_mac                    -cdslib ./cds_libs/tse_mac.cds.lib                   
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_tristate_conduit_bridge_0.sv"                                             -work tristate_conduit_bridge_0  -cdslib ./cds_libs/tristate_conduit_bridge_0.cds.lib 
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_timer_1us.v"                                                              -work timer_1us                  -cdslib ./cds_libs/timer_1us.cds.lib                 
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_timer_1ms.v"                                                              -work timer_1ms                  -cdslib ./cds_libs/timer_1ms.cds.lib                 
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sysid_qsys.v"                                                             -work sysid_qsys                 -cdslib ./cds_libs/sysid_qsys.cds.lib                
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_topfile.vhd"                                                                           -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_mm_registers_pkg.vhd"                                                                  -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_outen.vhd"                                                                             -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_outen_pkg.vhd"                                                                         -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_int.vhd"                                                                               -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_int_pkg.vhd"                                                                           -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_gen.vhd"                                                                               -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_gen_pkg.vhd"                                                                           -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_common_pkg.vhd"                                                                        -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_avalon_mm_pkg.vhd"                                                                     -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_avalon_mm_read.vhd"                                                                    -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/sync_avalon_mm_write.vhd"                                                                   -work sync                       -cdslib ./cds_libs/sync.cds.lib                      
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sgdma_tx.v"                                                               -work sgdma_tx                   -cdslib ./cds_libs/sgdma_tx.cds.lib                  
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sgdma_rx.v"                                                               -work sgdma_rx                   -cdslib ./cds_libs/sgdma_rx.cds.lib                  
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sd_dat.v"                                                                 -work sd_dat                     -cdslib ./cds_libs/sd_dat.cds.lib                    
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_LED_painel.v"                                                         -work pio_LED_painel             -cdslib ./cds_libs/pio_LED_painel.cds.lib            
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_LED.v"                                                                -work pio_LED                    -cdslib ./cds_libs/pio_LED.cds.lib                   
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_EXT.v"                                                                -work pio_EXT                    -cdslib ./cds_libs/pio_EXT.cds.lib                   
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_DIP.v"                                                                -work pio_DIP                    -cdslib ./cds_libs/pio_DIP.cds.lib                   
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_BUTTON.v"                                                             -work pio_BUTTON                 -cdslib ./cds_libs/pio_BUTTON.cds.lib                
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_onchip_memory.v"                                                          -work onchip_memory              -cdslib ./cds_libs/onchip_memory.cds.lib             
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0.v"                                                           -work nios2_gen2_0               -cdslib ./cds_libs/nios2_gen2_0.cds.lib              
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory.v"                                                         -work m2_ddr2_memory             -cdslib ./cds_libs/m2_ddr2_memory.cds.lib            
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory.v"                                                         -work m1_ddr2_memory             -cdslib ./cds_libs/m1_ddr2_memory.cds.lib            
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_i2c_sda.v"                                                        -work m1_ddr2_i2c_sda            -cdslib ./cds_libs/m1_ddr2_i2c_sda.cds.lib           
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_jtag_uart_0.v"                                                            -work jtag_uart_0                -cdslib ./cds_libs/jtag_uart_0.cds.lib               
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_ext_flash.vhd"                                                            -work ext_flash                  -cdslib ./cds_libs/ext_flash.cds.lib                 
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_dma_DDR_M.v"                                                              -work dma_DDR_M                  -cdslib ./cds_libs/dma_DDR_M.cds.lib                 
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_descriptor_memory.v"                                                      -work descriptor_memory          -cdslib ./cds_libs/descriptor_memory.cds.lib         
  ncvlog -sv $USER_DEFINED_COMPILE_OPTIONS  "$QSYS_SIMDIR/submodules/altera_address_span_extender.sv"                                                            -work ddr2_address_span_extender -cdslib ./cds_libs/ddr2_address_span_extender.cds.lib
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_csense_sdo.v"                                                             -work csense_sdo                 -cdslib ./cds_libs/csense_sdo.cds.lib                
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_csense_cs_n.v"                                                            -work csense_cs_n                -cdslib ./cds_libs/csense_cs_n.cds.lib               
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_csense_adc_fo.v"                                                          -work csense_adc_fo              -cdslib ./cds_libs/csense_adc_fo.cds.lib             
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_avalon_mm_clock_crossing_bridge.v"                                                   -work clock_bridge_afi_50        -cdslib ./cds_libs/clock_bridge_afi_50.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_avalon_dc_fifo.v"                                                                    -work clock_bridge_afi_50        -cdslib ./cds_libs/clock_bridge_afi_50.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_dcfifo_synchronizer_bundle.v"                                                        -work clock_bridge_afi_50        -cdslib ./cds_libs/clock_bridge_afi_50.cds.lib       
  ncvlog $USER_DEFINED_COMPILE_OPTIONS      "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                            -work clock_bridge_afi_50        -cdslib ./cds_libs/clock_bridge_afi_50.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SEVEN_SEG_REGISTER.vhd"                                                                     -work SEVEN_SEGMENT_CONTROLLER_0 -cdslib ./cds_libs/SEVEN_SEGMENT_CONTROLLER_0.cds.lib
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/DOUBLE_DABBLE_8BIT.vhd"                                                                     -work SEVEN_SEGMENT_CONTROLLER_0 -cdslib ./cds_libs/SEVEN_SEGMENT_CONTROLLER_0.cds.lib
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SEVEN_SEG_DPS.vhd"                                                                          -work SEVEN_SEGMENT_CONTROLLER_0 -cdslib ./cds_libs/SEVEN_SEGMENT_CONTROLLER_0.cds.lib
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SEVEN_SEG_TOP.vhd"                                                                          -work SEVEN_SEGMENT_CONTROLLER_0 -cdslib ./cds_libs/SEVEN_SEGMENT_CONTROLLER_0.cds.lib
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_AVALON_MM_PKG.vhd"                                                                     -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_MM_REGISTERS_PKG.vhd"                                                                  -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_AVALON_BURST_PKG.vhd"                                                                  -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_BURST_REGISTERS_PKG.vhd"                                                               -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_PIPELINE_FIFO_PKG.vhd"                                                                 -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_CONTROLLER_PKG.vhd"                                                                    -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_PATTERN_PKG.vhd"                                                                       -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_DATA_FIFO_PKG.vhd"                                                                     -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_AVALON_MM_READ.vhd"                                                                    -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_AVALON_MM_WRITE.vhd"                                                                   -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pipeline_sc_fifo.vhd"                                                                       -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_AVALON_BURST_READ.vhd"                                                                 -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/data_sc_fifo.vhd"                                                                           -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_CONTROLLER.vhd"                                                                        -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/PGEN_TOPFILE.vhd"                                                                           -work Pattern_Generator_A        -cdslib ./cds_libs/Pattern_Generator_A.cds.lib       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_MM_REGISTERS_PKG.vhd"                                                                  -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_RX_DATA_DC_FIFO_PKG.vhd"                                                               -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_TX_DATA_DC_FIFO_PKG.vhd"                                                               -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwc_dc_data_fifo.vhd"                                                                      -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_DATA_DC_FIFO_INSTANTIATION.vhd"                                                        -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_BUS_CONTROLLER_PKG.vhd"                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_RX_BUS_CONTROLLER.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_TX_BUS_CONTROLLER.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwpkg.vhd"                                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwlink.vhd"                                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwram.vhd"                                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwrecv.vhd"                                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwrecvfront_fast.vhd"                                                                      -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwrecvfront_generic.vhd"                                                                   -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwxmit.vhd"                                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwxmit_fast.vhd"                                                                           -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/streamtest.vhd"                                                                             -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/syncdff.vhd"                                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwstream.vhd"                                                                              -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_CODEC_PKG.vhd"                                                                         -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_CODEC.vhd"                                                                             -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spw_backdoor_dc_fifo.vhd"                                                                   -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_CODEC_LOOPBACK.vhd"                                                                    -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwc_clk100_codec_commands_dc_fifo.vhd"                                                     -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/spwc_clk200_codec_commands_dc_fifo.vhd"                                                     -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_CODEC_CONTROLLER.vhd"                                                                  -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/SPWC_TOPFILE.vhd"                                                                           -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_MM_REGISTERS_PKG.vhd"                                                                  -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_BURST_REGISTERS_PKG.vhd"                                                               -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_AVS_DATA_SC_FIFO_PKG.vhd"                                                              -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/tran_avs_sc_fifo.vhd"                                                                       -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_AVS_DATA_SC_FIFO_INSTANTIATION.vhd"                                                    -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/AVS_CONTROLLER_PKG.vhd"                                                                     -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/AVS_RX_CONTROLLER.vhd"                                                                      -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/AVS_TX_CONTROLLER.vhd"                                                                      -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_BUS_SC_FIFO_PKG.vhd"                                                                   -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/tran_bus_sc_fifo.vhd"                                                                       -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_BUS_SC_FIFO_INSTANTIATION.vhd"                                                         -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_BUS_CONTROLLER_PKG.vhd"                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_RX_BUS_CONTROLLER.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_TX_BUS_CONTROLLER.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_RX_INTERFACE_CONTROLLER.vhd"                                                           -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_TX_INTERFACE_CONTROLLER.vhd"                                                           -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/TRAN_TOPFILE.vhd"                                                                           -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_MM_REGISTERS_PKG.vhd"                                                                  -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_BURST_REGISTERS_PKG.vhd"                                                               -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVS_CONTROLLER_PKG.vhd"                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVALON_MM_PKG.vhd"                                                                     -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVALON_BURST_PKG.vhd"                                                                  -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_PIPELINE_FIFO_PKG.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/comm_pipeline_sc_fifo.vhd"                                                                  -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVALON_MM_READ.vhd"                                                                    -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVALON_MM_WRITE.vhd"                                                                   -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVALON_BURST_READ.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_AVALON_BURST_WRITE.vhd"                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_BUS_CONTROLLER_PKG.vhd"                                                                -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_RX_BUS_CONTROLLER.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_TX_BUS_CONTROLLER.vhd"                                                                 -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/COMM_TOPFILE.vhd"                                                                           -work Communication_Module_A     -cdslib ./cds_libs/Communication_Module_A.cds.lib    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/MebX_Qsys_Project.vhd"                                                                                                                                                                       
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/mebx_qsys_project_rst_controller.vhd"                                                                                                                                                        
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/mebx_qsys_project_rst_controller_001.vhd"                                                                                                                                                    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/mebx_qsys_project_rst_controller_003.vhd"                                                                                                                                                    
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/mebx_qsys_project_clock_bridge_afi_50.vhd"                                                                                                                                                   
  ncvhdl -v93 $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/mebx_qsys_project_m1_clock_bridge.vhd"                                                                                                                                                       
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  export GENERIC_PARAM_COMPAT_CHECK=1
  ncelab -access +w+r+c -namemap_mixgen -relax $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  eval ncsim -licqueue $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS $TOP_LEVEL_NAME
fi
