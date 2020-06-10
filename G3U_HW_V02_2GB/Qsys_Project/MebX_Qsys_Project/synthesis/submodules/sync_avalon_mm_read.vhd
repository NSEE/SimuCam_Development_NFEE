--=============================================================================
--! @file sync_avalon_mm_read.vhd
--=============================================================================
--! Standard library
library ieee;
--! Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! Specific packages
use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;

-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync avalon mm read (sync_avalon_mm_read)
--
--! @brief 
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Cassio Berni (ccberni@hotmail.com)
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--! 08\11\2018 CB Module optimization & revision\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for sync avalon mm read
--============================================================================
entity sync_avalon_mm_read is
	port(
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		avalon_mm_i    : in  t_sync_avalon_mm_read_i;
		mm_write_reg_i : in  t_sync_mm_write_registers;
		mm_read_reg_i  : in  t_sync_mm_read_registers;
		avalon_mm_o    : out t_sync_avalon_mm_read_o
	);
end entity sync_avalon_mm_read;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_avalon_mm_read is

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	p_sync_avalon_mm_read : process(clk_i, rst_i) is
		-- Sync module readdata procedure
		procedure p_mm_readdata(mm_read_address_i : t_sync_avalon_mm_address) is
		begin

			-- Registers Data Read
			case (mm_read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Sync Status Register : Internal/External_n
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.sync_status_reg.int_ext_n;
					end if;

				when (16#01#) =>
					-- Sync Status Register : State
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_read_reg_i.sync_status_reg.state;
					end if;
					-- Sync Status Register : Error code
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_read_reg_i.sync_status_reg.error_code;
					end if;
					-- Sync Status Register : Cycle number
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_read_reg_i.sync_status_reg.cycle_number;
					end if;

				when (16#02#) =>
					-- Sync Interrupt Enable Register : Error interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_enable_reg.error_irq_enable;
					end if;

				when (16#03#) =>
					-- Sync Interrupt Enable Register : Blank pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_enable_reg.blank_pulse_irq_enable;
					end if;

				when (16#04#) =>
					-- Sync Interrupt Enable Register : Master pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_enable_reg.master_pulse_irq_enable;
					end if;

				when (16#05#) =>
					-- Sync Interrupt Enable Register : Normal pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_enable_reg.normal_pulse_irq_enable;
					end if;

				when (16#06#) =>
					-- Sync Interrupt Enable Register : Last pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_enable_reg.last_pulse_irq_enable;
					end if;

				when (16#07#) =>
					-- Sync Interrupt Flag Clear Register : Error interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_flag_clear_reg.error_irq_flag_clear;
					end if;

				when (16#08#) =>
					-- Sync Interrupt Flag Clear Register : Blank pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear;
					end if;

				when (16#09#) =>
					-- Sync Interrupt Flag Clear Register : Master pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear;
					end if;

				when (16#0A#) =>
					-- Sync Interrupt Flag Clear Register : Normal pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear;
					end if;

				when (16#0B#) =>
					-- Sync Interrupt Flag Clear Register : Last pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear;
					end if;

				when (16#0C#) =>
					-- Sync Interrupt Flag Register : Error interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.sync_irq_flag_reg.error_irq_flag;
					end if;

				when (16#0D#) =>
					-- Sync Interrupt Flag Register : Blank pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.sync_irq_flag_reg.blank_pulse_irq_flag;
					end if;

				when (16#0E#) =>
					-- Sync Interrupt Flag Register : Master pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.sync_irq_flag_reg.master_pulse_irq_flag;
					end if;

				when (16#0F#) =>
					-- Sync Interrupt Flag Register : Normal pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.sync_irq_flag_reg.normal_pulse_irq_flag;
					end if;

				when (16#10#) =>
					-- Sync Interrupt Flag Register : Last pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.sync_irq_flag_reg.last_pulse_irq_flag;
					end if;

				when (16#11#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Blank pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_enable_reg.pre_blank_pulse_irq_enable;
					end if;

				when (16#12#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Master pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_enable_reg.pre_master_pulse_irq_enable;
					end if;

				when (16#13#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Normal pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_enable_reg.pre_normal_pulse_irq_enable;
					end if;

				when (16#14#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Last pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_enable_reg.pre_last_pulse_irq_enable;
					end if;

				when (16#15#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Blank pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear;
					end if;

				when (16#16#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Master pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear;
					end if;

				when (16#17#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Normal pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear;
					end if;

				when (16#18#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Last pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear;
					end if;

				when (16#19#) =>
					-- Pre-Sync Interrupt Flag Register : Pre-Blank pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.pre_sync_irq_flag_reg.pre_blank_pulse_irq_flag;
					end if;

				when (16#1A#) =>
					-- Pre-Sync Interrupt Flag Register : Pre-Master pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.pre_sync_irq_flag_reg.pre_master_pulse_irq_flag;
					end if;

				when (16#1B#) =>
					-- Pre-Sync Interrupt Flag Register : Pre-Normal pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.pre_sync_irq_flag_reg.pre_normal_pulse_irq_flag;
					end if;

				when (16#1C#) =>
					-- Pre-Sync Interrupt Flag Register : Pre-Last pulse interrupt flag bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_read_reg_i.pre_sync_irq_flag_reg.pre_last_pulse_irq_flag;
					end if;

				when (16#1D#) =>
					-- Sync Master Blank Time Config Register : MBT value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.master_blank_time(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.master_blank_time(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.master_blank_time(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.master_blank_time(31 downto 24);
					end if;

				when (16#1E#) =>
					-- Sync Blank Time Config Register : BT value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.blank_time(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.blank_time(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.blank_time(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.blank_time(31 downto 24);
					end if;

				when (16#1F#) =>
					-- Sync Last Blank Time Config Register : LBT value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.last_blank_time(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.last_blank_time(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.last_blank_time(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.last_blank_time(31 downto 24);
					end if;

				when (16#20#) =>
					-- Sync Pre-Blank Time Config Register : Pre-Blank value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.pre_blank_time(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.pre_blank_time(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.pre_blank_time(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.pre_blank_time(31 downto 24);
					end if;

				when (16#21#) =>
					-- Sync Period Config Register : Period value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.period(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.period(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.period(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.period(31 downto 24);
					end if;

				when (16#22#) =>
					-- Sync Last Period Config Register : Last Period value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.last_period(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.last_period(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.last_period(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.last_period(31 downto 24);
					end if;

				when (16#23#) =>
					-- Sync Master Detection Time : Master Detection Time value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.master_detection_time(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.master_detection_time(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.master_detection_time(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.master_detection_time(31 downto 24);
					end if;

				when (16#24#) =>
					-- Sync Shot Time Config Register : OST value
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_config_reg.one_shot_time(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_config_reg.one_shot_time(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_config_reg.one_shot_time(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_config_reg.one_shot_time(31 downto 24);
					end if;

				when (16#25#) =>
					-- Sync General Config Register : Signal polarity
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_general_config_reg.signal_polarity;
					end if;

				when (16#26#) =>
					-- Sync General Config Register : Number of cycles
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_general_config_reg.number_of_cycles;
					end if;

				when (16#27#) =>
					-- Sync Error Injection Register : Reserved
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_write_reg_i.sync_error_injection_reg.error_injection(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_write_reg_i.sync_error_injection_reg.error_injection(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_write_reg_i.sync_error_injection_reg.error_injection(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_write_reg_i.sync_error_injection_reg.error_injection(31 downto 24);
					end if;

				when (16#28#) =>
					-- Sync Control Register : Internal/External(n) bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.int_ext_n;
					end if;

				when (16#29#) =>
					-- Sync Control Register : Start bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.start;
					end if;

				when (16#2A#) =>
					-- Sync Control Register : Reset bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.reset;
					end if;

				when (16#2B#) =>
					-- Sync Control Register : One Shot bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.one_shot;
					end if;

				when (16#2C#) =>
					-- Sync Control Register : Err_inj bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.err_inj;
					end if;

				when (16#2D#) =>
					-- Sync Control Register : Sync_out  out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.out_enable;
					end if;

				when (16#2E#) =>
					-- Sync Control Register : Channel 1 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_1_enable;
					end if;

				when (16#2F#) =>
					-- Sync Control Register : Channel 2 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_2_enable;
					end if;

				when (16#30#) =>
					-- Sync Control Register : Channel 3 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_3_enable;
					end if;

				when (16#31#) =>
					-- Sync Control Register : Channel 4 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_4_enable;
					end if;

				when (16#32#) =>
					-- Sync Control Register : Channel 5 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_5_enable;
					end if;

				when (16#33#) =>
					-- Sync Control Register : Channel 6 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_6_enable;
					end if;

				when (16#34#) =>
					-- Sync Control Register : Channel 7 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_7_enable;
					end if;

				when (16#35#) =>
					-- Sync Control Register : Channel 8 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(0) <= mm_write_reg_i.sync_control_reg.channel_8_enable;
					end if;

				when (16#36#) =>
					-- Sync IRQ Number Register : Sync IRQ number
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_read_reg_i.sync_irq_number_reg.sync_irq_number(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_read_reg_i.sync_irq_number_reg.sync_irq_number(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_read_reg_i.sync_irq_number_reg.sync_irq_number(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_read_reg_i.sync_irq_number_reg.sync_irq_number(31 downto 24);
					end if;

				when (16#37#) =>
					-- Sync IRQ Number Register : Pre-Sync IRQ number
					if (avalon_mm_i.byteenable(0) = '1') then
						avalon_mm_o.readdata(7 downto 0) <= mm_read_reg_i.sync_irq_number_reg.pre_sync_irq_number(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						avalon_mm_o.readdata(15 downto 8) <= mm_read_reg_i.sync_irq_number_reg.pre_sync_irq_number(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						avalon_mm_o.readdata(23 downto 16) <= mm_read_reg_i.sync_irq_number_reg.pre_sync_irq_number(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						avalon_mm_o.readdata(31 downto 24) <= mm_read_reg_i.sync_irq_number_reg.pre_sync_irq_number(31 downto 24);
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_o.readdata <= (others => '0');

			end case;

		end procedure p_mm_readdata;

		variable v_mm_read_address : t_sync_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_o.readdata    <= (others => '0');
			avalon_mm_o.waitrequest <= '1';
			v_mm_read_address       := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_o.readdata    <= (others => '0');
			avalon_mm_o.waitrequest <= '1';
			if (avalon_mm_i.read = '1') then
				avalon_mm_o.waitrequest <= '0';
				v_mm_read_address       := to_integer(unsigned(avalon_mm_i.address));
				p_mm_readdata(v_mm_read_address);
			end if;
		end if;
	end process p_sync_avalon_mm_read;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
