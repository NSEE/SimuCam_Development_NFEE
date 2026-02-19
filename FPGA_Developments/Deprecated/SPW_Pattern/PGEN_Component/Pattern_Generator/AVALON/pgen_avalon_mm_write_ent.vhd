library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_mm_pkg.all;
use work.pgen_mm_registers_pkg.all;

entity pgen_avalon_mm_write_ent is
	port(
		clk_i                     : in  std_logic;
		rst_i                     : in  std_logic;
		avalon_mm_write_inputs_i  : in  t_pgen_avalon_mm_write_inputs;
		mm_write_registers_o      : out t_pgen_mm_write_registers;
		avalon_mm_write_outputs_o : out t_pgen_avalon_mm_write_outputs
	);
end entity pgen_avalon_mm_write_ent;

architecture rtl of pgen_avalon_mm_write_ent is

begin

	p_pgen_avalon_mm_write : process(clk_i, rst_i) is
		procedure p_mm_reset_registers is
		begin
			mm_write_registers_o.generator_control_register.start_bit <= '0';
			mm_write_registers_o.generator_control_register.stop_bit  <= '0';
			mm_write_registers_o.generator_control_register.reset_bit <= '0';
			mm_write_registers_o.pattern_size.rows_quantity           <= (others => '0');
			mm_write_registers_o.pattern_size.columns_quantity        <= (others => '0');
			mm_write_registers_o.pattern_parameters.ccd_side          <= '0';
			mm_write_registers_o.pattern_parameters.ccd_number        <= (others => '0');
			mm_write_registers_o.pattern_parameters.timecode          <= (others => '0');
		end procedure p_mm_reset_registers;

		procedure p_mm_control_triggers is
		begin
			mm_write_registers_o.generator_control_register.start_bit <= '0';
			mm_write_registers_o.generator_control_register.stop_bit  <= '0';
			mm_write_registers_o.generator_control_register.reset_bit <= '0';
		end procedure p_mm_control_triggers;

		procedure p_mm_writedata(mm_write_address_i : t_pgen_avalon_mm_address) is
		begin
			-- Registers Write Data
			case (mm_write_address_i) is
				-- Case for access to all registers address

				-- Generator Control and Status Register         (32 bits):
				when (c_PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS + c_PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31- 5 : Reserved                              [-/-]
					--    4- 4 : Start control bit                     [R/W]
					mm_write_registers_o.generator_control_register.start_bit <= avalon_mm_write_inputs_i.writedata(4);
					--    3- 3 : Stop control bit                      [R/W]
					mm_write_registers_o.generator_control_register.stop_bit  <= avalon_mm_write_inputs_i.writedata(3);
					--    2- 2 : Reset control bit                     [R/W]
					mm_write_registers_o.generator_control_register.reset_bit <= avalon_mm_write_inputs_i.writedata(2);
				--    1- 1 : Reseted status bit                    [R/-]
				--    0- 0 : Stopped status bit                    [R/-]

				-- Pattern Size Register                         (32 bits):
				when (c_PGEN_PATTERN_SIZE_MM_REG_ADDRESS + c_PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-16 : Rows Quantity value                   [R/W]
					mm_write_registers_o.pattern_size.rows_quantity    <= avalon_mm_write_inputs_i.writedata(31 downto 16);
					--   15- 0 : Columns Quantity value                [R/W]
					mm_write_registers_o.pattern_size.columns_quantity <= avalon_mm_write_inputs_i.writedata(15 downto 0);

				-- Pattern Parameters Register                   (32 bits):
				when (c_PGEN_PATTERN_PARAMETERS_MM_REG_ADDRESS + c_PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-11 : Reserved                              [-/-]
					--   10-10 : CCD Side value                        [R/W]
					mm_write_registers_o.pattern_parameters.ccd_side   <= avalon_mm_write_inputs_i.writedata(10);
					--    9- 8 : CCD Number value                      [R/W]
					mm_write_registers_o.pattern_parameters.ccd_number <= avalon_mm_write_inputs_i.writedata(9 downto 8);
					--    7- 0 : TimeCode value                        [R/W]
					mm_write_registers_o.pattern_parameters.timecode   <= avalon_mm_write_inputs_i.writedata(7 downto 0);

				when others =>
					null;
			end case;
		end procedure p_mm_writedata;

		variable v_mm_write_address : t_pgen_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_write_outputs_o.waitrequest <= '1';
			v_mm_write_address                    := 0;
			p_mm_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_write_outputs_o.waitrequest <= '1';
			p_mm_control_triggers;
			if (avalon_mm_write_inputs_i.write = '1') then
				avalon_mm_write_outputs_o.waitrequest <= '0';
				v_mm_write_address                    := to_integer(unsigned(avalon_mm_write_inputs_i.address));
				p_mm_writedata(v_mm_write_address);
			end if;
		end if;
	end process p_pgen_avalon_mm_write;

end architecture rtl;
