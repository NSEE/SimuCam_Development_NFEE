library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;

entity sync_avalon_mm_read is
	port(
		-- in
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		avalon_mm_i    : in  t_sync_avalon_mm_read_i;
		mm_write_reg_i : in  t_sync_mm_write_registers;
		mm_read_reg_i  : in  t_sync_mm_read_registers;
		-- out
		avalon_mm_o    : out t_sync_avalon_mm_read_o
	);
end entity sync_avalon_mm_read;

architecture RTL of sync_avalon_mm_read is

begin

	p_sync_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_mm_readdata(mm_read_address_i : t_sync_avalon_mm_address) is
		begin
			-- Registers Data Read
			case (mm_read_address_i) is

				-- SYNC Module ReadData procedure

				--  Sync Module Control and Status Register           (32 bits):
				when (c_SYNC_MODULE_CONTROL_STATUS_MM_REG_ADDRESS) =>
					--    31-23 : Reserved                                  [-/-]
					avalon_mm_o.readdata(31 downto 23) <= (others => '0');
					--    22-22 : Sync Start control bit                    [R/W]
					avalon_mm_o.readdata(22)           <= mm_write_reg_i.module_control_register.sync_start;
					--    21-21 : Sync Stop control bit                     [R/W]
					avalon_mm_o.readdata(21)           <= mm_write_reg_i.module_control_register.sync_stop;
					--    20-20 : Sync Reset control bit                    [R/W]
					avalon_mm_o.readdata(20)           <= mm_write_reg_i.module_control_register.sync_reset;
					--    19-19 : Sync Running status bit                   [R/-]
					avalon_mm_o.readdata(19)           <= mm_read_reg_i.module_status_register.sync_running;
					--    18-18 : Sync Stopped status bit                   [R/-]
					avalon_mm_o.readdata(18)           <= mm_read_reg_i.module_status_register.sync_stopped;
					--    17-17 : Sync Error interrupt enable bit           [R/W]
					avalon_mm_o.readdata(17)           <= mm_write_reg_i.interrupt_enable_register.sync_error;
					--    16-16 : Sync Master Start interrupt enable bit    [R/W]
					avalon_mm_o.readdata(16)           <= mm_write_reg_i.interrupt_enable_register.master_start;
					--    15-15 : Sync Pulse Start interrupt enable bit     [R/W]
					avalon_mm_o.readdata(15)           <= mm_write_reg_i.interrupt_enable_register.pulse_start;
					--    14-14 : Sync Master Stop interrupt enable bit     [R/W]
					avalon_mm_o.readdata(14)           <= mm_write_reg_i.interrupt_enable_register.master_stop;
					--    13-13 : Sync Pulse Stop interrupt enable bit      [R/W]
					avalon_mm_o.readdata(13)           <= mm_write_reg_i.interrupt_enable_register.pulse_stop;
					--    12-12 : Sync Reseted interrupt enable bit         [R/W]
					avalon_mm_o.readdata(12)           <= mm_write_reg_i.interrupt_enable_register.sync_reseted;
					--    11-11 : Sync Error interrupt flag                 [R/-]
					avalon_mm_o.readdata(11)           <= mm_read_reg_i.interrupt_flag_register.sync_error;
					--    10-10 : Sync Error interrupt flag clear           [-/W]
					avalon_mm_o.readdata(10)           <= mm_write_reg_i.interrupt_flag_clear_register.sync_error;
					--     9- 9 : Sync Master Start interrupt flag          [R/-]
					avalon_mm_o.readdata(9)            <= mm_read_reg_i.interrupt_flag_register.master_start;
					--     8- 8 : Sync Master Start interrupt flag clear    [-/W]
					avalon_mm_o.readdata(8)            <= mm_write_reg_i.interrupt_flag_clear_register.master_start;
					--     7- 7 : Sync Pulse Start interrupt flag           [R/-]
					avalon_mm_o.readdata(7)            <= mm_read_reg_i.interrupt_flag_register.pulse_start;
					--     6- 6 : Sync Pulse Start interrupt flag clear     [-/W]
					avalon_mm_o.readdata(6)            <= mm_write_reg_i.interrupt_flag_clear_register.pulse_start;
					--     5- 5 : Sync Master Stop interrupt flag           [R/-]
					avalon_mm_o.readdata(5)            <= mm_read_reg_i.interrupt_flag_register.master_stop;
					--     4- 4 : Sync Master Stop interrupt flag clear     [-/W]
					avalon_mm_o.readdata(4)            <= mm_write_reg_i.interrupt_flag_clear_register.master_stop;
					--     3- 3 : Sync Pulse Stop interrupt flag            [R/-]
					avalon_mm_o.readdata(3)            <= mm_read_reg_i.interrupt_flag_register.pulse_stop;
					--     2- 2 : Sync Pulse Stop interrupt flag clear      [-/W]
					avalon_mm_o.readdata(2)            <= mm_write_reg_i.interrupt_flag_clear_register.pulse_stop;
					--     1- 1 : Sync Reseted interrupt flag               [R/-]
					avalon_mm_o.readdata(1)            <= mm_read_reg_i.interrupt_flag_register.sync_reseted;
					--     0- 0 : Sync Reseted interrupt flag clear         [-/W]
					avalon_mm_o.readdata(0)            <= mm_write_reg_i.interrupt_flag_clear_register.sync_reseted;

				--  Sync Signal Configuration Register                (32 bits):
				when (c_SYNC_SIGNAL_CONFIGURATION_MM_REG_ADDRESS) =>
					--    31-14 : Reserved                                  [-/-]
					avalon_mm_o.readdata(31 downto 14) <= (others => '0');
					--    13-12 : Sync Signal Number of Pulses value        [R/W]
					avalon_mm_o.readdata(13 downto 12) <= mm_write_reg_i.signal_configuration_register.signal_number_pulses;
					--    11-11 : Sync Signal Polarity bit                  [R/W]
					avalon_mm_o.readdata(11)           <= mm_write_reg_i.signal_configuration_register.signal_polarity;
					--    10-10 : Sync External/Internal(n) control bit     [R/W]
					avalon_mm_o.readdata(10)           <= mm_write_reg_i.signal_configuration_register.sync_external;
					--     9- 9 : Sync Signal Sync In enable bit            [R/W]
					avalon_mm_o.readdata(9)            <= mm_write_reg_i.signal_configuration_register.sync_in_enable;
					--     8- 8 : Sync Signal Sync Out enable bit           [R/W]
					avalon_mm_o.readdata(8)            <= mm_write_reg_i.signal_configuration_register.sync_out_enable;
					--     7- 7 : Sync Signal Channel A enable bit          [R/W]
					avalon_mm_o.readdata(7)            <= mm_write_reg_i.signal_configuration_register.channel_A_enable;
					--     6- 6 : Sync Signal Channel B enable bit          [R/W]
					avalon_mm_o.readdata(6)            <= mm_write_reg_i.signal_configuration_register.channel_B_enable;
					--     5- 5 : Sync Signal Channel C enable bit          [R/W]
					avalon_mm_o.readdata(5)            <= mm_write_reg_i.signal_configuration_register.channel_C_enable;
					--     4- 4 : Sync Signal Channel D enable bit          [R/W]
					avalon_mm_o.readdata(4)            <= mm_write_reg_i.signal_configuration_register.channel_D_enable;
					--     3- 3 : Sync Signal Channel E enable bit          [R/W]
					avalon_mm_o.readdata(3)            <= mm_write_reg_i.signal_configuration_register.channel_E_enable;
					--     2- 2 : Sync Signal Channel F enable bit          [R/W]
					avalon_mm_o.readdata(2)            <= mm_write_reg_i.signal_configuration_register.channel_F_enable;
					--     1- 1 : Sync Signal Channel G enable bit          [R/W]
					avalon_mm_o.readdata(1)            <= mm_write_reg_i.signal_configuration_register.channel_G_enable;
					--     0- 0 : Sync Signal Channel H enable bit          [R/W]
					avalon_mm_o.readdata(0)            <= mm_write_reg_i.signal_configuration_register.channel_H_enable;

				--  Sync Signal Master Width Register                 (32 bits):
				when (c_SYNC_SIGNAL_MASTER_WIDTH_MM_REG_ADDRESS) =>
					--    31-0 : Sync Signal Master Width value             [R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.signal_master_width_register.signal_master_width;

				--  Sync Signal Pulse Width Register                  (32 bits):
				when (c_SYNC_SIGNAL_PULSE_WIDTH_MM_REG_ADDRESS) =>
					--    31-0 : Sync Signal Pulse Width value              [R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.signal_pulse_width_register.signal_pulse_width;

				--  Sync Signal Pulse Period Register                 (32 bits):
				when (c_SYNC_SIGNAL_PULSE_PERIOD_MM_REG_ADDRESS) =>
					--    31-0 : Sync Signal Pulse Period value             [R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.signal_pulse_period_register.signal_pulse_period;

				when others =>
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
				v_mm_read_address       := to_integer(unsigned(avalon_mm_inputs.address));
				p_mm_readdata(v_mm_read_address);
			end if;
		end if;
	end process p_sync_avalon_mm_read;

end architecture RTL;
