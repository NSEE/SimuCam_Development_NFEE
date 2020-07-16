## Generated SDC file "MebX_Quartus_Project_DE4_230.out.sdc"

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

## DATE    "Thu Jul 16 00:09:31 2020"

##
## DEVICE  "EP4SGX230KF40C2"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {umft601a_clk_100mhz} -period 10.000 -waveform { 0.000 5.000 } [get_ports {FTDI_CLOCK}]
create_clock -name {osc_bank_2_50mhz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK2}]
create_clock -name {osc_bank_3_50mhz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK3}]
create_clock -name {osc_bank_4_50mhz} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK4}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_3_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_3_50mhz}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.060  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {osc_bank_4_50mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {osc_bank_4_50mhz}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -rise_to [get_clocks {umft601a_clk_100mhz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {umft601a_clk_100mhz}] -fall_to [get_clocks {umft601a_clk_100mhz}]  0.020  


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


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[0]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[1]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[2]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_BE[3]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[0]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[1]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[2]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[3]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[4]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[5]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[6]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[7]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[8]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[9]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[10]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[11]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[12]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[13]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[14]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[15]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[16]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[17]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[18]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[19]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[20]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[21]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[22]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[23]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[24]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[25]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[26]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[27]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[28]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[29]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[30]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_DATA[31]}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_OE_N}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_RD_N}]
set_output_delay -add_delay -clock [get_clocks {umft601a_clk_100mhz}]  0.500 [get_ports {FTDI_WR_N}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

