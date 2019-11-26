library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.rmap_mem_area_nfee_pkg.all;

entity avalon_mm_spacewire_write_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_write_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_write_out;
		spacewire_write_registers_o : out t_windowing_write_registers
	);
end entity avalon_mm_spacewire_write_ent;

architecture rtl of avalon_mm_spacewire_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_spacewire_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- Comm Device Address Register : Comm Device Base Address
			spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr                                <= (others => '0');
			-- Comm IRQ Control Register : Comm Global IRQ Enable
			spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en                             <= '0';
			-- SpaceWire Device Address Register : SpaceWire Device Base Address
			spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr                                  <= (others => '0');
			-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect                           <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart                            <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart                            <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
			spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                             <= x"01";
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_clear                              <= '0';
			-- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_en                                 <= '1';
			-- FEE Buffers Device Address Register : FEE Buffers Device Base Address
			spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr                  <= (others => '0');
			-- FEE Machine Config Register : FEE Machine Clear
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_clear                            <= '0';
			-- FEE Machine Config Register : FEE Machine Stop
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_stop                             <= '0';
			-- FEE Machine Config Register : FEE Machine Start
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_start                            <= '0';
			-- FEE Machine Config Register : FEE Data Controller Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_data_controller_en                       <= '1';
			-- FEE Machine Config Register : FEE Digitalise Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_digitalise_en                            <= '1';
			-- FEE Machine Config Register : FEE Windowing Enable
			spacewire_write_registers_o.fee_machine_config_reg.fee_windowing_en                             <= '0';
			-- FEE Buffers Config Register : Windowing Right Buffer Size Config
			spacewire_write_registers_o.fee_buffers_config_reg.fee_right_buffer_size                        <= (others => '1');
			-- FEE Buffers Config Register : Windowing Left Buffer Size Config
			spacewire_write_registers_o.fee_buffers_config_reg.fee_left_buffer_size                         <= (others => '1');
			-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
			spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_right_buffer_empty_en               <= '0';
			-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
			spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_left_buffer_empty_en                <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear  <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear  <= '0';
			-- RMAP Device Address Register : RMAP Device Base Address
			spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr                                <= (others => '0');
			-- RMAP Codec Config Register : RMAP Target Logical Address
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr                      <= x"51";
			-- RMAP Codec Config Register : RMAP Target Key
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key                               <= x"D1";
			-- RMAP Memory Area Address Register : RMAP Config Memory Area Base Address
			spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr               <= (others => '0');
			-- RMAP Memory Area Address Register : RMAP HouseKeeping Memory Area Base Address
			spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr                   <= (others => '0');
			-- RMAP IRQ Control Register : RMAP Write Command IRQ Enable
			spacewire_write_registers_o.rmap_irq_control_reg.rmap_write_command_en                          <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Command IRQ Flag Clear
			spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_command_flag_clear              <= '0';
			-- Data Packet Device Channel Address Register : Data Packet Device Base Address
			spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr                  <= (others => '0');
			-- Data Packet Config Register : Data Packet CCD X Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size                          <= std_logic_vector(to_unsigned(2295, 16));
			-- Data Packet Config Register : Data Packet CCD Y Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size                          <= std_logic_vector(to_unsigned(4540, 16));
			-- Data Packet Config Register : Data Packet Data Y Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_data_y_size                         <= std_logic_vector(to_unsigned(4510, 16));
			-- Data Packet Config Register : Data Packet Overscan Y Size
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size                     <= std_logic_vector(to_unsigned(30, 16));
			-- Data Packet Config Register : Data Packet Packet Length
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_packet_length                       <= std_logic_vector(to_unsigned(32768, 16));
			-- Data Packet Config Register : Data Packet Logical Address
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_logical_addr                        <= x"50";
			-- Data Packet Config Register : Data Packet Protocol ID
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_protocol_id                         <= x"F0";
			-- Data Packet Config Register : Data Packet FEE Mode
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_fee_mode                            <= std_logic_vector(to_unsigned(1, 4));
			-- Data Packet Config Register : Data Packet CCD Number
			spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_number                          <= std_logic_vector(to_unsigned(0, 2));
			-- PLATO-MSSL-PL-ICD-0002, Issue 3.0, page 16, Figure 3-3 : Video interface ADC operate at @ 2.941 Msps 
			-- PTO-CCD-E2V-ICD-0019, Issue 3, page 27, Table 10:
			--   Line transfer time = [82..90] us ==> @10Mhz --> 100 ns -->  delay = 900
			--   Register clock period = 333 ns ==> @100MHz --> 10 ns --> delay = 33
			-- Data Packet Pixel Delay Register : Data Packet Line Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay                     <= std_logic_vector(to_unsigned(900, 16));
			-- Data Packet Pixel Delay Register : Data Packet Column Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_column_delay                   <= std_logic_vector(to_unsigned(0, 16));
			-- Data Packet Pixel Delay Register : Data Packet ADC Delay
			spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay                      <= std_logic_vector(to_unsigned(33, 16));
			-- Error Injection Control Register : Error Injection Tx Disabled Enable
			spacewire_write_registers_o.error_injection_control_reg.errinj_tx_disabled                      <= '0';
			-- Error Injection Control Register : Error Injection Missing Packets Enable
			spacewire_write_registers_o.error_injection_control_reg.errinj_missing_pkts                     <= '0';
			-- Error Injection Control Register : Error Injection Missing Data Enable
			spacewire_write_registers_o.error_injection_control_reg.errinj_missing_data                     <= '0';
			-- Error Injection Control Register : Error Injection Frame Number of Error
			spacewire_write_registers_o.error_injection_control_reg.errinj_frame_num                        <= std_logic_vector(to_unsigned(0, 2));
			-- Error Injection Control Register : Error Injection Sequence Counter of Error
			spacewire_write_registers_o.error_injection_control_reg.errinj_sequence_cnt                     <= std_logic_vector(to_unsigned(0, 16));
			-- Error Injection Control Register : Error Injection Data Counter of Error
			spacewire_write_registers_o.error_injection_control_reg.errinj_data_cnt                         <= std_logic_vector(to_unsigned(0, 16));
			-- Error Injection Control Register : Error Injection Number of Error Repeats
			spacewire_write_registers_o.error_injection_control_reg.errinj_n_repeat                         <= std_logic_vector(to_unsigned(0, 16));

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
			spacewire_write_registers_o.spw_timecode_config_reg.timecode_clear                              <= '0';
			-- FEE Machine Config Register : FEE Machine Clear
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_clear                            <= '0';
			-- FEE Machine Config Register : FEE Machine Stop
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_stop                             <= '0';
			-- FEE Machine Config Register : FEE Machine Start
			spacewire_write_registers_o.fee_machine_config_reg.fee_machine_start                            <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear  <= '0';
			-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
			spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear  <= '0';
			-- RMAP IRQ Flags Clear Register : RMAP Write Command IRQ Flag Clear
			spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_command_flag_clear              <= '0';

		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Comm Device Address Register : Comm Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.comm_dev_addr_reg.comm_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#01#) =>
					-- Comm IRQ Control Register : Comm Global IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#02#) =>
					-- SpaceWire Device Address Register : SpaceWire Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#03#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#04#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#05#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#06#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;

				when (16#0E#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#0F#) =>
					-- SpaceWire Timecode Config Register : SpaceWire Timecode Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.spw_timecode_config_reg.timecode_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#11#) =>
					-- FEE Buffers Device Address Register : FEE Buffers Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#12#) =>
					-- FEE Machine Config Register : FEE Machine Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_machine_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#13#) =>
					-- FEE Machine Config Register : FEE Machine Stop
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_machine_stop <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#14#) =>
					-- FEE Machine Config Register : FEE Machine Start
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_machine_start <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#15#) =>
					-- FEE Machine Config Register : FEE Data Controller Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_data_controller_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#16#) =>
					-- FEE Machine Config Register : FEE Digitalise Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_digitalise_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#17#) =>
					-- FEE Machine Config Register : FEE Windowing Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_machine_config_reg.fee_windowing_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#18#) =>
					-- FEE Buffers Config Register : Windowing Right Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_config_reg.fee_right_buffer_size <= avalon_mm_spacewire_i.writedata(3 downto 0);
					end if;
					-- FEE Buffers Config Register : Windowing Left Buffer Size Config
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.fee_buffers_config_reg.fee_left_buffer_size <= avalon_mm_spacewire_i.writedata(11 downto 8);
					end if;

				when (16#1D#) =>
					-- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_right_buffer_empty_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#1E#) =>
					-- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_control_reg.fee_left_buffer_empty_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#23#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#24#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_1_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#25#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#26#) =>
					-- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 1 Empty IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_1_empty_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#28#) =>
					-- RMAP Device Address Register : RMAP Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#29#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;

				when (16#3A#) =>
					-- RMAP Memory Area Address Register : RMAP Config Memory Area Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_config_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#3B#) =>
					-- RMAP Memory Area Address Register : RMAP HouseKeeping Memory Area Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.rmap_mem_area_addr_reg.rmap_mem_area_hk_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#3C#) =>
					-- RMAP IRQ Control Register : RMAP Write Command IRQ Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_irq_control_reg.rmap_write_command_en <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#3E#) =>
					-- RMAP IRQ Flags Clear Register : RMAP Write Command IRQ Flag Clear
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.rmap_irq_flags_clear_reg.rmap_write_command_flag_clear <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#40#) =>
					-- Data Packet Device Channel Address Register : Data Packet Device Base Address
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(23 downto 16) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_dev_addr_reg.data_packet_dev_base_addr(31 downto 24) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#41#) =>
					-- Data Packet Config Register : Data Packet CCD X Size
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_x_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet CCD Y Size
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_y_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#42#) =>
					-- Data Packet Config Register : Data Packet Data Y Size
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_data_y_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_data_y_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet Overscan Y Size
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_overscan_y_size(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#43#) =>
					-- Data Packet Config Register : Data Packet Packet Length
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_packet_length(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_packet_length(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Config Register : Data Packet Logical Address
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_logical_addr <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					-- Data Packet Config Register : Data Packet Protocol ID
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_protocol_id <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#44#) =>
					-- Data Packet Config Register : Data Packet FEE Mode
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_fee_mode <= avalon_mm_spacewire_i.writedata(3 downto 0);
					end if;
					-- Data Packet Config Register : Data Packet CCD Number
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_config_reg.data_pkt_ccd_number <= avalon_mm_spacewire_i.writedata(9 downto 8);
					end if;
					-- Data Packet Pixel Delay Register : Data Packet Line Delay
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_line_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#47#) =>
					-- Data Packet Pixel Delay Register : Data Packet Column Delay
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_column_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_column_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Data Packet Pixel Delay Register : Data Packet ADC Delay
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.data_packet_pixel_delay_reg.data_pkt_adc_delay(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#48#) =>
					-- Error Injection Control Register : Error Injection Tx Disabled Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_tx_disabled <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#49#) =>
					-- Error Injection Control Register : Error Injection Missing Packets Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_missing_pkts <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#4A#) =>
					-- Error Injection Control Register : Error Injection Missing Data Enable
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_missing_data <= avalon_mm_spacewire_i.writedata(0);
					end if;

				when (16#4B#) =>
					-- Error Injection Control Register : Error Injection Frame Number of Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_frame_num <= avalon_mm_spacewire_i.writedata(1 downto 0);
					end if;
					-- Error Injection Control Register : Error Injection Sequence Counter of Error
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_sequence_cnt(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_sequence_cnt(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when (16#4C#) =>
					-- Error Injection Control Register : Error Injection Data Counter of Error
					if (avalon_mm_spacewire_i.byteenable(0) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_data_cnt(7 downto 0) <= avalon_mm_spacewire_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_spacewire_i.byteenable(1) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_data_cnt(15 downto 8) <= avalon_mm_spacewire_i.writedata(15 downto 8);
					end if;
					-- Error Injection Control Register : Error Injection Number of Error Repeats
					if (avalon_mm_spacewire_i.byteenable(2) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_n_repeat(7 downto 0) <= avalon_mm_spacewire_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_spacewire_i.byteenable(3) = '1') then
						spacewire_write_registers_o.error_injection_control_reg.errinj_n_repeat(15 downto 8) <= avalon_mm_spacewire_i.writedata(31 downto 24);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.waitrequest <= '1';
			s_data_acquired                   <= '0';
			v_write_address                   := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_control_triggers;
			s_data_acquired                   <= '0';
			if (avalon_mm_spacewire_i.write = '1') then
				v_write_address := to_integer(unsigned(avalon_mm_spacewire_i.address));
				-- check if the address is allowed
				if ((v_write_address >= c_AVALON_MM_SPACEWIRE_MIN_ADDR) and (v_write_address <= c_AVALON_MM_SPACEWIRE_MAX_ADDR)) then
					avalon_mm_spacewire_o.waitrequest <= '0';
					s_data_acquired                   <= '1';
					if (s_data_acquired = '0') then
						p_writedata(v_write_address);
					end if;
				end if;
			end if;
		end if;
	end process p_avalon_mm_spacewire_write;

end architecture rtl;
