library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_avalon_mm_pkg.all;
use work.tran_mm_registers_pkg.all;

entity tran_avalon_mm_write_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  tran_avalon_mm_write_inputs_type;
		avalon_mm_outputs  : out tran_avalon_mm_write_outputs_type;
		mm_write_registers : out tran_mm_write_registers_type
	);
end entity tran_avalon_mm_write_ent;

architecture tran_avalon_mm_write_arc of tran_avalon_mm_write_ent is

begin

	tran_avalon_mm_write_proc : process(clk, rst) is
		procedure mm_reset_registers_procedure is
		begin
			mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT    <= '0';
			mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT <= '0';
			mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR          <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED            <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY            <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL             <= '0';
			mm_write_registers.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT            <= '0';
			mm_write_registers.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT            <= '0';
		end procedure mm_reset_registers_procedure;

		procedure mm_control_triggers_procedure is
		begin
			mm_write_registers.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT <= '0';
			mm_write_registers.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT <= '0';
		end procedure mm_control_triggers_procedure;

		procedure mm_writedata_procedure(mm_write_address : tran_avalon_mm_address_type) is
		begin
			-- Registers Write Data
			case (mm_write_address) is
				-- Case for access to all registers address

				--  Interface Control and Status Register        (32 bits):
				when (TRAN_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					--    10-10 : Interface Enable control bit         [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT    <= avalon_mm_inputs.writedata(10);
					--     9- 9 : Interface RX Enable control bit      [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT <= avalon_mm_inputs.writedata(9);
					--     8- 8 : Interface TX Enable control bit      [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT <= avalon_mm_inputs.writedata(8);
					--     7- 7 : Interface Error interrupt enable bit [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR          <= avalon_mm_inputs.writedata(7);
					--     6- 6 : Data Received interrupt enable bit   [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED            <= avalon_mm_inputs.writedata(6);
					--     5- 5 : TX FIFO Empty interrupt enable bit   [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY            <= avalon_mm_inputs.writedata(5);
					--     4- 4 : RX FIFO Full interrupt enable bit    [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL             <= avalon_mm_inputs.writedata(4);
					--     3- 3 : Interface Error interrupt flag       [R/-]
					--     2- 2 : Data Received interrupt flag         [R/-]
					--     1- 1 : TX FIFO Empty interrupt flag         [R/-]
					--     0- 0 : RX FIFO Full interrupt flag          [R/-]

					--  RX Mode Control Register                     (32 bits):
				when (TRAN_RX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31- 3 : Reserved                             [-/-]
					--     2- 2 : RX FIFO Reset control bit            [R/W]
					mm_write_registers.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT <= avalon_mm_inputs.writedata(2);
					--     1- 1 : RX FIFO Empty status bit             [R/-]
					--     0- 0 : RX FIFO Full status bit              [R/-]

					--  TX Mode Control Register                     (32 bits):
				when (TRAN_TX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31- 3 : Reserved                             [-/-]
					--     2- 2 : TX FIFO Reset control bit            [R/W]
					mm_write_registers.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT <= avalon_mm_inputs.writedata(2);
					--     1- 1 : TX FIFO Empty status bit             [R/-]
					--     0- 0 : TX FIFO Full status bit              [R/-]

				when others =>
					null;
			end case;
		end procedure mm_writedata_procedure;

		variable mm_write_address : tran_avalon_mm_address_type := 0;
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
	end process tran_avalon_mm_write_proc;

end architecture tran_avalon_mm_write_arc;
