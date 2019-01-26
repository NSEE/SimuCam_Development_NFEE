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
		clk_i              : in  std_logic;
		rst_i              : in  std_logic;
		avalon_mm_i        : in  t_sync_avalon_mm_write_i;
		avalon_mm_o        : out t_sync_avalon_mm_write_o;
		mm_write_reg_o     : out t_sync_mm_write_registers;
		sync_irq_trigger_o : out std_logic
	);
end entity sync_avalon_mm_write;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_avalon_mm_write is

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	-- Signals not used by ip logic. Initial levels made here, to suppress IDE "using don´t care ('x') value" 
	mm_write_reg_o.int_enable_register.error_int_flag_clear       <= '0';
	mm_write_reg_o.int_enable_register.blank_pulse_int_flag_clear <= '0';
	mm_write_reg_o.int_enable_register.error_int_flag             <= '0';
	mm_write_reg_o.int_enable_register.blank_pulse_int_flag       <= '0';
	mm_write_reg_o.int_flag_clear_register.error_int_enable       <= '0';
	mm_write_reg_o.int_flag_clear_register.blank_pulse_int_enable <= '0';
	mm_write_reg_o.int_flag_clear_register.error_int_flag         <= '0';
	mm_write_reg_o.int_flag_clear_register.blank_pulse_int_flag   <= '0';

	p_sync_avalon_mm_write : process(clk_i, rst_i) is
		-- Sync registers reset procedure
		procedure p_mm_reset_registers is
		begin
			mm_write_reg_o.int_enable_register.error_int_enable       <= '0';
			mm_write_reg_o.int_enable_register.blank_pulse_int_enable <= '0';

			mm_write_reg_o.int_flag_clear_register.error_int_flag_clear       <= '0';
			mm_write_reg_o.int_flag_clear_register.blank_pulse_int_flag_clear <= '0';

			mm_write_reg_o.config_register.master_blank_time        <= (others => '0');
			mm_write_reg_o.config_register.blank_time               <= (others => '0');
			mm_write_reg_o.config_register.period                   <= (others => '0');
			mm_write_reg_o.config_register.one_shot_time            <= (others => '0');
			mm_write_reg_o.config_register.general.signal_polarity  <= not g_SYNC_DEFAULT_STBY_POLARITY;
			mm_write_reg_o.config_register.general.number_of_cycles <= (others => '0');

			mm_write_reg_o.error_injection_register.error_injection <= (others => '0');

			mm_write_reg_o.control_register.int_ext_n <= '0';
			mm_write_reg_o.control_register.start     <= '0';
			mm_write_reg_o.control_register.reset     <= '0';
			mm_write_reg_o.control_register.one_shot  <= '0';
			mm_write_reg_o.control_register.err_inj   <= '0';

			mm_write_reg_o.control_register.out_enable       <= '0';
			mm_write_reg_o.control_register.channel_h_enable <= '0';
			mm_write_reg_o.control_register.channel_g_enable <= '0';
			mm_write_reg_o.control_register.channel_f_enable <= '0';
			mm_write_reg_o.control_register.channel_e_enable <= '0';
			mm_write_reg_o.control_register.channel_d_enable <= '0';
			mm_write_reg_o.control_register.channel_c_enable <= '0';
			mm_write_reg_o.control_register.channel_b_enable <= '0';
			mm_write_reg_o.control_register.channel_a_enable <= '0';

			--TODO: organizar
			sync_irq_trigger_o <= '0';
		end procedure p_mm_reset_registers;

		-- Sync control triggers reset procedure
		procedure p_mm_control_triggers is
		begin
			mm_write_reg_o.control_register.start    <= '0';
			mm_write_reg_o.control_register.reset    <= '0';
			mm_write_reg_o.control_register.one_shot <= '0';
			mm_write_reg_o.control_register.err_inj  <= '0';
			--TODO: organizar
			sync_irq_trigger_o                       <= '0';
		end procedure p_mm_control_triggers;

		-- Sync writedata procedure
		procedure p_mm_writedata(mm_write_address_i : t_sync_avalon_mm_address) is
		begin
			case (mm_write_address_i) is
				-- Interrupt enable register (32 bits):
				when (c_SYNC_INTERRUPT_MM_ENABLE_REG_ADDRESS) =>
					--    31- 2 : Reserved	                                [-/-]
					--     1- 1 : Error interrupt enable bit                [R/W]
					mm_write_reg_o.int_enable_register.error_int_enable       <= avalon_mm_i.writedata(1);
					--     0- 0 : Blank pulse interrupt enable bit          [R/W]
					mm_write_reg_o.int_enable_register.blank_pulse_int_enable <= avalon_mm_i.writedata(0);

				-- Interrupt flag clear register (32 bits):
				when (c_SYNC_INTERRUPT_MM_FLAG_CLEAR_REG_ADDRESS) =>
					--    31- 2 : Reserved	                                [-/-]
					--     1- 1 : Error interrupt flag clear bit            [R/W]
					mm_write_reg_o.int_flag_clear_register.error_int_flag_clear       <= avalon_mm_i.writedata(1);
					--     0- 0 : Blank pulse interrupt flag clear bit      [R/W]
					mm_write_reg_o.int_flag_clear_register.blank_pulse_int_flag_clear <= avalon_mm_i.writedata(0);

				-- Master blank time register (32 bits):
				when (c_SYNC_CONFIG_MASTER_BLANK_TIME_MM_REG_ADDRESS) =>
					--    31-0 : Master blank time value		            [R/W]
					mm_write_reg_o.config_register.master_blank_time <= avalon_mm_i.writedata(31 downto 0);

				--  Blank time register (32 bits):
				when (c_SYNC_CONFIG_BLANK_TIME_MM_REG_ADDRESS) =>
					--    31-0 : Blank time value		            		[R/W]
					mm_write_reg_o.config_register.blank_time <= avalon_mm_i.writedata(31 downto 0);

				--  Period register (32 bits):
				when (c_SYNC_CONFIG_PERIOD_MM_REG_ADDRESS) =>
					--    31-0 : Period value		            			[R/W]
					mm_write_reg_o.config_register.period <= avalon_mm_i.writedata(31 downto 0);

				--  One shot time register (32 bits):
				when (c_SYNC_CONFIG_ONE_SHOT_TIME_MM_REG_ADDRESS) =>
					--    31-0 : One shot time value	           			[R/W]
					mm_write_reg_o.config_register.one_shot_time <= avalon_mm_i.writedata(31 downto 0);

				--  General config register (32 bits):
				when (c_SYNC_CONFIG_GENERAL_MM_REG_ADDRESS) =>
					--    31- 9 : Reserved                                  [-/-]
					--     8- 8 : Signal polarity bit		                [R/W]
					mm_write_reg_o.config_register.general.signal_polarity  <= avalon_mm_i.writedata(8);
					--     7- 0 : Number of cycles value           			[R/W]
					mm_write_reg_o.config_register.general.number_of_cycles <= avalon_mm_i.writedata(7 downto 0);

				--  Error injection register (32 bits):
				when (c_SYNC_ERROR_INJECTION_MM_REG_ADDRESS) =>
					--    31-0 : Error injection value	           			[R/W]
					mm_write_reg_o.error_injection_register.error_injection <= avalon_mm_i.writedata(31 downto 0);

				--  Control register (32 bits):
				when (c_SYNC_CONTROL_MM_REG_ADDRESS) =>
					--    31-31 : Internal/External_n sync bit              [R/W]
					mm_write_reg_o.control_register.int_ext_n        <= avalon_mm_i.writedata(31);
					--    30-20 : Reserved                                  [-/-]
					--    19-19 : Start bit		                			[R/W]
					mm_write_reg_o.control_register.start            <= avalon_mm_i.writedata(19);
					--    18-18 : Reset bit		                			[R/W]
					mm_write_reg_o.control_register.reset            <= avalon_mm_i.writedata(18);
					--    17-17 : One_shot bit		                		[R/W]
					mm_write_reg_o.control_register.one_shot         <= avalon_mm_i.writedata(17);
					--    16-16 : Err_inj bit		                		[R/W]
					mm_write_reg_o.control_register.err_inj          <= avalon_mm_i.writedata(16);
					--    15- 9 : Reserved                                  [-/-]
					--     8- 8 : sync out enable bit               		[R/W]
					mm_write_reg_o.control_register.out_enable       <= avalon_mm_i.writedata(8);
					--     7- 7 : channel H out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_h_enable <= avalon_mm_i.writedata(7);
					--     6- 6 : channel G out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_g_enable <= avalon_mm_i.writedata(6);
					--     5- 5 : channel F out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_f_enable <= avalon_mm_i.writedata(5);
					--     4- 4 : channel E out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_e_enable <= avalon_mm_i.writedata(4);
					--     3- 3 : channel D out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_d_enable <= avalon_mm_i.writedata(3);
					--     2- 2 : channel C out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_c_enable <= avalon_mm_i.writedata(2);
					--     1- 1 : channel B out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_b_enable <= avalon_mm_i.writedata(1);
					--     0- 0 : channel A out enable bit               	[R/W]
					mm_write_reg_o.control_register.channel_a_enable <= avalon_mm_i.writedata(0);

				-- TODO: organizar
				when (c_SYNC_IRQ_FLAG_CLEAR) =>
					sync_irq_trigger_o <= avalon_mm_i.writedata(0);

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

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
