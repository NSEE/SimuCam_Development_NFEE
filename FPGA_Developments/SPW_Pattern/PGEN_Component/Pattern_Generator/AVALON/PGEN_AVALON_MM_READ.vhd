library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_mm_pkg.all;
use work.pgen_mm_registers_pkg.all;

entity pgen_avalon_mm_read_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  pgen_avalon_mm_read_inputs_type;
		avalon_mm_outputs  : out pgen_avalon_mm_read_outputs_type;
		mm_write_registers : in  pgen_mm_write_registers_type;
		mm_read_registers  : in  pgen_mm_read_registers_type
	);
end entity pgen_avalon_mm_read_ent;

architecture pgen_avalon_mm_read_arc of pgen_avalon_mm_read_ent is

begin

	pgen_avalon_mm_read_proc : process(clk, rst) is
		procedure mm_readdata_procedure(mm_read_address : pgen_avalon_mm_address_type) is
		begin
			-- Registers Data Read
			case (mm_read_address) is
				-- Case for access to all registers address

				-- Generator Control and Status Register (32 bits):
				when (PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS + PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31- 5 : Reserved                   [-]
					avalon_mm_outputs.readdata(31 downto 5) <= (others => '0');
					--    4- 4 : Start control bit          [R/W]
					avalon_mm_outputs.readdata(4)           <= mm_write_registers.GENERATOR_CONTROL_REGISTER.START_BIT;
					--    3- 3 : Stop control bit           [R/W]
					avalon_mm_outputs.readdata(3)           <= mm_write_registers.GENERATOR_CONTROL_REGISTER.STOP_BIT;
					--    2- 2 : Reset control bit          [R/W]
					avalon_mm_outputs.readdata(2)           <= mm_write_registers.GENERATOR_CONTROL_REGISTER.RESET_BIT;
					--    1- 1 : Reseted status bit         [R]
					avalon_mm_outputs.readdata(1)           <= mm_read_registers.GENERATOR_STATUS_REGISTER.RESETED_BIT;
					--    0- 0 : Stopped status bit         [R]
					avalon_mm_outputs.readdata(0)           <= mm_read_registers.GENERATOR_STATUS_REGISTER.STOPPED_BIT;

				-- Pattern Size Register                 (32 bits):
				when (PGEN_PATTERN_SIZE_MM_REG_ADDRESS + PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-16 : Lines Quantity             [R/W]
					avalon_mm_outputs.readdata(31 downto 16) <= mm_write_registers.PATTERN_SIZE.LINES_QUANTITY;
					--   15- 0 : Columns Quantity           [R/W]
					avalon_mm_outputs.readdata(15 downto 0)  <= mm_write_registers.PATTERN_SIZE.COLUMNS_QUANTITY;

				-- Pattern Parameters Register           (32 bits):
				when (PGEN_PATTERN_PARAMETERS_MM_REG_ADDRESS + PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-11 : Reserved                   [-]
					avalon_mm_outputs.readdata(31 downto 11) <= (others => '0');
					--   10-10 : CCD Side                   [R/W]
					avalon_mm_outputs.readdata(10)           <= mm_write_registers.PATTERN_PARAMETERS.CCD_SIDE;
					--    9- 8 : CCD Number                 [R/W]
					avalon_mm_outputs.readdata(9 downto 8)   <= mm_write_registers.PATTERN_PARAMETERS.CCD_NUMBER;
					--    7- 0 : TimeCode                   [R/W]
					avalon_mm_outputs.readdata(7 downto 0)   <= mm_write_registers.PATTERN_PARAMETERS.TIMECODE;

				when others =>
					avalon_mm_outputs.readdata <= (others => '0');
			end case;
		end procedure mm_readdata_procedure;

		variable mm_read_address : pgen_avalon_mm_address_type := 0;
	begin
		if (rst = '1') then
			avalon_mm_outputs.readdata    <= (others => '0');
			avalon_mm_outputs.waitrequest <= '1';
			mm_read_address               := 0;
		elsif (rising_edge(clk)) then
			avalon_mm_outputs.waitrequest <= '1';
			if (avalon_mm_inputs.read = '1') then
				avalon_mm_outputs.waitrequest <= '0';
				mm_read_address               := to_integer(unsigned(avalon_mm_inputs.address));
				mm_readdata_procedure(mm_read_address);
			end if;
		end if;
	end process pgen_avalon_mm_read_proc;

end architecture pgen_avalon_mm_read_arc;
