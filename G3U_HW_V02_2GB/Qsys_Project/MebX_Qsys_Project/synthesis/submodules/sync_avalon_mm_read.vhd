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
		clk_i           : in  std_logic;
		rst_i           : in  std_logic;
		avalon_mm_i     : in  t_sync_avalon_mm_read_i;
		mm_write_reg_i  : in  t_sync_mm_write_registers;
		mm_read_reg_i   : in  t_sync_mm_read_registers;
		sync_irq_flag_i : in  std_logic;
		avalon_mm_o     : out t_sync_avalon_mm_read_o
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
			-- Registers data read
			case (mm_read_address_i) is
				-- Status register (32 bits):
				when (c_SYNC_STATUS_MM_REG_ADDRESS) =>
					--    31-31 : Internal/External_n status bit            [R/-]
					avalon_mm_o.readdata(31)           <= mm_read_reg_i.status_register.int_ext_n;
					--    30-24 : Reserved                                  [-/-]
					avalon_mm_o.readdata(30 downto 24) <= (others => '0');
					--    23-16 : State code			                    [R/-]
					avalon_mm_o.readdata(23 downto 16) <= mm_read_reg_i.status_register.state;
					--    15- 8 : Error code			                    [R/-]
					avalon_mm_o.readdata(15 downto 8)  <= mm_read_reg_i.status_register.error_code;
					--    7-  0 : Cycle number 			                    [R/-]
					avalon_mm_o.readdata(7 downto 0)   <= mm_read_reg_i.status_register.cycle_number;

				-- Interrupt enable register (32 bits):
				when (c_SYNC_INTERRUPT_MM_ENABLE_REG_ADDRESS) =>
					--    31-2 : Reserved                                  [-/-]
					avalon_mm_o.readdata(31 downto 2) <= (others => '0');
					--     1- 1 : Error interrupt enable bit                [R/W]
					avalon_mm_o.readdata(1)           <= mm_write_reg_i.int_enable_register.error_int_enable;
					--     0- 0 : Blank pulse interrupt enable bit          [R/W]
					avalon_mm_o.readdata(0)           <= mm_write_reg_i.int_enable_register.blank_pulse_int_enable;

				-- Interrupt flag clear register (32 bits):
				when (c_SYNC_INTERRUPT_MM_FLAG_CLEAR_REG_ADDRESS) =>
					--    31-2 : Reserved                                  [-/-]
					avalon_mm_o.readdata(31 downto 2) <= (others => '0');
					--     1- 1 : Error interrupt flag clear bit            [R/W]
					avalon_mm_o.readdata(1)           <= mm_write_reg_i.int_flag_clear_register.error_int_flag_clear;
					--     0- 0 : Blank pulse interrupt flag clear bit      [R/W]
					avalon_mm_o.readdata(0)           <= mm_write_reg_i.int_flag_clear_register.blank_pulse_int_flag_clear;

				-- Interrupt flag register (32 bits):
				when (c_SYNC_INTERRUPT_MM_FLAG_REG_ADDRESS) =>
					--    31-2 : Reserved                                  [-/-]
					avalon_mm_o.readdata(31 downto 2) <= (others => '0');
					--     1- 1 : Error interrupt flag bit		            [R/-]
					avalon_mm_o.readdata(1)           <= mm_read_reg_i.int_flag_register.error_int_flag;
					--     0- 0 : Blank pulse interrupt flag bit 		    [R/-]
					avalon_mm_o.readdata(0)           <= mm_read_reg_i.int_flag_register.blank_pulse_int_flag;

				-- Master blank time register (32 bits):
				when (c_SYNC_CONFIG_MASTER_BLANK_TIME_MM_REG_ADDRESS) =>
					--    31-0 : Master blank time value		            [R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.config_register.master_blank_time;

				-- Blank time register (32 bits):
				when (c_SYNC_CONFIG_BLANK_TIME_MM_REG_ADDRESS) =>
					--    31-0 : Blank time value		            		[R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.config_register.blank_time;

				-- Period register (32 bits):
				when (c_SYNC_CONFIG_PERIOD_MM_REG_ADDRESS) =>
					--    31-0 : Period value		            			[R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.config_register.period;

				-- One shot time register (32 bits):
				when (c_SYNC_CONFIG_ONE_SHOT_TIME_MM_REG_ADDRESS) =>
					--    31-0 : One shot time value	           			[R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.config_register.one_shot_time;

				-- General config register (32 bits):
				when (c_SYNC_CONFIG_GENERAL_MM_REG_ADDRESS) =>
					--    31- 9 : Reserved                                  [-/-]
					avalon_mm_o.readdata(31 downto 9) <= (others => '0');
					--     8- 8 : Signal polarity bit		                [R/W]
					avalon_mm_o.readdata(8)           <= mm_write_reg_i.config_register.general.signal_polarity;
					--     7- 0 : Number of cycles value           			[R/W]
					avalon_mm_o.readdata(7 downto 0)  <= mm_write_reg_i.config_register.general.number_of_cycles;

				-- Error injection register (32 bits):
				when (c_SYNC_ERROR_INJECTION_MM_REG_ADDRESS) =>
					--    31-0 : Error injection value	           			[R/W]
					avalon_mm_o.readdata(31 downto 0) <= mm_write_reg_i.error_injection_register.error_injection;

				-- Control register (32 bits):
				when (c_SYNC_CONTROL_MM_REG_ADDRESS) =>
					--    31-31 : Internal/External_n sync bit              [R/W]
					avalon_mm_o.readdata(31)           <= mm_write_reg_i.control_register.int_ext_n;
					--    30-20 : Reserved                                  [-/-]
					avalon_mm_o.readdata(30 downto 20) <= (others => '0');
					--    19-19 : Start bit		                			[R/W]
					avalon_mm_o.readdata(19)           <= mm_write_reg_i.control_register.start;
					--    18-18 : Reset bit		                			[R/W]
					avalon_mm_o.readdata(18)           <= mm_write_reg_i.control_register.reset;
					--    17-17 : One_shot bit		                		[R/W]
					avalon_mm_o.readdata(17)           <= mm_write_reg_i.control_register.one_shot;
					--    16-16 : Err_inj bit		                		[R/W]
					avalon_mm_o.readdata(16)           <= mm_write_reg_i.control_register.err_inj;
					--    15- 9 : Reserved                                  [-/-]
					avalon_mm_o.readdata(15 downto 9)  <= (others => '0');
					--     8- 8 : sync out enable bit               		[R/W]
					avalon_mm_o.readdata(8)            <= mm_write_reg_i.control_register.out_enable;
					--     7- 7 : channel H out enable bit               	[R/W]
					avalon_mm_o.readdata(7)            <= mm_write_reg_i.control_register.channel_h_enable;
					--     6- 6 : channel G out enable bit               	[R/W]
					avalon_mm_o.readdata(6)            <= mm_write_reg_i.control_register.channel_g_enable;
					--     5- 5 : channel F out enable bit               	[R/W]
					avalon_mm_o.readdata(5)            <= mm_write_reg_i.control_register.channel_f_enable;
					--     4- 4 : channel E out enable bit               	[R/W]
					avalon_mm_o.readdata(4)            <= mm_write_reg_i.control_register.channel_e_enable;
					--     3- 3 : channel D out enable bit               	[R/W]
					avalon_mm_o.readdata(3)            <= mm_write_reg_i.control_register.channel_d_enable;
					--     2- 2 : channel C out enable bit               	[R/W]
					avalon_mm_o.readdata(2)            <= mm_write_reg_i.control_register.channel_c_enable;
					--     1- 1 : channel B out enable bit               	[R/W]
					avalon_mm_o.readdata(1)            <= mm_write_reg_i.control_register.channel_b_enable;
					--     0- 0 : channel A out enable bit               	[R/W]
					avalon_mm_o.readdata(0)            <= mm_write_reg_i.control_register.channel_a_enable;

				when (c_SYNC_IRQ_FLAG) =>
					avalon_mm_o.readdata(31 downto 1) <= (others => '0');
					avalon_mm_o.readdata(0)           <= sync_irq_flag_i;

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
				v_mm_read_address       := to_integer(unsigned(avalon_mm_i.address));
				p_mm_readdata(v_mm_read_address);
			end if;
		end if;
	end process p_sync_avalon_mm_read;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
