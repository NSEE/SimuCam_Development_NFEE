#//------------------------------------------------------------------------------
#//
#// SDC file for M245 bus master 
#//             
#//------------------------------------------------------------------------------


create_clock -name fifoClk -period 10.0 [get_ports {CLK}]

set_false_path -from [get_ports {RESET_N}] -to [get_registers *]
set_false_path -from [get_ports {TXE_N}]
set_false_path -to [get_ports {sys_led[*] debug_sig}]
set_false_path -to [get_ports {SIWU_N RD_N OE_N TXE_N}]
set_false_path -to [get_ports {debug_sig}]

#// Inputs
set_input_delay -clock [get_clocks fifoClk] -max 7.0 [get_ports {RXF_N}]
set_input_delay -clock [get_clocks fifoClk] -max 7.0  [get_ports {BE[*] DATA[*]}]
set_input_delay -clock [get_clocks fifoClk] -add_delay -min 4.0 [get_ports RXF_N]
set_input_delay -clock [get_clocks fifoClk] -add_delay -min 4.0  [get_ports {BE[*] DATA[*]}]

#// outputs
set_output_delay -clock [get_clocks fifoClk] -add_delay -max 0.5 [get_ports WR_N]
set_output_delay -clock [get_clocks fifoClk] -add_delay -max 0.5 [get_ports {BE[*] DATA[*]}]

#// multicycle paths
set_false_path -from {fifo_mst_fsm:i_fifo_mst_fsm|tp_be_oe*} -to [get_ports {DATA[*] BE[*]}]
set_false_path -from {fifo_mst_fsm:i_fifo_mst_fsm|tp_dt_oe*} -to [get_ports {DATA[*]}]
