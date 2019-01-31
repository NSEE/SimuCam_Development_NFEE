@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "Communications_Module_v1_8" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\Communications_Module_v1_8" /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "..\Development" "..\..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "COMM_Pedreiro_v1_01_hw.tcl" /R:0 /W:0 /NJH /NJS
REM Copia dos arquivos individuais para o Qsys_Project >> MebX_Qsys_Project >> synthesis >> submodules
ROBOCOPY "Communications_Module_v1_8/REGISTERS" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "avalon_mm_spacewire_registers_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/AVALON_SPACEWIRE_REGISTERS" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "avalon_mm_spacewire_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/AVALON_SPACEWIRE_REGISTERS" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "avalon_mm_spacewire_read_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/AVALON_SPACEWIRE_REGISTERS" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "avalon_mm_spacewire_write_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/AVALON_WINDOWING_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "avalon_mm_windowing_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/AVALON_WINDOWING_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "avalon_mm_windowing_write_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/WINDOWING_BUFFER/altera_ipcore/scfifo/windowing_data_sc_fifo" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "windowing_data_sc_fifo.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/WINDOWING_BUFFER/altera_ipcore/scfifo/windowing_mask_sc_fifo" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "windowing_mask_sc_fifo.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/WINDOWING_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "windowing_fifo_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/WINDOWING_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "windowing_data_fifo_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/WINDOWING_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "windowing_mask_fifo_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/WINDOWING_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "windowing_buffer_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/DATA_CONTROLLER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "data_controller_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwpkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "syncdff.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwram.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwrecv.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "streamtest.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwxmit.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwstream.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwrecvfront_generic.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwrecvfront_fast.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwlink.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC/spacewire_light_codec" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spwxmit_fast.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spw_codec_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CODEC" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spw_codec.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_MUX" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spw_mux_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CLK_SYNCHRONIZATION/altera_ipcore/dcfifo/spw_data_dc_fifo" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spw_data_dc_fifo.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CLK_SYNCHRONIZATION/altera_ipcore/dcfifo/spw_timecode_dc_fifo" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spw_timecode_dc_fifo.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/SPW_CLK_SYNCHRONIZATION" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "spw_clk_synchronization_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_MEMORY" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_mem_area_nfee_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_MEMORY" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_mem_area_nfee_read.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_MEMORY" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_mem_area_nfee_write.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_crc_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_pkg.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_command_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_read_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_reply_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_write_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_user_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/RMAP_TARGET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "rmap_target_top.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/MASKING_MACHINE" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "delay_block_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/MASKING_MACHINE/altera_ip/scfifo" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "masking_machine_sc_fifo.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/MASKING_MACHINE" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "masking_machine_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/DATA_PACKET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "data_packet_header_gen_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/DATA_PACKET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "data_packet_hk_writer_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/DATA_PACKET" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "data_packet_data_writer_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/SEND_BUFFER/altera_ip/scfifo" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "scfifo_data_buffer.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/SEND_BUFFER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "send_buffer_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/DATA_TRANSMITTER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "data_transmitter_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/FEE_DATA_MANAGER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "fee_master_data_manager_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "fee_master_data_controller_top.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER/FEE_DATA_MANAGER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "fee_slave_data_manager_ent.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8/FEE_DATA_CONTROLLER" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "fee_slave_data_controller_top.vhd" /R:0 /W:0 /NJH /NJS
ROBOCOPY "Communications_Module_v1_8" "..\..\..\G3U_HW_V02_2GB\Qsys_Project\MebX_Qsys_Project\synthesis\submodules" "comm_v1_80_top.vhd" /R:0 /W:0 /NJH /NJS
REM PAUSE