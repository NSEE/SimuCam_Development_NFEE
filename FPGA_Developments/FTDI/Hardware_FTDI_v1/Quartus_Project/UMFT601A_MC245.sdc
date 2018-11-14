#//------------------------------------------------------------------------------
#//
#// SDC file for M245 bus master 
#//             
#//------------------------------------------------------------------------------


create_clock -name FTDImoduleClk -period 10.0 [get_ports {FTDI_CLOCK}]

set_false_path -from [get_ports {FTDI_RESET_N}] -to [get_registers *]
set_false_path -from [get_ports {FTDI_TXE_N}]
set_false_path -to [get_ports {FTDI_SIWU_N FTDI_RD_N FTDI_OE_N FTDI_TXE_N}]

#// Inputs
set_input_delay -clock [get_clocks FTDImoduleClk] -max 7.0 [get_ports {FTDI_RXF_N}]
set_input_delay -clock [get_clocks FTDImoduleClk] -max 7.0  [get_ports {FTDI_BE[*] FTDI_DATA[*]}]
set_input_delay -clock [get_clocks FTDImoduleClk] -add_delay -min 4.0 [get_ports FTDI_RXF_N]
set_input_delay -clock [get_clocks FTDImoduleClk] -add_delay -min 4.0  [get_ports {FTDI_BE[*] FTDI_DATA[*]}]

#// outputs
set_output_delay -clock [get_clocks FTDImoduleClk] -add_delay -max 0.5 [get_ports FTDI_WR_N]
set_output_delay -clock [get_clocks FTDImoduleClk] -add_delay -max 0.5 [get_ports {FTDI_BE[*] FTDI_DATA[*]}]

