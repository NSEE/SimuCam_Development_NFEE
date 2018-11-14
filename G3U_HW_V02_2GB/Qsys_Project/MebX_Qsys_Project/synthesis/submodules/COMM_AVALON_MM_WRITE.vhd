library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_avalon_mm_pkg.all;
use work.comm_mm_registers_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.tran_mm_registers_pkg.all;

entity comm_avalon_mm_write_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  comm_avalon_mm_write_inputs_type;
		avalon_mm_outputs  : out comm_avalon_mm_write_outputs_type;
		mm_write_registers : out comm_mm_write_registers_type
	);
end entity comm_avalon_mm_write_ent;

architecture comm_avalon_mm_write_arc of comm_avalon_mm_write_ent is

begin

	comm_avalon_mm_write_proc : process(clk, rst) is
		procedure mm_reset_registers_procedure is
		begin
			-- SPWC Module Reset procedure
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT           <= '0';
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT        <= '0';
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT        <= '0';
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT          <= '0';
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT <= '0';
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT          <= '0';
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT            <= '0';
			mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_ERROR                  <= '0';
			mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED           <= '0';
			mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING                <= '0';
			mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR              <= '0';
			mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED       <= '0';
			mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING            <= '0';
			mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT                  <= '0';
			mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.LINK_START_BIT                 <= '0';
			mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT            <= '0';
			mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV                   <= x"01";
			mm_write_registers.SPWC.RX_TIMECODE_CLEAR_REGISTER.CONTROL_STATUS_BIT         <= '0';
			mm_write_registers.SPWC.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS            <= (others => '0');
			mm_write_registers.SPWC.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE           <= (others => '0');
			mm_write_registers.SPWC.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT               <= '0';
			mm_write_registers.SPWC.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE         <= '0';
			mm_write_registers.SPWC.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE         <= '0';
			mm_write_registers.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG              <= '0';
			mm_write_registers.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA              <= (others => '0');

			-- TRAN Module Reset procedure
			mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT    <= '0';
			mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT <= '0';
			mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT <= '0';
			mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR          <= '0';
			mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED            <= '0';
			mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY            <= '0';
			mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL             <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.INTERFACE_ERROR      <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.DATA_RECEIVED        <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.TX_FIFO_EMPTY        <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.RX_FIFO_FULL         <= '0';
			mm_write_registers.TRAN.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT            <= '0';
			mm_write_registers.TRAN.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT            <= '0';

		end procedure mm_reset_registers_procedure;

		procedure mm_control_triggers_procedure is
		begin
			-- SPWC Module Control Triggers procedure
			mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT      <= '0';
			mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR        <= '0';
			mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED <= '0';
			mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING      <= '0';
			mm_write_registers.SPWC.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT         <= '0';
			mm_write_registers.SPWC.RX_TIMECODE_CLEAR_REGISTER.CONTROL_STATUS_BIT   <= '0';
			mm_write_registers.SPWC.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE   <= '0';
			mm_write_registers.SPWC.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE   <= '0';

			-- TRAN Module Control Triggers procedure
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.INTERFACE_ERROR <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.DATA_RECEIVED   <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.TX_FIFO_EMPTY   <= '0';
			mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.RX_FIFO_FULL    <= '0';
			mm_write_registers.TRAN.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT       <= '0';
			mm_write_registers.TRAN.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT       <= '0';

		end procedure mm_control_triggers_procedure;

		procedure mm_writedata_procedure(mm_write_address : comm_avalon_mm_address_type) is
		begin
			-- Registers Write Data
			case (mm_write_address) is
				-- Case for access to all registers address

				-- SPWC Module WriteData procedure

				--  Interface Control and Status Register          (32 bits):
				when (SPWC_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-13 : Reserved                               [-/-]
					--    12-12 : Backdoor Mode control bit              [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT          <= avalon_mm_inputs.writedata(12);
					--    11-11 : External Loopback Mode control bit     [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT <= avalon_mm_inputs.writedata(11);
					--    10-10 : Codec Enable control bit               [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT           <= avalon_mm_inputs.writedata(10);
					--     9- 9 : Codec RX Enable control bit            [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT        <= avalon_mm_inputs.writedata(9);
					--     8- 8 : Codec TX Enable control bit            [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT        <= avalon_mm_inputs.writedata(8);
					--     7- 7 : Loopback Mode control bit              [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT          <= avalon_mm_inputs.writedata(7);
					--     6- 6 : Codec Force Reset control bit          [R/W]
					mm_write_registers.SPWC.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT            <= avalon_mm_inputs.writedata(6);
					--     5- 5 : Link Error interrupt enable bit        [R/W]
					mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_ERROR                  <= avalon_mm_inputs.writedata(5);
					--     4- 4 : TimeCode Received interrupt enable bit [R/W]
					mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED           <= avalon_mm_inputs.writedata(4);
					--     3- 3 : Link Running interrupt enable bit      [R/W]
					mm_write_registers.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING                <= avalon_mm_inputs.writedata(3);
					--     2- 2 : Link Error interrupt flag              [R/-]
					--     2- 2 : Link Error interrupt flag clear        [-/W]
					mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR              <= avalon_mm_inputs.writedata(2);
					--     1- 1 : TimeCode Received interrupt flag       [R/-]
					--     1- 1 : TimeCode Received interrupt flag clear [-/W]
					mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED       <= avalon_mm_inputs.writedata(1);
					--     0- 0 : Link Running interrupt flag            [R/-]
					--     0- 0 : Link Running interrupt flag clear      [-/W]
					mm_write_registers.SPWC.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING            <= avalon_mm_inputs.writedata(0);

				--  SpW Link Control and Status Register           (32 bits):
				when (SPWC_SPW_LINK_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-18 : Reserved                               [-/-]
					--    17-10 : TX Clock Divisor value                 [R/W]
					mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV        <= avalon_mm_inputs.writedata(17 downto 10);
					--     9- 9 : Autostart control bit                  [R/W]
					mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT       <= avalon_mm_inputs.writedata(9);
					--     8- 8 : Link Start control bit                 [R/W]
					mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.LINK_START_BIT      <= avalon_mm_inputs.writedata(8);
					--     7- 7 : Link Disconnect control bit            [R/W]
					mm_write_registers.SPWC.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT <= avalon_mm_inputs.writedata(7);
				--     6- 6 : Link Disconnect error bit              [R/-]
				--     5- 5 : Link Parity error bit                  [R/-]
				--     4- 4 : Link Escape error bit                  [R/-]
				--     3- 3 : Link Credit error bit                  [R/-]
				--     2- 2 : Link Started status bit                [R/-]
				--     1- 1 : Link Connecting status bit             [R/-]
				--     0- 0 : Link Running status bit                [R/-]

				--  Timecode Control Register                      (32 bits):
				when (SPWC_TIMECODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-25 : Reserved                               [-/-]
					--    24-23 : RX TimeCode Control bits               [R/-]
					--    22-17 : RX TimeCode Counter value              [R/-]
					--    16-16 : RX TimeCode status bit                 [R/-]
					--    16-16 : RX TimeCode status bit clear           [-/W]
					mm_write_registers.SPWC.RX_TIMECODE_CLEAR_REGISTER.CONTROL_STATUS_BIT <= avalon_mm_inputs.writedata(16);
					--    15- 9 : Reserved                               [R/-]
					--     8- 7 : TX TimeCode Control bits               [R/W]
					mm_write_registers.SPWC.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS    <= avalon_mm_inputs.writedata(8 downto 7);
					--     6- 1 : TX TimeCode Counter value              [R/W]
					mm_write_registers.SPWC.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE   <= avalon_mm_inputs.writedata(6 downto 1);
					--     0- 0 : TX TimeCode control bit                [R/W]
					mm_write_registers.SPWC.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT       <= avalon_mm_inputs.writedata(0);

				--  Backdoor Mode Control Register                 (32 bits):
				when (SPWC_BACKDOOR_MODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-27 : Reserved                               [-/-]
					--    26-26 : RX Codec RX DataValid status bit       [R/-]
					--    25-25 : RX Codec RX Read control bit           [R/W]
					mm_write_registers.SPWC.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= avalon_mm_inputs.writedata(25);
					--    24-24 : RX Codec SpaceWire Flag value          [R/-]
					--    23-16 : RX Codec SpaceWire Data value          [R/-]
					--    15-11 : Reserved                               [-/-]
					--    10-10 : TX Codec TX Ready status bit           [R/-]
					--     9- 9 : TX Codec TX Write control bit          [R/W]
					mm_write_registers.SPWC.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE <= avalon_mm_inputs.writedata(9);
					--     8- 8 : TX Codec SpaceWire Flag value          [R/W]
					mm_write_registers.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG      <= avalon_mm_inputs.writedata(8);
					--     7- 0 : TX Codec SpaceWire Data value          [R/W]
					mm_write_registers.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA      <= avalon_mm_inputs.writedata(7 downto 0);

				-- TRAN Module WriteData procedure

				--  Interface Control and Status Register        (32 bits):
				when (TRAN_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					--    10-10 : Interface Enable control bit         [R/W]
					mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT    <= avalon_mm_inputs.writedata(10);
					--     9- 9 : Interface RX Enable control bit      [R/W]
					mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT <= avalon_mm_inputs.writedata(9);
					--     8- 8 : Interface TX Enable control bit      [R/W]
					mm_write_registers.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT <= avalon_mm_inputs.writedata(8);
					--     7- 7 : Interface Error interrupt enable bit [R/W]
					mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR          <= avalon_mm_inputs.writedata(7);
					--     6- 6 : Data Received interrupt enable bit   [R/W]
					mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED            <= avalon_mm_inputs.writedata(6);
					--     5- 5 : TX FIFO Empty interrupt enable bit   [R/W]
					mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY            <= avalon_mm_inputs.writedata(5);
					--     4- 4 : RX FIFO Full interrupt enable bit    [R/W]
					mm_write_registers.TRAN.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL             <= avalon_mm_inputs.writedata(4);
					--     3- 3 : Interface Error interrupt flag       [R/-]
					--     3- 3 : Interface Error interrupt flag       [-/W]
					mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.INTERFACE_ERROR      <= avalon_mm_inputs.writedata(3);
					--     2- 2 : Data Received interrupt flag         [R/-]
					--     2- 2 : Data Received interrupt flag clear   [-/W]
					mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.DATA_RECEIVED        <= avalon_mm_inputs.writedata(2);
					--     1- 1 : TX FIFO Empty interrupt flag         [R/-]
					--     1- 1 : RX FIFO Full interrupt flag clear    [-/W]
					mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.TX_FIFO_EMPTY        <= avalon_mm_inputs.writedata(1);
					--     0- 0 : RX FIFO Full interrupt flag          [R/-]
					--     0- 0 : TX FIFO Empty interrupt flag clear   [-/W]
					mm_write_registers.TRAN.INTERRUPT_FLAG_CLEAR_REGISTER.RX_FIFO_FULL         <= avalon_mm_inputs.writedata(0);

				--  RX Mode Control Register                     (32 bits):
				when (TRAN_RX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					--    10- 3 : RX FIFO Used Space value             [R/-]
					--     2- 2 : RX FIFO Reset control bit            [R/W]
					mm_write_registers.TRAN.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT <= avalon_mm_inputs.writedata(2);
				--     1- 1 : RX FIFO Empty status bit             [R/-]
				--     0- 0 : RX FIFO Full status bit              [R/-]

				--  TX Mode Control Register                     (32 bits):
				when (TRAN_TX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					--    10- 3 : TX FIFO Used Space value             [R/-]
					--     2- 2 : TX FIFO Reset control bit            [R/W]
					mm_write_registers.TRAN.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT <= avalon_mm_inputs.writedata(2);
				--     1- 1 : TX FIFO Empty status bit             [R/-]
				--     0- 0 : TX FIFO Full status bit              [R/-]

				when others =>
					null;
			end case;
		end procedure mm_writedata_procedure;

		variable mm_write_address : comm_avalon_mm_address_type := 0;
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
	end process comm_avalon_mm_write_proc;

end architecture comm_avalon_mm_write_arc;
