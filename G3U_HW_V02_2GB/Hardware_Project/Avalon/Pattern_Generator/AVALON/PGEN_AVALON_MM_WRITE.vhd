library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_mm_pkg.all;
use work.pgen_mm_registers_pkg.all;

entity pgen_avalon_mm_write_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  pgen_avalon_mm_write_inputs_type;
		avalon_mm_outputs  : out pgen_avalon_mm_write_outputs_type;
		mm_write_registers : out pgen_mm_write_registers_type
	);
end entity pgen_avalon_mm_write_ent;

architecture pgen_avalon_mm_write_arc of pgen_avalon_mm_write_ent is

begin

	pgen_avalon_mm_write_proc : process(clk, rst) is
		procedure mm_reset_registers_procedure is
		begin
			mm_write_registers.GENERATOR_CONTROL_REGISTER.START_BIT                 <= '0';
			mm_write_registers.GENERATOR_CONTROL_REGISTER.STOP_BIT                  <= '0';
			mm_write_registers.GENERATOR_CONTROL_REGISTER.RESET_BIT                 <= '0';
			mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_ID   <= (others => '0');
			mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_SIDE <= (others => '0');
			mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_TIMECODE <= (others => '0');
		end procedure mm_reset_registers_procedure;

		procedure mm_control_triggers_procedure is
		begin
			mm_write_registers.GENERATOR_CONTROL_REGISTER.START_BIT <= '0';
			mm_write_registers.GENERATOR_CONTROL_REGISTER.STOP_BIT  <= '0';
			mm_write_registers.GENERATOR_CONTROL_REGISTER.RESET_BIT <= '0';
		end procedure mm_control_triggers_procedure;

		procedure mm_writedata_procedure(mm_write_address : pgen_avalon_mm_address_type) is
		begin
			-- Registers Write Data
			case (mm_write_address) is
				-- Case for access to all registers address

				-- Generator Control and Status Register (32 bits):
				when (PGEN_GENERATOR_CONTROL_STATUS_MM_REG_ADDRESS + PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31- 5 : Reserved                   [-]
					--    4- 4 : Start control bit          [R/W]
					mm_write_registers.GENERATOR_CONTROL_REGISTER.START_BIT <= avalon_mm_inputs.writedata(4);
					--    3- 3 : Stop control bit           [R/W]
					mm_write_registers.GENERATOR_CONTROL_REGISTER.STOP_BIT  <= avalon_mm_inputs.writedata(3);
					--    2- 2 : Reset control bit          [R/W]
					mm_write_registers.GENERATOR_CONTROL_REGISTER.RESET_BIT <= avalon_mm_inputs.writedata(2);
					--    1- 1 : Reseted status bit         [R]
					--    0- 0 : Stopped status bit         [R]

					-- Initial Transmission State Register  (32 bits):
				when (PGEN_INITIAL_TRANSMISSION_STATE_MM_REG_ADDRESS + PGEN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--   31-11 : Reserved                   [-]
					--   10- 9 : Initial CCD ID             [R/W]
					mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_ID   <= avalon_mm_inputs.writedata(10 downto 9);
					--    8- 8 : Initial CCD Side           [R/W]
					mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_CCD_SIDE <= avalon_mm_inputs.writedata(8 downto 8);
					--    7- 0 : Initial TimeCode           [R/W]
					mm_write_registers.INITIAL_TRANSMISSION_STATE_REGISTER.INITIAL_TIMECODE <= avalon_mm_inputs.writedata(7 downto 0);

				when others =>
					null;
			end case;
		end procedure mm_writedata_procedure;

		variable mm_write_address : pgen_avalon_mm_address_type := 0;
	begin
		if (rst = '1') then
			avalon_mm_outputs.waitrequest <= '1';
			mm_write_address              := 0;
			mm_reset_registers_procedure;
		elsif (rising_edge(clk)) then
			avalon_mm_outputs.waitrequest <= '1';
			mm_control_triggers_procedure;
			if (avalon_mm_inputs.write = '1') then
				avalon_mm_outputs.waitrequest <= '0';
				mm_write_address              := to_integer(unsigned(avalon_mm_inputs.address));
				mm_writedata_procedure(mm_write_address);
			end if;
		end if;
	end process pgen_avalon_mm_write_proc;

end architecture pgen_avalon_mm_write_arc;
