## Generated SDC file "MebX_Quartus_Project_DE4_530.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"

## DATE    "Wed May 05 01:13:22 2021"

##
## DEVICE  "EP4SGX530KH40C2"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {umft601a_clk_100mhz} -period 10.000 -waveform { 0.000 5.000 } [get_ports {FTDI_CLOCK}]
create_clock -name {osc_bank_2_50mhz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK2}]
create_clock -name {osc_bank_3_50mhz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK3}]
create_clock -name {osc_bank_4_50mhz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK4}]
create_clock -name {M2_DDR2_dqs[0]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[0]}] -add
create_clock -name {M2_DDR2_dqs[1]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[1]}] -add
create_clock -name {M2_DDR2_dqs[2]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[2]}] -add
create_clock -name {M2_DDR2_dqs[3]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[3]}] -add
create_clock -name {M2_DDR2_dqs[4]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[4]}] -add
create_clock -name {M2_DDR2_dqs[5]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[5]}] -add
create_clock -name {M2_DDR2_dqs[6]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[6]}] -add
create_clock -name {M2_DDR2_dqs[7]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M2_DDR2_dqs[7]}] -add
create_clock -name {M1_DDR2_dqs[0]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[0]}] -add
create_clock -name {M1_DDR2_dqs[1]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[1]}] -add
create_clock -name {M1_DDR2_dqs[2]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[2]}] -add
create_clock -name {M1_DDR2_dqs[3]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[3]}] -add
create_clock -name {M1_DDR2_dqs[4]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[4]}] -add
create_clock -name {M1_DDR2_dqs[5]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[5]}] -add
create_clock -name {M1_DDR2_dqs[6]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[6]}] -add
create_clock -name {M1_DDR2_dqs[7]_IN} -period 2.500 -waveform { 0.000 1.250 } [get_ports {M1_DDR2_dqs[7]}] -add


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk} -source [get_ports {OSC_50_BANK4}] -multiply_by 4 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk} -source [get_ports {OSC_50_BANK4}] -multiply_by 8 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk} -source [get_ports {OSC_50_BANK4}] -multiply_by 4 -phase 270.000 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[3]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk} -source [get_ports {OSC_50_BANK4}] -multiply_by 8 -phase 90.000 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[2]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk} -source [get_ports {OSC_50_BANK4}] -multiply_by 2 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[4]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk} -source [get_ports {OSC_50_BANK4}] -multiply_by 2 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[5]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk} -source [get_ports {OSC_50_BANK4}] -divide_by 2 -master_clock {osc_bank_4_50mhz} [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[6]}] 
create_generated_clock -name {M2_DDR2_clk[0]} -source [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk} [get_ports {M2_DDR2_clk[0]}] 
create_generated_clock -name {M2_DDR2_clk[1]} -source [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk} [get_ports {M2_DDR2_clk[1]}] 
create_generated_clock -name {M2_DDR2_clk_n[0]} -source [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk} -invert [get_ports {M2_DDR2_clk_n[0]}] 
create_generated_clock -name {M2_DDR2_clk_n[1]} -source [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk} -invert [get_ports {M2_DDR2_clk_n[1]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_0} -source [get_ports {M2_DDR2_dqs[0]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[0]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_1} -source [get_ports {M2_DDR2_dqs[1]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[1]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_2} -source [get_ports {M2_DDR2_dqs[2]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[2]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_3} -source [get_ports {M2_DDR2_dqs[3]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[3]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_4} -source [get_ports {M2_DDR2_dqs[4]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[4]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_5} -source [get_ports {M2_DDR2_dqs[5]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[5]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_6} -source [get_ports {M2_DDR2_dqs[6]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[6]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|div_clock_7} -source [get_ports {M2_DDR2_dqs[7]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M2_DDR2_dqs[7]_IN} [get_registers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}] 
create_generated_clock -name {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} -source [get_pins {SOPC_INST|m2_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[2]}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk} [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk}] 
create_generated_clock -name {M2_DDR2_dqs[0]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[0]}] -add
create_generated_clock -name {M2_DDR2_dqs[1]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[1]}] -add
create_generated_clock -name {M2_DDR2_dqs[2]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[2]}] -add
create_generated_clock -name {M2_DDR2_dqs[3]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[3]}] -add
create_generated_clock -name {M2_DDR2_dqs[4]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[4]}] -add
create_generated_clock -name {M2_DDR2_dqs[5]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[5]}] -add
create_generated_clock -name {M2_DDR2_dqs[6]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[6]}] -add
create_generated_clock -name {M2_DDR2_dqs[7]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqs[7]}] -add
create_generated_clock -name {M2_DDR2_dqsn[0]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[0]}] 
create_generated_clock -name {M2_DDR2_dqsn[1]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[1]}] 
create_generated_clock -name {M2_DDR2_dqsn[2]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[2]}] 
create_generated_clock -name {M2_DDR2_dqsn[3]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[3]}] 
create_generated_clock -name {M2_DDR2_dqsn[4]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[4]}] 
create_generated_clock -name {M2_DDR2_dqsn[5]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[5]}] 
create_generated_clock -name {M2_DDR2_dqsn[6]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[6]}] 
create_generated_clock -name {M2_DDR2_dqsn[7]_OUT} -source [get_pins {SOPC_INST|m2_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk} [get_ports {M2_DDR2_dqsn[7]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk} -source [get_ports {OSC_50_BANK3}] -multiply_by 4 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk} -source [get_ports {OSC_50_BANK3}] -multiply_by 8 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk} -source [get_ports {OSC_50_BANK3}] -multiply_by 4 -phase 270.000 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[3]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk} -source [get_ports {OSC_50_BANK3}] -multiply_by 8 -phase 90.000 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[2]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk} -source [get_ports {OSC_50_BANK3}] -multiply_by 2 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[4]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk} -source [get_ports {OSC_50_BANK3}] -multiply_by 2 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[5]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk} -source [get_ports {OSC_50_BANK3}] -divide_by 2 -master_clock {osc_bank_3_50mhz} [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[6]}] 
create_generated_clock -name {M1_DDR2_clk[0]} -source [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk} [get_ports {M1_DDR2_clk[0]}] 
create_generated_clock -name {M1_DDR2_clk[1]} -source [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk} [get_ports {M1_DDR2_clk[1]}] 
create_generated_clock -name {M1_DDR2_clk_n[0]} -source [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk} -invert [get_ports {M1_DDR2_clk_n[0]}] 
create_generated_clock -name {M1_DDR2_clk_n[1]} -source [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[1]}] -master_clock {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk} -invert [get_ports {M1_DDR2_clk_n[1]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_0} -source [get_ports {M1_DDR2_dqs[0]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[0]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_1} -source [get_ports {M1_DDR2_dqs[1]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[1]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_2} -source [get_ports {M1_DDR2_dqs[2]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[2]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_3} -source [get_ports {M1_DDR2_dqs[3]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[3]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_4} -source [get_ports {M1_DDR2_dqs[4]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[4]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_5} -source [get_ports {M1_DDR2_dqs[5]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[5]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_6} -source [get_ports {M1_DDR2_dqs[6]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[6]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|div_clock_7} -source [get_ports {M1_DDR2_dqs[7]}] -divide_by 2 -offset 0.001 -phase 90.000 -master_clock {M1_DDR2_dqs[7]_IN} [get_registers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}] 
create_generated_clock -name {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} -source [get_pins {SOPC_INST|m1_ddr2_memory|pll0|upll_memphy|auto_generated|pll1|clk[2]}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk} [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oe_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|dqs_oct_bar_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|extra_output_pad_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[0].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[1].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[2].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[3].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[4].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[5].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[6].oct_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].data_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oe_alignment|clk SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|output_path_gen[7].oct_alignment|clk}] 
create_generated_clock -name {M1_DDR2_dqs[0]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[0]}] -add
create_generated_clock -name {M1_DDR2_dqs[1]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[1]}] -add
create_generated_clock -name {M1_DDR2_dqs[2]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[2]}] -add
create_generated_clock -name {M1_DDR2_dqs[3]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[3]}] -add
create_generated_clock -name {M1_DDR2_dqs[4]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[4]}] -add
create_generated_clock -name {M1_DDR2_dqs[5]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[5]}] -add
create_generated_clock -name {M1_DDR2_dqs[6]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[6]}] -add
create_generated_clock -name {M1_DDR2_dqs[7]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqs[7]}] -add
create_generated_clock -name {M1_DDR2_dqsn[0]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[0].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[0]}] 
create_generated_clock -name {M1_DDR2_dqsn[1]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[1].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[1]}] 
create_generated_clock -name {M1_DDR2_dqsn[2]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[2].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[2]}] 
create_generated_clock -name {M1_DDR2_dqsn[3]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[3].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[3]}] 
create_generated_clock -name {M1_DDR2_dqsn[4]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[4].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[4]}] 
create_generated_clock -name {M1_DDR2_dqsn[5]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[5].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[5]}] 
create_generated_clock -name {M1_DDR2_dqsn[6]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[6].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[6]}] 
create_generated_clock -name {M1_DDR2_dqsn[7]_OUT} -source [get_pins {SOPC_INST|m1_ddr2_memory|p0|umemphy|uio_pads|dq_ddio[7].ubidir_dq_dqs|altdq_dqs2_inst|obuf_os_bar_0|o}] -phase 90.000 -master_clock {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk} [get_ports {M1_DDR2_dqsn[7]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M2_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[7]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[6]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[5]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[4]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[3]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[2]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[1]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_2_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk_n[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_mem_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {M1_DDR2_dqs[0]_IN}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|MebX_Qsys_Project_m2_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M2_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M2_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M2_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M2_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_config_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M1_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M1_DDR2_clk[1]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {M1_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {M1_DDR2_clk[0]}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.050  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|MebX_Qsys_Project_m1_ddr2_memory_p0_leveling_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[7]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[6]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[5]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[4]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[3]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[2]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[1]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {M1_DDR2_dqs[0]_IN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_addr_cmd_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -rise_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -fall_to [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_BE[0]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_BE[0]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_BE[1]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_BE[1]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_BE[2]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_BE[2]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_BE[3]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_BE[3]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[0]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[0]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[1]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[1]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[2]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[2]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[3]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[3]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[4]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[4]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[5]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[5]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[6]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[6]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[7]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[7]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[8]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[8]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[9]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[9]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[10]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[10]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[11]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[11]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[12]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[12]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[13]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[13]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[14]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[14]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[15]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[15]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[16]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[16]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[17]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[17]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[18]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[18]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[19]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[19]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[20]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[20]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[21]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[21]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[22]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[22]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[23]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[23]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[24]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[24]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[25]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[25]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[26]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[26]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[27]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[27]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[28]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[28]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[29]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[29]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[30]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[30]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_DATA[31]}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_DATA[31]}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_RXF_N}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_RXF_N}]
set_input_delay -add_delay -max -clock [get_clocks {umft601a_clk_100mhz}]  7.000 [get_ports {FTDI_TXE_N}]
set_input_delay -add_delay -min -clock [get_clocks {umft601a_clk_100mhz}]  4.000 [get_ports {FTDI_TXE_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWA_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWA_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWA_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWA_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWA_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWA_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWA_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWA_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWB_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWB_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWB_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWB_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWB_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWB_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWB_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWB_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWC_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWC_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWC_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWC_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWC_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWC_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWC_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWC_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWD_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWD_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWD_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWD_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWD_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWD_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWD_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWD_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWE_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWE_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWE_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWE_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWE_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWE_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWE_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWE_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWF_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWF_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWF_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWF_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWF_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWF_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWF_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWF_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWG_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWG_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWG_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWG_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWG_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWG_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWG_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWG_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWH_DI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWH_DI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWH_DI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWH_DI_P}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWH_SI_N}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWH_SI_N}]
set_input_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_RX_SPWH_SI_P}]
set_input_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_RX_SPWH_SI_P}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[0]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[0]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[1]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[1]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[2]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[2]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[3]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[3]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[4]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[4]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[5]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[5]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[6]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[6]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  0.324 [get_ports {M1_DDR2_dq[7]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M1_DDR2_dq[7]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[8]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[8]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[9]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[9]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[10]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[10]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[11]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[11]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[12]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[12]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[13]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[13]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[14]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[14]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  0.324 [get_ports {M1_DDR2_dq[15]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M1_DDR2_dq[15]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[16]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[16]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[17]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[17]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[18]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[18]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[19]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[19]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[20]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[20]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[21]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[21]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[22]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[22]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  0.324 [get_ports {M1_DDR2_dq[23]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M1_DDR2_dq[23]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[24]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[24]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[25]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[25]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[26]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[26]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[27]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[27]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[28]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[28]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[29]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[29]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[30]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[30]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  0.324 [get_ports {M1_DDR2_dq[31]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M1_DDR2_dq[31]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[32]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[32]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[33]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[33]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[34]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[34]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[35]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[35]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[36]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[36]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[37]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[37]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[38]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[38]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  0.324 [get_ports {M1_DDR2_dq[39]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M1_DDR2_dq[39]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[40]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[40]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[41]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[41]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[42]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[42]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[43]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[43]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[44]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[44]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[45]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[45]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[46]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[46]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  0.324 [get_ports {M1_DDR2_dq[47]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M1_DDR2_dq[47]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[48]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[48]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[49]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[49]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[50]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[50]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[51]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[51]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[52]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[52]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[53]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[53]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[54]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[54]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  0.324 [get_ports {M1_DDR2_dq[55]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M1_DDR2_dq[55]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[56]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[56]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[57]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[57]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[58]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[58]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[59]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[59]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[60]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[60]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[61]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[61]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[62]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[62]}]
set_input_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  0.324 [get_ports {M1_DDR2_dq[63]}]
set_input_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M1_DDR2_dq[63]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[0]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[0]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[1]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[1]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[2]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[2]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[3]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[3]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[4]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[4]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[5]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[5]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[6]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[6]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  0.324 [get_ports {M2_DDR2_dq[7]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_IN}]  -0.474 [get_ports {M2_DDR2_dq[7]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[8]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[8]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[9]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[9]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[10]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[10]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[11]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[11]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[12]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[12]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[13]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[13]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[14]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[14]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  0.324 [get_ports {M2_DDR2_dq[15]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_IN}]  -0.474 [get_ports {M2_DDR2_dq[15]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[16]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[16]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[17]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[17]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[18]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[18]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[19]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[19]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[20]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[20]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[21]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[21]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[22]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[22]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  0.324 [get_ports {M2_DDR2_dq[23]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_IN}]  -0.474 [get_ports {M2_DDR2_dq[23]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[24]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[24]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[25]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[25]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[26]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[26]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[27]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[27]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[28]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[28]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[29]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[29]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[30]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[30]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  0.324 [get_ports {M2_DDR2_dq[31]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_IN}]  -0.474 [get_ports {M2_DDR2_dq[31]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[32]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[32]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[33]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[33]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[34]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[34]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[35]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[35]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[36]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[36]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[37]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[37]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[38]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[38]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  0.324 [get_ports {M2_DDR2_dq[39]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_IN}]  -0.474 [get_ports {M2_DDR2_dq[39]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[40]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[40]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[41]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[41]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[42]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[42]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[43]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[43]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[44]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[44]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[45]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[45]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[46]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[46]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  0.324 [get_ports {M2_DDR2_dq[47]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_IN}]  -0.474 [get_ports {M2_DDR2_dq[47]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[48]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[48]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[49]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[49]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[50]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[50]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[51]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[51]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[52]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[52]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[53]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[53]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[54]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[54]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  0.324 [get_ports {M2_DDR2_dq[55]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_IN}]  -0.474 [get_ports {M2_DDR2_dq[55]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[56]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[56]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[57]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[57]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[58]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[58]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[59]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[59]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[60]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[60]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[61]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[61]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[62]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[62]}]
set_input_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  0.324 [get_ports {M2_DDR2_dq[63]}]
set_input_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_IN}]  -0.474 [get_ports {M2_DDR2_dq[63]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[0]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[1]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[2]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[3]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[0]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[1]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[2]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[3]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[4]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[5]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[6]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[7]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[8]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[9]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[10]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[11]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[12]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[13]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[14]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[15]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[16]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[17]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[18]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[19]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[20]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[21]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[22]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[23]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[24]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[25]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[26]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[27]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[28]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[29]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[30]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[31]}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_OE_N}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_RD_N}]
set_output_delay -add_delay  -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_WR_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWA_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWA_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWA_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWA_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWA_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWA_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWA_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWA_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWB_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWB_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWB_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWB_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWB_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWB_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWB_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWB_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWC_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWC_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWC_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWC_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWC_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWC_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWC_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWC_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWD_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWD_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWD_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWD_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWD_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWD_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWD_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWD_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWE_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWE_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWE_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWE_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWE_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWE_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWE_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWE_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWF_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWF_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWF_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWF_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWF_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWF_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWF_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWF_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWG_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWG_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWG_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWG_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWG_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWG_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWG_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWG_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWH_DO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWH_DO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWH_DO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWH_DO_P}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWH_SO_N}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWH_SO_N}]
set_output_delay -add_delay -max -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  4.000 [get_ports {HSMB_LVDS_TX_SPWH_SO_P}]
set_output_delay -add_delay -min -clock [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  1.000 [get_ports {HSMB_LVDS_TX_SPWH_SO_P}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_addr[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_addr[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_addr[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_addr[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_ba[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_ba[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_ba[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_ba[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_ba[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_ba[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_ba[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_ba[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_ba[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_ba[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_ba[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_ba[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_cas_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_cas_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_cas_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_cas_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_cke[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_cke[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_cke[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_cke[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_cke[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_cke[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_cke[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_cke[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_cs_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_cs_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_cs_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_cs_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_cs_n[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_cs_n[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_cs_n[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_cs_n[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dm[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dm[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dm[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dm[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dm[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dm[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dm[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dm[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dm[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dm[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dm[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dm[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dm[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dm[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dm[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dm[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dm[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M1_DDR2_dq[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[14]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[14]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[14]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[14]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[15]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[15]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M1_DDR2_dq[15]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[15]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[16]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[16]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[16]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[16]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[17]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[17]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[17]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[17]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[18]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[18]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[18]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[18]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[19]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[19]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[19]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[19]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[20]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[20]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[20]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[20]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[21]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[21]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[21]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[21]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[22]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[22]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[22]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[22]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[23]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[23]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M1_DDR2_dq[23]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[23]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[24]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[24]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[24]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[24]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[25]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[25]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[25]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[25]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[26]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[26]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[26]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[26]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[27]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[27]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[27]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[27]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[28]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[28]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[28]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[28]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[29]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[29]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[29]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[29]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[30]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[30]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[30]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[30]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[31]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[31]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M1_DDR2_dq[31]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[31]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[32]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[32]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[32]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[32]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[33]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[33]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[33]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[33]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[34]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[34]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[34]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[34]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[35]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[35]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[35]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[35]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[36]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[36]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[36]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[36]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[37]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[37]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[37]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[37]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[38]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[38]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[38]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[38]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[39]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[39]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M1_DDR2_dq[39]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[39]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[40]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[40]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[40]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[40]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[41]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[41]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[41]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[41]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[42]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[42]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[42]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[42]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[43]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[43]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[43]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[43]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[44]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[44]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[44]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[44]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[45]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[45]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[45]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[45]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[46]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[46]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[46]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[46]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[47]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[47]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M1_DDR2_dq[47]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[47]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[48]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[48]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[48]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[48]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[49]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[49]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[49]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[49]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[50]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[50]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[50]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[50]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[51]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[51]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[51]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[51]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[52]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[52]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[52]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[52]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[53]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[53]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[53]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[53]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[54]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[54]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[54]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[54]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[55]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[55]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M1_DDR2_dq[55]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[55]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[56]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[56]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[56]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[56]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[57]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[57]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[57]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[57]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[58]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[58]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[58]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[58]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[59]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[59]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[59]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[59]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[60]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[60]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[60]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[60]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[61]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[61]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[61]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[61]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[62]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[62]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[62]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[62]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[63]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[63]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M1_DDR2_dq[63]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M1_DDR2_dq[63]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_odt[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_odt[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_odt[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_odt[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_odt[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_odt[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_odt[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_odt[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_ras_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_ras_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_ras_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_ras_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[1]}]  1.195 [get_ports {M1_DDR2_we_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[1]}]  0.080 [get_ports {M1_DDR2_we_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M1_DDR2_clk[0]}]  1.195 [get_ports {M1_DDR2_we_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M1_DDR2_clk[0]}]  0.080 [get_ports {M1_DDR2_we_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_addr[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_addr[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_addr[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_addr[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_ba[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_ba[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_ba[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_ba[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_ba[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_ba[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_ba[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_ba[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_ba[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_ba[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_ba[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_ba[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_cas_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_cas_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_cas_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_cas_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_cke[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_cke[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_cke[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_cke[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_cke[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_cke[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_cke[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_cke[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_cs_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_cs_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_cs_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_cs_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_cs_n[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_cs_n[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_cs_n[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_cs_n[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dm[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dm[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dm[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dm[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dm[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dm[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dm[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dm[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dm[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dm[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dm[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dm[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dm[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dm[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dm[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dm[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dm[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[2]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[2]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[3]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[3]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[4]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[4]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[5]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[5]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[6]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[6]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  0.643 [get_ports {M2_DDR2_dq[7]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[0]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[7]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[8]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[8]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[9]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[9]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[10]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[10]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[11]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[11]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[12]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[12]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[13]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[13]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[14]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[14]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[14]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[14]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[15]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[15]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  0.643 [get_ports {M2_DDR2_dq[15]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[1]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[15]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[16]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[16]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[16]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[16]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[17]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[17]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[17]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[17]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[18]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[18]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[18]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[18]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[19]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[19]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[19]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[19]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[20]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[20]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[20]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[20]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[21]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[21]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[21]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[21]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[22]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[22]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[22]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[22]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[23]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[23]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  0.643 [get_ports {M2_DDR2_dq[23]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[2]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[23]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[24]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[24]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[24]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[24]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[25]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[25]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[25]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[25]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[26]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[26]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[26]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[26]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[27]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[27]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[27]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[27]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[28]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[28]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[28]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[28]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[29]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[29]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[29]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[29]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[30]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[30]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[30]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[30]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[31]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[31]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  0.643 [get_ports {M2_DDR2_dq[31]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[3]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[31]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[32]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[32]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[32]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[32]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[33]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[33]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[33]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[33]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[34]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[34]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[34]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[34]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[35]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[35]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[35]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[35]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[36]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[36]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[36]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[36]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[37]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[37]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[37]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[37]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[38]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[38]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[38]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[38]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[39]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[39]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  0.643 [get_ports {M2_DDR2_dq[39]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[4]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[39]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[40]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[40]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[40]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[40]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[41]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[41]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[41]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[41]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[42]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[42]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[42]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[42]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[43]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[43]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[43]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[43]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[44]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[44]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[44]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[44]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[45]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[45]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[45]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[45]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[46]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[46]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[46]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[46]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[47]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[47]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  0.643 [get_ports {M2_DDR2_dq[47]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[5]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[47]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[48]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[48]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[48]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[48]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[49]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[49]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[49]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[49]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[50]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[50]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[50]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[50]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[51]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[51]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[51]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[51]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[52]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[52]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[52]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[52]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[53]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[53]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[53]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[53]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[54]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[54]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[54]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[54]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[55]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[55]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  0.643 [get_ports {M2_DDR2_dq[55]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[6]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[55]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[56]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[56]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[56]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[56]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[57]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[57]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[57]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[57]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[58]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[58]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[58]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[58]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[59]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[59]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[59]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[59]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[60]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[60]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[60]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[60]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[61]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[61]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[61]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[61]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[62]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[62]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[62]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[62]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[63]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqsn[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[63]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  0.643 [get_ports {M2_DDR2_dq[63]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_dqs[7]_OUT}]  -0.531 [get_ports {M2_DDR2_dq[63]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_odt[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_odt[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_odt[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_odt[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_odt[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_odt[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_odt[1]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_odt[1]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_ras_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_ras_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_ras_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_ras_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[0]}]  1.195 [get_ports {M2_DDR2_we_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[0]}]  0.080 [get_ports {M2_DDR2_we_n[0]}]
set_output_delay -add_delay -max -clock [get_clocks {M2_DDR2_clk[1]}]  1.195 [get_ports {M2_DDR2_we_n[0]}]
set_output_delay -add_delay -min -clock [get_clocks {M2_DDR2_clk[1]}]  0.080 [get_ports {M2_DDR2_we_n[0]}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[0]_IN SOPC_INST|m2_ddr2_memory|div_clock_0}] -group [get_clocks {M2_DDR2_dqs[0]_OUT M2_DDR2_dqsn[0]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[1]_IN SOPC_INST|m2_ddr2_memory|div_clock_1}] -group [get_clocks {M2_DDR2_dqs[1]_OUT M2_DDR2_dqsn[1]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[2]_IN SOPC_INST|m2_ddr2_memory|div_clock_2}] -group [get_clocks {M2_DDR2_dqs[2]_OUT M2_DDR2_dqsn[2]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[3]_IN SOPC_INST|m2_ddr2_memory|div_clock_3}] -group [get_clocks {M2_DDR2_dqs[3]_OUT M2_DDR2_dqsn[3]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[4]_IN SOPC_INST|m2_ddr2_memory|div_clock_4}] -group [get_clocks {M2_DDR2_dqs[4]_OUT M2_DDR2_dqsn[4]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[5]_IN SOPC_INST|m2_ddr2_memory|div_clock_5}] -group [get_clocks {M2_DDR2_dqs[5]_OUT M2_DDR2_dqsn[5]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[6]_IN SOPC_INST|m2_ddr2_memory|div_clock_6}] -group [get_clocks {M2_DDR2_dqs[6]_OUT M2_DDR2_dqsn[6]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M2_DDR2_dqs[7]_IN SOPC_INST|m2_ddr2_memory|div_clock_7}] -group [get_clocks {M2_DDR2_dqs[7]_OUT M2_DDR2_dqsn[7]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[0]_IN SOPC_INST|m1_ddr2_memory|div_clock_0}] -group [get_clocks {M1_DDR2_dqs[0]_OUT M1_DDR2_dqsn[0]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[1]_IN SOPC_INST|m1_ddr2_memory|div_clock_1}] -group [get_clocks {M1_DDR2_dqs[1]_OUT M1_DDR2_dqsn[1]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[2]_IN SOPC_INST|m1_ddr2_memory|div_clock_2}] -group [get_clocks {M1_DDR2_dqs[2]_OUT M1_DDR2_dqsn[2]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[3]_IN SOPC_INST|m1_ddr2_memory|div_clock_3}] -group [get_clocks {M1_DDR2_dqs[3]_OUT M1_DDR2_dqsn[3]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[4]_IN SOPC_INST|m1_ddr2_memory|div_clock_4}] -group [get_clocks {M1_DDR2_dqs[4]_OUT M1_DDR2_dqsn[4]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[5]_IN SOPC_INST|m1_ddr2_memory|div_clock_5}] -group [get_clocks {M1_DDR2_dqs[5]_OUT M1_DDR2_dqsn[5]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[6]_IN SOPC_INST|m1_ddr2_memory|div_clock_6}] -group [get_clocks {M1_DDR2_dqs[6]_OUT M1_DDR2_dqsn[6]_OUT}] 
set_clock_groups -physically_exclusive -group [get_clocks {M1_DDR2_dqs[7]_IN SOPC_INST|m1_ddr2_memory|div_clock_7}] -group [get_clocks {M1_DDR2_dqs[7]_OUT M1_DDR2_dqsn[7]_OUT}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_0}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_1}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_2}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_3}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_4}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_5}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_6}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|div_clock_7}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_write_clk}]  -to  [get_clocks {*_IN}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]
set_false_path  -from  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_avl_clk}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_0}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_1}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_2}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_3}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_4}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_5}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_6}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|div_clock_7}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_write_clk}]  -to  [get_clocks {*_IN}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]
set_false_path  -from  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}]  -to  [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_avl_clk}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read}] -to [get_registers {*|alt_jtag_atlantic:*|read1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|tck_t_dav}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write}] -to [get_registers {*|alt_jtag_atlantic:*|write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_dd9:dffpipe13|dffe14a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_cd9:dffpipe10|dffe11a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_fd9:dffpipe8|dffe9a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_ed9:dffpipe5|dffe6a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_te9:dffpipe18|dffe19a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_se9:dffpipe15|dffe16a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_id9:dffpipe13|dffe14a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe10|dffe11a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_kd9:dffpipe13|dffe14a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_jd9:dffpipe10|dffe11a*}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_break:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck|*sr[33]}]
set_false_path -from [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck|*sr[0]}]
set_false_path -from [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck|*sr[34]}]
set_false_path -from [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_ocimem:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_tck|*sr*}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_sysclk:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_wrapper|MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_sysclk:the_MebX_Qsys_Project_nios2_gen2_0_cpu_debug_slave_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*MebX_Qsys_Project_nios2_gen2_0_cpu:*|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci|MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug:the_MebX_Qsys_Project_nios2_gen2_0_cpu_nios2_oci_debug|monitor_go}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|enable_ctrl~DQS_ENABLE_OUT_DFF}] -to [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|dqs_enable_block~DFFIN}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|enable_ctrl~DFFEXTENDDQSENABLE}] -to [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|dqs_enable_block~DFFIN}]
set_false_path -to [get_ports {M2_DDR2_dqs[0]}]
set_false_path -to [get_ports {M2_DDR2_dqs[1]}]
set_false_path -to [get_ports {M2_DDR2_dqs[2]}]
set_false_path -to [get_ports {M2_DDR2_dqs[3]}]
set_false_path -to [get_ports {M2_DDR2_dqs[4]}]
set_false_path -to [get_ports {M2_DDR2_dqs[5]}]
set_false_path -to [get_ports {M2_DDR2_dqs[6]}]
set_false_path -to [get_ports {M2_DDR2_dqs[7]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[0]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[1]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[2]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[3]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[4]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[5]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[6]}]
set_false_path -to [get_ports {M2_DDR2_dqsn[7]}]
set_false_path -to [get_ports {M2_DDR2_clk[0]}]
set_false_path -to [get_ports {M2_DDR2_clk[1]}]
set_false_path -to [get_ports {M2_DDR2_clk_n[0]}]
set_false_path -to [get_ports {M2_DDR2_clk_n[1]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}]
set_false_path -from [get_clocks {SOPC_INST|m2_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}]
set_false_path -from [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].read_subgroup[*].uread_fifo*|data_stored[*][*]}] -to [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].uread_fifo*|rd_data[*]}]
set_false_path -from [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|afi_half_clk_reg}] -to [get_keepers {SOPC_INST|m2_ddr2_memory|p0|umemphy|afi_half_clk_reg}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|enable_ctrl~DQS_ENABLE_OUT_DFF}] -to [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|dqs_enable_block~DFFIN}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|enable_ctrl~DFFEXTENDDQSENABLE}] -to [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|dqs_enable_block~DFFIN}]
set_false_path -to [get_ports {M1_DDR2_dqs[0]}]
set_false_path -to [get_ports {M1_DDR2_dqs[1]}]
set_false_path -to [get_ports {M1_DDR2_dqs[2]}]
set_false_path -to [get_ports {M1_DDR2_dqs[3]}]
set_false_path -to [get_ports {M1_DDR2_dqs[4]}]
set_false_path -to [get_ports {M1_DDR2_dqs[5]}]
set_false_path -to [get_ports {M1_DDR2_dqs[6]}]
set_false_path -to [get_ports {M1_DDR2_dqs[7]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[0]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[1]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[2]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[3]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[4]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[5]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[6]}]
set_false_path -to [get_ports {M1_DDR2_dqsn[7]}]
set_false_path -to [get_ports {M1_DDR2_clk[0]}]
set_false_path -to [get_ports {M1_DDR2_clk[1]}]
set_false_path -to [get_ports {M1_DDR2_clk_n[0]}]
set_false_path -to [get_ports {M1_DDR2_clk_n[1]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[0]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[1]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[2]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[3]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[4]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[5]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[6]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}]
set_false_path -from [get_clocks {SOPC_INST|m1_ddr2_memory|pll0|pll_afi_half_clk}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}]
set_false_path -from [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:s0|*}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|uread_datapath|read_capture_clk_div2[7]}]
set_false_path -from [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].read_subgroup[*].uread_fifo*|data_stored[*][*]}] -to [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].uread_fifo*|rd_data[*]}]
set_false_path -from [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|afi_half_clk_reg}] -to [get_keepers {SOPC_INST|m1_ddr2_memory|p0|umemphy|afi_half_clk_reg}]


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel}] -to [remove_from_collection [get_keepers *] [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel *:SOPC_INST|*:m2_ddr2_memory|*p0|*altdq_dqs2_inst|oct_*reg*}]] 3
set_multicycle_path -hold -end -from [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel}] -to [remove_from_collection [get_keepers *] [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel *:SOPC_INST|*:m2_ddr2_memory|*p0|*altdq_dqs2_inst|oct_*reg*}]] 2
set_multicycle_path -setup -end -to [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*p0|*umemphy|*uio_pads|*uaddr_cmd_pads|*clock_gen[*].umem_ck_pad|*}] 4
set_multicycle_path -hold -end -to [get_registers {*:SOPC_INST|*:m2_ddr2_memory|*p0|*umemphy|*uio_pads|*uaddr_cmd_pads|*clock_gen[*].umem_ck_pad|*}] 4
set_multicycle_path -setup -end -from [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel}] -to [remove_from_collection [get_keepers *] [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel *:SOPC_INST|*:m1_ddr2_memory|*p0|*altdq_dqs2_inst|oct_*reg*}]] 3
set_multicycle_path -hold -end -from [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel}] -to [remove_from_collection [get_keepers *] [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*s0|*sequencer_phy_mgr_inst|phy_mux_sel *:SOPC_INST|*:m1_ddr2_memory|*p0|*altdq_dqs2_inst|oct_*reg*}]] 2
set_multicycle_path -setup -end -to [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*p0|*umemphy|*uio_pads|*uaddr_cmd_pads|*clock_gen[*].umem_ck_pad|*}] 4
set_multicycle_path -hold -end -to [get_registers {*:SOPC_INST|*:m1_ddr2_memory|*p0|*umemphy|*uio_pads|*uaddr_cmd_pads|*clock_gen[*].umem_ck_pad|*}] 4


#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}] 100.000
set_max_delay -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}] 100.000
set_max_delay -from [get_ports {M2_DDR2_dq[0]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[1]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[2]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[3]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[4]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[5]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[6]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[7]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[8]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[9]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[10]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[11]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[12]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[13]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[14]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[15]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[16]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[17]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[18]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[19]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[20]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[21]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[22]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[23]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[24]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[25]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[26]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[27]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[28]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[29]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[30]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[31]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[32]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[33]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[34]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[35]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[36]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[37]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[38]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[39]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[40]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[41]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[42]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[43]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[44]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[45]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[46]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[47]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[48]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[49]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[50]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[51]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[52]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[53]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[54]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[55]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[56]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[57]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[58]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[59]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[60]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[61]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[62]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M2_DDR2_dq[63]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_registers {*:SOPC_INST|*:m2_ddr2_memory*read_data_out*}] -to [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].read_subgroup[*].uread_fifo*|data_stored[*][*]}] -0.050
set_max_delay -from [get_ports {M1_DDR2_dq[0]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[1]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[2]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[3]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[4]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[5]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[6]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[7]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[8]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[9]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[10]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[11]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[12]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[13]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[14]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[15]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[16]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[17]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[18]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[19]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[20]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[21]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[22]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[23]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[24]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[25]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[26]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[27]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[28]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[29]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[30]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[31]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[32]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[33]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[34]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[35]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[36]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[37]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[38]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[39]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[40]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[41]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[42]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[43]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[44]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[45]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[46]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[47]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[48]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[49]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[50]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[51]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[52]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[53]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[54]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[55]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[56]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[57]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[58]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[59]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[60]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[61]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[62]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_ports {M1_DDR2_dq[63]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] 0.000
set_max_delay -from [get_registers {*:SOPC_INST|*:m1_ddr2_memory*read_data_out*}] -to [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].read_subgroup[*].uread_fifo*|data_stored[*][*]}] -0.050
set_max_delay -from [get_registers {*|in_wr_ptr_gray[*]}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] 100.000
set_max_delay -from [get_registers {*|out_rd_ptr_gray[*]}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] 100.000


#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}] -100.000
set_min_delay -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}] -100.000
set_min_delay -from [get_ports {M2_DDR2_dq[0]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[1]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[2]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[3]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[4]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[5]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[6]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[7]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[8]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[9]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[10]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[11]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[12]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[13]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[14]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[15]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[16]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[17]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[18]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[19]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[20]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[21]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[22]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[23]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[24]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[25]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[26]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[27]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[28]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[29]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[30]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[31]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[32]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[33]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[34]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[35]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[36]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[37]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[38]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[39]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[40]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[41]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[42]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[43]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[44]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[45]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[46]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[47]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[48]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[49]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[50]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[51]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[52]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[53]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[54]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[55]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[56]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[57]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[58]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[59]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[60]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[61]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[62]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M2_DDR2_dq[63]}] -to [get_keepers {{*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_registers {*:SOPC_INST|*:m2_ddr2_memory*read_data_out*}] -to [get_keepers {*:SOPC_INST|*:m2_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].read_subgroup[*].uread_fifo*|data_stored[*][*]}] -2.300
set_min_delay -from [get_ports {M1_DDR2_dq[0]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[1]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[2]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[3]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[4]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[5]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[6]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[7]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[8]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[9]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[10]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[11]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[12]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[13]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[14]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[15]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[16]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[17]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[18]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[19]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[20]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[21]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[22]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[23]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[24]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[25]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[26]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[27]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[28]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[29]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[30]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[31]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[32]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[33]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[34]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[35]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[36]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[37]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[38]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[39]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[40]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[41]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[42]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[43]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[44]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[45]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[46]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[47]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[48]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[49]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[50]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[51]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[52]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[53]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[54]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[55]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[56]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[57]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[58]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[59]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[60]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[61]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[62]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_ports {M1_DDR2_dq[63]}] -to [get_keepers {{*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*input_path_gen[*].capture_reg*} {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uio_pads|*:dq_ddio[*].ubidir_dq_dqs|*:altdq_dqs2_inst|*read_data_out[*]}}] -1.250
set_min_delay -from [get_registers {*:SOPC_INST|*:m1_ddr2_memory*read_data_out*}] -to [get_keepers {*:SOPC_INST|*:m1_ddr2_memory|*:p0|*:umemphy|*:uread_datapath|*:read_buffering[*].read_subgroup[*].uread_fifo*|data_stored[*][*]}] -2.300
set_min_delay -from [get_registers {*|in_wr_ptr_gray[*]}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] -100.000
set_min_delay -from [get_registers {*|out_rd_ptr_gray[*]}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] -100.000


#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Net Delay
#**************************************************************

set_net_delay -max 2.000 -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}]
set_net_delay -max 2.000 -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}]
set_net_delay -max 2.000 -from [get_pins -compatibility_mode {*|in_wr_ptr_gray[*]*}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}]
set_net_delay -max 2.000 -from [get_pins -compatibility_mode {*|out_rd_ptr_gray[*]*}] -to [get_registers {*|altera_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}]
