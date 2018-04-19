library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;

entity sync_avalon_mm_write is
	port(
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		avalon_mm_i    : in  t_sync_avalon_mm_write_i;
		-- out
		avalon_mm_o    : out t_sync_avalon_mm_write_o;
		mm_write_reg_o : out t_sync_mm_write_registers
	);
end entity sync_avalon_mm_write;

architecture RTL of sync_avalon_mm_write is

begin

	p_sync_avalon_mm_write : process(clk_i, rst_i) is
		procedure p_mm_reset_registers is
		begin
			-- SYNC Module Reset procedure
			mm_write_reg_o.module_control_register.sync_start                 <= '0';
			mm_write_reg_o.module_control_register.sync_stop                  <= '0';
			mm_write_reg_o.module_control_register.sync_reset                 <= '0';
			mm_write_reg_o.interrupt_enable_register.sync_error               <= '0';
			mm_write_reg_o.interrupt_enable_register.master_start             <= '0';
			mm_write_reg_o.interrupt_enable_register.pulse_start              <= '0';
			mm_write_reg_o.interrupt_enable_register.master_stop              <= '0';
			mm_write_reg_o.interrupt_enable_register.pulse_stop               <= '0';
			mm_write_reg_o.interrupt_enable_register.sync_reseted             <= '0';
			mm_write_reg_o.interrupt_flag_clear_register.sync_error           <= '0';
			mm_write_reg_o.interrupt_flag_clear_register.pulse_start          <= '0';
			mm_write_reg_o.interrupt_flag_clear_register.master_stop          <= '0';
			mm_write_reg_o.interrupt_flag_clear_register.pulse_stop           <= '0';
			mm_write_reg_o.interrupt_flag_clear_register.sync_reseted         <= '0';
			mm_write_reg_o.signal_configuration_register.signal_number_pulses <= (others => '0');
			mm_write_reg_o.signal_configuration_register.signal_polarity      <= '0';
			mm_write_reg_o.signal_configuration_register.sync_external        <= '0';
			mm_write_reg_o.signal_configuration_register.sync_in_enable       <= '0';
			mm_write_reg_o.signal_configuration_register.sync_out_enable      <= '0';
			mm_write_reg_o.signal_configuration_register.channel_A_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_B_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_C_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_D_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_E_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_F_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_G_enable     <= '0';
			mm_write_reg_o.signal_configuration_register.channel_H_enable     <= '0';
			mm_write_reg_o.signal_master_width_register.signal_master_width   <= (others => '0');
			mm_write_reg_o.signal_pulse_width_register.signal_pulse_width     <= (others => '0');
			mm_write_reg_o.signal_pulse_period_register.signal_pulse_period   <= (others => '0');
		end procedure p_mm_reset_registers;

		procedure p_mm_control_triggers is
		begin
			-- SYNC Module Control Triggers procedure
			mm_write_reg_o.module_control_register.sync_start <= '0';
			mm_write_reg_o.module_control_register.sync_stop  <= '0';
			mm_write_reg_o.module_control_register.sync_reset <= '0';
		end procedure p_mm_control_triggers;

		procedure p_mm_writedata(mm_write_address_i : t_sync_avalon_mm_address) is
		begin
			-- Registers Write Data
			case (mm_write_address_i) is
				-- Case for access to all registers address

				-- SYNC Module WriteData procedure

				--  Sync Module Control and Status Register           (32 bits):
				when (c_SYNC_MODULE_CONTROL_STATUS_MM_REG_ADDRESS) =>
					--    31-23 : Reserved                                  [-/-]
					--    22-22 : Sync Start control bit                    [R/W]
					mm_write_reg_i.module_control_register.sync_start         <= avalon_mm_o.writedata(22);
					--    21-21 : Sync Stop control bit                     [R/W]
					mm_write_reg_i.module_control_register.sync_stop          <= avalon_mm_o.writedata(21);
					--    20-20 : Sync Reset control bit                    [R/W]
					mm_write_reg_i.module_control_register.sync_reset         <= avalon_mm_o.writedata(20);
					--    19-19 : Sync Running status bit                   [R/-]
					--    18-18 : Sync Stopped status bit                   [R/-]
					--    17-17 : Sync Error interrupt enable bit           [R/W]
					mm_write_reg_i.interrupt_enable_register.sync_error       <= avalon_mm_o.writedata(17);
					--    16-16 : Sync Master Start interrupt enable bit    [R/W]
					mm_write_reg_i.interrupt_enable_register.master_start     <= avalon_mm_o.writedata(16);
					--    15-15 : Sync Pulse Start interrupt enable bit     [R/W]
					mm_write_reg_i.interrupt_enable_register.pulse_start      <= avalon_mm_o.writedata(15);
					--    14-14 : Sync Master Stop interrupt enable bit     [R/W]
					mm_write_reg_i.interrupt_enable_register.master_stop      <= avalon_mm_o.writedata(14);
					--    13-13 : Sync Pulse Stop interrupt enable bit      [R/W]
					mm_write_reg_i.interrupt_enable_register.pulse_stop       <= avalon_mm_o.writedata(13);
					--    12-12 : Sync Reseted interrupt enable bit         [R/W]
					mm_write_reg_i.interrupt_enable_register.sync_reseted     <= avalon_mm_o.writedata(12);
					--    11-11 : Sync Error interrupt flag                 [R/-]
					--    10-10 : Sync Error interrupt flag clear           [-/W]
					mm_write_reg_i.interrupt_flag_clear_register.sync_error   <= avalon_mm_o.writedata(10);
					--     9- 9 : Sync Master Start interrupt flag          [R/-]
					--     8- 8 : Sync Master Start interrupt flag clear    [-/W]
					mm_write_reg_i.interrupt_flag_clear_register.master_start <= avalon_mm_o.writedata(8);
					--     7- 7 : Sync Pulse Start interrupt flag           [R/-]
					--     6- 6 : Sync Pulse Start interrupt flag clear     [-/W]
					mm_write_reg_i.interrupt_flag_clear_register.pulse_start  <= avalon_mm_o.writedata(6);
					--     5- 5 : Sync Master Stop interrupt flag           [R/-]
					--     4- 4 : Sync Master Stop interrupt flag clear     [-/W]
					mm_write_reg_i.interrupt_flag_clear_register.master_stop  <= avalon_mm_o.writedata(4);
					--     3- 3 : Sync Pulse Stop interrupt flag            [R/-]
					--     2- 2 : Sync Pulse Stop interrupt flag clear      [-/W]
					mm_write_reg_i.interrupt_flag_clear_register.pulse_stop   <= avalon_mm_o.writedata(2);
					--     1- 1 : Sync Reseted interrupt flag               [R/-]
					--     0- 0 : Sync Reseted interrupt flag clear         [-/W]
					mm_write_reg_i.interrupt_flag_clear_register.sync_reseted <= avalon_mm_o.writedata(0);

				--  Sync Signal Configuration Register                (32 bits):
				when (c_SYNC_SIGNAL_CONFIGURATION_MM_REG_ADDRESS) =>
					--    31-14 : Reserved                                  [-/-]
					--    13-12 : Sync Signal Number of Pulses value        [R/W]
					mm_write_reg_i.signal_configuration_register.signal_number_pulses <= avalon_mm_o.writedata(13 downto 12);
					--    11-11 : Sync Signal Polarity bit                  [R/W]
					mm_write_reg_i.signal_configuration_register.signal_polarity      <= avalon_mm_o.writedata(11);
					--    10-10 : Sync External/Internal(n) control bit     [R/W]
					mm_write_reg_i.signal_configuration_register.sync_external        <= avalon_mm_o.writedata(10);
					--     9- 9 : Sync Signal Sync In enable bit            [R/W]
					mm_write_reg_i.signal_configuration_register.sync_in_enable       <= avalon_mm_o.writedata(9);
					--     8- 8 : Sync Signal Sync Out enable bit           [R/W]
					mm_write_reg_i.signal_configuration_register.sync_out_enable      <= avalon_mm_o.writedata(8);
					--     7- 7 : Sync Signal Channel A enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_A_enable     <= avalon_mm_o.writedata(7);
					--     6- 6 : Sync Signal Channel B enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_B_enable     <= avalon_mm_o.writedata(6);
					--     5- 5 : Sync Signal Channel C enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_C_enable     <= avalon_mm_o.writedata(5);
					--     4- 4 : Sync Signal Channel D enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_D_enable     <= avalon_mm_o.writedata(4);
					--     3- 3 : Sync Signal Channel E enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_E_enable     <= avalon_mm_o.writedata(3);
					--     2- 2 : Sync Signal Channel F enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_F_enable     <= avalon_mm_o.writedata(2);
					--     1- 1 : Sync Signal Channel G enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_G_enable     <= avalon_mm_o.writedata(1);
					--     0- 0 : Sync Signal Channel H enable bit          [R/W]
					mm_write_reg_i.signal_configuration_register.channel_H_enable     <= avalon_mm_o.writedata(0);

				--  Sync Signal Master Width Register                 (32 bits):
				when (c_SYNC_SIGNAL_MASTER_WIDTH_MM_REG_ADDRESS) =>
					--    31-0 : Sync Signal Master Width value             [R/W]
					mm_write_reg_i.signal_master_width_register.signal_master_width <= avalon_mm_o.writedata(31 downto 0);

				--  Sync Signal Pulse Width Register                  (32 bits):
				when (c_SYNC_SIGNAL_PULSE_WIDTH_MM_REG_ADDRESS) =>
					--    31-0 : Sync Signal Pulse Width value              [R/W]
					mm_write_reg_i.signal_pulse_width_register.signal_pulse_width <= avalon_mm_o.writedata(31 downto 0);

				--  Sync Signal Pulse Period Register                 (32 bits):
				when (c_SYNC_SIGNAL_PULSE_PERIOD_MM_REG_ADDRESS) =>
					--    31-0 : Sync Signal Pulse Period value             [R/W]
					mm_write_reg_i.signal_pulse_period_register.signal_pulse_period <= avalon_mm_o.writedata(31 downto 0);

				when others =>
					null;
			end case;
		end procedure p_mm_writedata;

		variable v_mm_write_address : t_sync_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_o.waitrequest <= '1';
			v_mm_write_address      := 0;
			p_mm_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_o.waitrequest <= '1';
			p_mm_control_triggers;
			if (avalon_mm_i.write = '1') then
				avalon_mm_o.waitrequest <= '0';
				v_mm_write_address      := to_integer(unsigned(avalon_mm_i.address));
				p_mm_writedata(v_mm_write_address);
			end if;
		end if;
	end process p_sync_avalon_mm_write;

end architecture RTL;
