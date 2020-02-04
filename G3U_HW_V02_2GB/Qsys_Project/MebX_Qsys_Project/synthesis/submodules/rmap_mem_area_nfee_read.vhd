library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_mem_area_nfee_pkg.all;
use work.avalon_mm_spacewire_pkg.all;

entity rmap_mem_area_nfee_read is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		fee_hk_read_i           : in  std_logic;
		fee_hk_readaddr_i       : in  std_logic_vector(31 downto 0);
		rmap_read_i             : in  std_logic;
		rmap_readaddr_i         : in  std_logic_vector(31 downto 0);
		avalon_mm_rmap_i        : in  t_avalon_mm_spacewire_read_in;
		rmap_write_authorized_i : in  std_logic;
		rmap_write_finished_i   : in  std_logic;
		rmap_registers_wr_i     : in  t_rmap_memory_wr_area;
		rmap_registers_rd_i     : in  t_rmap_memory_rd_area;
		rmap_memerror_o         : out std_logic;
		fee_hk_datavalid_o      : out std_logic;
		fee_hk_readdata_o       : out std_logic_vector(7 downto 0);
		rmap_datavalid_o        : out std_logic;
		rmap_readdata_o         : out std_logic_vector(7 downto 0);
		avalon_mm_rmap_o        : out t_avalon_mm_spacewire_read_out
	);
end entity rmap_mem_area_nfee_read;

architecture RTL of rmap_mem_area_nfee_read is

begin

	p_rmap_mem_area_nfee_read : process(clk_i, rst_i) is
		procedure p_nfee_rmap_mem_rd(rd_addr_i : std_logic_vector) is
		begin

			-- MemArea Data Read
			case (rd_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000000") =>
					-- RMAP Area Config Register 0 : V End Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_config.v_end(15 downto 8);

				when (x"00000001") =>
					-- RMAP Area Config Register 0 : V End Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_config.v_end(7 downto 0);

				when (x"00000002") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_config.v_start(15 downto 8);

				when (x"00000003") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_config.v_start(7 downto 0);

				when (x"00000004") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_gap(15 downto 8);

				when (x"00000005") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_gap(7 downto 0);

				when (x"00000006") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_width(15 downto 8);

				when (x"00000007") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_width(7 downto 0);

				when (x"00000008") =>
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
					rmap_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_1st_ccd;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
					rmap_readdata_o(3 downto 2) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_2nd_ccd;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
					rmap_readdata_o(5 downto 4) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_3rd_ccd;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_4th_ccd;

				when (x"00000009") =>
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_2_config.parallel_clk_overlap(11 downto 4);

				when (x"0000000A") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_2_config.parallel_toi_period(11 downto 8);
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_2_config.parallel_clk_overlap(3 downto 0);

				when (x"0000000B") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_2_config.parallel_toi_period(7 downto 0);

				when (x"0000000C") =>
					-- RMAP Area Config Register 3 : H End Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_3_config.h_end(11 downto 8);
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					rmap_readdata_o(4)          <= rmap_registers_wr_i.reg_3_config.charge_injection_en;
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					rmap_readdata_o(5)          <= rmap_registers_wr_i.reg_3_config.tri_level_clk_en;
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					rmap_readdata_o(6)          <= rmap_registers_wr_i.reg_3_config.img_clk_dir;
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					rmap_readdata_o(7)          <= rmap_registers_wr_i.reg_3_config.reg_clk_dir;

				when (x"0000000D") =>
					-- RMAP Area Config Register 3 : H End Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_config.h_end(7 downto 0);

				when (x"0000000E") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_config.n_final_dump(15 downto 8);

				when (x"0000000F") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_config.n_final_dump(7 downto 0);

				when (x"00000010") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_config.int_sync_period(15 downto 8);

				when (x"00000011") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_config.int_sync_period(7 downto 0);

				when (x"00000012") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_config.packet_size(15 downto 8);

				when (x"00000013") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_config.packet_size(7 downto 0);

				when (x"00000014") =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					rmap_readdata_o(0)          <= rmap_registers_wr_i.reg_5_config.dg_en;
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					rmap_readdata_o(7 downto 1) <= rmap_registers_wr_i.reg_5_config.reg_5_config_reserved;

				when (x"00000015") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(19 downto 16);
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					rmap_readdata_o(4)          <= rmap_registers_wr_i.reg_5_config.sync_sel;
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					rmap_readdata_o(6 downto 5) <= rmap_registers_wr_i.reg_5_config.sensor_sel;
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					rmap_readdata_o(7)          <= rmap_registers_wr_i.reg_5_config.digitise_en;

				when (x"00000016") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(15 downto 8);

				when (x"00000017") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(7 downto 0);

				when (x"00000018") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(31 downto 24);

				when (x"00000019") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(23 downto 16);

				when (x"0000001A") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(15 downto 8);

				when (x"0000001B") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(7 downto 0);

				when (x"0000001C") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(31 downto 24);

				when (x"0000001D") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(23 downto 16);

				when (x"0000001E") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(15 downto 8);

				when (x"0000001F") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(7 downto 0);

				when (x"00000020") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_y(5 downto 2);
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_8_config.reg_8_config_reserved;

				when (x"00000021") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_x;
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_y(1 downto 0);

				when (x"00000022") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_8_config.ccd1_win_list_length(15 downto 8);

				when (x"00000023") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_8_config.ccd1_win_list_length(7 downto 0);

				when (x"00000024") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(31 downto 24);

				when (x"00000025") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(23 downto 16);

				when (x"00000026") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(15 downto 8);

				when (x"00000027") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(7 downto 0);

				when (x"00000028") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(31 downto 24);

				when (x"00000029") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(23 downto 16);

				when (x"0000002A") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(15 downto 8);

				when (x"0000002B") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(7 downto 0);

				when (x"0000002C") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_y(5 downto 2);
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_11_config.reg_11_config_reserved;

				when (x"0000002D") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_x;
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_y(1 downto 0);

				when (x"0000002E") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_11_config.ccd2_win_list_length(15 downto 8);

				when (x"0000002F") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_11_config.ccd2_win_list_length(7 downto 0);

				when (x"00000030") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(31 downto 24);

				when (x"00000031") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(23 downto 16);

				when (x"00000032") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(15 downto 8);

				when (x"00000033") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(7 downto 0);

				when (x"00000034") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(31 downto 24);

				when (x"00000035") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(23 downto 16);

				when (x"00000036") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(15 downto 8);

				when (x"00000037") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(7 downto 0);

				when (x"00000038") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_y(5 downto 2);
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_14_config.reg_14_config_reserved;

				when (x"00000039") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_x;
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_y(1 downto 0);

				when (x"0000003A") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_14_config.ccd3_win_list_length(15 downto 8);

				when (x"0000003B") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_14_config.ccd3_win_list_length(7 downto 0);

				when (x"0000003C") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(31 downto 24);

				when (x"0000003D") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(23 downto 16);

				when (x"0000003E") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(15 downto 8);

				when (x"0000003F") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(7 downto 0);

				when (x"00000040") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(31 downto 24);

				when (x"00000041") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(23 downto 16);

				when (x"00000042") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(15 downto 8);

				when (x"00000043") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(7 downto 0);

				when (x"00000044") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_y(5 downto 2);
					-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_17_config.reg_17_config_reserved;

				when (x"00000045") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_x;
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_y(1 downto 0);

				when (x"00000046") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_17_config.ccd4_win_list_length(15 downto 8);

				when (x"00000047") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_17_config.ccd4_win_list_length(7 downto 0);

				when (x"00000048") =>
					-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_config.ccd2_vrd_config0;

				when (x"00000049") =>
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_config.ccd1_vrd_config(11 downto 4);

				when (x"0000004A") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_18_config.ccd_vod_config(11 downto 8);
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_18_config.ccd1_vrd_config(3 downto 0);

				when (x"0000004B") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_config.ccd_vod_config(7 downto 0);

				when (x"0000004C") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_19_config.ccd4_vrd_config(11 downto 8);
					-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_19_config.ccd_vgd_config0;

				when (x"0000004D") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_19_config.ccd4_vrd_config(7 downto 0);

				when (x"0000004E") =>
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_19_config.ccd3_vrd_config(11 downto 4);

				when (x"0000004F") =>
					-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_19_config.ccd2_vrd_config1;
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_19_config.ccd3_vrd_config(3 downto 0);

				when (x"00000050") =>
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_config.ccd_ig_hi_config(11 downto 4);

				when (x"00000051") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_20_config.ccd_vog_config(11 downto 8);
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_20_config.ccd_ig_hi_config(3 downto 0);

				when (x"00000052") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_config.ccd_vog_config(7 downto 0);

				when (x"00000053") =>
					-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_config.ccd_vgd_config1;

				when (x"00000054") =>
					-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_21_config.ccd_mode_config;
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_readdata_o(6 downto 4) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_1;
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					rmap_readdata_o(7)          <= rmap_registers_wr_i.reg_21_config.clear_error_flag;

				when (x"00000055") =>
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_0(11 downto 4);

				when (x"00000056") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_21_config.ccd_ig_lo_config(11 downto 8);
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_0(3 downto 0);

				when (x"00000057") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_21_config.ccd_ig_lo_config(7 downto 0);

				when (x"00000058") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(31 downto 24);

				when (x"00000059") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(23 downto 16);

				when (x"0000005A") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(15 downto 8);

				when (x"0000005B") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(7 downto 0);

				when (x"0000005C") =>
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd2_last_e_packet(9 downto 4);
					-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_23_config.reg_23_config_reserved;

				when (x"0000005D") =>
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd1_last_f_packet(9 downto 6);
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_23_config.ccd2_last_e_packet(3 downto 0);

				when (x"0000005E") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					rmap_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd1_last_e_packet(9 downto 8);
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					rmap_readdata_o(7 downto 2) <= rmap_registers_wr_i.reg_23_config.ccd1_last_f_packet(5 downto 0);

				when (x"0000005F") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_23_config.ccd1_last_e_packet(7 downto 0);

				when (x"00000060") =>
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd3_last_f_packet(9 downto 4);
					-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_24_config.reg_24_config_reserved;

				when (x"00000061") =>
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd3_last_e_packet(9 downto 6);
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_24_config.ccd3_last_f_packet(3 downto 0);

				when (x"00000062") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					rmap_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd2_last_f_packet(9 downto 8);
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					rmap_readdata_o(7 downto 2) <= rmap_registers_wr_i.reg_24_config.ccd3_last_e_packet(5 downto 0);

				when (x"00000063") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_24_config.ccd2_last_f_packet(7 downto 0);

				when (x"00000064") =>
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					rmap_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_25_config.surface_inversion_counter(9 downto 4);
					-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_25_config.reg_25_config_reserved;

				when (x"00000065") =>
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_25_config.ccd4_last_f_packet(9 downto 6);
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_25_config.surface_inversion_counter(3 downto 0);

				when (x"00000066") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					rmap_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_25_config.ccd4_last_e_packet(9 downto 8);
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					rmap_readdata_o(7 downto 2) <= rmap_registers_wr_i.reg_25_config.ccd4_last_f_packet(5 downto 0);

				when (x"00000067") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_25_config.ccd4_last_e_packet(7 downto 0);

				when (x"00000068") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_config.trap_pumping_shuffle_counter(15 downto 8);

				when (x"00000069") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_config.trap_pumping_shuffle_counter(7 downto 0);

				when (x"0000006A") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_config.readout_pause_counter(15 downto 8);

				when (x"0000006B") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_config.readout_pause_counter(7 downto 0);

				when (x"00000700") =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_1(15 downto 8);

				when (x"00000701") =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_1(7 downto 0);

				when (x"00000702") =>
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_2(15 downto 8);

				when (x"00000703") =>
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_2(7 downto 0);

				when (x"00000704") =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_3(15 downto 8);

				when (x"00000705") =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_3(7 downto 0);

				when (x"00000706") =>
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_4(15 downto 8);

				when (x"00000707") =>
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_4(7 downto 0);

				when (x"00000708") =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_5(15 downto 8);

				when (x"00000709") =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_5(7 downto 0);

				when (x"0000070A") =>
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_6(15 downto 8);

				when (x"0000070B") =>
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_6(7 downto 0);

				when (x"0000070C") =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd1_ts(15 downto 8);

				when (x"0000070D") =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd1_ts(7 downto 0);

				when (x"0000070E") =>
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd2_ts(15 downto 8);

				when (x"0000070F") =>
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd2_ts(7 downto 0);

				when (x"00000710") =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd3_ts(15 downto 8);

				when (x"00000711") =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd3_ts(7 downto 0);

				when (x"00000712") =>
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd4_ts(15 downto 8);

				when (x"00000713") =>
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd4_ts(7 downto 0);

				when (x"00000714") =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt1(15 downto 8);

				when (x"00000715") =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt1(7 downto 0);

				when (x"00000716") =>
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt2(15 downto 8);

				when (x"00000717") =>
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt2(7 downto 0);

				when (x"00000718") =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt3(15 downto 8);

				when (x"00000719") =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt3(7 downto 0);

				when (x"0000071A") =>
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt4(15 downto 8);

				when (x"0000071B") =>
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt4(7 downto 0);

				when (x"0000071C") =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_hk.prt5(15 downto 8);

				when (x"0000071D") =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_hk.prt5(7 downto 0);

				when (x"0000071E") =>
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_hk.zero_diff_amp(15 downto 8);

				when (x"0000071F") =>
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_7_hk.zero_diff_amp(7 downto 0);

				when (x"00000720") =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vod_mon(15 downto 8);

				when (x"00000721") =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vod_mon(7 downto 0);

				when (x"00000722") =>
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vog_mon(15 downto 8);

				when (x"00000723") =>
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vog_mon(7 downto 0);

				when (x"00000724") =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd1_vrd_mon_e(15 downto 8);

				when (x"00000725") =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd1_vrd_mon_e(7 downto 0);

				when (x"00000726") =>
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd2_vod_mon(15 downto 8);

				when (x"00000727") =>
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd2_vod_mon(7 downto 0);

				when (x"00000728") =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vog_mon(15 downto 8);

				when (x"00000729") =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vog_mon(7 downto 0);

				when (x"0000072A") =>
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vrd_mon_e(15 downto 8);

				when (x"0000072B") =>
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vrd_mon_e(7 downto 0);

				when (x"0000072C") =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vod_mon(15 downto 8);

				when (x"0000072D") =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vod_mon(7 downto 0);

				when (x"0000072E") =>
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vog_mon(15 downto 8);

				when (x"0000072F") =>
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vog_mon(7 downto 0);

				when (x"00000730") =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd3_vrd_mon_e(15 downto 8);

				when (x"00000731") =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd3_vrd_mon_e(7 downto 0);

				when (x"00000732") =>
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd4_vod_mon(15 downto 8);

				when (x"00000733") =>
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd4_vod_mon(7 downto 0);

				when (x"00000734") =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vog_mon(15 downto 8);

				when (x"00000735") =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vog_mon(7 downto 0);

				when (x"00000736") =>
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vrd_mon_e(15 downto 8);

				when (x"00000737") =>
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vrd_mon_e(7 downto 0);

				when (x"00000738") =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_14_hk.vccd(15 downto 8);

				when (x"00000739") =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_14_hk.vccd(7 downto 0);

				when (x"0000073A") =>
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_14_hk.vrclk_mon(15 downto 8);

				when (x"0000073B") =>
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_14_hk.vrclk_mon(7 downto 0);

				when (x"0000073C") =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_hk.viclk(15 downto 8);

				when (x"0000073D") =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_hk.viclk(7 downto 0);

				when (x"0000073E") =>
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_hk.vrclk_low(15 downto 8);

				when (x"0000073F") =>
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_15_hk.vrclk_low(7 downto 0);

				when (x"00000740") =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_pos_mon(15 downto 8);

				when (x"00000741") =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_pos_mon(7 downto 0);

				when (x"00000742") =>
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_neg_mon(15 downto 8);

				when (x"00000743") =>
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_neg_mon(7 downto 0);

				when (x"00000744") =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_17_hk.d3v3b_mon(15 downto 8);

				when (x"00000745") =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_17_hk.d3v3b_mon(7 downto 0);

				when (x"00000746") =>
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_17_hk.d2v5a_mon(15 downto 8);

				when (x"00000747") =>
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_17_hk.d2v5a_mon(7 downto 0);

				when (x"00000748") =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_hk.d3v3d_mon(15 downto 8);

				when (x"00000749") =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_hk.d3v3d_mon(7 downto 0);

				when (x"0000074A") =>
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_hk.d2v5d_mon(15 downto 8);

				when (x"0000074B") =>
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_18_hk.d2v5d_mon(7 downto 0);

				when (x"0000074C") =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_19_hk.d1v5d_mon(15 downto 8);

				when (x"0000074D") =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_19_hk.d1v5d_mon(7 downto 0);

				when (x"0000074E") =>
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_19_hk.d5vref_mon(15 downto 8);

				when (x"0000074F") =>
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_19_hk.d5vref_mon(7 downto 0);

				when (x"00000750") =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_hk.vccd_pos_raw(15 downto 8);

				when (x"00000751") =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_hk.vccd_pos_raw(7 downto 0);

				when (x"00000752") =>
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_hk.vclk_pos_raw(15 downto 8);

				when (x"00000753") =>
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_20_hk.vclk_pos_raw(7 downto 0);

				when (x"00000754") =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_21_hk.van1_pos_raw(15 downto 8);

				when (x"00000755") =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_21_hk.van1_pos_raw(7 downto 0);

				when (x"00000756") =>
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_21_hk.van3_neg_mon(15 downto 8);

				when (x"00000757") =>
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_21_hk.van3_neg_mon(7 downto 0);

				when (x"00000758") =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_hk.van2_pos_raw(15 downto 8);

				when (x"00000759") =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_hk.van2_pos_raw(7 downto 0);

				when (x"0000075A") =>
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_hk.vdig_raw(15 downto 8);

				when (x"0000075B") =>
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_22_hk.vdig_raw(7 downto 0);

				when (x"0000075C") =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_23_hk.vdig_raw_2(15 downto 8);

				when (x"0000075D") =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_23_hk.vdig_raw_2(7 downto 0);

				when (x"0000075E") =>
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_23_hk.viclk_low(15 downto 8);

				when (x"0000075F") =>
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_23_hk.viclk_low(7 downto 0);

				when (x"00000760") =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vrd_mon_f(15 downto 8);

				when (x"00000761") =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vrd_mon_f(7 downto 0);

				when (x"00000762") =>
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vdd_mon(15 downto 8);

				when (x"00000763") =>
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vdd_mon(7 downto 0);

				when (x"00000764") =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd1_vgd_mon(15 downto 8);

				when (x"00000765") =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd1_vgd_mon(7 downto 0);

				when (x"00000766") =>
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd2_vrd_mon_f(15 downto 8);

				when (x"00000767") =>
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd2_vrd_mon_f(7 downto 0);

				when (x"00000768") =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vdd_mon(15 downto 8);

				when (x"00000769") =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vdd_mon(7 downto 0);

				when (x"0000076A") =>
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vgd_mon(15 downto 8);

				when (x"0000076B") =>
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vgd_mon(7 downto 0);

				when (x"0000076C") =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vrd_mon_f(15 downto 8);

				when (x"0000076D") =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vrd_mon_f(7 downto 0);

				when (x"0000076E") =>
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vdd_mon(15 downto 8);

				when (x"0000076F") =>
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vdd_mon(7 downto 0);

				when (x"00000770") =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd3_vgd_mon(15 downto 8);

				when (x"00000771") =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd3_vgd_mon(7 downto 0);

				when (x"00000772") =>
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd4_vrd_mon_f(15 downto 8);

				when (x"00000773") =>
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd4_vrd_mon_f(7 downto 0);

				when (x"00000774") =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vdd_mon(15 downto 8);

				when (x"00000775") =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vdd_mon(7 downto 0);

				when (x"00000776") =>
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vgd_mon(15 downto 8);

				when (x"00000777") =>
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vgd_mon(7 downto 0);

				when (x"00000778") =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_hi_mon(15 downto 8);

				when (x"00000779") =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_hi_mon(7 downto 0);

				when (x"0000077A") =>
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_lo_mon(15 downto 8);

				when (x"0000077B") =>
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_lo_mon(7 downto 0);

				when (x"0000077C") =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_a(15 downto 8);

				when (x"0000077D") =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_a(7 downto 0);

				when (x"0000077E") =>
					-- RMAP Area HK Register 31 : Tsense B HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_b(15 downto 8);

				when (x"0000077F") =>
					-- RMAP Area HK Register 31 : Tsense B HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_b(7 downto 0);

				when (x"00000780") =>
					-- RMAP Area HK Register 32 : Register 32 HK Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_32_hk.reg_32_hk_reserved;

				when (x"00000781") =>
					-- RMAP Area HK Register 32 : SpW Status : Timecode From SpaceWire HK Field
					rmap_readdata_o <= rmap_registers_rd_i.reg_32_hk.spw_status_timecode_from_spw;

				when (x"00000782") =>
					-- RMAP Area HK Register 32 : SpW Status : RMAP Target Status HK Field
					rmap_readdata_o <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_status;

				when (x"00000783") =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Running HK Field
					rmap_readdata_o(0)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_running;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Disconnect HK Field
					rmap_readdata_o(1)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_disconnect;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Parity Error HK Field
					rmap_readdata_o(2)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_parity_error;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Credit Error HK Field
					rmap_readdata_o(3)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_credit_error;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Escape Error HK Field
					rmap_readdata_o(4)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_escape_error;
					-- RMAP Area HK Register 32 : SpW Status : RMAP Target Indicate HK Field
					rmap_readdata_o(5)          <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_indicate;
					-- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_32_hk.spw_status_spw_status_reserved;

				when (x"00000784") =>
					-- RMAP Area HK Register 33 : Frame Counter HK Field
					rmap_readdata_o <= rmap_registers_rd_i.reg_33_hk.frame_counter(15 downto 8);

				when (x"00000785") =>
					-- RMAP Area HK Register 33 : Frame Counter HK Field
					rmap_readdata_o <= rmap_registers_rd_i.reg_33_hk.frame_counter(7 downto 0);

				when (x"00000786") =>
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_33_hk.reg_33_hk_reserved(9 downto 2);

				when (x"00000787") =>
					-- RMAP Area HK Register 33 : Frame Number HK Field
					rmap_readdata_o(1 downto 0) <= rmap_registers_rd_i.reg_33_hk.frame_number;
					-- RMAP Area HK Register 33 : Operational Mode HK Field
					rmap_readdata_o(5 downto 2) <= rmap_registers_wr_i.reg_33_hk.op_mode;
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					rmap_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_33_hk.reg_33_hk_reserved(1 downto 0);

				when (x"00000788") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(26 downto 19);

				when (x"00000789") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(18 downto 11);

				when (x"0000078A") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_readdata_o <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(10 downto 3);

				when (x"0000078B") =>
					-- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field
					rmap_readdata_o(0)          <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate;
					-- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field
					rmap_readdata_o(1)          <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate;
					-- RMAP Area HK Register 34 : Error Flags : E Side Pixel External SRAM Buffer is Full HK Field
					rmap_readdata_o(2)          <= rmap_registers_rd_i.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full;
					-- RMAP Area HK Register 34 : Error Flags : F Side Pixel External SRAM Buffer is Full HK Field
					rmap_readdata_o(3)          <= rmap_registers_rd_i.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full;
					-- RMAP Area HK Register 34 : Error Flags : Invalid CCD Mode
					rmap_readdata_o(4)          <= rmap_registers_rd_i.reg_34_hk.error_flags_invalid_ccd_mode;
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					rmap_readdata_o(7 downto 5) <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(2 downto 0);

				when (x"0000078C") =>
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_35_hk.reg_35_hk_reserved(10 downto 3);

				when (x"0000078D") =>
					-- RMAP Area HK Register 35 : Board ID Field
					rmap_readdata_o(4 downto 0) <= rmap_registers_wr_i.reg_35_hk.board_id(8 downto 4);
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					rmap_readdata_o(7 downto 5) <= rmap_registers_wr_i.reg_35_hk.reg_35_hk_reserved(2 downto 0);

				when (x"0000078E") =>
					-- RMAP Area HK Register 35 : FPGA Major Version Field
					rmap_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_35_hk.fpga_major_version;
					-- RMAP Area HK Register 35 : Board ID Field
					rmap_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_35_hk.board_id(3 downto 0);

				when (x"0000078F") =>
					-- RMAP Area HK Register 35 : FPGA Minor Version Field
					rmap_readdata_o <= rmap_registers_wr_i.reg_35_hk.fpga_minor_version;

				when others =>
					rmap_readdata_o <= (others => '0');

			end case;

		end procedure p_nfee_rmap_mem_rd;

		procedure p_nfee_hk_mem_rd(rd_addr_i : std_logic_vector) is
		begin

			-- MemArea Data Read
			case (rd_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000000") =>
					-- RMAP Area Config Register 0 : V End Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_config.v_end(15 downto 8);

				when (x"00000001") =>
					-- RMAP Area Config Register 0 : V End Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_config.v_end(7 downto 0);

				when (x"00000002") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_config.v_start(15 downto 8);

				when (x"00000003") =>
					-- RMAP Area Config Register 0 : V Start Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_config.v_start(7 downto 0);

				when (x"00000004") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_gap(15 downto 8);

				when (x"00000005") =>
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_gap(7 downto 0);

				when (x"00000006") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_width(15 downto 8);

				when (x"00000007") =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_config.charge_injection_width(7 downto 0);

				when (x"00000008") =>
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
					fee_hk_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_1st_ccd;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
					fee_hk_readdata_o(3 downto 2) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_2nd_ccd;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
					fee_hk_readdata_o(5 downto 4) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_3rd_ccd;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_4th_ccd;

				when (x"00000009") =>
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_2_config.parallel_clk_overlap(11 downto 4);

				when (x"0000000A") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_2_config.parallel_toi_period(11 downto 8);
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_2_config.parallel_clk_overlap(3 downto 0);

				when (x"0000000B") =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_2_config.parallel_toi_period(7 downto 0);

				when (x"0000000C") =>
					-- RMAP Area Config Register 3 : H End Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_3_config.h_end(11 downto 8);
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					fee_hk_readdata_o(4)          <= rmap_registers_wr_i.reg_3_config.charge_injection_en;
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					fee_hk_readdata_o(5)          <= rmap_registers_wr_i.reg_3_config.tri_level_clk_en;
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					fee_hk_readdata_o(6)          <= rmap_registers_wr_i.reg_3_config.img_clk_dir;
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					fee_hk_readdata_o(7)          <= rmap_registers_wr_i.reg_3_config.reg_clk_dir;

				when (x"0000000D") =>
					-- RMAP Area Config Register 3 : H End Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_config.h_end(7 downto 0);

				when (x"0000000E") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_config.n_final_dump(15 downto 8);

				when (x"0000000F") =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_config.n_final_dump(7 downto 0);

				when (x"00000010") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_config.int_sync_period(15 downto 8);

				when (x"00000011") =>
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_config.int_sync_period(7 downto 0);

				when (x"00000012") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_config.packet_size(15 downto 8);

				when (x"00000013") =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_config.packet_size(7 downto 0);

				when (x"00000014") =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					fee_hk_readdata_o(0)          <= rmap_registers_wr_i.reg_5_config.dg_en;
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					fee_hk_readdata_o(7 downto 1) <= rmap_registers_wr_i.reg_5_config.reg_5_config_reserved;

				when (x"00000015") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(19 downto 16);
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					fee_hk_readdata_o(4)          <= rmap_registers_wr_i.reg_5_config.sync_sel;
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					fee_hk_readdata_o(6 downto 5) <= rmap_registers_wr_i.reg_5_config.sensor_sel;
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					fee_hk_readdata_o(7)          <= rmap_registers_wr_i.reg_5_config.digitise_en;

				when (x"00000016") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(15 downto 8);

				when (x"00000017") =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(7 downto 0);

				when (x"00000018") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(31 downto 24);

				when (x"00000019") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(23 downto 16);

				when (x"0000001A") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(15 downto 8);

				when (x"0000001B") =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(7 downto 0);

				when (x"0000001C") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(31 downto 24);

				when (x"0000001D") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(23 downto 16);

				when (x"0000001E") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(15 downto 8);

				when (x"0000001F") =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(7 downto 0);

				when (x"00000020") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_y(5 downto 2);
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_8_config.reg_8_config_reserved;

				when (x"00000021") =>
					-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_x;
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_y(1 downto 0);

				when (x"00000022") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_8_config.ccd1_win_list_length(15 downto 8);

				when (x"00000023") =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_8_config.ccd1_win_list_length(7 downto 0);

				when (x"00000024") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(31 downto 24);

				when (x"00000025") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(23 downto 16);

				when (x"00000026") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(15 downto 8);

				when (x"00000027") =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(7 downto 0);

				when (x"00000028") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(31 downto 24);

				when (x"00000029") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(23 downto 16);

				when (x"0000002A") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(15 downto 8);

				when (x"0000002B") =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(7 downto 0);

				when (x"0000002C") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_y(5 downto 2);
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_11_config.reg_11_config_reserved;

				when (x"0000002D") =>
					-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_x;
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_y(1 downto 0);

				when (x"0000002E") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_11_config.ccd2_win_list_length(15 downto 8);

				when (x"0000002F") =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_11_config.ccd2_win_list_length(7 downto 0);

				when (x"00000030") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(31 downto 24);

				when (x"00000031") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(23 downto 16);

				when (x"00000032") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(15 downto 8);

				when (x"00000033") =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(7 downto 0);

				when (x"00000034") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(31 downto 24);

				when (x"00000035") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(23 downto 16);

				when (x"00000036") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(15 downto 8);

				when (x"00000037") =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(7 downto 0);

				when (x"00000038") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_y(5 downto 2);
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_14_config.reg_14_config_reserved;

				when (x"00000039") =>
					-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_x;
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_y(1 downto 0);

				when (x"0000003A") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_14_config.ccd3_win_list_length(15 downto 8);

				when (x"0000003B") =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_14_config.ccd3_win_list_length(7 downto 0);

				when (x"0000003C") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(31 downto 24);

				when (x"0000003D") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(23 downto 16);

				when (x"0000003E") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(15 downto 8);

				when (x"0000003F") =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(7 downto 0);

				when (x"00000040") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(31 downto 24);

				when (x"00000041") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(23 downto 16);

				when (x"00000042") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(15 downto 8);

				when (x"00000043") =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(7 downto 0);

				when (x"00000044") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_y(5 downto 2);
					-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_17_config.reg_17_config_reserved;

				when (x"00000045") =>
					-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_x;
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_y(1 downto 0);

				when (x"00000046") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_17_config.ccd4_win_list_length(15 downto 8);

				when (x"00000047") =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_17_config.ccd4_win_list_length(7 downto 0);

				when (x"00000048") =>
					-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_config.ccd2_vrd_config0;

				when (x"00000049") =>
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_config.ccd1_vrd_config(11 downto 4);

				when (x"0000004A") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_18_config.ccd_vod_config(11 downto 8);
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_18_config.ccd1_vrd_config(3 downto 0);

				when (x"0000004B") =>
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_config.ccd_vod_config(7 downto 0);

				when (x"0000004C") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_19_config.ccd4_vrd_config(11 downto 8);
					-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_19_config.ccd_vgd_config0;

				when (x"0000004D") =>
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_19_config.ccd4_vrd_config(7 downto 0);

				when (x"0000004E") =>
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_19_config.ccd3_vrd_config(11 downto 4);

				when (x"0000004F") =>
					-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_19_config.ccd2_vrd_config1;
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_19_config.ccd3_vrd_config(3 downto 0);

				when (x"00000050") =>
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_config.ccd_ig_hi_config(11 downto 4);

				when (x"00000051") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_20_config.ccd_vog_config(11 downto 8);
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_20_config.ccd_ig_hi_config(3 downto 0);

				when (x"00000052") =>
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_config.ccd_vog_config(7 downto 0);

				when (x"00000053") =>
					-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_config.ccd_vgd_config1;

				when (x"00000054") =>
					-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_21_config.ccd_mode_config;
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					fee_hk_readdata_o(6 downto 4) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_1;
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					fee_hk_readdata_o(7)          <= rmap_registers_wr_i.reg_21_config.clear_error_flag;

				when (x"00000055") =>
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_0(11 downto 4);

				when (x"00000056") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_21_config.ccd_ig_lo_config(11 downto 8);
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_0(3 downto 0);

				when (x"00000057") =>
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_21_config.ccd_ig_lo_config(7 downto 0);

				when (x"00000058") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(31 downto 24);

				when (x"00000059") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(23 downto 16);

				when (x"0000005A") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(15 downto 8);

				when (x"0000005B") =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(7 downto 0);

				when (x"0000005C") =>
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd2_last_e_packet(9 downto 4);
					-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_23_config.reg_23_config_reserved;

				when (x"0000005D") =>
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd1_last_f_packet(9 downto 6);
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_23_config.ccd2_last_e_packet(3 downto 0);

				when (x"0000005E") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					fee_hk_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd1_last_e_packet(9 downto 8);
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					fee_hk_readdata_o(7 downto 2) <= rmap_registers_wr_i.reg_23_config.ccd1_last_f_packet(5 downto 0);

				when (x"0000005F") =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_23_config.ccd1_last_e_packet(7 downto 0);

				when (x"00000060") =>
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd3_last_f_packet(9 downto 4);
					-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_24_config.reg_24_config_reserved;

				when (x"00000061") =>
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd3_last_e_packet(9 downto 6);
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_24_config.ccd3_last_f_packet(3 downto 0);

				when (x"00000062") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					fee_hk_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd2_last_f_packet(9 downto 8);
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					fee_hk_readdata_o(7 downto 2) <= rmap_registers_wr_i.reg_24_config.ccd3_last_e_packet(5 downto 0);

				when (x"00000063") =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_24_config.ccd2_last_f_packet(7 downto 0);

				when (x"00000064") =>
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					fee_hk_readdata_o(5 downto 0) <= rmap_registers_wr_i.reg_25_config.surface_inversion_counter(9 downto 4);
					-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_25_config.reg_25_config_reserved;

				when (x"00000065") =>
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_25_config.ccd4_last_f_packet(9 downto 6);
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_25_config.surface_inversion_counter(3 downto 0);

				when (x"00000066") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					fee_hk_readdata_o(1 downto 0) <= rmap_registers_wr_i.reg_25_config.ccd4_last_e_packet(9 downto 8);
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					fee_hk_readdata_o(7 downto 2) <= rmap_registers_wr_i.reg_25_config.ccd4_last_f_packet(5 downto 0);

				when (x"00000067") =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_25_config.ccd4_last_e_packet(7 downto 0);

				when (x"00000068") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_config.trap_pumping_shuffle_counter(15 downto 8);

				when (x"00000069") =>
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_config.trap_pumping_shuffle_counter(7 downto 0);

				when (x"0000006A") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_config.readout_pause_counter(15 downto 8);

				when (x"0000006B") =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_config.readout_pause_counter(7 downto 0);

				when (x"00000700") =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_1(15 downto 8);

				when (x"00000701") =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_1(7 downto 0);

				when (x"00000702") =>
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_2(15 downto 8);

				when (x"00000703") =>
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_0_hk.tou_sense_2(7 downto 0);

				when (x"00000704") =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_3(15 downto 8);

				when (x"00000705") =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_3(7 downto 0);

				when (x"00000706") =>
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_4(15 downto 8);

				when (x"00000707") =>
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_1_hk.tou_sense_4(7 downto 0);

				when (x"00000708") =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_5(15 downto 8);

				when (x"00000709") =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_5(7 downto 0);

				when (x"0000070A") =>
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_6(15 downto 8);

				when (x"0000070B") =>
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_2_hk.tou_sense_6(7 downto 0);

				when (x"0000070C") =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd1_ts(15 downto 8);

				when (x"0000070D") =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd1_ts(7 downto 0);

				when (x"0000070E") =>
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd2_ts(15 downto 8);

				when (x"0000070F") =>
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_3_hk.ccd2_ts(7 downto 0);

				when (x"00000710") =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd3_ts(15 downto 8);

				when (x"00000711") =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd3_ts(7 downto 0);

				when (x"00000712") =>
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd4_ts(15 downto 8);

				when (x"00000713") =>
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_4_hk.ccd4_ts(7 downto 0);

				when (x"00000714") =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt1(15 downto 8);

				when (x"00000715") =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt1(7 downto 0);

				when (x"00000716") =>
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt2(15 downto 8);

				when (x"00000717") =>
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_5_hk.prt2(7 downto 0);

				when (x"00000718") =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt3(15 downto 8);

				when (x"00000719") =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt3(7 downto 0);

				when (x"0000071A") =>
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt4(15 downto 8);

				when (x"0000071B") =>
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_6_hk.prt4(7 downto 0);

				when (x"0000071C") =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_hk.prt5(15 downto 8);

				when (x"0000071D") =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_hk.prt5(7 downto 0);

				when (x"0000071E") =>
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_hk.zero_diff_amp(15 downto 8);

				when (x"0000071F") =>
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_7_hk.zero_diff_amp(7 downto 0);

				when (x"00000720") =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vod_mon(15 downto 8);

				when (x"00000721") =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vod_mon(7 downto 0);

				when (x"00000722") =>
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vog_mon(15 downto 8);

				when (x"00000723") =>
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_8_hk.ccd1_vog_mon(7 downto 0);

				when (x"00000724") =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd1_vrd_mon_e(15 downto 8);

				when (x"00000725") =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd1_vrd_mon_e(7 downto 0);

				when (x"00000726") =>
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd2_vod_mon(15 downto 8);

				when (x"00000727") =>
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_9_hk.ccd2_vod_mon(7 downto 0);

				when (x"00000728") =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vog_mon(15 downto 8);

				when (x"00000729") =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vog_mon(7 downto 0);

				when (x"0000072A") =>
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vrd_mon_e(15 downto 8);

				when (x"0000072B") =>
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_10_hk.ccd2_vrd_mon_e(7 downto 0);

				when (x"0000072C") =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vod_mon(15 downto 8);

				when (x"0000072D") =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vod_mon(7 downto 0);

				when (x"0000072E") =>
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vog_mon(15 downto 8);

				when (x"0000072F") =>
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_11_hk.ccd3_vog_mon(7 downto 0);

				when (x"00000730") =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd3_vrd_mon_e(15 downto 8);

				when (x"00000731") =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd3_vrd_mon_e(7 downto 0);

				when (x"00000732") =>
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd4_vod_mon(15 downto 8);

				when (x"00000733") =>
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_12_hk.ccd4_vod_mon(7 downto 0);

				when (x"00000734") =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vog_mon(15 downto 8);

				when (x"00000735") =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vog_mon(7 downto 0);

				when (x"00000736") =>
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vrd_mon_e(15 downto 8);

				when (x"00000737") =>
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_13_hk.ccd4_vrd_mon_e(7 downto 0);

				when (x"00000738") =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_14_hk.vccd(15 downto 8);

				when (x"00000739") =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_14_hk.vccd(7 downto 0);

				when (x"0000073A") =>
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_14_hk.vrclk_mon(15 downto 8);

				when (x"0000073B") =>
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_14_hk.vrclk_mon(7 downto 0);

				when (x"0000073C") =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_hk.viclk(15 downto 8);

				when (x"0000073D") =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_hk.viclk(7 downto 0);

				when (x"0000073E") =>
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_hk.vrclk_low(15 downto 8);

				when (x"0000073F") =>
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_15_hk.vrclk_low(7 downto 0);

				when (x"00000740") =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_pos_mon(15 downto 8);

				when (x"00000741") =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_pos_mon(7 downto 0);

				when (x"00000742") =>
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_neg_mon(15 downto 8);

				when (x"00000743") =>
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_16_hk.d5vb_neg_mon(7 downto 0);

				when (x"00000744") =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_17_hk.d3v3b_mon(15 downto 8);

				when (x"00000745") =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_17_hk.d3v3b_mon(7 downto 0);

				when (x"00000746") =>
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_17_hk.d2v5a_mon(15 downto 8);

				when (x"00000747") =>
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_17_hk.d2v5a_mon(7 downto 0);

				when (x"00000748") =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_hk.d3v3d_mon(15 downto 8);

				when (x"00000749") =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_hk.d3v3d_mon(7 downto 0);

				when (x"0000074A") =>
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_hk.d2v5d_mon(15 downto 8);

				when (x"0000074B") =>
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_18_hk.d2v5d_mon(7 downto 0);

				when (x"0000074C") =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_19_hk.d1v5d_mon(15 downto 8);

				when (x"0000074D") =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_19_hk.d1v5d_mon(7 downto 0);

				when (x"0000074E") =>
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_19_hk.d5vref_mon(15 downto 8);

				when (x"0000074F") =>
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_19_hk.d5vref_mon(7 downto 0);

				when (x"00000750") =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_hk.vccd_pos_raw(15 downto 8);

				when (x"00000751") =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_hk.vccd_pos_raw(7 downto 0);

				when (x"00000752") =>
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_hk.vclk_pos_raw(15 downto 8);

				when (x"00000753") =>
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_20_hk.vclk_pos_raw(7 downto 0);

				when (x"00000754") =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_21_hk.van1_pos_raw(15 downto 8);

				when (x"00000755") =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_21_hk.van1_pos_raw(7 downto 0);

				when (x"00000756") =>
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_21_hk.van3_neg_mon(15 downto 8);

				when (x"00000757") =>
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_21_hk.van3_neg_mon(7 downto 0);

				when (x"00000758") =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_hk.van2_pos_raw(15 downto 8);

				when (x"00000759") =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_hk.van2_pos_raw(7 downto 0);

				when (x"0000075A") =>
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_hk.vdig_raw(15 downto 8);

				when (x"0000075B") =>
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_22_hk.vdig_raw(7 downto 0);

				when (x"0000075C") =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_23_hk.vdig_raw_2(15 downto 8);

				when (x"0000075D") =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_23_hk.vdig_raw_2(7 downto 0);

				when (x"0000075E") =>
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_23_hk.viclk_low(15 downto 8);

				when (x"0000075F") =>
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_23_hk.viclk_low(7 downto 0);

				when (x"00000760") =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vrd_mon_f(15 downto 8);

				when (x"00000761") =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vrd_mon_f(7 downto 0);

				when (x"00000762") =>
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vdd_mon(15 downto 8);

				when (x"00000763") =>
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_24_hk.ccd1_vdd_mon(7 downto 0);

				when (x"00000764") =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd1_vgd_mon(15 downto 8);

				when (x"00000765") =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd1_vgd_mon(7 downto 0);

				when (x"00000766") =>
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd2_vrd_mon_f(15 downto 8);

				when (x"00000767") =>
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_25_hk.ccd2_vrd_mon_f(7 downto 0);

				when (x"00000768") =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vdd_mon(15 downto 8);

				when (x"00000769") =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vdd_mon(7 downto 0);

				when (x"0000076A") =>
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vgd_mon(15 downto 8);

				when (x"0000076B") =>
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_26_hk.ccd2_vgd_mon(7 downto 0);

				when (x"0000076C") =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vrd_mon_f(15 downto 8);

				when (x"0000076D") =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vrd_mon_f(7 downto 0);

				when (x"0000076E") =>
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vdd_mon(15 downto 8);

				when (x"0000076F") =>
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_27_hk.ccd3_vdd_mon(7 downto 0);

				when (x"00000770") =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd3_vgd_mon(15 downto 8);

				when (x"00000771") =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd3_vgd_mon(7 downto 0);

				when (x"00000772") =>
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd4_vrd_mon_f(15 downto 8);

				when (x"00000773") =>
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_28_hk.ccd4_vrd_mon_f(7 downto 0);

				when (x"00000774") =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vdd_mon(15 downto 8);

				when (x"00000775") =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vdd_mon(7 downto 0);

				when (x"00000776") =>
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vgd_mon(15 downto 8);

				when (x"00000777") =>
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_29_hk.ccd4_vgd_mon(7 downto 0);

				when (x"00000778") =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_hi_mon(15 downto 8);

				when (x"00000779") =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_hi_mon(7 downto 0);

				when (x"0000077A") =>
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_lo_mon(15 downto 8);

				when (x"0000077B") =>
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_30_hk.ig_lo_mon(7 downto 0);

				when (x"0000077C") =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_a(15 downto 8);

				when (x"0000077D") =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_a(7 downto 0);

				when (x"0000077E") =>
					-- RMAP Area HK Register 31 : Tsense B HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_b(15 downto 8);

				when (x"0000077F") =>
					-- RMAP Area HK Register 31 : Tsense B HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_31_hk.tsense_b(7 downto 0);

				when (x"00000780") =>
					-- RMAP Area HK Register 32 : Register 32 HK Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_32_hk.reg_32_hk_reserved;

				when (x"00000781") =>
					-- RMAP Area HK Register 32 : SpW Status : Timecode From SpaceWire HK Field
					fee_hk_readdata_o <= rmap_registers_rd_i.reg_32_hk.spw_status_timecode_from_spw;

				when (x"00000782") =>
					-- RMAP Area HK Register 32 : SpW Status : RMAP Target Status HK Field
					fee_hk_readdata_o <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_status;

				when (x"00000783") =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Running HK Field
					fee_hk_readdata_o(0)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_running;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Disconnect HK Field
					fee_hk_readdata_o(1)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_disconnect;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Parity Error HK Field
					fee_hk_readdata_o(2)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_parity_error;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Credit Error HK Field
					fee_hk_readdata_o(3)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_credit_error;
					-- RMAP Area HK Register 32 : SpW Status : Status Link Escape Error HK Field
					fee_hk_readdata_o(4)          <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_escape_error;
					-- RMAP Area HK Register 32 : SpW Status : RMAP Target Indicate HK Field
					fee_hk_readdata_o(5)          <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_indicate;
					-- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_32_hk.spw_status_spw_status_reserved;

				when (x"00000784") =>
					-- RMAP Area HK Register 33 : Frame Counter HK Field
					fee_hk_readdata_o <= rmap_registers_rd_i.reg_33_hk.frame_counter(15 downto 8);

				when (x"00000785") =>
					-- RMAP Area HK Register 33 : Frame Counter HK Field
					fee_hk_readdata_o <= rmap_registers_rd_i.reg_33_hk.frame_counter(7 downto 0);

				when (x"00000786") =>
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_33_hk.reg_33_hk_reserved(9 downto 2);

				when (x"00000787") =>
					-- RMAP Area HK Register 33 : Frame Number HK Field
					fee_hk_readdata_o(1 downto 0) <= rmap_registers_rd_i.reg_33_hk.frame_number;
					-- RMAP Area HK Register 33 : Operational Mode HK Field
					fee_hk_readdata_o(5 downto 2) <= rmap_registers_wr_i.reg_33_hk.op_mode;
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					fee_hk_readdata_o(7 downto 6) <= rmap_registers_wr_i.reg_33_hk.reg_33_hk_reserved(1 downto 0);

				when (x"00000788") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(26 downto 19);

				when (x"00000789") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(18 downto 11);

				when (x"0000078A") =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(10 downto 3);

				when (x"0000078B") =>
					-- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field
					fee_hk_readdata_o(0)          <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate;
					-- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field
					fee_hk_readdata_o(1)          <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate;
					-- RMAP Area HK Register 34 : Error Flags : E Side Pixel External SRAM Buffer is Full HK Field
					fee_hk_readdata_o(2)          <= rmap_registers_rd_i.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full;
					-- RMAP Area HK Register 34 : Error Flags : F Side Pixel External SRAM Buffer is Full HK Field
					fee_hk_readdata_o(3)          <= rmap_registers_rd_i.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full;
					-- RMAP Area HK Register 34 : Error Flags : Invalid CCD Mode
					fee_hk_readdata_o(4)          <= rmap_registers_rd_i.reg_34_hk.error_flags_invalid_ccd_mode;
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					fee_hk_readdata_o(7 downto 5) <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(2 downto 0);

				when (x"0000078C") =>
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_35_hk.reg_35_hk_reserved(10 downto 3);

				when (x"0000078D") =>
					-- RMAP Area HK Register 35 : Board ID Field
					fee_hk_readdata_o(4 downto 0) <= rmap_registers_wr_i.reg_35_hk.board_id(8 downto 4);
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					fee_hk_readdata_o(7 downto 5) <= rmap_registers_wr_i.reg_35_hk.reg_35_hk_reserved(2 downto 0);

				when (x"0000078E") =>
					-- RMAP Area HK Register 35 : FPGA Major Version Field
					fee_hk_readdata_o(3 downto 0) <= rmap_registers_wr_i.reg_35_hk.fpga_major_version;
					-- RMAP Area HK Register 35 : Board ID Field
					fee_hk_readdata_o(7 downto 4) <= rmap_registers_wr_i.reg_35_hk.board_id(3 downto 0);

				when (x"0000078F") =>
					-- RMAP Area HK Register 35 : FPGA Minor Version Field
					fee_hk_readdata_o <= rmap_registers_wr_i.reg_35_hk.fpga_minor_version;

				when others =>
					fee_hk_readdata_o <= (others => '0');

			end case;

		end procedure p_nfee_hk_mem_rd;

		-- p_avalon_mm_rmap_read


		-- p_avalon_mm_rmap_read

		procedure p_avs_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#80#) =>
					-- RMAP Area Config Register 0 : V Start Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_0_config.v_start(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_0_config.v_start(15 downto 8);
					end if;
					-- RMAP Area Config Register 0 : V End Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_0_config.v_end(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_0_config.v_end(15 downto 8);
					end if;

				when (16#81#) =>
					-- RMAP Area Config Register 1 : Charge Injection Width Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_1_config.charge_injection_width(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_1_config.charge_injection_width(15 downto 8);
					end if;
					-- RMAP Area Config Register 1 : Charge Injection Gap Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_1_config.charge_injection_gap(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_1_config.charge_injection_gap(15 downto 8);
					end if;

				when (16#82#) =>
					-- RMAP Area Config Register 2 : Parallel Toi Period Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_2_config.parallel_toi_period(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.reg_2_config.parallel_toi_period(11 downto 8);
					end if;
					-- RMAP Area Config Register 2 : Parallel Clock Overlap Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_2_config.parallel_clk_overlap(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_2_config.parallel_clk_overlap(11 downto 8);
					end if;

				when (16#83#) =>
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (1st CCD)
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_1st_ccd;
					end if;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (2nd CCD)
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_2nd_ccd;
					end if;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (3rd CCD)
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_3rd_ccd;
					end if;
					-- RMAP Area Config Register 2 : CCD Readout Order Config Field (4th CCD)
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.reg_2_config.ccd_readout_order_4th_ccd;
					end if;

				when (16#84#) =>
					-- RMAP Area Config Register 3 : N Final Dump Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_3_config.n_final_dump(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_3_config.n_final_dump(15 downto 8);
					end if;
					-- RMAP Area Config Register 3 : H End Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_3_config.h_end(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_3_config.h_end(11 downto 8);
					end if;

				when (16#85#) =>
					-- RMAP Area Config Register 3 : Charge Injection Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_3_config.charge_injection_en;
					end if;

				when (16#86#) =>
					-- RMAP Area Config Register 3 : Tri Level Clock Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_3_config.tri_level_clk_en;
					end if;

				when (16#87#) =>
					-- RMAP Area Config Register 3 : Image Clock Direction Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_3_config.img_clk_dir;
					end if;

				when (16#88#) =>
					-- RMAP Area Config Register 3 : Register Clock Direction Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_3_config.reg_clk_dir;
					end if;

				when (16#89#) =>
					-- RMAP Area Config Register 4 : Data Packet Size Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_4_config.packet_size(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_4_config.packet_size(15 downto 8);
					end if;
					-- RMAP Area Config Register 4 : Internal Sync Period Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_4_config.int_sync_period(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_4_config.int_sync_period(15 downto 8);
					end if;

				when (16#8A#) =>
					-- RMAP Area Config Register 5 : Trap Pumping Dwell Counter Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(19 downto 16) <= rmap_registers_wr_i.reg_5_config.trap_pumping_dwell_counter(19 downto 16);
					end if;

				when (16#8B#) =>
					-- RMAP Area Config Register 5 : Sync Source Selection Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_5_config.sync_sel;
					end if;

				when (16#8C#) =>
					-- RMAP Area Config Register 5 : CCD Port Data Sensor Selection Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.reg_5_config.sensor_sel;
					end if;

				when (16#8D#) =>
					-- RMAP Area Config Register 5 : Digitalise Enable Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_5_config.digitise_en;
					end if;

				when (16#8E#) =>
					-- RMAP Area Config Register 5 : DG (Drain Gate) Enable Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_5_config.dg_en;
					end if;

				when (16#8F#) =>
					-- RMAP Area Config Register 5 : Register 5 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(6 downto 0) <= rmap_registers_wr_i.reg_5_config.reg_5_config_reserved;
					end if;

				when (16#90#) =>
					-- RMAP Area Config Register 6 : CCD 1 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_6_config.ccd1_win_list_ptr(31 downto 24);
					end if;

				when (16#91#) =>
					-- RMAP Area Config Register 7 : CCD 1 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_7_config.ccd1_pktorder_list_ptr(31 downto 24);
					end if;

				when (16#92#) =>
					-- RMAP Area Config Register 8 : CCD 1 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_8_config.ccd1_win_list_length(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_8_config.ccd1_win_list_length(15 downto 8);
					end if;
					-- RMAP Area Config Register 8 : CCD 1 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(21 downto 16) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_x;
					end if;
					-- RMAP Area Config Register 8 : CCD 1 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.reg_8_config.ccd1_win_size_y;
					end if;

				when (16#93#) =>
					-- RMAP Area Config Register 8 : Register 8 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.reg_8_config.reg_8_config_reserved;
					end if;

				when (16#94#) =>
					-- RMAP Area Config Register 9 : CCD 2 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_9_config.ccd2_win_list_ptr(31 downto 24);
					end if;

				when (16#95#) =>
					-- RMAP Area Config Register 10 : CCD 2 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_10_config.ccd2_pktorder_list_ptr(31 downto 24);
					end if;

				when (16#96#) =>
					-- RMAP Area Config Register 11 : CCD 2 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_11_config.ccd2_win_list_length(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_11_config.ccd2_win_list_length(15 downto 8);
					end if;
					-- RMAP Area Config Register 11 : CCD 2 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(21 downto 16) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_x;
					end if;
					-- RMAP Area Config Register 11 : CCD 2 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.reg_11_config.ccd2_win_size_y;
					end if;

				when (16#97#) =>
					-- RMAP Area Config Register 11 : Register 11 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.reg_11_config.reg_11_config_reserved;
					end if;

				when (16#98#) =>
					-- RMAP Area Config Register 12 : CCD 3 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_12_config.ccd3_win_list_ptr(31 downto 24);
					end if;

				when (16#99#) =>
					-- RMAP Area Config Register 13 : CCD 3 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_13_config.ccd3_pktorder_list_ptr(31 downto 24);
					end if;

				when (16#9A#) =>
					-- RMAP Area Config Register 14 : CCD 3 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_14_config.ccd3_win_list_length(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_14_config.ccd3_win_list_length(15 downto 8);
					end if;
					-- RMAP Area Config Register 14 : CCD 3 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(21 downto 16) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_x;
					end if;
					-- RMAP Area Config Register 14 : CCD 3 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.reg_14_config.ccd3_win_size_y;
					end if;

				when (16#9B#) =>
					-- RMAP Area Config Register 14 : Register 14 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.reg_14_config.reg_14_config_reserved;
					end if;

				when (16#9C#) =>
					-- RMAP Area Config Register 15 : CCD 4 Window List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_15_config.ccd4_win_list_ptr(31 downto 24);
					end if;

				when (16#9D#) =>
					-- RMAP Area Config Register 16 : CCD 4 Packet Order List Pointer Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_16_config.ccd4_pktorder_list_ptr(31 downto 24);
					end if;

				when (16#9E#) =>
					-- RMAP Area Config Register 17 : CCD 4 Window List Length Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_17_config.ccd4_win_list_length(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_17_config.ccd4_win_list_length(15 downto 8);
					end if;
					-- RMAP Area Config Register 17 : CCD 4 Window Size X Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(21 downto 16) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_x;
					end if;
					-- RMAP Area Config Register 17 : CCD 4 Window Size Y Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.reg_17_config.ccd4_win_size_y;
					end if;

				when (16#9F#) =>
					-- RMAP Area Config Register 17 : Register 17 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.reg_17_config.reg_17_config_reserved;
					end if;
					-- RMAP Area Config Register 18 : CCD Vod Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_18_config.ccd_vod_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_18_config.ccd_vod_config(11 downto 8);
					end if;

				when (16#A0#) =>
					-- RMAP Area Config Register 18 : CCD 1 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_18_config.ccd1_vrd_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.reg_18_config.ccd1_vrd_config(11 downto 8);
					end if;
					-- RMAP Area Config Register 18 : CCD 2 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_18_config.ccd2_vrd_config0;
					end if;
					-- RMAP Area Config Register 19 : CCD 2 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_19_config.ccd2_vrd_config1;
					end if;

				when (16#A1#) =>
					-- RMAP Area Config Register 19 : CCD 3 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_19_config.ccd3_vrd_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.reg_19_config.ccd3_vrd_config(11 downto 8);
					end if;
					-- RMAP Area Config Register 19 : CCD 4 Vrd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_19_config.ccd4_vrd_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_19_config.ccd4_vrd_config(11 downto 8);
					end if;

				when (16#A2#) =>
					-- RMAP Area Config Register 19 : CCD Vgd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.reg_19_config.ccd_vgd_config0;
					end if;
					-- RMAP Area Config Register 20 : CCD Vgd Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_20_config.ccd_vgd_config1;
					end if;
					-- RMAP Area Config Register 20 : CCD Vog Configurion Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_20_config.ccd_vog_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_20_config.ccd_vog_config(11 downto 8);
					end if;

				when (16#A3#) =>
					-- RMAP Area Config Register 20 : CCD Ig High Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_20_config.ccd_ig_hi_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.reg_20_config.ccd_ig_hi_config(11 downto 8);
					end if;
					-- RMAP Area Config Register 21 : CCD Ig Low Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_21_config.ccd_ig_lo_config(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.reg_21_config.ccd_ig_lo_config(11 downto 8);
					end if;

				when (16#A4#) =>
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_0(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_0(11 downto 8);
					end if;
					-- RMAP Area Config Register 21 : CCD Mode Configuration Config Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(19 downto 16) <= rmap_registers_wr_i.reg_21_config.ccd_mode_config;
					end if;
					-- RMAP Area Config Register 21 : Register 21 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(26 downto 24) <= rmap_registers_wr_i.reg_21_config.reg_21_config_reserved_1;
					end if;

				when (16#A5#) =>
					-- RMAP Area Config Register 21 : Clear Error Flag Config Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.reg_21_config.clear_error_flag;
					end if;

				when (16#A6#) =>
					-- RMAP Area Config Register 22 : Register 22 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_22_config.reg_22_config_reserved(31 downto 24);
					end if;

				when (16#A7#) =>
					-- RMAP Area Config Register 23 : CCD 1 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd1_last_e_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_23_config.ccd1_last_e_packet(9 downto 8);
					end if;
					-- RMAP Area Config Register 23 : CCD 1 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_23_config.ccd1_last_f_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.reg_23_config.ccd1_last_f_packet(9 downto 8);
					end if;

				when (16#A8#) =>
					-- RMAP Area Config Register 23 : CCD 2 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_23_config.ccd2_last_e_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_23_config.ccd2_last_e_packet(9 downto 8);
					end if;
					-- RMAP Area Config Register 23 : Register 23 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.reg_23_config.reg_23_config_reserved;
					end if;

				when (16#A9#) =>
					-- RMAP Area Config Register 24 : CCD 2 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd2_last_f_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_24_config.ccd2_last_f_packet(9 downto 8);
					end if;
					-- RMAP Area Config Register 24 : CCD 3 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_24_config.ccd3_last_e_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.reg_24_config.ccd3_last_e_packet(9 downto 8);
					end if;

				when (16#AA#) =>
					-- RMAP Area Config Register 24 : CCD 3 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_24_config.ccd3_last_f_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_24_config.ccd3_last_f_packet(9 downto 8);
					end if;
					-- RMAP Area Config Register 24 : Register 24 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.reg_24_config.reg_24_config_reserved;
					end if;

				when (16#AB#) =>
					-- RMAP Area Config Register 25 : CCD 4 Last E Packet Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_25_config.ccd4_last_e_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_25_config.ccd4_last_e_packet(9 downto 8);
					end if;
					-- RMAP Area Config Register 25 : CCD 4 Last F Packet Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_25_config.ccd4_last_f_packet(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.reg_25_config.ccd4_last_f_packet(9 downto 8);
					end if;

				when (16#AC#) =>
					-- RMAP Area Config Register 25 : Surface Inversion Counter Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_25_config.surface_inversion_counter(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_25_config.surface_inversion_counter(9 downto 8);
					end if;
					-- RMAP Area Config Register 25 : Register 25 Configuration Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.reg_25_config.reg_25_config_reserved;
					end if;

				when (16#AD#) =>
					-- RMAP Area Config Register 26 : Readout Pause Counter Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_26_config.readout_pause_counter(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_26_config.readout_pause_counter(15 downto 8);
					end if;
					-- RMAP Area Config Register 26 : Trap Pumping Shuffle Counter Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_26_config.trap_pumping_shuffle_counter(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_26_config.trap_pumping_shuffle_counter(15 downto 8);
					end if;

				when (16#AE#) =>
					-- RMAP Area HK Register 0 : TOU Sense 1 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_0_hk.tou_sense_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_0_hk.tou_sense_1(15 downto 8);
					end if;
					-- RMAP Area HK Register 0 : TOU Sense 2 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_0_hk.tou_sense_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_0_hk.tou_sense_2(15 downto 8);
					end if;

				when (16#AF#) =>
					-- RMAP Area HK Register 1 : TOU Sense 3 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_1_hk.tou_sense_3(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_1_hk.tou_sense_3(15 downto 8);
					end if;
					-- RMAP Area HK Register 1 : TOU Sense 4 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_1_hk.tou_sense_4(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_1_hk.tou_sense_4(15 downto 8);
					end if;

				when (16#B0#) =>
					-- RMAP Area HK Register 2 : TOU Sense 5 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_2_hk.tou_sense_5(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_2_hk.tou_sense_5(15 downto 8);
					end if;
					-- RMAP Area HK Register 2 : TOU Sense 6 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_2_hk.tou_sense_6(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_2_hk.tou_sense_6(15 downto 8);
					end if;

				when (16#B1#) =>
					-- RMAP Area HK Register 3 : CCD 1 TS HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_3_hk.ccd1_ts(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_3_hk.ccd1_ts(15 downto 8);
					end if;
					-- RMAP Area HK Register 3 : CCD 2 TS HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_3_hk.ccd2_ts(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_3_hk.ccd2_ts(15 downto 8);
					end if;

				when (16#B2#) =>
					-- RMAP Area HK Register 4 : CCD 3 TS HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_4_hk.ccd3_ts(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_4_hk.ccd3_ts(15 downto 8);
					end if;
					-- RMAP Area HK Register 4 : CCD 4 TS HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_4_hk.ccd4_ts(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_4_hk.ccd4_ts(15 downto 8);
					end if;

				when (16#B3#) =>
					-- RMAP Area HK Register 5 : PRT 1 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_5_hk.prt1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_5_hk.prt1(15 downto 8);
					end if;
					-- RMAP Area HK Register 5 : PRT 2 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_5_hk.prt2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_5_hk.prt2(15 downto 8);
					end if;

				when (16#B4#) =>
					-- RMAP Area HK Register 6 : PRT 3 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_6_hk.prt3(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_6_hk.prt3(15 downto 8);
					end if;
					-- RMAP Area HK Register 6 : PRT 4 HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_6_hk.prt4(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_6_hk.prt4(15 downto 8);
					end if;

				when (16#B5#) =>
					-- RMAP Area HK Register 7 : PRT 5 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_7_hk.prt5(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_7_hk.prt5(15 downto 8);
					end if;
					-- RMAP Area HK Register 7 : Zero Diff Amplifier HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_7_hk.zero_diff_amp(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_7_hk.zero_diff_amp(15 downto 8);
					end if;

				when (16#B6#) =>
					-- RMAP Area HK Register 8 : CCD 1 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_8_hk.ccd1_vod_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_8_hk.ccd1_vod_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 8 : CCD 1 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_8_hk.ccd1_vog_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_8_hk.ccd1_vog_mon(15 downto 8);
					end if;

				when (16#B7#) =>
					-- RMAP Area HK Register 9 : CCD 1 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_9_hk.ccd1_vrd_mon_e(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_9_hk.ccd1_vrd_mon_e(15 downto 8);
					end if;
					-- RMAP Area HK Register 9 : CCD 2 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_9_hk.ccd2_vod_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_9_hk.ccd2_vod_mon(15 downto 8);
					end if;

				when (16#B8#) =>
					-- RMAP Area HK Register 10 : CCD 2 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_10_hk.ccd2_vog_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_10_hk.ccd2_vog_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 10 : CCD 2 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_10_hk.ccd2_vrd_mon_e(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_10_hk.ccd2_vrd_mon_e(15 downto 8);
					end if;

				when (16#B9#) =>
					-- RMAP Area HK Register 11 : CCD 3 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_11_hk.ccd3_vod_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_11_hk.ccd3_vod_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 11 : CCD 3 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_11_hk.ccd3_vog_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_11_hk.ccd3_vog_mon(15 downto 8);
					end if;

				when (16#BA#) =>
					-- RMAP Area HK Register 12 : CCD 3 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_12_hk.ccd3_vrd_mon_e(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_12_hk.ccd3_vrd_mon_e(15 downto 8);
					end if;
					-- RMAP Area HK Register 12 : CCD 4 Vod Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_12_hk.ccd4_vod_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_12_hk.ccd4_vod_mon(15 downto 8);
					end if;

				when (16#BB#) =>
					-- RMAP Area HK Register 13 : CCD 4 Vog Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_13_hk.ccd4_vog_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_13_hk.ccd4_vog_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 13 : CCD 4 Vrd Monitor E HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_13_hk.ccd4_vrd_mon_e(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_13_hk.ccd4_vrd_mon_e(15 downto 8);
					end if;

				when (16#BC#) =>
					-- RMAP Area HK Register 14 : V CCD HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_14_hk.vccd(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_14_hk.vccd(15 downto 8);
					end if;
					-- RMAP Area HK Register 14 : VRClock Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_14_hk.vrclk_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_14_hk.vrclk_mon(15 downto 8);
					end if;

				when (16#BD#) =>
					-- RMAP Area HK Register 15 : VIClock HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_15_hk.viclk(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_15_hk.viclk(15 downto 8);
					end if;
					-- RMAP Area HK Register 15 : VRClock Low HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_15_hk.vrclk_low(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_15_hk.vrclk_low(15 downto 8);
					end if;

				when (16#BE#) =>
					-- RMAP Area HK Register 16 : 5Vb Positive Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_16_hk.d5vb_pos_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_16_hk.d5vb_pos_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 16 : 5Vb Negative Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_16_hk.d5vb_neg_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_16_hk.d5vb_neg_mon(15 downto 8);
					end if;

				when (16#BF#) =>
					-- RMAP Area HK Register 17 : 3V3b Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_17_hk.d3v3b_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_17_hk.d3v3b_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 17 : 2V5a Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_17_hk.d2v5a_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_17_hk.d2v5a_mon(15 downto 8);
					end if;

				when (16#C0#) =>
					-- RMAP Area HK Register 18 : 3V3d Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_18_hk.d3v3d_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_18_hk.d3v3d_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 18 : 2V5d Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_18_hk.d2v5d_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_18_hk.d2v5d_mon(15 downto 8);
					end if;

				when (16#C1#) =>
					-- RMAP Area HK Register 19 : 1V5d Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_19_hk.d1v5d_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_19_hk.d1v5d_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 19 : 5Vref Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_19_hk.d5vref_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_19_hk.d5vref_mon(15 downto 8);
					end if;

				when (16#C2#) =>
					-- RMAP Area HK Register 20 : Vccd Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_20_hk.vccd_pos_raw(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_20_hk.vccd_pos_raw(15 downto 8);
					end if;
					-- RMAP Area HK Register 20 : Vclk Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_20_hk.vclk_pos_raw(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_20_hk.vclk_pos_raw(15 downto 8);
					end if;

				when (16#C3#) =>
					-- RMAP Area HK Register 21 : Van 1 Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_21_hk.van1_pos_raw(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_21_hk.van1_pos_raw(15 downto 8);
					end if;
					-- RMAP Area HK Register 21 : Van 3 Negative Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_21_hk.van3_neg_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_21_hk.van3_neg_mon(15 downto 8);
					end if;

				when (16#C4#) =>
					-- RMAP Area HK Register 22 : Van Positive Raw HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_22_hk.van2_pos_raw(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_22_hk.van2_pos_raw(15 downto 8);
					end if;
					-- RMAP Area HK Register 22 : Vdig Raw HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_22_hk.vdig_raw(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_22_hk.vdig_raw(15 downto 8);
					end if;

				when (16#C5#) =>
					-- RMAP Area HK Register 23 : Vdig Raw 2 HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_23_hk.vdig_raw_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_23_hk.vdig_raw_2(15 downto 8);
					end if;
					-- RMAP Area HK Register 23 : VIClock Low HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_23_hk.viclk_low(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_23_hk.viclk_low(15 downto 8);
					end if;

				when (16#C6#) =>
					-- RMAP Area HK Register 24 : CCD 1 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_24_hk.ccd1_vrd_mon_f(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_24_hk.ccd1_vrd_mon_f(15 downto 8);
					end if;
					-- RMAP Area HK Register 24 : CCD 1 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_24_hk.ccd1_vdd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_24_hk.ccd1_vdd_mon(15 downto 8);
					end if;

				when (16#C7#) =>
					-- RMAP Area HK Register 25 : CCD 1 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_25_hk.ccd1_vgd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_25_hk.ccd1_vgd_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 25 : CCD 2 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_25_hk.ccd2_vrd_mon_f(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_25_hk.ccd2_vrd_mon_f(15 downto 8);
					end if;

				when (16#C8#) =>
					-- RMAP Area HK Register 26 : CCD 2 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_26_hk.ccd2_vdd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_26_hk.ccd2_vdd_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 26 : CCD 2 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_26_hk.ccd2_vgd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_26_hk.ccd2_vgd_mon(15 downto 8);
					end if;

				when (16#C9#) =>
					-- RMAP Area HK Register 27 : CCD 3 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_27_hk.ccd3_vrd_mon_f(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_27_hk.ccd3_vrd_mon_f(15 downto 8);
					end if;
					-- RMAP Area HK Register 27 : CCD 3 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_27_hk.ccd3_vdd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_27_hk.ccd3_vdd_mon(15 downto 8);
					end if;

				when (16#CA#) =>
					-- RMAP Area HK Register 28 : CCD 3 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_28_hk.ccd3_vgd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_28_hk.ccd3_vgd_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 28 : CCD 4 Vrd Monitor F HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_28_hk.ccd4_vrd_mon_f(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_28_hk.ccd4_vrd_mon_f(15 downto 8);
					end if;

				when (16#CB#) =>
					-- RMAP Area HK Register 29 : CCD 4 Vdd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_29_hk.ccd4_vdd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_29_hk.ccd4_vdd_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 29 : CCD 4 Vgd Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_29_hk.ccd4_vgd_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_29_hk.ccd4_vgd_mon(15 downto 8);
					end if;

				when (16#CC#) =>
					-- RMAP Area HK Register 30 : Ig High Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_30_hk.ig_hi_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_30_hk.ig_hi_mon(15 downto 8);
					end if;
					-- RMAP Area HK Register 30 : Ig Low Monitor HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_30_hk.ig_lo_mon(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_30_hk.ig_lo_mon(15 downto 8);
					end if;

				when (16#CD#) =>
					-- RMAP Area HK Register 31 : Tsense A HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_31_hk.tsense_a(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_31_hk.tsense_a(15 downto 8);
					end if;
					-- RMAP Area HK Register 31 : Tsense B HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_31_hk.tsense_b(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.reg_31_hk.tsense_b(15 downto 8);
					end if;

				when (16#CE#) =>
					-- RMAP Area HK Register 32 : SpW Status : Timecode From SpaceWire HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.reg_32_hk.spw_status_timecode_from_spw;
					end if;
					-- RMAP Area HK Register 32 : SpW Status : RMAP Target Status HK Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_status;
					end if;
					-- RMAP Area HK Register 32 : SpW Status : SpaceWire Status Reserved
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.reg_32_hk.spw_status_spw_status_reserved;
					end if;

				when (16#CF#) =>
					-- RMAP Area HK Register 32 : SpW Status : RMAP Target Indicate HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_rmap_target_indicate;
					end if;

				when (16#D0#) =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Escape Error HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_escape_error;
					end if;

				when (16#D1#) =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Credit Error HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_credit_error;
					end if;

				when (16#D2#) =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Parity Error HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_parity_error;
					end if;

				when (16#D3#) =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Disconnect HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_disconnect;
					end if;

				when (16#D4#) =>
					-- RMAP Area HK Register 32 : SpW Status : Status Link Running HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_32_hk.spw_status_stat_link_running;
					end if;

				when (16#D5#) =>
					-- RMAP Area HK Register 32 : Register 32 HK Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_32_hk.reg_32_hk_reserved;
					end if;
					-- RMAP Area HK Register 33 : Frame Counter HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_rd_i.reg_33_hk.frame_counter(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_rd_i.reg_33_hk.frame_counter(15 downto 8);
					end if;

				when (16#D6#) =>
					-- RMAP Area HK Register 33 : Register 33 HK Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_33_hk.reg_33_hk_reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.reg_33_hk.reg_33_hk_reserved(9 downto 8);
					end if;
					-- RMAP Area HK Register 33 : Operational Mode HK Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(19 downto 16) <= rmap_registers_wr_i.reg_33_hk.op_mode;
					end if;
					-- RMAP Area HK Register 33 : Frame Number HK Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_rd_i.reg_33_hk.frame_number;
					end if;

				when (16#D7#) =>
					-- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_x_coordinate;
					end if;

				when (16#D8#) =>
					-- RMAP Area HK Register 34 : Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_window_pixels_fall_outside_cdd_boundary_due_to_wrong_y_coordinate;
					end if;

				when (16#D9#) =>
					-- RMAP Area HK Register 34 : Error Flags : E Side Pixel External SRAM Buffer is Full HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_e_side_pixel_external_sram_buffer_is_full;
					end if;

				when (16#DA#) =>
					-- RMAP Area HK Register 34 : Error Flags : F Side Pixel External SRAM Buffer is Full HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_f_side_pixel_external_sram_buffer_is_full;
					end if;

				when (16#DB#) =>
					-- RMAP Area HK Register 34 : Error Flags : Invalid CCD Mode
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.reg_34_hk.error_flags_invalid_ccd_mode;
					end if;

				when (16#DC#) =>
					-- RMAP Area HK Register 34 : Error Flags : Error Flags Reserved
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(26 downto 24) <= rmap_registers_wr_i.reg_34_hk.error_flags_error_flags_reserved(26 downto 24);
					end if;

				when (16#DD#) =>
					-- RMAP Area HK Register 35 : FPGA Minor Version Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_35_hk.fpga_minor_version;
					end if;
					-- RMAP Area HK Register 35 : FPGA Major Version Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.reg_35_hk.fpga_major_version;
					end if;
					-- RMAP Area HK Register 35 : Board ID Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.reg_35_hk.board_id(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(24) <= rmap_registers_wr_i.reg_35_hk.board_id(8);
					end if;

				when (16#DE#) =>
					-- RMAP Area HK Register 35 : Register 35 HK Reserved HK Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.reg_35_hk.reg_35_hk_reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(10 downto 8) <= rmap_registers_wr_i.reg_35_hk.reg_35_hk_reserved(10 downto 8);
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_rmap_o.readdata <= (others => '0');

			end case;

		end procedure p_avs_readdata;

		variable v_read_address     : t_avalon_mm_spacewire_address := 0;
		variable v_read_timeout_cnt : natural range 0 to 15         := 15;
		variable v_read_executed    : std_logic                     := '0';

	begin
		if (rst_i = '1') then
			fee_hk_datavalid_o           <= '0';
			fee_hk_readdata_o            <= (others => '0');
			rmap_memerror_o              <= '0';
			rmap_datavalid_o             <= '0';
			rmap_readdata_o              <= (others => '0');
			-- p_avalon_mm_rmap_read
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			v_read_address               := 0;
			v_read_timeout_cnt           := 15;
			v_read_executed              := '0';
		elsif rising_edge(clk_i) then

			-- fee hk read
			fee_hk_datavalid_o <= '0';
			fee_hk_readdata_o  <= (others => '0');
			-- check if a read request was issued
			if (fee_hk_read_i = '1') then
				fee_hk_datavalid_o <= '1';
				--				fee_hk_readdata_o; 
				p_nfee_hk_mem_rd(fee_hk_readaddr_i);
			end if;

			-- rmap read
			rmap_memerror_o  <= '0';
			rmap_datavalid_o <= '0';
			rmap_readdata_o  <= (others => '0');
			-- check if a read request was issued
			if (rmap_read_i = '1') then
				rmap_datavalid_o <= '1';
				--				rmap_readdata_o;
				p_nfee_rmap_mem_rd(rmap_readaddr_i);
			end if;

			-- p_avalon_mm_rmap_read

			avalon_mm_rmap_o.waitrequest <= '1';
			if (v_read_executed = '0') then
				avalon_mm_rmap_o.readdata <= (others => '0');
				if (avalon_mm_rmap_i.read = '1') then
					v_read_address := to_integer(unsigned(avalon_mm_rmap_i.address));
					-- check if the read address is in the rmap area range
					--					if ((v_read_address >= 16#A0#) and (v_read_address <= 16#BF#)) then
					--						-- read address is in the rmap housekeeping area range
					--						-- no need to protect hk registers, read register
					--						avalon_mm_rmap_o.waitrequest <= '0';
					--						p_avs_hk_readdata(v_read_address);
					--						v_read_timeout_cnt           := 15;
					--						v_read_executed              := '1';
					--					elsif ((v_read_address >= 16#40#) and (v_read_address <= 16#51#)) then
					if ((v_read_address >= c_AVALON_MM_RMAP_MIN_ADDR) and (v_read_address <= c_AVALON_MM_RMAP_MAX_ADDR)) then
						-- read address is in the rmap config area range 
						-- check if a rmap write is ocurring
						if (rmap_write_authorized_i = '0') then
							-- rmap write not ocurring, read register
							avalon_mm_rmap_o.waitrequest <= '0';
							p_avs_readdata(v_read_address);
							v_read_timeout_cnt           := 15;
							v_read_executed              := '1';
						else
							-- rmap write ocurring, wait to read register
							avalon_mm_rmap_o.waitrequest <= '1';
							v_read_timeout_cnt           := v_read_timeout_cnt - 1;
							-- check if the write finished or a timeout ocurred
							if ((rmap_write_finished_i = '1') or (v_read_timeout_cnt = 0)) then
								-- write finished or timeout ocurred, read register	
								avalon_mm_rmap_o.waitrequest <= '0';
								p_avs_readdata(v_read_address);
								v_read_timeout_cnt           := 15;
								v_read_executed              := '1';
							end if;
						end if;
					end if;
				end if;
			else
				v_read_executed := '0';
			end if;
		end if;
	end process p_rmap_mem_area_nfee_read;

end architecture RTL;
