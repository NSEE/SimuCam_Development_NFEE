library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_avs_config_stimulli is
	port(
		clk_i                : in  std_logic;
		rst_i                : in  std_logic;
		avs_config_rd_regs_i : in  t_ftdi_config_rd_registers;
		avs_config_wr_regs_o : out t_ftdi_config_wr_registers
	);
end entity ftdi_avs_config_stimulli;

architecture RTL of ftdi_avs_config_stimulli is

	signal s_counter : natural := 0;
	signal s_times   : natural := 0;

begin

	p_ftdi_avs_config_stimulli : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- FTDI IRQ Control Register : FTDI Global IRQ Enable
			avs_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en                  <= '0';
			-- FTDI Rx IRQ Control Register : Rx Buffer 0 Readable IRQ Enable
			avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en             <= '0';
			-- FTDI Rx IRQ Control Register : Rx Buffer 1 Readable IRQ Enable
			avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en             <= '0';
			-- FTDI Rx IRQ Control Register : Rx Last Buffer Readable IRQ Enable
			avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en          <= '0';
			-- FTDI Rx IRQ Control Register : Rx Last Buffer Empty IRQ Enable
			avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_empty_irq_en           <= '0';
			-- FTDI Rx IRQ Control Register : Rx Communication Error IRQ Enable
			avs_config_wr_regs_o.rx_irq_control_reg.rx_comm_err_irq_en                    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '0';
			-- FTDI Module Control Register : Stop Module Operation
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                <= '0';
			-- FTDI Module Control Register : Start Module Operation
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                 <= '0';
			-- FTDI Module Control Register : Clear Module Memories
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                <= '0';
			-- FTDI Module Control Register : Enable Module USB Loopback
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_loopback_en          <= '0';
			-- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout                <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number                 <= std_logic_vector(to_unsigned(0, 3));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number                 <= std_logic_vector(to_unsigned(0, 2));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side                   <= '0';
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height                 <= std_logic_vector(to_unsigned(0, 13));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width                  <= std_logic_vector(to_unsigned(0, 12));
			-- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
			avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number            <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI Half-CCD Request Control Register : Request Half-CCD
			avs_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                    <= '0';
			-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
			avs_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                  <= '0';
			-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
			avs_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller           <= '0';

		end procedure p_reset_registers;
		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '0';
			-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
			avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '0';
			-- FTDI Module Control Register : Stop Module Operation
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                <= '0';
			-- FTDI Module Control Register : Start Module Operation
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                 <= '0';
			-- FTDI Module Control Register : Clear Module Memories
			avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                <= '0';
			-- FTDI Half-CCD Request Control Register : Request Half-CCD
			avs_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                    <= '0';
			-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
			avs_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                  <= '0';
			-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
			avs_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller           <= '0';

		end procedure p_control_triggers;
	begin
		if (rst_i = '1') then

			s_counter <= 0;
			s_times   <= 0;
			p_reset_registers;

		elsif rising_edge(clk_i) then

			s_counter <= s_counter + 1;
			p_control_triggers;

			case s_counter is

				when 5 =>
					-- Stop the ftdi module
					avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop        <= '1';
					-- Disable loopback the ftdi module
					avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_loopback_en <= '0';

				when 10 =>
					-- Clear the ftdi module
					avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear <= '1';

				when 15 =>
					-- Start the ftdi module
					avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start <= '1';

				when 20 =>
					-- Request Half-CCD
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number      <= std_logic_vector(to_unsigned(3, 3));
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number      <= std_logic_vector(to_unsigned(2, 2));
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side        <= '1';
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height      <= std_logic_vector(to_unsigned(16, 13));
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width       <= std_logic_vector(to_unsigned(7, 12));
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number <= std_logic_vector(to_unsigned(875, 16));
					avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout     <= (others => '0');
					avs_config_wr_regs_o.hccd_req_control_reg.req_request_hccd         <= '1';

				when 25 =>
					-- Enables IRQ
					avs_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en         <= '1';
					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en    <= '1';
					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en    <= '1';
					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en <= '1';
					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_empty_irq_en  <= '1';
					avs_config_wr_regs_o.rx_irq_control_reg.rx_comm_err_irq_en           <= '1';

				when 250 =>
					-- Reset Half-CCD
					avs_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller <= '1';

				when 6000 =>
					-- Clear IRQ
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';

				when 16000 =>
					-- Clear IRQ
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';

				when 25000 =>
					-- Clear IRQ
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';

				when 28000 =>
					-- Clear IRQ
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_ftdi_avs_config_stimulli;

end architecture RTL;
