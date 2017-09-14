
# (C) 2001-2017 Altera Corporation. All rights reserved.
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

# ACDS 16.1 196 win32 2017.06.23.17:22:13

# ----------------------------------------
# vcsmx - auto-generated simulation script

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
# ACDS 16.1 196 win32 2017.06.23.17:22:13
# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="MebX_Qsys_Project"
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
mkdir -p ./libraries/a0/
mkdir -p ./libraries/ng0/
mkdir -p ./libraries/timing_adapter_0/
mkdir -p ./libraries/rsp_mux/
mkdir -p ./libraries/rsp_demux/
mkdir -p ./libraries/cmd_mux/
mkdir -p ./libraries/cmd_demux/
mkdir -p ./libraries/router_001/
mkdir -p ./libraries/router/
mkdir -p ./libraries/avalon_st_adapter_016/
mkdir -p ./libraries/avalon_st_adapter_010/
mkdir -p ./libraries/avalon_st_adapter_002/
mkdir -p ./libraries/avalon_st_adapter/
mkdir -p ./libraries/crosser/
mkdir -p ./libraries/dma_M1_M2_descriptor_slave_cmd_width_adapter/
mkdir -p ./libraries/rsp_mux_002/
mkdir -p ./libraries/rsp_mux_001/
mkdir -p ./libraries/rsp_demux_015/
mkdir -p ./libraries/rsp_demux_014/
mkdir -p ./libraries/rsp_demux_013/
mkdir -p ./libraries/rsp_demux_009/
mkdir -p ./libraries/rsp_demux_002/
mkdir -p ./libraries/cmd_mux_015/
mkdir -p ./libraries/cmd_mux_014/
mkdir -p ./libraries/cmd_mux_009/
mkdir -p ./libraries/cmd_mux_002/
mkdir -p ./libraries/cmd_demux_002/
mkdir -p ./libraries/cmd_demux_001/
mkdir -p ./libraries/m2_ddr2_memory_avl_burst_adapter/
mkdir -p ./libraries/nios2_gen2_0_instruction_master_limiter/
mkdir -p ./libraries/router_028/
mkdir -p ./libraries/router_027/
mkdir -p ./libraries/router_026/
mkdir -p ./libraries/router_025/
mkdir -p ./libraries/router_022/
mkdir -p ./libraries/router_021/
mkdir -p ./libraries/router_014/
mkdir -p ./libraries/router_012/
mkdir -p ./libraries/router_010/
mkdir -p ./libraries/router_008/
mkdir -p ./libraries/router_004/
mkdir -p ./libraries/router_002/
mkdir -p ./libraries/FTDI_0_FTDI_avalon_slave_agent_rsp_fifo/
mkdir -p ./libraries/FTDI_0_FTDI_avalon_slave_agent/
mkdir -p ./libraries/nios2_gen2_0_data_master_agent/
mkdir -p ./libraries/nios2_gen2_0_data_master_translator/
mkdir -p ./libraries/i_tse_pcs_0/
mkdir -p ./libraries/i_tse_mac/
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
mkdir -p ./libraries/irq_synchronizer/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/mm_interconnect_2/
mkdir -p ./libraries/mm_interconnect_1/
mkdir -p ./libraries/mm_interconnect_0/
mkdir -p ./libraries/tse_mac/
mkdir -p ./libraries/tristate_conduit_bridge_0/
mkdir -p ./libraries/timer_1us/
mkdir -p ./libraries/timer_1ms/
mkdir -p ./libraries/sysid_qsys/
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
mkdir -p ./libraries/dma_M2_M1/
mkdir -p ./libraries/dma_M1_M2/
mkdir -p ./libraries/descriptor_memory/
mkdir -p ./libraries/csense_sdo/
mkdir -p ./libraries/csense_cs_n/
mkdir -p ./libraries/csense_adc_fo/
mkdir -p ./libraries/clock_bridge_afi_50/
mkdir -p ./libraries/SEVEN_SEGMENT_CONTROLLER_0/
mkdir -p ./libraries/FTDI_0/
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
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_016_error_adapter_0.sv"               -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_010_error_adapter_0.sv"               -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_002_error_adapter_0.sv"               -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv"                   -work error_adapter_0                             
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/alt_mem_ddrx_mm_st_converter.v"                                                             -work a0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_addr_cmd.v"                                                                    -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_addr_cmd_wrap.v"                                                               -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ddr2_odt_gen.v"                                                                -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ddr3_odt_gen.v"                                                                -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_lpddr2_addr_cmd.v"                                                             -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_odt_gen.v"                                                                     -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_rdwr_data_tmg.v"                                                               -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_arbiter.v"                                                                     -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_burst_gen.v"                                                                   -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_cmd_gen.v"                                                                     -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_csr.v"                                                                         -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_buffer.v"                                                                      -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_buffer_manager.v"                                                              -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_burst_tracking.v"                                                              -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_dataid_manager.v"                                                              -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_fifo.v"                                                                        -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_list.v"                                                                        -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_rdata_path.v"                                                                  -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_wdata_path.v"                                                                  -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_decoder.v"                                                                 -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_decoder_32_syn.v"                                                          -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_decoder_64_syn.v"                                                          -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_encoder.v"                                                                 -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_encoder_32_syn.v"                                                          -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_encoder_64_syn.v"                                                          -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_ecc_encoder_decoder_wrapper.v"                                                 -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_axi_st_converter.v"                                                            -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_input_if.v"                                                                    -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_rank_timer.v"                                                                  -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_sideband.v"                                                                    -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_tbp.v"                                                                         -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_timing_param.v"                                                                -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_controller.v"                                                                  -work ng0                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS           \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_ddrx_controller_st_top.v"                                                           -work ng0                                         
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS \"+incdir+$QSYS_SIMDIR/submodules/\" "$QSYS_SIMDIR/submodules/alt_mem_if_nextgen_ddr2_controller_core.sv"                                                 -work ng0                                         
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter_001_timing_adapter_0.sv"                                -work timing_adapter_0                            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter_001_timing_adapter_0_fifo.sv"                           -work timing_adapter_0                            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter_001_error_adapter_0.sv"                                 -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter_error_adapter_0.sv"                                     -work error_adapter_0                             
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2_rsp_mux.sv"                                             -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2_rsp_demux.sv"                                           -work rsp_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2_cmd_mux.sv"                                             -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2_cmd_demux.sv"                                           -work cmd_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2_router_001.sv"                                          -work router_001                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2_router.sv"                                              -work router                                      
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1_rsp_mux.sv"                                             -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1_rsp_demux.sv"                                           -work rsp_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1_cmd_mux.sv"                                             -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1_cmd_demux.sv"                                           -work cmd_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1_router_001.sv"                                          -work router_001                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1_router.sv"                                              -work router                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_016.vhd"                              -work avalon_st_adapter_016                       
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_010.vhd"                              -work avalon_st_adapter_010                       
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter_002.vhd"                              -work avalon_st_adapter_002                       
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_avalon_st_adapter.vhd"                                  -work avalon_st_adapter                           
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_st_handshake_clock_crosser.v"                                                 -work crosser                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_st_clock_crosser.v"                                                           -work crosser                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                           -work crosser                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                            -work crosser                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_width_adapter.sv"                                                             -work dma_M1_M2_descriptor_slave_cmd_width_adapter
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                                         -work dma_M1_M2_descriptor_slave_cmd_width_adapter
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                        -work dma_M1_M2_descriptor_slave_cmd_width_adapter
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_mux_002.sv"                                         -work rsp_mux_002                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work rsp_mux_002                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_mux_001.sv"                                         -work rsp_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work rsp_mux_001                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_mux.sv"                                             -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work rsp_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_demux_015.sv"                                       -work rsp_demux_015                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_demux_014.sv"                                       -work rsp_demux_014                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_demux_013.sv"                                       -work rsp_demux_013                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_demux_009.sv"                                       -work rsp_demux_009                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_rsp_demux_002.sv"                                       -work rsp_demux_002                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_mux_015.sv"                                         -work cmd_mux_015                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux_015                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_mux_014.sv"                                         -work cmd_mux_014                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux_014                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_mux_009.sv"                                         -work cmd_mux_009                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux_009                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_mux_002.sv"                                         -work cmd_mux_002                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux_002                                 
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_mux.sv"                                             -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work cmd_mux                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_demux_002.sv"                                       -work cmd_demux_002                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_demux_001.sv"                                       -work cmd_demux_001                               
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_cmd_demux.sv"                                           -work cmd_demux                                   
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                                                             -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_uncmpr.sv"                                                      -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_13_1.sv"                                                        -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_new.sv"                                                         -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_incr_burst_converter.sv"                                                             -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_wrap_burst_converter.sv"                                                             -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_default_burst_converter.sv"                                                          -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                                         -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_stage.sv"                                                         -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                           -work m2_ddr2_memory_avl_burst_adapter            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv"                                                           -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_reorder_memory.sv"                                                            -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                    -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                           -work nios2_gen2_0_instruction_master_limiter     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_028.sv"                                          -work router_028                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_027.sv"                                          -work router_027                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_026.sv"                                          -work router_026                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_025.sv"                                          -work router_025                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_022.sv"                                          -work router_022                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_021.sv"                                          -work router_021                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_014.sv"                                          -work router_014                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_012.sv"                                          -work router_012                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_010.sv"                                          -work router_010                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_008.sv"                                          -work router_008                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_004.sv"                                          -work router_004                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_002.sv"                                          -work router_002                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router_001.sv"                                          -work router_001                                  
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0_router.sv"                                              -work router                                      
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                    -work FTDI_0_FTDI_avalon_slave_agent_rsp_fifo     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                               -work FTDI_0_FTDI_avalon_slave_agent              
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                        -work FTDI_0_FTDI_avalon_slave_agent              
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                              -work nios2_gen2_0_data_master_agent              
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                         -work nios2_gen2_0_data_master_translator         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                            -work i_tse_pcs_0                                 
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                            -work i_tse_mac                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu.vo"                                                      -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_sysclk.v"                                    -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck.v"                                       -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper.v"                                   -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_mult_cell.v"                                             -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0_cpu_test_bench.v"                                            -work cpu                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0.v"                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                    -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst.v"                                 -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst_test_bench.v"                      -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv"                                             -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_rst.sv"                                                             -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                              -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                         -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                               -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                          -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_irq_mapper.sv"                                          -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0.v"                                    -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter.v"                  -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv" -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_demux.sv"                         -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_demux_001.sv"                     -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_mux.sv"                           -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_cmd_mux_003.sv"                       -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router.sv"                            -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router_001.sv"                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router_002.sv"                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_router_005.sv"                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_rsp_demux_003.sv"                     -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_rsp_mux.sv"                           -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_s0_mm_interconnect_0_rsp_mux_001.sv"                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_no_ifdef_params.v"                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_reg.v"                                                                    -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_bitcheck.v"                                                                      -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/rw_manager_core.sv"                                                                         -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_datamux.v"                                                                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_data_broadcast.v"                                                                -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_data_decoder.v"                                                                  -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ddr2.v"                                                                          -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_di_buffer.v"                                                                     -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_di_buffer_wrap.v"                                                                -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_dm_decoder.v"                                                                    -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/rw_manager_generic.sv"                                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_no_ifdef_params.v"                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_reg.v"                                                                  -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_jumplogic.v"                                                                     -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_lfsr12.v"                                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_lfsr36.v"                                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_lfsr72.v"                                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_pattern_fifo.v"                                                                  -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ram.v"                                                                           -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ram_csr.v"                                                                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_read_datapath.v"                                                                 -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_write_decoder.v"                                                                 -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_data_mgr.sv"                                                                      -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_phy_mgr.sv"                                                                       -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_reg_file.sv"                                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_acv_phase_decode.v"                                                           -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_acv_wrapper.sv"                                                               -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_mgr.sv"                                                                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_reg_file.v"                                                                   -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_siii_phase_decode.v"                                                          -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_siii_wrapper.sv"                                                              -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_sv_phase_decode.v"                                                            -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_sv_wrapper.sv"                                                                -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_clock_pair_generator.v"                                 -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_read_valid_selector.v"                                  -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_addr_cmd_datapath.v"                                    -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_reset.v"                                                -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_acv_ldc.v"                                              -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_memphy.sv"                                              -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_reset_sync.v"                                           -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_new_io_pads.v"                                          -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_fr_cycle_shifter.v"                                     -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_fr_cycle_extender.v"                                    -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_read_datapath.sv"                                       -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_write_datapath.v"                                       -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_simple_ddio_out.sv"                                     -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_phy_csr.sv"                                             -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_iss_probe.v"                                            -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_addr_cmd_pads.v"                                        -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_flop_mem.v"                                             -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0.sv"                                                     -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_p0_altdqdqs.v"                                             -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altdq_dqs2_ddio_3reg_stratixiv.sv"                                                          -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altdq_dqs2_abstract.sv"                                                                     -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altdq_dqs2_cal_delays.sv"                                                                   -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory_pll0.sv"                                                   -work pll0                                        
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_mem_if_dll_stratixiv.sv"                                                             -work dll0                                        
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_mem_if_oct_stratixiv.sv"                                                             -work oct0                                        
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_c0.v"                                                      -work c0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0.v"                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                    -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst.v"                                 -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_no_ifdef_params_sim_cpu_inst_test_bench.v"                      -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv"                                             -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_rst.sv"                                                             -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                              -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                         -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                               -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                          -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_irq_mapper.sv"                                          -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0.v"                                    -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter.v"                  -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv" -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_demux.sv"                         -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_demux_001.sv"                     -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_mux.sv"                           -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_cmd_mux_003.sv"                       -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router.sv"                            -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router_001.sv"                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router_002.sv"                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_router_005.sv"                        -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_rsp_demux_003.sv"                     -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_rsp_mux.sv"                           -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_s0_mm_interconnect_0_rsp_mux_001.sv"                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_no_ifdef_params.v"                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ac_ROM_reg.v"                                                                    -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_bitcheck.v"                                                                      -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/rw_manager_core.sv"                                                                         -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_datamux.v"                                                                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_data_broadcast.v"                                                                -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_data_decoder.v"                                                                  -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ddr2.v"                                                                          -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_di_buffer.v"                                                                     -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_di_buffer_wrap.v"                                                                -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_dm_decoder.v"                                                                    -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/rw_manager_generic.sv"                                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_no_ifdef_params.v"                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_inst_ROM_reg.v"                                                                  -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_jumplogic.v"                                                                     -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_lfsr12.v"                                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_lfsr36.v"                                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_lfsr72.v"                                                                        -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_pattern_fifo.v"                                                                  -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ram.v"                                                                           -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_ram_csr.v"                                                                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_read_datapath.v"                                                                 -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/rw_manager_write_decoder.v"                                                                 -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_data_mgr.sv"                                                                      -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_phy_mgr.sv"                                                                       -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_reg_file.sv"                                                                      -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_acv_phase_decode.v"                                                           -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_acv_wrapper.sv"                                                               -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_mgr.sv"                                                                       -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_reg_file.v"                                                                   -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_siii_phase_decode.v"                                                          -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_siii_wrapper.sv"                                                              -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/sequencer_scc_sv_phase_decode.v"                                                            -work s0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/sequencer_scc_sv_wrapper.sv"                                                                -work s0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/afi_mux_ddrx.v"                                                                             -work m0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_clock_pair_generator.v"                                 -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_read_valid_selector.v"                                  -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_addr_cmd_datapath.v"                                    -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_reset.v"                                                -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_acv_ldc.v"                                              -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_memphy.sv"                                              -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_reset_sync.v"                                           -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_new_io_pads.v"                                          -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_fr_cycle_shifter.v"                                     -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_fr_cycle_extender.v"                                    -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_read_datapath.sv"                                       -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_write_datapath.v"                                       -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_simple_ddio_out.sv"                                     -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_phy_csr.sv"                                             -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_iss_probe.v"                                            -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_addr_cmd_pads.v"                                        -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_flop_mem.v"                                             -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0.sv"                                                     -work p0                                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_p0_altdqdqs.v"                                             -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altdq_dqs2_ddio_3reg_stratixiv.sv"                                                          -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altdq_dqs2_abstract.sv"                                                                     -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altdq_dqs2_cal_delays.sv"                                                                   -work p0                                          
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory_pll0.sv"                                                   -work pll0                                        
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_tristate_controller_aggregator.sv"                                                   -work tda                                         
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                          -work slave_translator                            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_tristate_controller_translator.sv"                                                   -work tdt                                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/write_master.v"                                                                             -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/byte_enable_generator.v"                                                                    -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/ST_to_MM_Adapter.v"                                                                         -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/write_burst_control.v"                                                                      -work write_mstr_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/read_master.v"                                                                              -work read_mstr_internal                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MM_to_ST_Adapter.v"                                                                         -work read_mstr_internal                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/read_burst_control.v"                                                                       -work read_mstr_internal                          
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/dispatcher.v"                                                                               -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/descriptor_buffers.v"                                                                       -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/csr_block.v"                                                                                -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/response_block.v"                                                                           -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/fifo_with_byteenables.v"                                                                    -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/read_signal_breakout.v"                                                                     -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/write_signal_breakout.v"                                                                    -work dispatcher_internal                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                                                  -work rst_controller                              
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                                                -work rst_controller                              
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter_001.vhd"                                                -work avalon_st_adapter_001                       
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_avalon_st_adapter.vhd"                                                    -work avalon_st_adapter                           
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/altera_irq_clock_crosser.sv"                                                                -work irq_synchronizer                            
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_irq_mapper.sv"                                                            -work irq_mapper                                  
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_2.v"                                                      -work mm_interconnect_2                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_1.v"                                                      -work mm_interconnect_1                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_mm_interconnect_0.v"                                                      -work mm_interconnect_0                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_tse_mac.v"                                                                -work tse_mac                                     
  vlogan +v2k -sverilog $USER_DEFINED_COMPILE_OPTIONS                                      "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_tristate_conduit_bridge_0.sv"                                             -work tristate_conduit_bridge_0                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_timer_1us.v"                                                              -work timer_1us                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_timer_1ms.v"                                                              -work timer_1ms                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sysid_qsys.v"                                                             -work sysid_qsys                                  
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sgdma_tx.v"                                                               -work sgdma_tx                                    
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sgdma_rx.v"                                                               -work sgdma_rx                                    
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_sd_dat.v"                                                                 -work sd_dat                                      
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_LED_painel.v"                                                         -work pio_LED_painel                              
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_LED.v"                                                                -work pio_LED                                     
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_EXT.v"                                                                -work pio_EXT                                     
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_DIP.v"                                                                -work pio_DIP                                     
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_pio_BUTTON.v"                                                             -work pio_BUTTON                                  
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_onchip_memory.v"                                                          -work onchip_memory                               
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_nios2_gen2_0.v"                                                           -work nios2_gen2_0                                
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m2_ddr2_memory.v"                                                         -work m2_ddr2_memory                              
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_memory.v"                                                         -work m1_ddr2_memory                              
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_m1_ddr2_i2c_sda.v"                                                        -work m1_ddr2_i2c_sda                             
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_jtag_uart_0.v"                                                            -work jtag_uart_0                                 
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_ext_flash.vhd"                                                            -work ext_flash                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_dma_M2_M1.v"                                                              -work dma_M2_M1                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_dma_M1_M2.v"                                                              -work dma_M1_M2                                   
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_descriptor_memory.v"                                                      -work descriptor_memory                           
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_csense_sdo.v"                                                             -work csense_sdo                                  
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_csense_cs_n.v"                                                            -work csense_cs_n                                 
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/MebX_Qsys_Project_csense_adc_fo.v"                                                          -work csense_adc_fo                               
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_avalon_mm_clock_crossing_bridge.v"                                                   -work clock_bridge_afi_50                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_avalon_dc_fifo.v"                                                                    -work clock_bridge_afi_50                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_dcfifo_synchronizer_bundle.v"                                                        -work clock_bridge_afi_50                         
  vlogan +v2k $USER_DEFINED_COMPILE_OPTIONS                                                "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                            -work clock_bridge_afi_50                         
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/SEVEN_SEG_REGISTER.vhd"                                                                     -work SEVEN_SEGMENT_CONTROLLER_0                  
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/DOUBLE_DABBLE_8BIT.vhd"                                                                     -work SEVEN_SEGMENT_CONTROLLER_0                  
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/SEVEN_SEG_DPS.vhd"                                                                          -work SEVEN_SEGMENT_CONTROLLER_0                  
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/SEVEN_SEG_TOP.vhd"                                                                          -work SEVEN_SEGMENT_CONTROLLER_0                  
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_BIDIR_PIN.vhd"                                                                         -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_BIDIR_BUS.vhd"                                                                         -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_DC_PIN.vhd"                                                                            -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_DC_BUS.vhd"                                                                            -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_REGISTERS_PCK.vhd"                                                                     -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_AVALON_READ.vhd"                                                                       -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_AVALON_WRITE.vhd"                                                                      -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/submodules/FTDI_TOPLEVEL.vhd"                                                                          -work FTDI_0                                      
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/MebX_Qsys_Project.vhd"                                                                                                                                   
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/mebx_qsys_project_rst_controller.vhd"                                                                                                                    
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/mebx_qsys_project_rst_controller_001.vhd"                                                                                                                
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/mebx_qsys_project_rst_controller_002.vhd"                                                                                                                
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/mebx_qsys_project_clock_bridge_afi_50.vhd"                                                                                                               
  vhdlan -xlrm $USER_DEFINED_COMPILE_OPTIONS                                               "$QSYS_SIMDIR/mebx_qsys_project_m1_clock_bridge.vhd"                                                                                                                   
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
