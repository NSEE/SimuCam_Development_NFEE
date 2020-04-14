library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_write_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		ftdi_config_avalon_mm_i : in  t_ftdi_config_avalon_mm_write_in;
		ftdi_config_avalon_mm_o : out t_ftdi_config_avalon_mm_write_out;
		ftdi_config_wr_regs_o   : out t_ftdi_config_wr_registers
	);
end entity ftdi_config_avalon_mm_write_ent;

architecture rtl of ftdi_config_avalon_mm_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_ftdi_config_avalon_mm_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- FTDI Module Control Register : Stop Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                 <= '0';
			-- FTDI Module Control Register : Start Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                  <= '0';
			-- FTDI Module Control Register : Clear Module Memories
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                 <= '0';
			-- FTDI Module Control Register : Enable Module USB Loopback
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_loopback_en           <= '0';
			-- FTDI IRQ Control Register : FTDI Global IRQ Enable
			ftdi_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en                   <= '0';
			-- FTDI Rx IRQ Control Register : Rx Buffer 0 Readable IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en              <= '0';
			-- FTDI Rx IRQ Control Register : Rx Buffer 1 Readable IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en              <= '0';
			-- FTDI Rx IRQ Control Register : Rx Last Buffer Readable IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en           <= '0';
			-- FTDI Rx IRQ Control Register : Rx Last Buffer Empty IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_empty_irq_en            <= '0';
			-- FTDI Rx IRQ Control Register : Rx Communication Error IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_comm_err_irq_en                     <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr     <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr     <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr  <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr   <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr            <= '0';
			-- FTDI Tx IRQ Control Register : Tx LUT Finished Transmission IRQ Enable
			ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_finished_irq_en                 <= '0';
			-- FTDI Tx IRQ Control Register : Tx LUT Communication Error IRQ Enable
			ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_comm_err_irq_en                 <= '0';
			-- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
			ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear      <= '0';
			-- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
			ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear      <= '0';
			-- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout                 <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number                  <= std_logic_vector(to_unsigned(0, 3));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number                  <= std_logic_vector(to_unsigned(0, 2));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side                    <= '0';
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height                  <= std_logic_vector(to_unsigned(0, 13));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width                   <= std_logic_vector(to_unsigned(0, 12));
			-- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number             <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI Half-CCD Request Control Register : Request Half-CCD
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                     <= '0';
			-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                   <= '0';
			-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller            <= '0';
			-- FTDI LUT Transmission Control Register : LUT FEE Number
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_fee_number                      <= std_logic_vector(to_unsigned(0, 3));
			-- FTDI LUT Transmission Control Register : LUT CCD Number
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_number                      <= std_logic_vector(to_unsigned(0, 2));
			-- FTDI LUT Transmission Control Register : LUT CCD Side
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_side                        <= '0';
			-- FTDI LUT Transmission Control Register : LUT CCD Height
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height                      <= std_logic_vector(to_unsigned(0, 13));
			-- FTDI LUT Transmission Control Register : LUT CCD Width
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width                       <= std_logic_vector(to_unsigned(0, 12));
			-- FTDI LUT Transmission Control Register : LUT Exposure Number
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number                 <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI LUT Transmission Control Register : LUT Length [Bytes]
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes                    <= std_logic_vector(to_unsigned(0, 32));
			-- FTDI LUT Transmission Control Register : LUT Request Timeout
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout                   <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI LUT Transmission Control Register : Transmit LUT
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_transmit                        <= '0';
			-- FTDI LUT Transmission Control Register : Abort LUT Transmission
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission              <= '0';
			-- FTDI LUT Transmission Control Register : Reset LUT Controller
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller                <= '0';
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Pointer
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer       <= (others => '0');
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Packet Order List Pointer
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer <= (others => '0');
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Length
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length        <= (others => '0');
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size X
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x            <= (others => '0');
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size Y
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y            <= (others => '0');
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Last E Packet
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet             <= (others => '0');
			-- FTDI LUT CCD1 Windowing Configuration : CCD1 Last F Packet
			ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet             <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Pointer
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer       <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Packet Order List Pointer
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Length
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length        <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size X
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x            <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size Y
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y            <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Last E Packet
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet             <= (others => '0');
			-- FTDI LUT CCD2 Windowing Configuration : CCD2 Last F Packet
			ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet             <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Pointer
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer       <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Packet Order List Pointer
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Length
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length        <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size X
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x            <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size Y
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y            <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Last E Packet
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet             <= (others => '0');
			-- FTDI LUT CCD3 Windowing Configuration : CCD3 Last F Packet
			ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet             <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Pointer
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer       <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Packet Order List Pointer
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Length
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length        <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size X
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x            <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size Y
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y            <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Last E Packet
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet             <= (others => '0');
			-- FTDI LUT CCD4 Windowing Configuration : CCD4 Last F Packet
			ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet             <= (others => '0');

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- FTDI Module Control Register : Stop Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                <= '0';
			-- FTDI Module Control Register : Start Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                 <= '0';
			-- FTDI Module Control Register : Clear Module Memories
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
			ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '0';
			-- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
			ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear     <= '0';
			-- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
			ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear     <= '0';
			-- FTDI Half-CCD Request Control Register : Request Half-CCD
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                    <= '0';
			-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                  <= '0';
			-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller           <= '0';
			-- FTDI LUT Transmission Control Register : Transmit LUT
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_transmit                       <= '0';
			-- FTDI LUT Transmission Control Register : Abort LUT Transmission
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission             <= '0';
			-- FTDI LUT Transmission Control Register : Reset LUT Controller
			ftdi_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller               <= '0';

		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_ftdi_config_avalon_mm_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- FTDI Module Control Register : Stop Module Operation
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#01#) =>
					-- FTDI Module Control Register : Start Module Operation
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#02#) =>
					-- FTDI Module Control Register : Clear Module Memories
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#03#) =>
					-- FTDI Module Control Register : Enable Module USB Loopback
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_loopback_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#04#) =>
					-- FTDI IRQ Control Register : FTDI Global IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#05#) =>
					-- FTDI Rx IRQ Control Register : Rx Buffer 0 Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#06#) =>
					-- FTDI Rx IRQ Control Register : Rx Buffer 1 Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#07#) =>
					-- FTDI Rx IRQ Control Register : Rx Last Buffer Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#08#) =>
					-- FTDI Rx IRQ Control Register : Rx Last Buffer Empty IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_empty_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#09#) =>
					-- FTDI Rx IRQ Control Register : Rx Communication Error IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_comm_err_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#0F#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#10#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#11#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#12#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#13#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#14#) =>
					-- FTDI Tx IRQ Control Register : Tx LUT Finished Transmission IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_finished_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#15#) =>
					-- FTDI Tx IRQ Control Register : Tx LUT Communication Error IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_comm_err_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#18#) =>
					-- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#19#) =>
					-- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#1A#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number <= ftdi_config_avalon_mm_i.writedata(18 downto 16);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number <= ftdi_config_avalon_mm_i.writedata(25 downto 24);
					end if;

				when (16#1B#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side <= ftdi_config_avalon_mm_i.writedata(0);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height(12 downto 8) <= ftdi_config_avalon_mm_i.writedata(28 downto 24);
					end if;

				when (16#1C#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width(11 downto 8) <= ftdi_config_avalon_mm_i.writedata(11 downto 8);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#1D#) =>
					-- FTDI Half-CCD Request Control Register : Request Half-CCD
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#1E#) =>
					-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#1F#) =>
					-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#27#) =>
					-- FTDI LUT Transmission Control Register : LUT FEE Number
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_fee_number <= ftdi_config_avalon_mm_i.writedata(2 downto 0);
					end if;
					-- FTDI LUT Transmission Control Register : LUT CCD Number
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_number <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;
					-- FTDI LUT Transmission Control Register : LUT CCD Side
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_side <= ftdi_config_avalon_mm_i.writedata(16);
					end if;

				when (16#28#) =>
					-- FTDI LUT Transmission Control Register : LUT CCD Height
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height(12 downto 8) <= ftdi_config_avalon_mm_i.writedata(12 downto 8);
					end if;
					-- FTDI LUT Transmission Control Register : LUT CCD Width
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width(11 downto 8) <= ftdi_config_avalon_mm_i.writedata(27 downto 24);
					end if;

				when (16#29#) =>
					-- FTDI LUT Transmission Control Register : LUT Exposure Number
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;

				when (16#2A#) =>
					-- FTDI LUT Transmission Control Register : LUT Length [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#2B#) =>
					-- FTDI LUT Transmission Control Register : LUT Request Timeout
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;

				when (16#2C#) =>
					-- FTDI LUT Transmission Control Register : Transmit LUT
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_transmit <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#2D#) =>
					-- FTDI LUT Transmission Control Register : Abort LUT Transmission
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#2E#) =>
					-- FTDI LUT Transmission Control Register : Reset LUT Controller
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#31#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#32#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Packet Order List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#33#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Length
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;

				when (16#34#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size X
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#35#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size Y
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#36#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Last E Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#37#) =>
					-- FTDI LUT CCD1 Windowing Configuration : CCD1 Last F Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#38#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#39#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Packet Order List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#3A#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Length
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;

				when (16#3B#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size X
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#3C#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size Y
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#3D#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Last E Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#3E#) =>
					-- FTDI LUT CCD2 Windowing Configuration : CCD2 Last F Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#3F#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#40#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Packet Order List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#41#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Length
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;

				when (16#42#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size X
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#43#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size Y
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#44#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Last E Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#45#) =>
					-- FTDI LUT CCD3 Windowing Configuration : CCD3 Last F Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#46#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#47#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Packet Order List Pointer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#48#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Length
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;

				when (16#49#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size X
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#4A#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size Y
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
					end if;

				when (16#4B#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Last E Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when (16#4C#) =>
					-- FTDI LUT CCD4 Windowing Configuration : CCD4 Last F Packet
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_writedata;

		variable v_write_address : t_ftdi_config_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			s_data_acquired                     <= '0';
			v_write_address                     := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			p_control_triggers;
			s_data_acquired                     <= '0';
			if (ftdi_config_avalon_mm_i.write = '1') then
				v_write_address                     := to_integer(unsigned(ftdi_config_avalon_mm_i.address));
				ftdi_config_avalon_mm_o.waitrequest <= '0';
				s_data_acquired                     <= '1';
				if (s_data_acquired = '0') then
					p_writedata(v_write_address);
				end if;
			end if;
		end if;
	end process p_ftdi_config_avalon_mm_write;

end architecture rtl;
