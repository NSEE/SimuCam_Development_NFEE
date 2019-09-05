transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/registers/sync_mm_registers_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/outen/sync_outen_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/common/sync_common_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/tb/tb_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/tb/avs_stimuli.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/outen/sync_outen.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/int/sync_int_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/gen/sync_gen_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/avalon/sync_avalon_mm_pkg.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/int/sync_int.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/gen/sync_gen.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/avalon/sync_avalon_mm_write.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/avalon/sync_avalon_mm_read.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync/sync_topfile.vhd}
vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/tb/tb.vhd}

vcom -93 -work work {E:/cassio/repo_simucam/SimuCam_Development/FPGA_Developments/Sync/sync_sim/../tb/tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
