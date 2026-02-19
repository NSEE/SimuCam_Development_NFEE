#//------------------------------------------------------------------------------
#//
#// SDC file for bus master 
#//             
#//------------------------------------------------------------------------------
#
create_clock -name fifoClk -period 10.0 [get_ports {CLK}]
#
set_false_path -from [get_ports {SRST_N HRST_N}] -to [get_registers *]
set_false_path -from [get_ports {TXE_N}] -to [get_registers *] 
set_false_path -from [get_ports {R_OOB W_OOB MLTCN STREN ERDIS}] -to [get_registers *]
#
set_false_path -from {mst_fifo_fsm:i1_fsm|be_oe_n} -to {DATA[*]};
set_false_path -from {mst_fifo_fsm:i1_fsm|be_oe_n} -to {BE[*]};
set_false_path -from {mst_fifo_fsm:i1_fsm|dt_oe_n} -to {DATA[*]}
#
set_false_path -to [get_ports {STRER[*] debug_sig[*]}]
set_false_path -to [get_ports {SIWU_N}]
#// Inputs
set_input_delay -clock [get_clocks fifoClk] -max 4  [get_ports {RXF_N TXE_N}]
set_input_delay -clock [get_clocks fifoClk] -max 7  [get_ports {BE[*] DATA[*]}]
set_input_delay -clock [get_clocks fifoClk] -min 3.5  [get_ports {RXF_N TXE_N}]
set_input_delay -clock [get_clocks fifoClk] -min 6.5  [get_ports {BE[*] DATA[*]}]
#// outputs
set_output_delay -clock [get_clocks fifoClk] -max 1.2 [get_ports {WR_N RD_N OE_N}]
set_output_delay -clock [get_clocks fifoClk] -max 1.2 [get_ports {BE[*] DATA[*]}]
set_output_delay -clock [get_clocks fifoClk] -min 0.7 [get_ports {WR_N RD_N OE_N}]
set_output_delay -clock [get_clocks fifoClk] -min 0.7 [get_ports {BE[*] DATA[*]}]
#
