library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_avalon_mm_pkg.all;
use work.tran_mm_registers_pkg.all;

entity tran_avalon_mm_read_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  tran_avalon_mm_read_inputs_type;
		avalon_mm_outputs  : out tran_avalon_mm_read_outputs_type;
		mm_write_registers : in  tran_mm_write_registers_type;
		mm_read_registers  : in  tran_mm_read_registers_type
	);
end entity tran_avalon_mm_read_ent;

architecture tran_avalon_mm_read_arc of tran_avalon_mm_read_ent is

begin

	tran_avalon_mm_read_proc : process(clk, rst) is
		procedure mm_readdata_procedure(mm_read_address : tran_avalon_mm_address_type) is
		begin
			-- Registers Data Read
			case (mm_read_address) is
				-- Case for access to all registers address

				--  Interface Control and Status Register        (32 bits):
				when (TRAN_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_outputs.readdata(31 downto 11) <= (others => '0');
					--    10-10 : Interface Enable control bit         [R/W]
					avalon_mm_outputs.readdata(10)           <= mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT;
					--     9- 9 : Interface RX Enable control bit      [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT;
					--     8- 8 : Interface TX Enable control bit      [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT;
					--     7- 7 : Interface Error interrupt enable bit [R/W]
					avalon_mm_outputs.readdata(7)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR;
					--     6- 6 : Data Received interrupt enable bit   [R/W]
					avalon_mm_outputs.readdata(6)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED;
					--     5- 5 : RX FIFO Full interrupt enable bit    [R/W]
					avalon_mm_outputs.readdata(5)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL;
					--     4- 4 : TX FIFO Empty interrupt enable bit   [R/W]
					avalon_mm_outputs.readdata(4)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY;
					--     3- 3 : Interface Error interrupt flag       [R/-]
					avalon_mm_outputs.readdata(3)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.INTERFACE_ERROR;
					--     2- 2 : Data Received interrupt flag         [R/-]
					avalon_mm_outputs.readdata(2)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.DATA_RECEIVED;
					--     1- 1 : RX FIFO Full interrupt flag          [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.RX_FIFO_FULL;
					--     0- 0 : TX FIFO Empty interrupt flag         [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.TX_FIFO_EMPTY;

					--  RX Mode Control Register                     (32 bits):
				when (TRAN_RX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31- 3 : Reserved                             [-/-]
					avalon_mm_outputs.readdata(31 downto 3) <= (others => '0');
					--     2- 2 : RX FIFO Reset control bit            [R/W]
					avalon_mm_outputs.readdata(2)           <= mm_write_registers.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT;
					--     1- 1 : RX FIFO Empty status bit             [R/-]
					avalon_mm_outputs.readdata(1)           <= mm_read_registers.RX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT;
					--     0- 0 : RX FIFO Full status bit              [R/-]
					avalon_mm_outputs.readdata(0)           <= mm_read_registers.RX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT;

					--  TX Mode Control Register                     (32 bits):
				when (TRAN_TX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31- 3 : Reserved                             [-/-]
					avalon_mm_outputs.readdata(31 downto 3) <= (others => '0');
					--     2- 2 : TX FIFO Reset control bit            [R/W]
					avalon_mm_outputs.readdata(2)           <= mm_write_registers.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT;
					--     1- 1 : TX FIFO Empty status bit             [R/-]
					avalon_mm_outputs.readdata(1)           <= mm_read_registers.TX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT;
					--     0- 0 : TX FIFO Full status bit              [R/-]
					avalon_mm_outputs.readdata(0)           <= mm_read_registers.TX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT;

				when others =>
					avalon_mm_outputs.readdata <= (others => '0');
			end case;
		end procedure mm_readdata_procedure;

		variable mm_read_address : tran_avalon_mm_address_type := 0;
	begin
		if (rst = '1') then
			avalon_mm_outputs.readdata    <= (others => '0');
			avalon_mm_outputs.waitrequest <= '1';
			mm_read_address               := 0;
		elsif (rising_edge(clk)) then
			avalon_mm_outputs.readdata    <= (others => '0');
			avalon_mm_outputs.waitrequest <= '1';
			if (avalon_mm_inputs.read = '1') then
				avalon_mm_outputs.waitrequest <= '0';
				mm_read_address               := to_integer(unsigned(avalon_mm_inputs.address));
				mm_readdata_procedure(mm_read_address);
			end if;
		end if;
	end process tran_avalon_mm_read_proc;

end architecture tran_avalon_mm_read_arc;
