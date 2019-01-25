onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/clk
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/rst
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/rst_n
add wave -noupdate -expand -group testbench_top -color Violet -expand -subitemconfig {/rmap_testbench_top/s_stimuli_spw_tx_flag.ready {-color Violet} /rmap_testbench_top/s_stimuli_spw_tx_flag.error {-color Violet}} sim:/rmap_testbench_top/s_stimuli_spw_tx_flag
add wave -noupdate -expand -group testbench_top -color Violet -childformat {{/rmap_testbench_top/s_stimuli_spw_tx_control.data -radix hexadecimal}} -expand -subitemconfig {/rmap_testbench_top/s_stimuli_spw_tx_control.write {-color Violet} /rmap_testbench_top/s_stimuli_spw_tx_control.flag {-color Violet} /rmap_testbench_top/s_stimuli_spw_tx_control.data {-color Violet -radix hexadecimal}} sim:/rmap_testbench_top/s_stimuli_spw_tx_control
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_spw_control
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_spw_flag
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_mem_control
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_mem_flag
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_mem_wr_byte_address
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_mem_rd_byte_address
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_mem_config_area
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_rmap_mem_hk_area
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_codec_fifo_control
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_codec_fifo_flag
add wave -noupdate -expand -group testbench_top -color Yellow sim:/rmap_testbench_top/s_spw_rxvalid
add wave -noupdate -expand -group testbench_top -color Yellow sim:/rmap_testbench_top/s_spw_rxhalff
add wave -noupdate -expand -group testbench_top -color Yellow sim:/rmap_testbench_top/s_spw_rxflag
add wave -noupdate -expand -group testbench_top -color Yellow -radix hexadecimal sim:/rmap_testbench_top/s_spw_rxdata
add wave -noupdate -expand -group testbench_top -color Yellow sim:/rmap_testbench_top/s_spw_rxread
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_stimuli_di
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_stimuli_si
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_stimuli_do
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_stimuli_so
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_rmap_di
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_rmap_si
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_rmap_do
add wave -noupdate -expand -group testbench_top sim:/rmap_testbench_top/s_spw_codec_rmap_so
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/clk_i
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/reset_n_i
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/spw_flag_i
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/mem_flag_i
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/spw_control_o
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/mem_control_o
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/mem_wr_byte_address_o
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/mem_rd_byte_address_o
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_control
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_flags
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_error
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_rmap_data
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_rmap_error
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_spw_command_rx_control
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_spw_write_rx_control
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_spw_read_tx_control
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_spw_reply_tx_control
add wave -noupdate -expand -group rmap_top sim:/rmap_testbench_top/rmap_target_top_inst/s_rmap_target_user_configs
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/clk
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rxclk
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txclk
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rst
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/autostart
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/linkstart
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/linkdis
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txdivcnt
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/tick_in
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/ctrl_in
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/time_in
add wave -noupdate -group spw_stimuli -color Yellow sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txwrite
add wave -noupdate -group spw_stimuli -color Yellow sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txflag
add wave -noupdate -group spw_stimuli -color Yellow sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txdata
add wave -noupdate -group spw_stimuli -color Yellow sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txrdy
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/txhalff
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/tick_out
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/ctrl_out
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/time_out
add wave -noupdate -group spw_stimuli -color Magenta sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rxvalid
add wave -noupdate -group spw_stimuli -color Magenta sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rxhalff
add wave -noupdate -group spw_stimuli -color Magenta sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rxflag
add wave -noupdate -group spw_stimuli -color Magenta sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rxdata
add wave -noupdate -group spw_stimuli -color Magenta sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rxread
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/started
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/connecting
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/running
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/errdisc
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/errpar
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/erresc
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/errcred
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/spw_di
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/spw_si
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/spw_do
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/spw_so
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/r
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/rin
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/recv_rxen
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/recvo
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/recv_inact
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/recv_inbvalid
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/recv_inbits
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/xmiti
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/xmito
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/xmit_divcnt
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/linki
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/linko
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_rxfifo_raddr
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_rxfifo_rdata
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_rxfifo_wen
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_rxfifo_waddr
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_rxfifo_wdata
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_txfifo_raddr
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_txfifo_rdata
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_txfifo_wen
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_txfifo_waddr
add wave -noupdate -group spw_stimuli sim:/rmap_testbench_top/spw_stimuli_spwstream_inst/s_txfifo_wdata
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/clk
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rxclk
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txclk
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rst
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/autostart
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/linkstart
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/linkdis
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txdivcnt
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/tick_in
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/ctrl_in
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/time_in
add wave -noupdate -group spw_rmap -color Violet sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txwrite
add wave -noupdate -group spw_rmap -color Violet sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txflag
add wave -noupdate -group spw_rmap -color Violet -radix hexadecimal sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txdata
add wave -noupdate -group spw_rmap -color Violet sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txrdy
add wave -noupdate -group spw_rmap -color Violet sim:/rmap_testbench_top/spw_rmap_spwstream_inst/txhalff
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/tick_out
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/ctrl_out
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/time_out
add wave -noupdate -group spw_rmap -color Yellow sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rxvalid
add wave -noupdate -group spw_rmap -color Yellow sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rxhalff
add wave -noupdate -group spw_rmap -color Yellow sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rxflag
add wave -noupdate -group spw_rmap -color Yellow -radix hexadecimal sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rxdata
add wave -noupdate -group spw_rmap -color Yellow sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rxread
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/started
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/connecting
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/running
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/errdisc
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/errpar
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/erresc
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/errcred
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/spw_di
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/spw_si
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/spw_do
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/spw_so
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/r
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/rin
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/recv_rxen
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/recvo
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/recv_inact
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/recv_inbvalid
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/recv_inbits
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/xmiti
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/xmito
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/xmit_divcnt
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/linki
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/linko
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_rxfifo_raddr
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_rxfifo_rdata
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_rxfifo_wen
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_rxfifo_waddr
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_rxfifo_wdata
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_txfifo_raddr
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_txfifo_rdata
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_txfifo_wen
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_txfifo_waddr
add wave -noupdate -group spw_rmap sim:/rmap_testbench_top/spw_rmap_spwstream_inst/s_txfifo_wdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14800532 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 268
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 us}
