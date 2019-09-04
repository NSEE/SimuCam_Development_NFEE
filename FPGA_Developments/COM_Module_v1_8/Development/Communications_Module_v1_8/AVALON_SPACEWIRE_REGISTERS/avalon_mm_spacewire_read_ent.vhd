library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;

entity avalon_mm_spacewire_read_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_read_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_read_out;
		spacewire_write_registers_i : in  t_windowing_write_registers;
		spacewire_read_registers_i  : in  t_windowing_read_registers
	);
end entity avalon_mm_spacewire_read_ent;

architecture rtl of avalon_mm_spacewire_read_ent is

begin

	p_avalon_mm_spacewire_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Comm Device Address Register : Comm Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.comm_dev_addr_reg.comm_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.comm_dev_addr_reg.comm_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.comm_dev_addr_reg.comm_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.comm_dev_addr_reg.comm_dev_base_addr(31 downto 24);
					end if;

				when (16#01#) =>
					-- Comm IRQ Control Register : Comm Global IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.comm_irq_control_reg.comm_global_irq_en;
					end if;

				when (16#02#) =>
					-- SpaceWire Device Address Register : SpaceWire Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24);
					end if;

				when (16#03#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.spw_link_config_reg.spw_lnkcfg_disconnect;
					end if;

				when (16#04#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.spw_link_config_reg.spw_lnkcfg_linkstart;
					end if;

				when (16#05#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.spw_link_config_reg.spw_lnkcfg_autostart;
					end if;

				when (16#06#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.spw_link_config_reg.spw_lnkcfg_txdivcnt;
					end if;

				when (16#07#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Running
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_link_running;
					end if;

				when (16#08#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Connecting
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_link_connecting;
					end if;

				when (16#09#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Started
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_link_started;
					end if;

				when (16#0A#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Disconnect
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_err_disconnect;
					end if;

				when (16#0B#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Parity
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_err_parity;
					end if;

				when (16#0C#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Escape
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_err_escape;
					end if;

				when (16#0D#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Credit
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.spw_link_status_reg.spw_err_credit;
					end if;

				when (16#0E#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.spw_timecode_config_reg.timecode_clear;
					end if;

				when (16#0F#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.spw_timecode_config_reg.timecode_en;
					end if;

				when (16#10#) =>
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Time
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(5 downto 0) <= spacewire_read_registers_i.spw_timecode_status_reg.timecode_time;
					end if;
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Control
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(9 downto 8) <= spacewire_read_registers_i.spw_timecode_status_reg.timecode_control;
					end if;

				when (16#11#) =>
					-- FEE Buffers Device Address Register : FEE Buffers Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(31 downto 24);
					end if;

				when (16#12#) =>
					-- FEE Machine Config Register : FEE Machine Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_machine_clear;
					end if;

				when (16#13#) =>
					-- FEE Machine Config Register : FEE Machine Stop
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_machine_stop;
					end if;

				when (16#14#) =>
					-- FEE Machine Config Register : FEE Machine Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_machine_start;
					end if;

				when (16#15#) =>
					-- FEE Machine Config Register : FEE Data Controller Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_data_controller_en;
					end if;

				when (16#16#) =>
					-- FEE Machine Config Register : FEE Digitalise Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_digitalise_en;
					end if;

				when (16#17#) =>
					-- FEE Machine Config Register : FEE Windowing Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_windowing_en;
					end if;

				when (16#18#) =>
					-- FEE Buffers Config Register : Windowing Right Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(3 downto 0) <= spacewire_write_registers_i.fee_buffers_config_reg.fee_right_buffer_size;
					end if;
					-- FEE Buffers Config Register : Windowing Left Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(11 downto 8) <= spacewire_write_registers_i.fee_buffers_config_reg.fee_left_buffer_size;
					end if;

				when (16#19#) =>
					-- FEE Buffers Status Register : Windowing Right Buffer Empty
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_right_buffer_empty;
					end if;

				when (16#1A#) =>
					-- FEE Buffers Status Register : Windowing Left Buffer Empty
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_left_buffer_empty;
					end if;

				when (16#1B#) =>
					-- FEE Buffers Status Register : FEE Right Machine Busy
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_right_machine_busy;
					end if;

				when (16#1C#) =>
					-- FEE Buffers Status Register : FEE Left Machine Busy
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_left_machine_busy;
					end if;

				when (16#1D#) =>
					-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_control_reg.fee_right_buffer_empty_en;
					end if;

				when (16#1E#) =>
					-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_control_reg.fee_left_buffer_empty_en;
					end if;

				when (16#1F#) =>
					-- FEE Buffers IRQ Flags Register : FEE Right Buffer 0 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_right_buffer_0_empty_flag;
					end if;

				when (16#20#) =>
					-- FEE Buffers IRQ Flags Register : FEE Right Buffer 1 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_right_buffer_1_empty_flag;
					end if;

				when (16#21#) =>
					-- FEE Buffers IRQ Flags Register : FEE Left Buffer 0 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_left_buffer_0_empty_flag;
					end if;

				when (16#22#) =>
					-- FEE Buffers IRQ Flags Register : FEE Left Buffer 1 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_left_buffer_1_empty_flag;
					end if;

				when (16#23#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear;
					end if;

				when (16#24#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear;
					end if;

				when (16#25#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear;
					end if;

				when (16#26#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear;
					end if;

				when (16#27#) =>
					-- FEE Buffers IRQ Number Register : FEE Buffers IRQ Number/ID
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_buffers_irq_number_reg.fee_buffers_irq_number(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_buffers_irq_number_reg.fee_buffers_irq_number(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_buffers_irq_number_reg.fee_buffers_irq_number(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_buffers_irq_number_reg.fee_buffers_irq_number(31 downto 24);
					end if;

				when (16#28#) =>
					-- RMAP Device Address Register : RMAP Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24);
					end if;

				when (16#29#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_logical_addr;
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_key;
					end if;

				when (16#2A#) =>
					-- RMAP Codec Status Register : RMAP Status Command Received
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_command_received;
					end if;

				when (16#2B#) =>
					-- RMAP Codec Status Register : RMAP Status Write Requested
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_requested;
					end if;

				when (16#2C#) =>
					-- RMAP Codec Status Register : RMAP Status Write Authorized
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_authorized;
					end if;

				when (16#2D#) =>
					-- RMAP Codec Status Register : RMAP Status Read Requested
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_requested;
					end if;

				when (16#2E#) =>
					-- RMAP Codec Status Register : RMAP Status Read Authorized
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_authorized;
					end if;

				when (16#2F#) =>
					-- RMAP Codec Status Register : RMAP Status Reply Sended
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_reply_sended;
					end if;

				when (16#30#) =>
					-- RMAP Codec Status Register : RMAP Status Discarded Package
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_discarded_package;
					end if;

				when (16#31#) =>
					-- RMAP Codec Status Register : RMAP Error Early EOP
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_early_eop;
					end if;

				when (16#32#) =>
					-- RMAP Codec Status Register : RMAP Error EEP
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_eep;
					end if;

				when (16#33#) =>
					-- RMAP Codec Status Register : RMAP Error Header CRC
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_header_crc;
					end if;

				when (16#34#) =>
					-- RMAP Codec Status Register : RMAP Error Unused Packet Type
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_unused_packet_type;
					end if;

				when (16#35#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Command Code
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_command_code;
					end if;

				when (16#36#) =>
					-- RMAP Codec Status Register : RMAP Error Too Much Data
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_too_much_data;
					end if;

				when (16#37#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Data CRC
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_data_crc;
					end if;

				when (16#38#) =>
					-- RMAP Memory Status Register : RMAP Last Write Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_addr(31 downto 24);
					end if;

				when (16#39#) =>
					-- RMAP Memory Status Register : RMAP Last Read Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_addr(31 downto 24);
					end if;

				when (16#3A#) =>
					-- RMAP Memory Area Address Register : RMAP Config Memory Area Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(31 downto 24);
					end if;

				when (16#3B#) =>
					-- RMAP Memory Area Address Register : RMAP HouseKeeping Memory Area Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(31 downto 24);
					end if;

				when (16#3C#) =>
					-- RMAP IRQ Control Register : RMAP Write Command IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_irq_control_reg.rmap_write_command_en;
					end if;

				when (16#3D#) =>
					-- RMAP IRQ Flags Register : RMAP Write Command IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_irq_flags_reg.rmap_write_command_flag;
					end if;

				when (16#3E#) =>
					-- RMAP IRQ Flags Clear Register : RMAP Write Command IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_irq_flags_clear_reg.rmap_write_command_flag_clear;
					end if;

				when (16#3F#) =>
					-- RMAP IRQ Number Register : RMAP IRQ Number/ID
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.rmap_irq_number_reg.rmap_irq_number(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.rmap_irq_number_reg.rmap_irq_number(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.rmap_irq_number_reg.rmap_irq_number(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.rmap_irq_number_reg.rmap_irq_number(31 downto 24);
					end if;

				when (16#40#) =>
					-- Data Packet Device Channel Address Register : Data Packet Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_dev_addr_reg.data_packet_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_dev_addr_reg.data_packet_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_dev_addr_reg.data_packet_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_dev_addr_reg.data_packet_dev_base_addr(31 downto 24);
					end if;

				when (16#41#) =>
					-- Data Packet Config Register : Data Packet CCD X Size
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_x_size(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_x_size(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD Y Size
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_y_size(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_y_size(15 downto 8);
					end if;

				when (16#42#) =>
					-- Data Packet Config Register : Data Packet Data Y Size
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_data_y_size(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_data_y_size(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet Overscan Y Size
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_overscan_y_size(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_overscan_y_size(15 downto 8);
					end if;

				when (16#43#) =>
					-- Data Packet Config Register : Data Packet Packet Length
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_packet_length(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_packet_length(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet Logical Address
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_logical_addr;
					end if;
					-- Data Packet Config Register : Data Packet Protocol ID
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_protocol_id;
					end if;

				when (16#44#) =>
					-- Data Packet Config Register : Data Packet FEE Mode
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(3 downto 0) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_fee_mode;
					end if;
					-- Data Packet Config Register : Data Packet CCD Number
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(9 downto 8) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_number;
					end if;
					-- Data Packet Header Register : Data Packet Header Length
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_length(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_length(15 downto 8);
					end if;

				when (16#45#) =>
					-- Data Packet Header Register : Data Packet Header Type
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_type(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_type(15 downto 8);
					end if;
					-- Data Packet Header Register : Data Packet Header Frame Counter
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_frame_counter(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_frame_counter(15 downto 8);
					end if;

				when (16#46#) =>
					-- Data Packet Header Register : Data Packet Header Sequence Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_sequence_counter(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_sequence_counter(15 downto 8);
					end if;
					-- Data Packet Pixel Delay Register : Data Packet Line Delay
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_line_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_line_delay(15 downto 8);
					end if;

				when (16#47#) =>
					-- Data Packet Pixel Delay Register : Data Packet Column Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_column_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_column_delay(15 downto 8);
					end if;
					-- Data Packet Pixel Delay Register : Data Packet ADC Delay
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_adc_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_adc_delay(15 downto 8);
					end if;

				when others =>
					avalon_mm_spacewire_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_read_address                    := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			if (avalon_mm_spacewire_i.read = '1') then
				v_read_address := to_integer(unsigned(avalon_mm_spacewire_i.address));
				-- check if the address is allowed
				if ((v_read_address >= c_AVALON_MM_SPACEWIRE_MIN_ADDR) and (v_read_address <= c_AVALON_MM_SPACEWIRE_MAX_ADDR)) then
					avalon_mm_spacewire_o.waitrequest <= '0';
					p_readdata(v_read_address);
				end if;
			end if;
		end if;
	end process p_avalon_mm_spacewire_read;

end architecture rtl;
