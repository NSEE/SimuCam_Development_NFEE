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

			-- FTDI IRQ Control Register : FTDI Global IRQ Enable
			ftdi_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en                  <= '0';
			-- FTDI Rx IRQ Control Register : Rx Buffer 0 Readable IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en             <= '0';
			-- FTDI Rx IRQ Control Register : Rx Buffer 1 Readable IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en             <= '0';
			-- FTDI Rx IRQ Control Register : Rx Last Buffer Readable IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en          <= '0';
			-- FTDI Rx IRQ Control Register : Rx Last Buffer Empty IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_empty_irq_en           <= '0';
			-- FTDI Rx IRQ Control Register : Rx Communication Error IRQ Enable
			ftdi_config_wr_regs_o.rx_irq_control_reg.rx_comm_err_irq_en                    <= '0';
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
			-- FTDI Module Control Register : Stop Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                <= '0';
			-- FTDI Module Control Register : Start Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                 <= '0';
			-- FTDI Module Control Register : Clear Module Memories
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                <= '0';
			-- FTDI Module Control Register : Enable Module USB Loopback
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_loopback_en          <= '0';
			-- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout                <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number                 <= std_logic_vector(to_unsigned(0, 3));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number                 <= std_logic_vector(to_unsigned(0, 2));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side                   <= '0';
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height                 <= std_logic_vector(to_unsigned(0, 13));
			-- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width                  <= std_logic_vector(to_unsigned(0, 12));
			-- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number            <= std_logic_vector(to_unsigned(0, 16));
			-- FTDI Half-CCD Request Control Register : Request Half-CCD
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                    <= '0';
			-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                  <= '0';
			-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller           <= '0';

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

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
			-- FTDI Module Control Register : Stop Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                <= '0';
			-- FTDI Module Control Register : Start Module Operation
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                 <= '0';
			-- FTDI Module Control Register : Clear Module Memories
			ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                <= '0';
			-- FTDI Half-CCD Request Control Register : Request Half-CCD
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                    <= '0';
			-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                  <= '0';
			-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
			ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller           <= '0';

		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_ftdi_config_avalon_mm_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- FTDI IRQ Control Register : FTDI Global IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#01#) =>
					-- FTDI Rx IRQ Control Register : Rx Buffer 0 Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#02#) =>
					-- FTDI Rx IRQ Control Register : Rx Buffer 1 Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#03#) =>
					-- FTDI Rx IRQ Control Register : Rx Last Buffer Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#04#) =>
					-- FTDI Rx IRQ Control Register : Rx Last Buffer Empty IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_empty_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#05#) =>
					-- FTDI Rx IRQ Control Register : Rx Communication Error IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_control_reg.rx_comm_err_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#0B#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#0C#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#0D#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#0E#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#0F#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#10#) =>
					-- FTDI Module Control Register : Stop Module Operation
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#11#) =>
					-- FTDI Module Control Register : Start Module Operation
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#12#) =>
					-- FTDI Module Control Register : Clear Module Memories
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#13#) =>
					-- FTDI Module Control Register : Enable Module USB Loopback
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_loopback_en <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#14#) =>
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

				when (16#15#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side <= ftdi_config_avalon_mm_i.writedata(0);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height(12 downto 8) <= ftdi_config_avalon_mm_i.writedata(20 downto 16);
					end if;

				when (16#16#) =>
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

				when (16#17#) =>
					-- FTDI Half-CCD Request Control Register : Request Half-CCD
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#18#) =>
					-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#19#) =>
					-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller <= ftdi_config_avalon_mm_i.writedata(0);
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
