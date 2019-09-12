library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_read_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		ftdi_config_avalon_mm_i : in  t_ftdi_config_avalon_mm_read_in;
		ftdi_config_avalon_mm_o : out t_ftdi_config_avalon_mm_read_out;
		ftdi_config_wr_regs_i   : in  t_ftdi_config_wr_registers;
		ftdi_config_rd_regs_i   : in  t_ftdi_config_rd_registers
	);
end entity ftdi_config_avalon_mm_read_ent;

architecture rtl of ftdi_config_avalon_mm_read_ent is

begin

	p_ftdi_config_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_ftdi_config_avalon_mm_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- FTDI IRQ Control Register : FTDI Global IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_irq_control_reg.ftdi_global_irq_en;
					end if;

				when (16#01#) =>
					-- FTDI Rx IRQ Control Register : Rx Buffer 0 Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_buffer_0_rdable_irq_en;
					end if;

				when (16#02#) =>
					-- FTDI Rx IRQ Control Register : Rx Buffer 1 Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_buffer_1_rdable_irq_en;
					end if;

				when (16#03#) =>
					-- FTDI Rx IRQ Control Register : Rx Last Buffer Readable IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_buffer_last_rdable_irq_en;
					end if;

				when (16#04#) =>
					-- FTDI Rx IRQ Control Register : Rx Last Buffer Empty IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_buffer_last_empty_irq_en;
					end if;

				when (16#05#) =>
					-- FTDI Rx IRQ Control Register : Rx Communication Error IRQ Enable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_comm_err_irq_en;
					end if;

				when (16#06#) =>
					-- FTDI Rx IRQ Flag Register : Rx Buffer 0 Readable IRQ Flag
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_buffer_0_rdable_irq_flag;
					end if;

				when (16#07#) =>
					-- FTDI Rx IRQ Flag Register : Rx Buffer 1 Readable IRQ Flag
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_buffer_1_rdable_irq_flag;
					end if;

				when (16#08#) =>
					-- FTDI Rx IRQ Flag Register : Rx Last Buffer Readable IRQ Flag
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_buffer_last_rdable_irq_flag;
					end if;

				when (16#09#) =>
					-- FTDI Rx IRQ Flag Register : Rx Last Buffer Empty IRQ Flag
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag;
					end if;

				when (16#0A#) =>
					-- FTDI Rx IRQ Flag Register : Rx Communication Error IRQ Flag
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_comm_err_irq_flag;
					end if;

				when (16#0B#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 0 Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr;
					end if;

				when (16#0C#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Buffer 1 Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr;
					end if;

				when (16#0D#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Readable IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr;
					end if;

				when (16#0E#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Last Buffer Empty IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr;
					end if;

				when (16#0F#) =>
					-- FTDI Rx IRQ Flag Clear Register : Rx Communication Error IRQ Flag Clear
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr;
					end if;

				when (16#10#) =>
					-- FTDI Module Control Register : Stop Module Operation
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_start;
					end if;

				when (16#11#) =>
					-- FTDI Module Control Register : Start Module Operation
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_stop;
					end if;

				when (16#12#) =>
					-- FTDI Module Control Register : Clear Module Memories
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_clear;
					end if;

				when (16#13#) =>
					-- FTDI Module Control Register : Enable Module USB Loopback
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_loopback_en;
					end if;

				when (16#14#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_req_timeout(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_req_timeout(15 downto 8);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(18 downto 16) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_fee_number;
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_avalon_mm_o.readdata(25 downto 24) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_number;
					end if;

				when (16#15#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_side;
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_height(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_avalon_mm_o.readdata(28 downto 24) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_height(12 downto 8);
					end if;

				when (16#16#) =>
					-- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_width(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(11 downto 8) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_width(11 downto 8);
					end if;
					-- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_exposure_number(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_exposure_number(15 downto 8);
					end if;

				when (16#17#) =>
					-- FTDI Half-CCD Request Control Register : Request Half-CCD
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_request_hccd;
					end if;

				when (16#18#) =>
					-- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_abort_hccd_req;
					end if;

				when (16#19#) =>
					-- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_reset_hccd_controller;
					end if;

				when (16#1A#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD FEE Number
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(2 downto 0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_fee_number;
					end if;
					-- FTDI Half-CCD Reply Status Register : Half-CCD CCD Number
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_number;
					end if;
					-- FTDI Half-CCD Reply Status Register : Half-CCD CCD Side
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(16) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_side;
					end if;

				when (16#1B#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD CCD Height
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_height(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(12 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_height(12 downto 8);
					end if;
					-- FTDI Half-CCD Reply Status Register : Half-CCD CCD Width
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_width(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_avalon_mm_o.readdata(27 downto 24) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_width(11 downto 8);
					end if;

				when (16#1C#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD Exposure Number
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_exposure_number(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_exposure_number(15 downto 8);
					end if;

				when (16#1D#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD Image Length [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(31 downto 24);
					end if;

				when (16#1E#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD Received
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_received;
					end if;

				when (16#1F#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD Controller Busy
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_controller_busy;
					end if;

				when (16#20#) =>
					-- FTDI Half-CCD Reply Status Register : Half-CCD Last Rx Buffer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_last_rx_buffer;
					end if;

				when (16#21#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 0 Readable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_0_rdable;
					end if;

				when (16#22#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 0 Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_0_empty;
					end if;

				when (16#23#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 0 Used [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_0_used_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(13 downto 8) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_0_used_bytes(13 downto 8);
					end if;

				when (16#24#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 0 Full
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_0_full;
					end if;

				when (16#25#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 1 Readable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_1_rdable;
					end if;

				when (16#26#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 1 Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_1_empty;
					end if;

				when (16#27#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 1 Used [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_1_used_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(13 downto 8) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_1_used_bytes(13 downto 8);
					end if;

				when (16#28#) =>
					-- FTDI Rx Buffer Status Register : Rx Buffer 1 Full
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_1_full;
					end if;

				when (16#29#) =>
					-- FTDI Rx Buffer Status Register : Rx Double Buffer Readable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_dbuffer_rdable;
					end if;

				when (16#2A#) =>
					-- FTDI Rx Buffer Status Register : Rx Double Buffer Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_dbuffer_empty;
					end if;

				when (16#2B#) =>
					-- FTDI Rx Buffer Status Register : Rx Double Buffer Used [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_dbuffer_used_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(13 downto 8) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_dbuffer_used_bytes(13 downto 8);
					end if;

				when (16#2C#) =>
					-- FTDI Rx Buffer Status Register : Rx Double Buffer Full
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_dbuffer_full;
					end if;

				when (16#2D#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 0 Writeable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_0_wrable;
					end if;

				when (16#2E#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 0 Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_0_empty;
					end if;

				when (16#2F#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 0 Space [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_0_space_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(13 downto 8) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_0_space_bytes(13 downto 8);
					end if;

				when (16#30#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 0 Full
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_0_full;
					end if;

				when (16#31#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 1 Writeable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_1_wrable;
					end if;

				when (16#32#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 1 Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_1_empty;
					end if;

				when (16#33#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 1 Space [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_1_space_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(13 downto 8) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_1_space_bytes(13 downto 8);
					end if;

				when (16#34#) =>
					-- FTDI Tx Buffer Status Register : Tx Buffer 1 Full
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_1_full;
					end if;

				when (16#35#) =>
					-- FTDI Tx Buffer Status Register : Tx Double Buffer Writeable
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_dbuffer_wrable;
					end if;

				when (16#36#) =>
					-- FTDI Tx Buffer Status Register : Tx Double Buffer Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_dbuffer_empty;
					end if;

				when (16#37#) =>
					-- FTDI Tx Buffer Status Register : Tx Double Buffer Space [Bytes]
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_dbuffer_space_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(13 downto 8) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_dbuffer_space_bytes(13 downto 8);
					end if;

				when (16#38#) =>
					-- FTDI Tx Buffer Status Register : Tx Double Buffer Full
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_dbuffer_full;
					end if;

				when (16#39#) =>
					-- FTDI Rx Communication Error Register : Rx Communication Error State
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.rx_comm_err_state;
					end if;

				when (16#3A#) =>
					-- FTDI Rx Communication Error Register : Rx Communication Error Code
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.rx_comm_err_code(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.rx_comm_error_reg.rx_comm_err_code(15 downto 8);
					end if;

				when (16#3B#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Request Nack Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_req_nack_err;
					end if;

				when (16#3C#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Reply Wrong Header CRC Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_header_crc_err;
					end if;

				when (16#3D#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Reply End of Header Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_eoh_err;
					end if;

				when (16#3E#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Reply Wrong Payload CRC Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_payload_crc_err;
					end if;

				when (16#3F#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Reply End of Payload Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_eop_err;
					end if;

				when (16#40#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Request Maximum Tries Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_req_max_tries_err;
					end if;

				when (16#41#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Request CCD Size Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_ccd_size_err;
					end if;

				when (16#42#) =>
					-- FTDI Rx Communication Error Register : Half-CCD Request Timeout Error
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_req_timeout_err;
					end if;

				when (16#43#) =>
					-- FTDI Reserved Register : Tx Buffer 0 Empty Irq
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.tx_buffer_0_empty_irq;
					end if;

				when (16#44#) =>
					-- FTDI Reserved Register : Tx Buffer 1 Empty Irq
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.tx_buffer_1_empty_irq;
					end if;

				when (16#45#) =>
					-- FTDI Reserved Register : LUT Transmitted Irq
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.lut_transmitted_irq;
					end if;

				when (16#46#) =>
					-- FTDI Reserved Register : Tx Communication Protocol Error Irq
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.tx_comm_protocol_err_irq;
					end if;

				when (16#47#) =>
					-- FTDI Reserved Register : LUT Length Bytes
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.reserved_reg.lut_length_bytes(7 downto 0);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
						ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.reserved_reg.lut_length_bytes(15 downto 8);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
						ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_rd_regs_i.reserved_reg.lut_length_bytes(23 downto 16);
					end if;
					if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
						ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_rd_regs_i.reserved_reg.lut_length_bytes(31 downto 24);
					end if;

				when (16#48#) =>
					-- FTDI Reserved Register : Transmit LUT
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.transmit_lut;
					end if;

				when (16#49#) =>
					-- FTDI Reserved Register : LUT Last Buffer
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.lut_last_buffer;
					end if;

				when (16#4A#) =>
					-- FTDI Reserved Register : LUT Transmitted
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.lut_transmitted;
					end if;

				when (16#4B#) =>
					-- FTDI Reserved Register : Tx Busy
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.tx_busy;
					end if;

				when (16#4C#) =>
					-- FTDI Reserved Register : Tx Buffer Empty
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.reserved_reg.tx_buffer_empty;
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					ftdi_config_avalon_mm_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_ftdi_config_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_config_avalon_mm_o.readdata    <= (others => '0');
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			v_read_address                      := 0;
		elsif (rising_edge(clk_i)) then
			ftdi_config_avalon_mm_o.readdata    <= (others => '0');
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			if (ftdi_config_avalon_mm_i.read = '1') then
				v_read_address                      := to_integer(unsigned(ftdi_config_avalon_mm_i.address));
				ftdi_config_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_ftdi_config_avalon_mm_read;

end architecture rtl;
