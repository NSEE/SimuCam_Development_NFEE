library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.scom_avs_config_pkg.all;
use work.scom_avs_config_registers_pkg.all;

entity scom_avs_config_read_ent is
	port(
		clk_i            : in  std_logic;
		rst_i            : in  std_logic;
		avs_config_i     : in  t_scom_avs_config_read_in;
		avs_config_o     : out t_scom_avs_config_read_out;
		config_wr_regs_i : in  t_scom_config_wr_regs;
		config_rd_regs_i : in  t_scom_config_rd_regs
	);
end entity scom_avs_config_read_ent;

architecture rtl of scom_avs_config_read_ent is

begin

	p_scom_avs_config_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_scom_avs_config_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Scom Device Address Register : Scom Device Base Address
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.scom_dev_addr_reg.scom_dev_base_addr(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.scom_dev_addr_reg.scom_dev_base_addr(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_wr_regs_i.scom_dev_addr_reg.scom_dev_base_addr(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_wr_regs_i.scom_dev_addr_reg.scom_dev_base_addr(31 downto 24);
					end if;

				when (16#01#) =>
					-- SpaceWire Device Address Register : SpaceWire Device Base Address
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_wr_regs_i.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_wr_regs_i.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24);
					end if;

				when (16#02#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_wr_regs_i.spw_link_config_reg.spw_lnkcfg_disconnect;
					end if;

				when (16#03#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_wr_regs_i.spw_link_config_reg.spw_lnkcfg_linkstart;
					end if;

				when (16#04#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_wr_regs_i.spw_link_config_reg.spw_lnkcfg_autostart;
					end if;

				when (16#05#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.spw_link_config_reg.spw_lnkcfg_txdivcnt;
					end if;

				when (16#06#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Running
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_link_running;
					end if;

				when (16#07#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Connecting
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_link_connecting;
					end if;

				when (16#08#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Started
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_link_started;
					end if;

				when (16#09#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Disconnect
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_err_disconnect;
					end if;

				when (16#0A#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Parity
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_err_parity;
					end if;

				when (16#0B#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Escape
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_err_escape;
					end if;

				when (16#0C#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Credit
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.spw_link_status_reg.spw_err_credit;
					end if;

				when (16#0D#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_wr_regs_i.spw_timecode_config_reg.timecode_clear;
					end if;

				when (16#0E#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_wr_regs_i.spw_timecode_config_reg.timecode_en;
					end if;

				when (16#0F#) =>
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Time
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(5 downto 0) <= config_rd_regs_i.spw_timecode_status_reg.timecode_time;
					end if;
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Control
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(9 downto 8) <= config_rd_regs_i.spw_timecode_status_reg.timecode_control;
					end if;

				when (16#10#) =>
					-- RMAP Device Address Register : RMAP Device Base Address
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_wr_regs_i.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_wr_regs_i.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24);
					end if;

				when (16#11#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.rmap_codec_config_reg.rmap_target_logical_addr;
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.rmap_codec_config_reg.rmap_target_key;
					end if;

				when (16#12#) =>
					-- RMAP Codec Status Register : RMAP Status Command Received
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_command_received;
					end if;

				when (16#13#) =>
					-- RMAP Codec Status Register : RMAP Status Write Requested
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_write_requested;
					end if;

				when (16#14#) =>
					-- RMAP Codec Status Register : RMAP Status Write Authorized
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_write_authorized;
					end if;

				when (16#15#) =>
					-- RMAP Codec Status Register : RMAP Status Read Requested
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_read_requested;
					end if;

				when (16#16#) =>
					-- RMAP Codec Status Register : RMAP Status Read Authorized
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_read_authorized;
					end if;

				when (16#17#) =>
					-- RMAP Codec Status Register : RMAP Status Reply Sended
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_reply_sended;
					end if;

				when (16#18#) =>
					-- RMAP Codec Status Register : RMAP Status Discarded Package
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_stat_discarded_package;
					end if;

				when (16#19#) =>
					-- RMAP Codec Status Register : RMAP Error Early EOP
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_early_eop;
					end if;

				when (16#1A#) =>
					-- RMAP Codec Status Register : RMAP Error EEP
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_eep;
					end if;

				when (16#1B#) =>
					-- RMAP Codec Status Register : RMAP Error Header CRC
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_header_crc;
					end if;

				when (16#1C#) =>
					-- RMAP Codec Status Register : RMAP Error Unused Packet Type
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_unused_packet_type;
					end if;

				when (16#1D#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Command Code
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_invalid_command_code;
					end if;

				when (16#1E#) =>
					-- RMAP Codec Status Register : RMAP Error Too Much Data
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_too_much_data;
					end if;

				when (16#1F#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Data CRC
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(0) <= config_rd_regs_i.rmap_codec_status_reg.rmap_err_invalid_data_crc;
					end if;

				when (16#20#) =>
					-- RMAP Memory Status Register : RMAP Last Write Address
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_addr(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_addr(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_addr(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_addr(31 downto 24);
					end if;

				when (16#21#) =>
					-- RMAP Memory Status Register : RMAP Last Write Length [Bytes]
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_length_bytes(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_length_bytes(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_length_bytes(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_write_length_bytes(31 downto 24);
					end if;

				when (16#22#) =>
					-- RMAP Memory Status Register : RMAP Last Read Address
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_addr(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_addr(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_addr(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_addr(31 downto 24);
					end if;

				when (16#23#) =>
					-- RMAP Memory Status Register : RMAP Last Read Length [Bytes]
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_length_bytes(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_length_bytes(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_length_bytes(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_rd_regs_i.rmap_memory_status_reg.rmap_last_read_length_bytes(31 downto 24);
					end if;

				when (16#24#) =>
					-- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(31 downto 24);
					end if;

				when (16#25#) =>
					-- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_wr_regs_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(31 downto 24);
					end if;

				when (16#26#) =>
					-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
					if (avs_config_i.byteenable(0) = '1') then
						avs_config_o.readdata(7 downto 0) <= config_wr_regs_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(7 downto 0);
					end if;
					if (avs_config_i.byteenable(1) = '1') then
						avs_config_o.readdata(15 downto 8) <= config_wr_regs_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(15 downto 8);
					end if;
					if (avs_config_i.byteenable(2) = '1') then
						avs_config_o.readdata(23 downto 16) <= config_wr_regs_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(23 downto 16);
					end if;
					if (avs_config_i.byteenable(3) = '1') then
						avs_config_o.readdata(31 downto 24) <= config_wr_regs_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(31 downto 24);
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avs_config_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_scom_avs_config_address := 0;
	begin
		if (rst_i = '1') then
			avs_config_o.readdata    <= (others => '0');
			avs_config_o.waitrequest <= '1';
			v_read_address           := 0;
		elsif (rising_edge(clk_i)) then
			avs_config_o.readdata    <= (others => '0');
			avs_config_o.waitrequest <= '1';
			if (avs_config_i.read = '1') then
				v_read_address           := to_integer(unsigned(avs_config_i.address));
				-- check if the address is allowed
				--				if ((v_read_address >= c_SCOM_AVS_CONFIG_MIN_ADDR) and (v_read_address <= c_SCOM_AVS_CONFIG_MAX_ADDR)) then
				avs_config_o.waitrequest <= '0';
				p_readdata(v_read_address);
				--				end if;
			end if;
		end if;
	end process p_scom_avs_config_read;

end architecture rtl;
