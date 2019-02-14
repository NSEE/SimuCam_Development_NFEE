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
		spacewire_read_registers_i  : in  t_windowing_read_registers;
		right_buffer_size_i         : in  std_logic_vector(7 downto 0);
		left_buffer_size_i          : in  std_logic_vector(7 downto 0)
	);
end entity avalon_mm_spacewire_read_ent;

architecture rtl of avalon_mm_spacewire_read_ent is

begin

	p_avalon_mm_spacewire_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			null;
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				-- comm registers
				when (16#00#) =>
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_disconnect;
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_linkstart;
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_autostart;
					avalon_mm_spacewire_o.readdata(7 downto 3)   <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)            <= spacewire_read_registers_i.spw_link_config_status_reg.spw_link_running;
					avalon_mm_spacewire_o.readdata(9)            <= spacewire_read_registers_i.spw_link_config_status_reg.spw_link_connecting;
					avalon_mm_spacewire_o.readdata(10)           <= spacewire_read_registers_i.spw_link_config_status_reg.spw_link_started;
					avalon_mm_spacewire_o.readdata(15 downto 11) <= (others => '0');
					avalon_mm_spacewire_o.readdata(16)           <= spacewire_read_registers_i.spw_link_config_status_reg.spw_err_disconnect;
					avalon_mm_spacewire_o.readdata(17)           <= spacewire_read_registers_i.spw_link_config_status_reg.spw_err_parity;
					avalon_mm_spacewire_o.readdata(18)           <= spacewire_read_registers_i.spw_link_config_status_reg.spw_err_escape;
					avalon_mm_spacewire_o.readdata(19)           <= spacewire_read_registers_i.spw_link_config_status_reg.spw_err_credit;
					avalon_mm_spacewire_o.readdata(23 downto 20) <= (others => '0');
					avalon_mm_spacewire_o.readdata(31 downto 24) <= spacewire_write_registers_i.spw_link_config_status_reg.spw_lnkcfg_txdivcnt;
				when (16#01#) =>
					avalon_mm_spacewire_o.readdata(5 downto 0)  <= spacewire_read_registers_i.spw_timecode_reg.timecode_time;
					avalon_mm_spacewire_o.readdata(7 downto 6)  <= spacewire_read_registers_i.spw_timecode_reg.timecode_control;
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_write_registers_i.spw_timecode_reg.timecode_clear;
					avalon_mm_spacewire_o.readdata(31 downto 9) <= (others => '0');
				when (16#02#) =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_machine_clear;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_machine_stop;
					avalon_mm_spacewire_o.readdata(2)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_machine_start;
					avalon_mm_spacewire_o.readdata(3)           <= spacewire_write_registers_i.fee_windowing_buffers_config_reg.fee_masking_en;
					avalon_mm_spacewire_o.readdata(31 downto 4) <= (others => '0');
				when (16#03#) =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.fee_windowing_buffers_status_reg.windowing_right_buffer_empty;
					avalon_mm_spacewire_o.readdata(1)           <= spacewire_read_registers_i.fee_windowing_buffers_status_reg.windowing_left_buffer_empty;
					avalon_mm_spacewire_o.readdata(31 downto 3) <= (others => '0');
				when (16#04#) =>
					avalon_mm_spacewire_o.readdata(7 downto 0)   <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_logical_addr;
					avalon_mm_spacewire_o.readdata(15 downto 8)  <= spacewire_write_registers_i.rmap_codec_config_reg.rmap_target_key;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= (others => '0');
				when (16#05#) =>
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_command_received;
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_requested;
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_write_authorized;
					avalon_mm_spacewire_o.readdata(3)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_requested;
					avalon_mm_spacewire_o.readdata(4)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_read_authorized;
					avalon_mm_spacewire_o.readdata(5)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_reply_sended;
					avalon_mm_spacewire_o.readdata(6)            <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_stat_discarded_package;
					avalon_mm_spacewire_o.readdata(15 downto 7)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(16)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_early_eop;
					avalon_mm_spacewire_o.readdata(17)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_eep;
					avalon_mm_spacewire_o.readdata(18)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_header_crc;
					avalon_mm_spacewire_o.readdata(19)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_unused_packet_type;
					avalon_mm_spacewire_o.readdata(20)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_command_code;
					avalon_mm_spacewire_o.readdata(21)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_too_much_data;
					avalon_mm_spacewire_o.readdata(22)           <= spacewire_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_data_crc;
					avalon_mm_spacewire_o.readdata(31 downto 23) <= (others => '0');
				when (16#06#) =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= spacewire_read_registers_i.rmap_last_write_addr_reg.rmap_last_write_addr;
				when (16#07#) =>
					avalon_mm_spacewire_o.readdata(31 downto 0) <= spacewire_read_registers_i.rmap_last_read_addr_reg.rmap_last_read_addr;
				when (16#08#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_write_registers_i.data_packet_config_1_reg.data_pkt_ccd_x_size;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= spacewire_write_registers_i.data_packet_config_1_reg.data_pkt_ccd_y_size;
				when (16#09#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_write_registers_i.data_packet_config_2_reg.data_pkt_data_y_size;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= spacewire_write_registers_i.data_packet_config_2_reg.data_pkt_overscan_y_size;
				when (16#0A#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_write_registers_i.data_packet_config_3_reg.data_pkt_packet_length;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= (others => '0');
				when (16#0B#) =>
					avalon_mm_spacewire_o.readdata(2 downto 0)   <= spacewire_write_registers_i.data_packet_config_4_reg.data_pkt_fee_mode;
					avalon_mm_spacewire_o.readdata(7 downto 3)   <= (others => '0');
					avalon_mm_spacewire_o.readdata(9 downto 8)   <= spacewire_write_registers_i.data_packet_config_4_reg.data_pkt_ccd_number;
					avalon_mm_spacewire_o.readdata(15 downto 10) <= (others => '0');
					avalon_mm_spacewire_o.readdata(31 downto 16) <= (others => '0');
				when (16#0C#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_read_registers_i.data_packet_header_1_reg.data_pkt_header_length;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= spacewire_read_registers_i.data_packet_header_1_reg.data_pkt_header_type;
				when (16#0D#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_read_registers_i.data_packet_header_2_reg.data_pkt_header_frame_counter;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= spacewire_read_registers_i.data_packet_header_2_reg.data_pkt_header_sequence_counter;
				when (16#0E#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_write_registers_i.data_packet_pixel_delay_1_reg.data_pkt_line_delay;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= (others => '0');
				when (16#0F#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_write_registers_i.data_packet_pixel_delay_2_reg.data_pkt_column_delay;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= (others => '0');
				when (16#10#) =>
					avalon_mm_spacewire_o.readdata(15 downto 0)  <= spacewire_write_registers_i.data_packet_pixel_delay_3_reg.data_pkt_adc_delay;
					avalon_mm_spacewire_o.readdata(31 downto 16) <= (others => '0');
				when (16#11#) =>
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_write_registers_i.comm_irq_control_reg.comm_rmap_write_command_en;
					avalon_mm_spacewire_o.readdata(7 downto 1)   <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)            <= spacewire_write_registers_i.comm_irq_control_reg.comm_right_buffer_empty_en;
					avalon_mm_spacewire_o.readdata(9)            <= spacewire_write_registers_i.comm_irq_control_reg.comm_left_buffer_empty_en;
					avalon_mm_spacewire_o.readdata(15 downto 10) <= (others => '0');
					avalon_mm_spacewire_o.readdata(16)           <= spacewire_write_registers_i.comm_irq_control_reg.comm_global_irq_en;
					avalon_mm_spacewire_o.readdata(31 downto 17) <= (others => '0');
				when (16#12#) =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_read_registers_i.comm_irq_flags_reg.comm_rmap_write_command_flag;
					avalon_mm_spacewire_o.readdata(7 downto 1)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_read_registers_i.comm_irq_flags_reg.comm_buffer_empty_flag;
					avalon_mm_spacewire_o.readdata(31 downto 9) <= (others => '0');
				when (16#13#) =>
					avalon_mm_spacewire_o.readdata(0)           <= spacewire_write_registers_i.comm_irq_flags_clear_reg.comm_rmap_write_command_flag_clear;
					avalon_mm_spacewire_o.readdata(7 downto 1)  <= (others => '0');
					avalon_mm_spacewire_o.readdata(8)           <= spacewire_write_registers_i.comm_irq_flags_clear_reg.comm_buffer_empty_flag_clear;
					avalon_mm_spacewire_o.readdata(31 downto 9) <= (others => '0');
				when (16#14#) =>
					avalon_mm_spacewire_o.readdata(7 downto 0)  <= right_buffer_size_i;
					avalon_mm_spacewire_o.readdata(31 downto 8) <= (others => '0');
				when (16#15#) =>
					avalon_mm_spacewire_o.readdata(7 downto 0)  <= left_buffer_size_i;
					avalon_mm_spacewire_o.readdata(31 downto 8) <= (others => '0');
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
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_spacewire_i.read = '1') then
				v_read_address := to_integer(unsigned(avalon_mm_spacewire_i.address));
				-- check if the address is allowed
				if not (((v_read_address >= 16#A0#) and (v_read_address <= 16#BF#)) or ((v_read_address >= 16#40#) and (v_read_address <= 16#51#))) then
					-- check if address is allowed
					avalon_mm_spacewire_o.waitrequest <= '0';
					p_readdata(v_read_address);
				end if;
			end if;
		end if;
	end process p_avalon_mm_spacewire_read;

end architecture rtl;
