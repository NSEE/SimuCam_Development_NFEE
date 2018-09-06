library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avalon_mm_pkg.all;
use work.comm_mm_registers_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.tran_mm_registers_pkg.all;

entity comm_avalon_mm_read_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  comm_avalon_mm_read_inputs_type;
		avalon_mm_outputs  : out comm_avalon_mm_read_outputs_type;
		mm_write_registers : in  comm_mm_write_registers_type;
		mm_read_registers  : in  comm_mm_read_registers_type
	);
end entity comm_avalon_mm_read_ent;

architecture comm_avalon_mm_read_arc of comm_avalon_mm_read_ent is

begin

	comm_avalon_mm_read_proc : process(clk, rst) is
		procedure mm_readdata_procedure(mm_read_address : comm_avalon_mm_address_type) is
		begin
			-- Registers Data Read
			case (mm_read_address) is
				-- Case for access to all registers address

				-- SPWC Module ReadData procedure

				--  Interface Control and Status Register          (32 bits):
				when (SPWC_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-13 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 13) <= (others => '0');
					--    12-12 : Backdoor Mode control bit              [R/W]
					avalon_mm_outputs.readdata(12)           <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT;
					--    11-11 : External Loopback Mode control bit     [R/W]
					avalon_mm_outputs.readdata(11)           <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT;
					--    10-10 : Codec Enable control bit               [R/W]
					avalon_mm_outputs.readdata(10)           <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
					--     9- 9 : Codec RX Enable control bit            [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT;
					--     8- 8 : Codec TX Enable control bit            [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT;
					--     7- 7 : Loopback Mode control bit              [R/W]
					avalon_mm_outputs.readdata(7)            <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT;
					--     6- 6 : Codec Force Reset control bit          [R/W]
					avalon_mm_outputs.readdata(6)            <= mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT;
					--     5- 5 : Link Error interrupt enable bit        [R/W]
					avalon_mm_outputs.readdata(5)            <= mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_ERROR;
					--     4- 4 : TimeCode Received interrupt enable bit [R/W]
					avalon_mm_outputs.readdata(4)            <= mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED;
					--     3- 3 : Link Running interrupt enable bit      [R/W]
					avalon_mm_outputs.readdata(3)            <= mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING;
					--     2- 2 : Link Error interrupt flag              [R/-]
					avalon_mm_outputs.readdata(2)            <= mm_read_registers.SPWC.INTERRUPT_FLAG_REGISTER.LINK_ERROR;
					--     2- 2 : Link Error interrupt flag clear        [-/W]
					--     1- 1 : TimeCode Received interrupt flag       [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.SPWC.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED;
					--     0- 0 : Link Running interrupt flag            [R/-]
					--     1- 1 : TimeCode Received interrupt flag clear [-/W]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.SPWC.INTERRUPT_FLAG_REGISTER.LINK_RUNNING;
				--     0- 0 : Link Running interrupt flag clear      [-/W]

				--  SpW Link Control and Status Register           (32 bits):
				when (SPWC_SPW_LINK_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-18 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 18) <= (others => '0');
					--    17-10 : TX Clock Divisor value                 [R/W]
					avalon_mm_outputs.readdata(17 downto 10) <= mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV;
					--     9- 9 : Autostart control bit                  [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT;
					--     8- 8 : Link Start control bit                 [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.LINK_START_BIT;
					--     7- 7 : Link Disconnect control bit            [R/W]
					avalon_mm_outputs.readdata(7)            <= mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT;
					--     6- 6 : Link Disconnect error bit              [R/-]
					avalon_mm_outputs.readdata(6)            <= mm_read_registers.SPWC.SPW_LINK_ERROR_REGISTER.DISCONNECT_ERROR_BIT;
					--     5- 5 : Link Parity error bit                  [R/-]
					avalon_mm_outputs.readdata(5)            <= mm_read_registers.SPWC.SPW_LINK_ERROR_REGISTER.PARITY_ERROR_BIT;
					--     4- 4 : Link Escape error bit                  [R/-]
					avalon_mm_outputs.readdata(4)            <= mm_read_registers.SPWC.SPW_LINK_ERROR_REGISTER.ESCAPE_ERROR_BIT;
					--     3- 3 : Link Credit error bit                  [R/-]
					avalon_mm_outputs.readdata(3)            <= mm_read_registers.SPWC.SPW_LINK_ERROR_REGISTER.CREDIT_ERROR_BIT;
					--     2- 2 : Link Started status bit                [R/-]
					avalon_mm_outputs.readdata(2)            <= mm_read_registers.SPWC.SPW_LINK_STATUS_REGISTER.STARTED;
					--     1- 1 : Link Connecting status bit             [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.SPWC.SPW_LINK_STATUS_REGISTER.CONNECTING;
					--     0- 0 : Link Running status bit                [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.SPWC.SPW_LINK_STATUS_REGISTER.RUNNING;

				--  Timecode Control Register                      (32 bits):
				when (SPWC_TIMECODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-25 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 25) <= (others => '0');
					--    24-23 : RX TimeCode Control bits               [R/W]
					avalon_mm_outputs.readdata(24 downto 23) <= mm_read_registers.SPWC.RX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--    22-17 : RX TimeCode Counter value              [R/W]
					avalon_mm_outputs.readdata(22 downto 17) <= mm_read_registers.SPWC.RX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--    16-16 : RX TimeCode status bit                 [R/W]
					avalon_mm_outputs.readdata(16)           <= mm_read_registers.SPWC.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;
					--    16-16 : RX TimeCode status bit clear           [-/W]
					--    15- 9 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(15 downto 9)  <= (others => '0');
					--     8- 7 : TX TimeCode Control bits               [R/-]
					avalon_mm_outputs.readdata(8 downto 7)   <= mm_write_registers.SPWC.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--     6- 1 : TX TimeCode Counter value              [R/-]
					avalon_mm_outputs.readdata(6 downto 1)   <= mm_write_registers.SPWC.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--     0- 0 : TX TimeCode control bit                [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_write_registers.SPWC.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;

				--  Backdoor Mode Control Register                 (32 bits):
				when (SPWC_BACKDOOR_MODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-27 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 27) <= (others => '0');
					--    26-26 : RX Codec RX DataValid status bit       [R/-]
					avalon_mm_outputs.readdata(26)           <= mm_read_registers.SPWC.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY;
					--    25-25 : RX Codec RX Read control bit           [R/W]
					avalon_mm_outputs.readdata(25)           <= mm_write_registers.SPWC.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE;
					--    24-24 : RX Codec SpaceWire Flag value          [R/-]
					avalon_mm_outputs.readdata(24)           <= mm_read_registers.SPWC.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG;
					--    23-16 : RX Codec SpaceWire Data value          [R/-]
					avalon_mm_outputs.readdata(23 downto 16) <= mm_read_registers.SPWC.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA;
					--    15-11 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(15 downto 11) <= (others => '0');
					--    10-10 : TX Codec TX Ready status bit           [R/-]
					avalon_mm_outputs.readdata(10)           <= mm_read_registers.SPWC.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY;
					--     9- 9 : TX Codec TX Write control bit          [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.SPWC.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE;
					--     8- 8 : TX Codec SpaceWire Flag value          [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG;
					--     7- 0 : TX Codec SpaceWire Data value          [R/W]
					avalon_mm_outputs.readdata(7 downto 0)   <= mm_write_registers.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA;

				-- TRAN Module ReadData procedure

				--  Interface Control and Status Register        (32 bits):
				when (TRAN_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_outputs.readdata(31 downto 11) <= (others => '0');
					--    10-10 : Interface Enable control bit         [R/W]
					avalon_mm_outputs.readdata(10)           <= mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT;
					--     9- 9 : Interface RX Enable control bit      [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT;
					--     8- 8 : Interface TX Enable control bit      [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT;
					--     7- 7 : Interface Error interrupt enable bit [R/W]
					avalon_mm_outputs.readdata(7)            <= mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR;
					--     6- 6 : Data Received interrupt enable bit   [R/W]
					avalon_mm_outputs.readdata(6)            <= mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED;
					--     5- 5 : RX FIFO Full interrupt enable bit    [R/W]
					avalon_mm_outputs.readdata(5)            <= mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL;
					--     4- 4 : TX FIFO Empty interrupt enable bit   [R/W]
					avalon_mm_outputs.readdata(4)            <= mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY;
					--     3- 3 : Interface Error interrupt flag       [R/-]
					avalon_mm_outputs.readdata(3)            <= mm_read_registers.TRAN.INTERRUPT_FLAG_REGISTER.INTERFACE_ERROR;
					--     3- 3 : Interface Error interrupt flag       [-/W]
					--     2- 2 : Data Received interrupt flag         [R/-]
					avalon_mm_outputs.readdata(2)            <= mm_read_registers.TRAN.INTERRUPT_FLAG_REGISTER.DATA_RECEIVED;
					--     2- 2 : Data Received interrupt flag clear   [-/W]
					--     1- 1 : RX FIFO Full interrupt flag          [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.TRAN.INTERRUPT_FLAG_REGISTER.RX_FIFO_FULL;
					--     1- 1 : RX FIFO Full interrupt flag clear    [-/W]
					--     0- 0 : TX FIFO Empty interrupt flag         [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.TRAN.INTERRUPT_FLAG_REGISTER.TX_FIFO_EMPTY;
				--     0- 0 : TX FIFO Empty interrupt flag clear   [-/W]

				--  RX Mode Control Register                     (32 bits):
				when (TRAN_RX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_outputs.readdata(31 downto 11) <= (others => '0');
					--    10- 3 : RX FIFO Used Space value             [R/-]
					avalon_mm_outputs.readdata(10 downto 3)  <= mm_read_registers.TRAN.RX_FIFO_STATUS_REGISTER.FIFO_USED_SPACE;
					--     2- 2 : RX FIFO Reset control bit            [R/W]
					avalon_mm_outputs.readdata(2)            <= mm_write_registers.TRAN.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT;
					--     1- 1 : RX FIFO Empty status bit             [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.TRAN.RX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT;
					--     0- 0 : RX FIFO Full status bit              [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.TRAN.RX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT;

				--  TX Mode Control Register                     (32 bits):
				when (TRAN_TX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_outputs.readdata(31 downto 11) <= (others => '0');
					--    10- 3 : TX FIFO Used Space value             [R/-]
					avalon_mm_outputs.readdata(10 downto 3)  <= mm_read_registers.TRAN.TX_FIFO_STATUS_REGISTER.FIFO_USED_SPACE;
					--     2- 2 : TX FIFO Reset control bit            [R/W]
					avalon_mm_outputs.readdata(2)            <= mm_write_registers.TRAN.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT;
					--     1- 1 : TX FIFO Empty status bit             [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.TRAN.TX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT;
					--     0- 0 : TX FIFO Full status bit              [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.TRAN.TX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT;

				when others =>
					avalon_mm_outputs.readdata <= (others => '0');
			end case;
		end procedure mm_readdata_procedure;

		variable mm_read_address : comm_avalon_mm_address_type := 0;
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
	end process comm_avalon_mm_read_proc;

end architecture comm_avalon_mm_read_arc;
