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
		spacewire_write_registers_o : out t_windowing_write_registers;
		right_buffer_size_o         : out std_logic_vector(3 downto 0);
		left_buffer_size_o          : out std_logic_vector(3 downto 0)
	);
end entity avalon_mm_spacewire_write_ent;

architecture rtl of avalon_mm_spacewire_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_spacewire_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			-- comm registers
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_disconnect              <= '0';
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_linkstart               <= '0';
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_autostart               <= '0';
			spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_txdivcnt                <= x"01";
			spacewire_write_registers_o.spw_timecode_reg.timecode_clear                               <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_clear            <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_stop             <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_start            <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_masking_en               <= '1';
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr                <= x"51";
			spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key                         <= x"D1";
			spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_x_size                  <= std_logic_vector(to_unsigned(2295, 16));
			spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_y_size                  <= std_logic_vector(to_unsigned(4540, 16));
			spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_data_y_size                 <= std_logic_vector(to_unsigned(4510, 16));
			spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_overscan_y_size             <= std_logic_vector(to_unsigned(30, 16));
			spacewire_write_registers_o.data_packet_config_3_reg.data_pkt_packet_length               <= std_logic_vector(to_unsigned(32768, 16));
			spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_fee_mode                    <= std_logic_vector(to_unsigned(1, 4));
			spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_ccd_number                  <= std_logic_vector(to_unsigned(0, 2));
			spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_protocol_id                 <= x"F0";
			spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_logical_addr                <= x"50";
			spacewire_write_registers_o.data_packet_pixel_delay_1_reg.data_pkt_line_delay             <= std_logic_vector(to_unsigned(900, 16));
			spacewire_write_registers_o.data_packet_pixel_delay_2_reg.data_pkt_column_delay           <= x"0000";
			-- PLATO-MSSL-PL-ICD-0002, Issue 3.0, page 16, Figure 3-3 : Video interface ADC operate at @ 2.941 Msps 
			-- PTO-CCD-E2V-ICD-0019, Issue 3, page 27, Table 10:
			--   Line transfer time = [82..90] us ==> @10Mhz --> 100 ns -->  delay = 900
			--   Register clock period = 333 ns ==> @100MHz --> 10 ns --> delay = 33
			spacewire_write_registers_o.data_packet_pixel_delay_3_reg.data_pkt_adc_delay              <= std_logic_vector(to_unsigned(33, 16));
			spacewire_write_registers_o.comm_irq_control_reg.comm_rmap_write_command_en               <= '0';
			spacewire_write_registers_o.comm_irq_control_reg.comm_right_buffer_empty_en               <= '0';
			spacewire_write_registers_o.comm_irq_control_reg.comm_left_buffer_empty_en                <= '0';
			spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en                       <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear   <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_right_buffer_0_empty_flag_clear <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_right_buffer_1_empty_flag_clear <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_left_buffer_0_empty_flag_clear  <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_left_buffer_1_empty_flag_clear  <= '0';
			right_buffer_size_o                                                                       <= (others => '1');
			left_buffer_size_o                                                                        <= (others => '1');
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			spacewire_write_registers_o.spw_timecode_reg.timecode_clear                               <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_clear            <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_stop             <= '0';
			spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_start            <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear   <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_right_buffer_0_empty_flag_clear <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_right_buffer_1_empty_flag_clear <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_left_buffer_0_empty_flag_clear  <= '0';
			spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_left_buffer_1_empty_flag_clear  <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				-- comm registers
				when (16#00#) =>
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_disconnect <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_linkstart  <= avalon_mm_spacewire_i.writedata(1);
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_autostart  <= avalon_mm_spacewire_i.writedata(2);
					spacewire_write_registers_o.spw_link_config_status_reg.spw_lnkcfg_txdivcnt   <= avalon_mm_spacewire_i.writedata(31 downto 24);
				when (16#01#) =>
					spacewire_write_registers_o.spw_timecode_reg.timecode_clear <= avalon_mm_spacewire_i.writedata(8);
				when (16#02#) =>
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_clear <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_stop  <= avalon_mm_spacewire_i.writedata(1);
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_machine_start <= avalon_mm_spacewire_i.writedata(2);
					spacewire_write_registers_o.fee_windowing_buffers_config_reg.fee_masking_en    <= avalon_mm_spacewire_i.writedata(3);
				when (16#03#) =>
					null;
				when (16#04#) =>
					spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr <= avalon_mm_spacewire_i.writedata(7 downto 0);
					spacewire_write_registers_o.rmap_codec_config_reg.rmap_target_key          <= avalon_mm_spacewire_i.writedata(15 downto 8);
				when (16#05#) =>
					null;
				when (16#06#) =>
					null;
				when (16#07#) =>
					null;
				when (16#08#) =>
					spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_x_size <= avalon_mm_spacewire_i.writedata(15 downto 0);
					spacewire_write_registers_o.data_packet_config_1_reg.data_pkt_ccd_y_size <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (16#09#) =>
					spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_data_y_size     <= avalon_mm_spacewire_i.writedata(15 downto 0);
					spacewire_write_registers_o.data_packet_config_2_reg.data_pkt_overscan_y_size <= avalon_mm_spacewire_i.writedata(31 downto 16);
				when (16#0A#) =>
					spacewire_write_registers_o.data_packet_config_3_reg.data_pkt_packet_length <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (16#0B#) =>
					spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_fee_mode     <= avalon_mm_spacewire_i.writedata(3 downto 0);
					spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_ccd_number   <= avalon_mm_spacewire_i.writedata(9 downto 8);
					spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_protocol_id  <= avalon_mm_spacewire_i.writedata(23 downto 16);
					spacewire_write_registers_o.data_packet_config_4_reg.data_pkt_logical_addr <= avalon_mm_spacewire_i.writedata(31 downto 24);
				when (16#0C#) =>
					null;
				when (16#0D#) =>
					null;
				when (16#0E#) =>
					spacewire_write_registers_o.data_packet_pixel_delay_1_reg.data_pkt_line_delay <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (16#0F#) =>
					spacewire_write_registers_o.data_packet_pixel_delay_2_reg.data_pkt_column_delay <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (16#10#) =>
					spacewire_write_registers_o.data_packet_pixel_delay_3_reg.data_pkt_adc_delay <= avalon_mm_spacewire_i.writedata(15 downto 0);
				when (16#11#) =>
					spacewire_write_registers_o.comm_irq_control_reg.comm_rmap_write_command_en <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.comm_irq_control_reg.comm_right_buffer_empty_en <= avalon_mm_spacewire_i.writedata(8);
					spacewire_write_registers_o.comm_irq_control_reg.comm_left_buffer_empty_en  <= avalon_mm_spacewire_i.writedata(9);
					spacewire_write_registers_o.comm_irq_control_reg.comm_global_irq_en         <= avalon_mm_spacewire_i.writedata(16);
				when (16#12#) =>
					null;
				when (16#13#) =>
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear   <= avalon_mm_spacewire_i.writedata(0);
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_right_buffer_0_empty_flag_clear <= avalon_mm_spacewire_i.writedata(8);
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_right_buffer_1_empty_flag_clear <= avalon_mm_spacewire_i.writedata(9);
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_left_buffer_0_empty_flag_clear  <= avalon_mm_spacewire_i.writedata(10);
					spacewire_write_registers_o.comm_irq_flags_clear_reg.comm_left_buffer_1_empty_flag_clear  <= avalon_mm_spacewire_i.writedata(11);
				when (16#14#) =>
					right_buffer_size_o <= avalon_mm_spacewire_i.writedata(3 downto 0);
				when (16#15#) =>
					left_buffer_size_o <= avalon_mm_spacewire_i.writedata(3 downto 0);
				when others =>
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
			if (avalon_mm_spacewire_i.write = '1') then
				v_write_address := to_integer(unsigned(avalon_mm_spacewire_i.address));
				-- check if the address is allowed
				if not (((v_write_address >= 16#A0#) and (v_write_address <= 16#BF#)) or ((v_write_address >= 16#40#) and (v_write_address <= 16#51#))) then
					-- check if address is allowed
					avalon_mm_spacewire_o.waitrequest <= '0';
					s_data_acquired                   <= '1';
					if (s_data_acquired = '1') then
						p_writedata(v_write_address);
						s_data_acquired <= '0';
					end if;
				end if;
			end if;
		end if;
	end process p_avalon_mm_spacewire_write;

end architecture rtl;
