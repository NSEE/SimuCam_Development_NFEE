library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.comm_mm_registers_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.tran_mm_registers_pkg.all;

entity avalon_mm_spacewire_read_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_read_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_read_out;
		spacewire_write_registers_i : in  t_write_registers;
		spacewire_read_registers_i  : in  t_read_registers
	);
end entity avalon_mm_spacewire_read_ent;

architecture rtl of avalon_mm_spacewire_read_ent is

begin

	p_avalon_mm_spacewire_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				-- SPWC Module ReadData procedure

				--  Interface Control and Status Register          (32 bits):
				when (SPWC_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-13 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 13) <= (others => '0');
					--    12-12 : Backdoor Mode control bit              [R/W]
					avalon_mm_spacewire_o.readdata(12)           <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT;
					--    11-11 : External Loopback Mode control bit     [R/W]
					avalon_mm_spacewire_o.readdata(11)           <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT;
					--    10-10 : Codec Enable control bit               [R/W]
					avalon_mm_spacewire_o.readdata(10)           <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
					--     9- 9 : Codec RX Enable control bit            [R/W]
					avalon_mm_spacewire_o.readdata(9)            <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT;
					--     8- 8 : Codec TX Enable control bit            [R/W]
					avalon_mm_spacewire_o.readdata(8)            <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT;
					--     7- 7 : Loopback Mode control bit              [R/W]
					avalon_mm_spacewire_o.readdata(7)            <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT;
					--     6- 6 : Codec Force Reset control bit          [R/W]
					avalon_mm_spacewire_o.readdata(6)            <= spacewire_write_registers_i.SPWC.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT;
					--     5- 5 : Link Error interrupt enable bit        [R/W]
					avalon_mm_spacewire_o.readdata(5)            <= spacewire_write_registers_i.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_ERROR;
					--     4- 4 : TimeCode Received interrupt enable bit [R/W]
					avalon_mm_spacewire_o.readdata(4)            <= spacewire_write_registers_i.SPWC.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED;
					--     3- 3 : Link Running interrupt enable bit      [R/W]
					avalon_mm_spacewire_o.readdata(3)            <= spacewire_write_registers_i.SPWC.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING;
					--     2- 2 : Link Error interrupt flag              [R/-]
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_read_registers_i.SPWC.INTERRUPT_FLAG_REGISTER.LINK_ERROR;
					--     2- 2 : Link Error interrupt flag clear        [-/W]
					--     1- 1 : TimeCode Received interrupt flag       [R/-]
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_read_registers_i.SPWC.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED;
					--     0- 0 : Link Running interrupt flag            [R/-]
					--     1- 1 : TimeCode Received interrupt flag clear [-/W]
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_read_registers_i.SPWC.INTERRUPT_FLAG_REGISTER.LINK_RUNNING;
				--     0- 0 : Link Running interrupt flag clear      [-/W]

				--  SpW Link Control and Status Register           (32 bits):
				when (SPWC_SPW_LINK_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-18 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 18) <= (others => '0');
					--    17-10 : TX Clock Divisor value                 [R/W]
					avalon_mm_spacewire_o.readdata(17 downto 10) <= spacewire_write_registers_i.SPWC.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV;
					--     9- 9 : Autostart control bit                  [R/W]
					avalon_mm_spacewire_o.readdata(9)            <= spacewire_write_registers_i.SPWC.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT;
					--     8- 8 : Link Start control bit                 [R/W]
					avalon_mm_spacewire_o.readdata(8)            <= spacewire_write_registers_i.SPWC.SPW_LINK_MODE_REGISTER.LINK_START_BIT;
					--     7- 7 : Link Disconnect control bit            [R/W]
					avalon_mm_spacewire_o.readdata(7)            <= spacewire_write_registers_i.SPWC.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT;
					--     6- 6 : Link Disconnect error bit              [R/-]
					avalon_mm_spacewire_o.readdata(6)            <= spacewire_read_registers_i.SPWC.SPW_LINK_ERROR_REGISTER.DISCONNECT_ERROR_BIT;
					--     5- 5 : Link Parity error bit                  [R/-]
					avalon_mm_spacewire_o.readdata(5)            <= spacewire_read_registers_i.SPWC.SPW_LINK_ERROR_REGISTER.PARITY_ERROR_BIT;
					--     4- 4 : Link Escape error bit                  [R/-]
					avalon_mm_spacewire_o.readdata(4)            <= spacewire_read_registers_i.SPWC.SPW_LINK_ERROR_REGISTER.ESCAPE_ERROR_BIT;
					--     3- 3 : Link Credit error bit                  [R/-]
					avalon_mm_spacewire_o.readdata(3)            <= spacewire_read_registers_i.SPWC.SPW_LINK_ERROR_REGISTER.CREDIT_ERROR_BIT;
					--     2- 2 : Link Started status bit                [R/-]
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_read_registers_i.SPWC.SPW_LINK_STATUS_REGISTER.STARTED;
					--     1- 1 : Link Connecting status bit             [R/-]
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_read_registers_i.SPWC.SPW_LINK_STATUS_REGISTER.CONNECTING;
					--     0- 0 : Link Running status bit                [R/-]
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_read_registers_i.SPWC.SPW_LINK_STATUS_REGISTER.RUNNING;

				--  Timecode Control Register                      (32 bits):
				when (SPWC_TIMECODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-25 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 25) <= (others => '0');
					--    24-23 : RX TimeCode Control bits               [R/W]
					avalon_mm_spacewire_o.readdata(24 downto 23) <= spacewire_read_registers_i.SPWC.RX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--    22-17 : RX TimeCode Counter value              [R/W]
					avalon_mm_spacewire_o.readdata(22 downto 17) <= spacewire_read_registers_i.SPWC.RX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--    16-16 : RX TimeCode status bit                 [R/W]
					avalon_mm_spacewire_o.readdata(16)           <= spacewire_read_registers_i.SPWC.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;
					--    16-16 : RX TimeCode status bit clear           [-/W]
					--    15- 9 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(15 downto 9)  <= (others => '0');
					--     8- 7 : TX TimeCode Control bits               [R/-]
					avalon_mm_spacewire_o.readdata(8 downto 7)   <= spacewire_write_registers_i.SPWC.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--     6- 1 : TX TimeCode Counter value              [R/-]
					avalon_mm_spacewire_o.readdata(6 downto 1)   <= spacewire_write_registers_i.SPWC.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--     0- 0 : TX TimeCode control bit                [R/-]
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_write_registers_i.SPWC.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;

				--  Backdoor Mode Control Register                 (32 bits):
				when (SPWC_BACKDOOR_MODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-27 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 27) <= (others => '0');
					--    26-26 : RX Codec RX DataValid status bit       [R/-]
					avalon_mm_spacewire_o.readdata(26)           <= spacewire_read_registers_i.SPWC.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY;
					--    25-25 : RX Codec RX Read control bit           [R/W]
					avalon_mm_spacewire_o.readdata(25)           <= spacewire_write_registers_i.SPWC.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE;
					--    24-24 : RX Codec SpaceWire Flag value          [R/-]
					avalon_mm_spacewire_o.readdata(24)           <= spacewire_read_registers_i.SPWC.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG;
					--    23-16 : RX Codec SpaceWire Data value          [R/-]
					avalon_mm_spacewire_o.readdata(23 downto 16) <= spacewire_read_registers_i.SPWC.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA;
					--    15-11 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(15 downto 11) <= (others => '0');
					--    10-10 : TX Codec TX Ready status bit           [R/-]
					avalon_mm_spacewire_o.readdata(10)           <= spacewire_read_registers_i.SPWC.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY;
					--     9- 9 : TX Codec TX Write control bit          [R/W]
					avalon_mm_spacewire_o.readdata(9)            <= spacewire_write_registers_i.SPWC.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE;
					--     8- 8 : TX Codec SpaceWire Flag value          [R/W]
					avalon_mm_spacewire_o.readdata(8)            <= spacewire_write_registers_i.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG;
					--     7- 0 : TX Codec SpaceWire Data value          [R/W]
					avalon_mm_spacewire_o.readdata(7 downto 0)   <= spacewire_write_registers_i.SPWC.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA;

				-- TRAN Module ReadData procedure

				--  Interface Control and Status Register        (32 bits):
				when (TRAN_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 11) <= (others => '0');
					--    10-10 : Interface Enable control bit         [R/W]
					avalon_mm_spacewire_o.readdata(10)           <= spacewire_write_registers_i.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_ENABLE_BIT;
					--     9- 9 : Interface RX Enable control bit      [R/W]
					avalon_mm_spacewire_o.readdata(9)            <= spacewire_write_registers_i.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_RX_ENABLE_BIT;
					--     8- 8 : Interface TX Enable control bit      [R/W]
					avalon_mm_spacewire_o.readdata(8)            <= spacewire_write_registers_i.TRAN.INTERFACE_CONTROL_REGISTER.INTERFACE_TX_ENABLE_BIT;
					--     7- 7 : Interface Error interrupt enable bit [R/W]
					avalon_mm_spacewire_o.readdata(7)            <= spacewire_write_registers_i.TRAN.INTERRUPT_ENABLE_REGISTER.INTERFACE_ERROR;
					--     6- 6 : Data Received interrupt enable bit   [R/W]
					avalon_mm_spacewire_o.readdata(6)            <= spacewire_write_registers_i.TRAN.INTERRUPT_ENABLE_REGISTER.DATA_RECEIVED;
					--     5- 5 : RX FIFO Full interrupt enable bit    [R/W]
					avalon_mm_spacewire_o.readdata(5)            <= spacewire_write_registers_i.TRAN.INTERRUPT_ENABLE_REGISTER.RX_FIFO_FULL;
					--     4- 4 : TX FIFO Empty interrupt enable bit   [R/W]
					avalon_mm_spacewire_o.readdata(4)            <= spacewire_write_registers_i.TRAN.INTERRUPT_ENABLE_REGISTER.TX_FIFO_EMPTY;
					--     3- 3 : Interface Error interrupt flag       [R/-]
					avalon_mm_spacewire_o.readdata(3)            <= spacewire_read_registers_i.TRAN.INTERRUPT_FLAG_REGISTER.INTERFACE_ERROR;
					--     3- 3 : Interface Error interrupt flag       [-/W]
					--     2- 2 : Data Received interrupt flag         [R/-]
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_read_registers_i.TRAN.INTERRUPT_FLAG_REGISTER.DATA_RECEIVED;
					--     2- 2 : Data Received interrupt flag clear   [-/W]
					--     1- 1 : RX FIFO Full interrupt flag          [R/-]
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_read_registers_i.TRAN.INTERRUPT_FLAG_REGISTER.RX_FIFO_FULL;
					--     1- 1 : RX FIFO Full interrupt flag clear    [-/W]
					--     0- 0 : TX FIFO Empty interrupt flag         [R/-]
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_read_registers_i.TRAN.INTERRUPT_FLAG_REGISTER.TX_FIFO_EMPTY;
				--     0- 0 : TX FIFO Empty interrupt flag clear   [-/W]

				--  RX Mode Control Register                     (32 bits):
				when (TRAN_RX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 11) <= (others => '0');
					--    10- 3 : RX FIFO Used Space value             [R/-]
					avalon_mm_spacewire_o.readdata(10 downto 3)  <= spacewire_read_registers_i.TRAN.RX_FIFO_STATUS_REGISTER.FIFO_USED_SPACE;
					--     2- 2 : RX FIFO Reset control bit            [R/W]
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_write_registers_i.TRAN.RX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT;
					--     1- 1 : RX FIFO Empty status bit             [R/-]
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_read_registers_i.TRAN.RX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT;
					--     0- 0 : RX FIFO Full status bit              [R/-]
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_read_registers_i.TRAN.RX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT;

				--  TX Mode Control Register                     (32 bits):
				when (TRAN_TX_MODE_CONTROL_MM_REG_ADDRESS + TRAN_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                             [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 11) <= (others => '0');
					--    10- 3 : TX FIFO Used Space value             [R/-]
					avalon_mm_spacewire_o.readdata(10 downto 3)  <= spacewire_read_registers_i.TRAN.TX_FIFO_STATUS_REGISTER.FIFO_USED_SPACE;
					--     2- 2 : TX FIFO Reset control bit            [R/W]
					avalon_mm_spacewire_o.readdata(2)            <= spacewire_write_registers_i.TRAN.TX_FIFO_CONTROL_REGISTER.FIFO_RESET_BIT;
					--     1- 1 : TX FIFO Empty status bit             [R/-]
					avalon_mm_spacewire_o.readdata(1)            <= spacewire_read_registers_i.TRAN.TX_FIFO_STATUS_REGISTER.FIFO_EMPTY_BIT;
					--     0- 0 : TX FIFO Full status bit              [R/-]
					avalon_mm_spacewire_o.readdata(0)            <= spacewire_read_registers_i.TRAN.TX_FIFO_STATUS_REGISTER.FIFO_FULL_BIT;

				when others =>
					avalon_mm_spacewire_o.readdata <= (others => '0');
			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_read_address                    := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			if (avalon_mm_spacewire_i.read = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_read_address                    := to_integer(unsigned(avalon_mm_spacewire_i.address));
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_spacewire_read;

end architecture rtl;
