library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;

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
					-- FEE Machine Config Register : FEE Buffer Overflow Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_buffer_overflow_en;
					end if;

				when (16#16#) =>
					-- FEE Machine Config Register : FEE Digitalise Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_digitalise_en;
					end if;

				when (16#17#) =>
					-- FEE Machine Config Register : FEE Readout Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_readout_en;
					end if;

				when (16#18#) =>
					-- FEE Machine Config Register : FEE Windowing Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_windowing_en;
					end if;

				when (16#19#) =>
					-- FEE Machine Config Register : FEE Statistics Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_machine_config_reg.fee_statistics_clear;
					end if;

				when (16#1A#) =>
					-- FEE Machine Statistics Register : FEE Incoming Packets Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_pkts_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_pkts_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_pkts_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_pkts_cnt(31 downto 24);
					end if;

				when (16#1B#) =>
					-- FEE Machine Statistics Register : FEE Incoming Bytes Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_bytes_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_bytes_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_bytes_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_incoming_bytes_cnt(31 downto 24);
					end if;

				when (16#1C#) =>
					-- FEE Machine Statistics Register : FEE Outgoing Packets Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_pkts_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_pkts_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_pkts_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_pkts_cnt(31 downto 24);
					end if;

				when (16#1D#) =>
					-- FEE Machine Statistics Register : FEE Outgoing Bytes Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_bytes_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_bytes_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_bytes_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_outgoing_bytes_cnt(31 downto 24);
					end if;

				when (16#1E#) =>
					-- FEE Machine Statistics Register : FEE SpW Link Escape Errors Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_escape_err_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_escape_err_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_escape_err_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_escape_err_cnt(31 downto 24);
					end if;

				when (16#1F#) =>
					-- FEE Machine Statistics Register : FEE SpW Link Credit Errors Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_credit_err_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_credit_err_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_credit_err_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_credit_err_cnt(31 downto 24);
					end if;

				when (16#20#) =>
					-- FEE Machine Statistics Register : FEE SpW Link Parity Errors Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_parity_err_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_parity_err_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_parity_err_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_parity_err_cnt(31 downto 24);
					end if;

				when (16#21#) =>
					-- FEE Machine Statistics Register : FEE SpW Link Disconnects Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_disconnect_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_disconnect_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_disconnect_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_link_disconnect_cnt(31 downto 24);
					end if;

				when (16#22#) =>
					-- FEE Machine Statistics Register : FEE SpaceWire EEPs Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_eep_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_eep_cnt(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_eep_cnt(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.fee_machine_statistics_reg.fee_spw_eep_cnt(31 downto 24);
					end if;

				when (16#23#) =>
					-- FEE Buffers Config Register : Windowing Right Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(3 downto 0) <= spacewire_write_registers_i.fee_buffers_config_reg.fee_right_buffer_size;
					end if;
					-- FEE Buffers Config Register : Windowing Left Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(11 downto 8) <= spacewire_write_registers_i.fee_buffers_config_reg.fee_left_buffer_size;
					end if;

				when (16#24#) =>
					-- FEE Buffers Status Register : Windowing Right Buffer Empty
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_right_buffer_empty;
					end if;

				when (16#25#) =>
					-- FEE Buffers Status Register : Windowing Left Buffer Empty
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_left_buffer_empty;
					end if;

				when (16#26#) =>
					-- FEE Buffers Status Register : FEE Right Machine Busy
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_right_machine_busy;
					end if;

				when (16#27#) =>
					-- FEE Buffers Status Register : FEE Left Machine Busy
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_status_reg.fee_left_machine_busy;
					end if;

				when (16#28#) =>
					-- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword(31 downto 24);
					end if;

				when (16#29#) =>
					-- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword(31 downto 24);
					end if;

				when (16#2A#) =>
					-- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_data_length_bytes(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_data_length_bytes(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_data_length_bytes(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_data_length_bytes(31 downto 24);
					end if;

				when (16#2B#) =>
					-- FEE Buffers Data Control Register : Right Data Read Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_start;
					end if;

				when (16#2C#) =>
					-- FEE Buffers Data Control Register : Right Data Read Reset
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.right_rd_reset;
					end if;

				when (16#2D#) =>
					-- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword(31 downto 24);
					end if;

				when (16#2E#) =>
					-- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword(31 downto 24);
					end if;

				when (16#2F#) =>
					-- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_data_length_bytes(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_data_length_bytes(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_data_length_bytes(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_data_length_bytes(31 downto 24);
					end if;

				when (16#30#) =>
					-- FEE Buffers Data Control Register : Left Data Read Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_start;
					end if;

				when (16#31#) =>
					-- FEE Buffers Data Control Register : Left Data Read Reset
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_data_control_reg.left_rd_reset;
					end if;

				when (16#32#) =>
					-- FEE Buffers Data Status Register : Right Data Read Busy
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_data_status_reg.right_rd_busy;
					end if;

				when (16#33#) =>
					-- FEE Buffers Data Status Register : Left Data Read Busy
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_data_status_reg.left_rd_busy;
					end if;

				when (16#34#) =>
					-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_control_reg.fee_right_buffer_empty_en;
					end if;

				when (16#35#) =>
					-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_control_reg.fee_left_buffer_empty_en;
					end if;

				when (16#36#) =>
					-- FEE Buffers IRQ Flags Register : FEE Right Buffer 0 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_right_buffer_0_empty_flag;
					end if;

				when (16#37#) =>
					-- FEE Buffers IRQ Flags Register : FEE Right Buffer 1 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_right_buffer_1_empty_flag;
					end if;

				when (16#38#) =>
					-- FEE Buffers IRQ Flags Register : FEE Left Buffer 0 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_left_buffer_0_empty_flag;
					end if;

				when (16#39#) =>
					-- FEE Buffers IRQ Flags Register : FEE Left Buffer 1 Empty IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.fee_buffers_irq_flags_reg.fee_left_buffer_1_empty_flag;
					end if;

				when (16#3A#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear;
					end if;

				when (16#3B#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear;
					end if;

				when (16#3C#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear;
					end if;

				when (16#3D#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear;
					end if;

				when (16#3E#) =>
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

				when (16#3F#) =>
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

				when (16#40#) =>
					-- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable;
					end if;

				when (16#41#) =>
					-- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_echoing_mode_config_reg.rmap_echoing_id_enable;
					end if;

				when (16#42#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_logical_addr;
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_key;
					end if;

				when (16#43#) =>
					-- RMAP Codec Status Register : RMAP Status Command Received
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_command_received;
					end if;

				when (16#44#) =>
					-- RMAP Codec Status Register : RMAP Status Write Requested
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_requested;
					end if;

				when (16#45#) =>
					-- RMAP Codec Status Register : RMAP Status Write Authorized
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_authorized;
					end if;

				when (16#46#) =>
					-- RMAP Codec Status Register : RMAP Status Read Requested
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_requested;
					end if;

				when (16#47#) =>
					-- RMAP Codec Status Register : RMAP Status Read Authorized
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_authorized;
					end if;

				when (16#48#) =>
					-- RMAP Codec Status Register : RMAP Status Reply Sended
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_reply_sended;
					end if;

				when (16#49#) =>
					-- RMAP Codec Status Register : RMAP Status Discarded Package
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_discarded_package;
					end if;

				when (16#4A#) =>
					-- RMAP Codec Status Register : RMAP Error Early EOP
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_early_eop;
					end if;

				when (16#4B#) =>
					-- RMAP Codec Status Register : RMAP Error EEP
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_eep;
					end if;

				when (16#4C#) =>
					-- RMAP Codec Status Register : RMAP Error Header CRC
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_header_crc;
					end if;

				when (16#4D#) =>
					-- RMAP Codec Status Register : RMAP Error Unused Packet Type
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_unused_packet_type;
					end if;

				when (16#4E#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Command Code
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_command_code;
					end if;

				when (16#4F#) =>
					-- RMAP Codec Status Register : RMAP Error Too Much Data
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_too_much_data;
					end if;

				when (16#50#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Data CRC
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_data_crc;
					end if;

				when (16#51#) =>
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

				when (16#52#) =>
					-- RMAP Memory Status Register : RMAP Last Write Length [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_length_bytes(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_length_bytes(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_length_bytes(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_write_length_bytes(31 downto 24);
					end if;

				when (16#53#) =>
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

				when (16#54#) =>
					-- RMAP Memory Status Register : RMAP Last Read Length [Bytes]
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_length_bytes(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_length_bytes(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_length_bytes(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.rmap_memory_status_reg.rmap_last_read_length_bytes(31 downto 24);
					end if;

				when (16#55#) =>
					-- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_high_dword(31 downto 24);
					end if;

				when (16#56#) =>
					-- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.rmap_memory_config_reg.rmap_win_area_offset_low_dword(31 downto 24);
					end if;

				when (16#57#) =>
					-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(31 downto 24);
					end if;

				when (16#58#) =>
					-- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_irq_control_reg.rmap_write_config_en;
					end if;

				when (16#59#) =>
					-- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_irq_control_reg.rmap_write_window_en;
					end if;

				when (16#5A#) =>
					-- RMAP IRQ Flags Register : RMAP Write Config IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_irq_flags_reg.rmap_write_config_flag;
					end if;

				when (16#5B#) =>
					-- RMAP IRQ Flags Register : RMAP Write Config IRQ Flag
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_read_registers_i.rmap_irq_flags_reg.rmap_write_window_flag;
					end if;

				when (16#5C#) =>
					-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear;
					end if;

				when (16#5D#) =>
					-- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear;
					end if;

				when (16#5E#) =>
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

				when (16#5F#) =>
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

				when (16#60#) =>
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

				when (16#61#) =>
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

				when (16#62#) =>
					-- Data Packet Config Register : Data Packet CCD V-Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_v_start(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_v_start(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD V-End
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_v_end(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_v_end(15 downto 8);
					end if;

				when (16#63#) =>
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

				when (16#64#) =>
					-- Data Packet Config Register : Data Packet FEE Mode
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(4 downto 0) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_fee_mode;
					end if;
					-- Data Packet Config Register : Data Packet CCD Number
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(9 downto 8) <= spacewire_write_registers_i.data_packet_config_reg.data_pkt_ccd_number;
					end if;

				when (16#65#) =>
					-- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.data_packet_errors_reg.data_pkt_invalid_ccd_mode;
					end if;

				when (16#66#) =>
					-- Data Packet Header Register : Data Packet Header Length
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_length(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_length(15 downto 8);
					end if;
					-- Data Packet Header Register : Data Packet Header Type
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_type(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_type(15 downto 8);
					end if;

				when (16#67#) =>
					-- Data Packet Header Register : Data Packet Header Frame Counter
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_frame_counter(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_frame_counter(15 downto 8);
					end if;
					-- Data Packet Header Register : Data Packet Header Sequence Counter
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_sequence_counter(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_read_registers_i.data_packet_header_reg.data_pkt_header_sequence_counter(15 downto 8);
					end if;

				when (16#68#) =>
					-- Data Packet Pixel Delay Register : Data Packet Start Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_start_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_start_delay(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_start_delay(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_start_delay(31 downto 24);
					end if;

				when (16#69#) =>
					-- Data Packet Pixel Delay Register : Data Packet Skip Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_skip_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_skip_delay(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_skip_delay(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_skip_delay(31 downto 24);
					end if;

				when (16#6A#) =>
					-- Data Packet Pixel Delay Register : Data Packet Line Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_line_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_line_delay(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_line_delay(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_line_delay(31 downto 24);
					end if;

				when (16#6B#) =>
					-- Data Packet Pixel Delay Register : Data Packet ADC Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_adc_delay(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_adc_delay(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_adc_delay(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.data_packet_pixel_delay_reg.data_pkt_adc_delay(31 downto 24);
					end if;

				when (16#6C#) =>
					-- Error Injection Control Register : Error Injection Tx Disabled Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.error_injection_control_reg.errinj_tx_disabled;
					end if;

				when (16#6D#) =>
					-- Error Injection Control Register : Error Injection Missing Packets Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.error_injection_control_reg.errinj_missing_pkts;
					end if;

				when (16#6E#) =>
					-- Error Injection Control Register : Error Injection Missing Data Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.error_injection_control_reg.errinj_missing_data;
					end if;

				when (16#6F#) =>
					-- Error Injection Control Register : Error Injection Frame Number of Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(1 downto 0) <= spacewire_write_registers_i.error_injection_control_reg.errinj_frame_num;
					end if;
					-- Error Injection Control Register : Error Injection Sequence Counter of Error
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.error_injection_control_reg.errinj_sequence_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.error_injection_control_reg.errinj_sequence_cnt(15 downto 8);
					end if;

				when (16#70#) =>
					-- Error Injection Control Register : Error Injection Data Counter of Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.error_injection_control_reg.errinj_data_cnt(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.error_injection_control_reg.errinj_data_cnt(15 downto 8);
					end if;
					-- Error Injection Control Register : Error Injection Number of Error Repeats
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.error_injection_control_reg.errinj_n_repeat(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.error_injection_control_reg.errinj_n_repeat(15 downto 8);
					end if;

				when (16#71#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 15
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_15(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_15(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_15(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_15(31 downto 24);
					end if;

				when (16#72#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 14
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_14(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_14(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_14(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_14(31 downto 24);
					end if;

				when (16#73#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 13
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_13(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_13(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_13(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_13(31 downto 24);
					end if;

				when (16#74#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 12
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_12(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_12(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_12(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_12(31 downto 24);
					end if;

				when (16#75#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 11
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_11(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_11(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_11(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_11(31 downto 24);
					end if;

				when (16#76#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 10
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_10(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_10(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_10(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_10(31 downto 24);
					end if;

				when (16#77#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 9
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_9(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_9(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_9(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_9(31 downto 24);
					end if;

				when (16#78#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 8
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_8(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_8(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_8(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_8(31 downto 24);
					end if;

				when (16#79#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 7
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_7(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_7(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_7(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_7(31 downto 24);
					end if;

				when (16#7A#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 6
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_6(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_6(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_6(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_6(31 downto 24);
					end if;

				when (16#7B#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 5
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_5(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_5(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_5(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_5(31 downto 24);
					end if;

				when (16#7C#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 4
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_4(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_4(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_4(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_4(31 downto 24);
					end if;

				when (16#7D#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 3
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_3(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_3(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_3(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_3(31 downto 24);
					end if;

				when (16#7E#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 2
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_2(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_2(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_2(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_2(31 downto 24);
					end if;

				when (16#7F#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 1
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_1(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_1(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_1(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_1(31 downto 24);
					end if;

				when (16#80#) =>
					-- Windowing Parameters Register : Windowing Packet Order List Dword 0
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_0(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(15 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_0(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_0(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_packet_order_list_0(31 downto 24);
					end if;

				when (16#81#) =>
					-- Windowing Parameters Register : Windowing Last E Packet
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_last_e_packet(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(9 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_last_e_packet(9 downto 8);
					end if;

				when (16#82#) =>
					-- Windowing Parameters Register : Windowing Last F Packet
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(7 downto 0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_last_f_packet(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						avalon_mm_spacewire_o.readdata(9 downto 8) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_last_f_packet(9 downto 8);
					end if;

				when (16#83#) =>
					-- Windowing Parameters Register : Windowing X-Coordinate Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_x_coordinate_error;
					end if;

				when (16#84#) =>
					-- Windowing Parameters Register : Windowing Y-Coordinate Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						avalon_mm_spacewire_o.readdata(0) <= spacewire_write_registers_i.windowing_parameters_reg.windowing_y_coordinate_error;
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
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
