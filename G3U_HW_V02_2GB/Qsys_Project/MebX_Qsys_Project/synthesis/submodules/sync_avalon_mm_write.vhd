--=============================================================================
--! @file sync_avalon_mm_write.vhd
--=============================================================================
--! Standard library
library ieee;
--! Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! Specific packages
use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;
use work.sync_common_pkg.all;

-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync avalon mm write (sync_avalon_mm_write)
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
--! Entity declaration for sync avalon mm write
--============================================================================
entity sync_avalon_mm_write is
	generic(
		g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY
	);
	port(
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		avalon_mm_i    : in  t_sync_avalon_mm_write_i;
		avalon_mm_o    : out t_sync_avalon_mm_write_o;
		mm_write_reg_o : out t_sync_mm_write_registers
	);
end entity sync_avalon_mm_write;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_avalon_mm_write is

	signal s_data_acquired : std_logic;

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	--	-- Signals not used by ip logic. Initial levels made here, to suppress IDE "using don´t care ('x') value" 
	--	mm_write_reg_o.int_enable_register.error_int_flag_clear       <= '0';
	--	mm_write_reg_o.int_enable_register.blank_pulse_int_flag_clear <= '0';
	--	mm_write_reg_o.int_enable_register.error_int_flag             <= '0';
	--	mm_write_reg_o.int_enable_register.blank_pulse_int_flag       <= '0';
	--	mm_write_reg_o.int_flag_clear_register.error_int_enable       <= '0';
	--	mm_write_reg_o.int_flag_clear_register.blank_pulse_int_enable <= '0';
	--	mm_write_reg_o.int_flag_clear_register.error_int_flag         <= '0';
	--	mm_write_reg_o.int_flag_clear_register.blank_pulse_int_flag   <= '0';

	p_sync_avalon_mm_write : process(clk_i, rst_i) is
		-- Sync registers reset procedure
		procedure p_mm_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- Sync Interrupt Enable Register : Error interrupt enable bit
			mm_write_reg_o.sync_irq_enable_reg.error_irq_enable                        <= '0';
			-- Sync Interrupt Enable Register : Blank pulse interrupt enable bit
			mm_write_reg_o.sync_irq_enable_reg.blank_pulse_irq_enable                  <= '0';
			-- Sync Interrupt Enable Register : Master pulse interrupt enable bit
			mm_write_reg_o.sync_irq_enable_reg.master_pulse_irq_enable                 <= '0';
			-- Sync Interrupt Enable Register : Normal pulse interrupt enable bit
			mm_write_reg_o.sync_irq_enable_reg.normal_pulse_irq_enable                 <= '0';
			-- Sync Interrupt Enable Register : Last pulse interrupt enable bit
			mm_write_reg_o.sync_irq_enable_reg.last_pulse_irq_enable                   <= '0';
			-- Sync Interrupt Flag Clear Register : Error interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.error_irq_flag_clear                <= '0';
			-- Sync Interrupt Flag Clear Register : Blank pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear          <= '0';
			-- Sync Interrupt Flag Clear Register : Master pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear         <= '0';
			-- Sync Interrupt Flag Clear Register : Normal pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear         <= '0';
			-- Sync Interrupt Flag Clear Register : Last pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear           <= '0';
			-- Pre-Sync Interrupt Enable Register : Pre-Blank pulse interrupt enable bit
			mm_write_reg_o.pre_sync_irq_enable_reg.pre_blank_pulse_irq_enable          <= '0';
			-- Pre-Sync Interrupt Enable Register : Pre-Master pulse interrupt enable bit
			mm_write_reg_o.pre_sync_irq_enable_reg.pre_master_pulse_irq_enable         <= '0';
			-- Pre-Sync Interrupt Enable Register : Pre-Normal pulse interrupt enable bit
			mm_write_reg_o.pre_sync_irq_enable_reg.pre_normal_pulse_irq_enable         <= '0';
			-- Pre-Sync Interrupt Enable Register : Pre-Last pulse interrupt enable bit
			mm_write_reg_o.pre_sync_irq_enable_reg.pre_last_pulse_irq_enable           <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Blank pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear  <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Master pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Normal pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Last pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear   <= '0';
			-- Sync Master Blank Time Config Register : MBT value
			mm_write_reg_o.sync_config_reg.master_blank_time                           <= (others => '0');
			-- Sync Blank Time Config Register : BT value
			mm_write_reg_o.sync_config_reg.blank_time                                  <= (others => '0');
			-- Sync Last Blank Time Config Register : LBT value
			mm_write_reg_o.sync_config_reg.last_blank_time                             <= (others => '0');
			-- Sync Pre-Blank Time Config Register : Pre-Blank value
			mm_write_reg_o.sync_config_reg.pre_blank_time                              <= (others => '0');
			-- Sync Period Config Register : Period value
			mm_write_reg_o.sync_config_reg.period                                      <= (others => '0');
			-- Sync Last Period Config Register : Last Period value
			mm_write_reg_o.sync_config_reg.last_period                                 <= (others => '0');
			-- Sync Master Detection Time : Master Detection Time value
			mm_write_reg_o.sync_config_reg.master_detection_time                       <= std_logic_vector(to_unsigned(15000000, 32));
--			mm_write_reg_o.sync_config_reg.master_detection_time                       <= std_logic_vector(to_unsigned(15, 32)); -- for testbench utilization
			-- Sync Shot Time Config Register : OST value
			mm_write_reg_o.sync_config_reg.one_shot_time                               <= (others => '0');
			-- Sync General Config Register : Signal polarity
			mm_write_reg_o.sync_general_config_reg.signal_polarity                     <= not g_SYNC_DEFAULT_STBY_POLARITY;
			-- Sync General Config Register : Number of cycles
			mm_write_reg_o.sync_general_config_reg.number_of_cycles                    <= (others => '0');
			-- Sync Error Injection Register : Reserved
			mm_write_reg_o.sync_error_injection_reg.error_injection                    <= (others => '0');
			-- Sync Control Register : Internal/External(n) bit
			mm_write_reg_o.sync_control_reg.int_ext_n                                  <= '0';
			-- Sync Control Register : Start bit
			mm_write_reg_o.sync_control_reg.start                                      <= '0';
			-- Sync Control Register : Reset bit
			mm_write_reg_o.sync_control_reg.reset                                      <= '0';
			-- Sync Control Register : One Shot bit
			mm_write_reg_o.sync_control_reg.one_shot                                   <= '0';
			-- Sync Control Register : Err_inj bit
			mm_write_reg_o.sync_control_reg.err_inj                                    <= '0';
			-- Sync Control Register : Sync_out  out enable bit
			mm_write_reg_o.sync_control_reg.out_enable                                 <= '0';
			-- Sync Control Register : Channel 1 out enable bit
			mm_write_reg_o.sync_control_reg.channel_1_enable                           <= '0';
			-- Sync Control Register : Channel 2 out enable bit
			mm_write_reg_o.sync_control_reg.channel_2_enable                           <= '0';
			-- Sync Control Register : Channel 3 out enable bit
			mm_write_reg_o.sync_control_reg.channel_3_enable                           <= '0';
			-- Sync Control Register : Channel 4 out enable bit
			mm_write_reg_o.sync_control_reg.channel_4_enable                           <= '0';
			-- Sync Control Register : Channel 5 out enable bit
			mm_write_reg_o.sync_control_reg.channel_5_enable                           <= '0';
			-- Sync Control Register : Channel 6 out enable bit
			mm_write_reg_o.sync_control_reg.channel_6_enable                           <= '0';
			-- Sync Control Register : Channel 7 out enable bit
			mm_write_reg_o.sync_control_reg.channel_7_enable                           <= '0';
			-- Sync Control Register : Channel 8 out enable bit
			mm_write_reg_o.sync_control_reg.channel_8_enable                           <= '0';

		end procedure p_mm_reset_registers;

		-- Sync control triggers reset procedure
		procedure p_mm_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- Sync Interrupt Flag Clear Register : Error interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.error_irq_flag_clear                <= '0';
			-- Sync Interrupt Flag Clear Register : Blank pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear          <= '0';
			-- Sync Interrupt Flag Clear Register : Master pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear         <= '0';
			-- Sync Interrupt Flag Clear Register : Normal pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear         <= '0';
			-- Sync Interrupt Flag Clear Register : Last pulse interrupt flag clear bit
			mm_write_reg_o.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear           <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Blank pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear  <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Master pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Normal pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear <= '0';
			-- Pre-Sync Interrupt Flag Clear Register : Pre-Last pulse interrupt flag clear bit
			mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear   <= '0';
			-- Sync Control Register : Start bit
			mm_write_reg_o.sync_control_reg.start                                      <= '0';
			-- Sync Control Register : Reset bit
			mm_write_reg_o.sync_control_reg.reset                                      <= '0';
			-- Sync Control Register : One Shot bit
			mm_write_reg_o.sync_control_reg.one_shot                                   <= '0';
			-- Sync Control Register : Err_inj bit
			mm_write_reg_o.sync_control_reg.err_inj                                    <= '0';

		end procedure p_mm_control_triggers;

		-- Sync writedata procedure
		procedure p_mm_writedata(mm_write_address_i : t_sync_avalon_mm_address) is
		begin

			-- Registers Write Data
			case (mm_write_address_i) is
				-- Case for access to all registers address

				when (16#02#) =>
					-- Sync Interrupt Enable Register : Error interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_enable_reg.error_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#03#) =>
					-- Sync Interrupt Enable Register : Blank pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_enable_reg.blank_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#04#) =>
					-- Sync Interrupt Enable Register : Master pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_enable_reg.master_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#05#) =>
					-- Sync Interrupt Enable Register : Normal pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_enable_reg.normal_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#06#) =>
					-- Sync Interrupt Enable Register : Last pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_enable_reg.last_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#07#) =>
					-- Sync Interrupt Flag Clear Register : Error interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_flag_clear_reg.error_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#08#) =>
					-- Sync Interrupt Flag Clear Register : Blank pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#09#) =>
					-- Sync Interrupt Flag Clear Register : Master pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#0A#) =>
					-- Sync Interrupt Flag Clear Register : Normal pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#0B#) =>
					-- Sync Interrupt Flag Clear Register : Last pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#11#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Blank pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_enable_reg.pre_blank_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#12#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Master pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_enable_reg.pre_master_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#13#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Normal pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_enable_reg.pre_normal_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#14#) =>
					-- Pre-Sync Interrupt Enable Register : Pre-Last pulse interrupt enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_enable_reg.pre_last_pulse_irq_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#15#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Blank pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#16#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Master pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#17#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Normal pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#18#) =>
					-- Pre-Sync Interrupt Flag Clear Register : Pre-Last pulse interrupt flag clear bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear <= avalon_mm_i.writedata(0);
					end if;

				when (16#1D#) =>
					-- Sync Master Blank Time Config Register : MBT value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.master_blank_time(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.master_blank_time(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.master_blank_time(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.master_blank_time(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#1E#) =>
					-- Sync Blank Time Config Register : BT value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.blank_time(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.blank_time(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.blank_time(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.blank_time(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#1F#) =>
					-- Sync Last Blank Time Config Register : LBT value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.last_blank_time(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.last_blank_time(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.last_blank_time(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.last_blank_time(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#20#) =>
					-- Sync Pre-Blank Time Config Register : Pre-Blank value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.pre_blank_time(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.pre_blank_time(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.pre_blank_time(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.pre_blank_time(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#21#) =>
					-- Sync Period Config Register : Period value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.period(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.period(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.period(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.period(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#22#) =>
					-- Sync Last Period Config Register : Last Period value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.last_period(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.last_period(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.last_period(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.last_period(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#23#) =>
					-- Sync Master Detection Time : Master Detection Time value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.master_detection_time(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.master_detection_time(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.master_detection_time(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.master_detection_time(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#24#) =>
					-- Sync Shot Time Config Register : OST value
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_config_reg.one_shot_time(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_config_reg.one_shot_time(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_config_reg.one_shot_time(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_config_reg.one_shot_time(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#25#) =>
					-- Sync General Config Register : Signal polarity
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_general_config_reg.signal_polarity <= avalon_mm_i.writedata(0);
					end if;

				when (16#26#) =>
					-- Sync General Config Register : Number of cycles
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_general_config_reg.number_of_cycles <= avalon_mm_i.writedata(7 downto 0);
					end if;

				when (16#27#) =>
					-- Sync Error Injection Register : Reserved
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_error_injection_reg.error_injection(7 downto 0) <= avalon_mm_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_i.byteenable(1) = '1') then
						mm_write_reg_o.sync_error_injection_reg.error_injection(15 downto 8) <= avalon_mm_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_i.byteenable(2) = '1') then
						mm_write_reg_o.sync_error_injection_reg.error_injection(23 downto 16) <= avalon_mm_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_i.byteenable(3) = '1') then
						mm_write_reg_o.sync_error_injection_reg.error_injection(31 downto 24) <= avalon_mm_i.writedata(31 downto 24);
					end if;

				when (16#28#) =>
					-- Sync Control Register : Internal/External(n) bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.int_ext_n <= avalon_mm_i.writedata(0);
					end if;

				when (16#29#) =>
					-- Sync Control Register : Start bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.start <= avalon_mm_i.writedata(0);
					end if;

				when (16#2A#) =>
					-- Sync Control Register : Reset bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.reset <= avalon_mm_i.writedata(0);
					end if;

				when (16#2B#) =>
					-- Sync Control Register : One Shot bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.one_shot <= avalon_mm_i.writedata(0);
					end if;

				when (16#2C#) =>
					-- Sync Control Register : Err_inj bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.err_inj <= avalon_mm_i.writedata(0);
					end if;

				when (16#2D#) =>
					-- Sync Control Register : Sync_out  out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.out_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#2E#) =>
					-- Sync Control Register : Channel 1 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_1_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#2F#) =>
					-- Sync Control Register : Channel 2 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_2_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#30#) =>
					-- Sync Control Register : Channel 3 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_3_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#31#) =>
					-- Sync Control Register : Channel 4 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_4_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#32#) =>
					-- Sync Control Register : Channel 5 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_5_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#33#) =>
					-- Sync Control Register : Channel 6 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_6_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#34#) =>
					-- Sync Control Register : Channel 7 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_7_enable <= avalon_mm_i.writedata(0);
					end if;

				when (16#35#) =>
					-- Sync Control Register : Channel 8 out enable bit
					if (avalon_mm_i.byteenable(0) = '1') then
						mm_write_reg_o.sync_control_reg.channel_8_enable <= avalon_mm_i.writedata(0);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_mm_writedata;

		variable v_mm_write_address : t_sync_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_o.waitrequest <= '1';
			s_data_acquired         <= '0';
			v_mm_write_address      := 0;
			p_mm_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_o.waitrequest <= '1';
			p_mm_control_triggers;
			s_data_acquired         <= '0';
			if (avalon_mm_i.write = '1') then
				avalon_mm_o.waitrequest <= '0';
				v_mm_write_address      := to_integer(unsigned(avalon_mm_i.address));
				s_data_acquired         <= '1';
				if (s_data_acquired = '0') then
					p_mm_writedata(v_mm_write_address);
				end if;
			end if;
		end if;
	end process p_sync_avalon_mm_write;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
