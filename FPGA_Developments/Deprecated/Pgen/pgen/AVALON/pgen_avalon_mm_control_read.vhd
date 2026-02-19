library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_mm_control_pkg.all;
use work.pgen_mm_control_registers_pkg.all;

entity pgen_avalon_mm_control_read is
	port(
		clk_i                    : in  std_logic;
		rst_i                    : in  std_logic;
		mm_read_registers_i      : in  t_pgen_mm_control_read_registers;
		mm_write_registers_i     : in  t_pgen_mm_control_write_registers;
		avalon_mm_read_inputs_i  : in  t_pgen_avalon_mm_control_read_inputs;
		avalon_mm_read_outputs_o : out t_pgen_avalon_mm_control_read_outputs
	);
end entity pgen_avalon_mm_control_read;

architecture rtl of pgen_avalon_mm_control_read is

begin
	p_pgen_avalon_mm_control_read : process(clk_i, rst_i) is
		procedure p_mm_readdata(mm_read_address_i : t_pgen_avalon_mm_control_address) is
		begin
			-- Registers Data Read
			case (mm_read_address_i) is
				-- Case for access to all registers address

				-- Generator Control and Status Register         (32 bits):
				when (c_PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS + c_PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31- 5 : Reserved                              [-/-]
					avalon_mm_read_outputs_o.readdata(31 downto 5) <= (others => '0');
					--    4- 4 : Start control bit                     [R/W]
					avalon_mm_read_outputs_o.readdata(4)           <= mm_write_registers_i.generator_control.start_bit;
					--    3- 3 : Stop control bit                      [R/W]
					avalon_mm_read_outputs_o.readdata(3)           <= mm_write_registers_i.generator_control.stop_bit;
					--    2- 2 : Reset control bit                     [R/W]
					avalon_mm_read_outputs_o.readdata(2)           <= mm_write_registers_i.generator_control.reset_bit;
					--    1- 1 : Reseted status bit                    [R/-]
					avalon_mm_read_outputs_o.readdata(1)           <= mm_read_registers_i.generator_status.reseted_bit;
					--    0- 0 : Stopped status bit                    [R/-]
					avalon_mm_read_outputs_o.readdata(0)           <= mm_read_registers_i.generator_status.stopped_bit;

				-- Pattern Size Register                         (32 bits):
				when (c_PGEN_PATTERN_SIZE_MM_REG_ADDRESS + c_PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-16 : Rows Quantity value                   [R/W]
					avalon_mm_read_outputs_o.readdata(31 downto 16) <= mm_write_registers_i.pattern_size.rows_quantity;
					--   15- 0 : Columns Quantity value                [R/W]
					avalon_mm_read_outputs_o.readdata(15 downto 0)  <= mm_write_registers_i.pattern_size.columns_quantity;

				-- Pattern Parameters Register                   (32 bits):
				when (c_PGEN_PATTERN_PARAMETERS_MM_REG_ADDRESS + c_PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-12 : Reserved                              [-/-]
					avalon_mm_read_outputs_o.readdata(31 downto 12) <= (others => '0');
					--   11-11 : Mask field bit                        [R/W]
					avalon_mm_read_outputs_o.readdata(11)           <= mm_write_registers_i.pattern_parameters.mask_field;
					--   10-10 : CCD Side value                        [R/W]
					avalon_mm_read_outputs_o.readdata(10)           <= mm_write_registers_i.pattern_parameters.ccd_side;
					--    9- 8 : CCD Number value                      [R/W]
					avalon_mm_read_outputs_o.readdata(9 downto 8)   <= mm_write_registers_i.pattern_parameters.ccd_number;
					--    7- 0 : TimeCode value                        [R/W]
					avalon_mm_read_outputs_o.readdata(7 downto 0)   <= mm_write_registers_i.pattern_parameters.timecode;

				when others =>
					avalon_mm_read_outputs_o.readdata <= (others => '0');
			end case;
		end procedure p_mm_readdata;

		variable v_mm_read_address : t_pgen_avalon_mm_control_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_read_outputs_o.readdata    <= (others => '0');
			avalon_mm_read_outputs_o.waitrequest <= '1';
			v_mm_read_address                    := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_read_outputs_o.waitrequest <= '1';
			if (avalon_mm_read_inputs_i.read = '1') then
				avalon_mm_read_outputs_o.waitrequest <= '0';
				v_mm_read_address                    := to_integer(unsigned(avalon_mm_read_inputs_i.address));
				p_mm_readdata(v_mm_read_address);
			end if;
		end if;
	end process p_pgen_avalon_mm_control_read;

end architecture rtl;
