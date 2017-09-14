library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_avalon_mm_pkg.all;
use work.spwc_mm_registers_pkg.all;

entity spwc_avalon_mm_read_ent is
	port(
		clk                   : in  std_logic;
		rst                   : in  std_logic;
		avalon_mm_inputs      : in  spwc_avalon_mm_read_inputs_type;
		avalon_mm_outputs     : out spwc_avalon_mm_read_outputs_type;
		mm_write_registers    : in  spwc_mm_write_registers_type;
		mm_read_registers     : in  spwc_mm_read_registers_type
	);
end entity spwc_avalon_mm_read_ent;

architecture spwc_avalon_mm_read_arc of spwc_avalon_mm_read_ent is

begin

	spwc_avalon_mm_read_proc : process(clk, rst) is
		procedure mm_readdata_procedure(mm_read_address : spwc_avalon_mm_address_type) is
		begin
			-- Registers Data Read
			case (mm_read_address) is
				-- Case for access to all registers address

				--  Interface Control and Status Register          (32 bits):
				when (SPWC_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 11) <= (others => '0');
					--    10-10 : Codec Enable control bit               [R/W]
					avalon_mm_outputs.readdata(10)           <= mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT;
					--     9- 9 : Codec RX Enable control bit            [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT;
					--     8- 8 : Codec TX Enable control bit            [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT;
					--     7- 7 : Loopback Mode control bit              [R/W]
					avalon_mm_outputs.readdata(7)            <= mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT;
					--     6- 6 : Codec Force Reset control bit          [R/W]
					avalon_mm_outputs.readdata(6)            <= mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT;
					--     5- 5 : Link Error interrupt enable bit        [R/W]
					avalon_mm_outputs.readdata(5)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR;
					--     4- 4 : TimeCode Received interrupt enable bit [R/W]
					avalon_mm_outputs.readdata(4)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED;
					--     3- 3 : Link Running interrupt enable bit      [R/W]
					avalon_mm_outputs.readdata(3)            <= mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING;
					--     2- 2 : Link Error interrupt flag              [R/-]
					avalon_mm_outputs.readdata(2)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_ERROR;
					--     1- 1 : TimeCode Received interrupt flag       [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.TIMECODE_RECEIVED;
					--     0- 0 : Link Running interrupt flag            [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.INTERRUPT_FLAG_REGISTER.LINK_RUNNING;

					--  SpW Link Control and Status Register           (32 bits):
				when (SPWC_SPW_LINK_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-10 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 10) <= (others => '0');
					--     9- 9 : Autostart control bit                  [R/W]
					avalon_mm_outputs.readdata(9)            <= mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT;
					--     8- 8 : Link Start control bit                 [R/W]
					avalon_mm_outputs.readdata(8)            <= mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT;
					--     7- 7 : Link Disconnect control bit            [R/W]
					avalon_mm_outputs.readdata(7)            <= mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT;
					--     6- 6 : Link Disconnect error bit              [R/-]
					avalon_mm_outputs.readdata(6)            <= mm_read_registers.SPW_LINK_ERROR_REGISTER.DISCONNECT_ERROR_BIT;
					--     5- 5 : Link Parity error bit                  [R/-]
					avalon_mm_outputs.readdata(5)            <= mm_read_registers.SPW_LINK_ERROR_REGISTER.PARITY_ERROR_BIT;
					--     4- 4 : Link Escape error bit                  [R/-]
					avalon_mm_outputs.readdata(4)            <= mm_read_registers.SPW_LINK_ERROR_REGISTER.ESCAPE_ERROR_BIT;
					--     3- 3 : Link Credit error bit                  [R/-]
					avalon_mm_outputs.readdata(3)            <= mm_read_registers.SPW_LINK_ERROR_REGISTER.CREDIT_ERROR_BIT;
					--     2- 2 : Link Started status bit                [R/-]
					avalon_mm_outputs.readdata(2)            <= mm_read_registers.SPW_LINK_STATUS_REGISTER.STARTED;
					--     1- 1 : Link Connecting status bit             [R/-]
					avalon_mm_outputs.readdata(1)            <= mm_read_registers.SPW_LINK_STATUS_REGISTER.CONNECTING;
					--     0- 0 : Link Running status bit                [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_read_registers.SPW_LINK_STATUS_REGISTER.RUNNING;

					--  Timecode Control Register                      (32 bits):
				when (SPWC_TIMECODE_CONTROL_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-25 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(31 downto 25) <= (others => '0');
					--    24-23 : RX TimeCode Control bits               [R/W]
					avalon_mm_outputs.readdata(24 downto 23) <= mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--    22-17 : RX TimeCode Counter value              [R/W]
					avalon_mm_outputs.readdata(22 downto 17) <= mm_read_registers.RX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--    16-16 : RX TimeCode control bit                [R/W]
					avalon_mm_outputs.readdata(16)           <= mm_read_registers.RX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;
					--    15- 9 : Reserved                               [-/-]
					avalon_mm_outputs.readdata(15 downto 9)  <= (others => '0');
					--     8- 7 : TX TimeCode Control bits               [R/-]
					avalon_mm_outputs.readdata(8 downto 7)   <= mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS;
					--     6- 1 : TX TimeCode Counter value              [R/-]
					avalon_mm_outputs.readdata(6 downto 1)   <= mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE;
					--     0- 0 : TX TimeCode status bit                 [R/-]
					avalon_mm_outputs.readdata(0)            <= mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT;

				when others =>
					avalon_mm_outputs.readdata <= (others => '0');
			end case;
		end procedure mm_readdata_procedure;

		variable mm_read_address : spwc_avalon_mm_address_type := 0;
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
	end process spwc_avalon_mm_read_proc;

end architecture spwc_avalon_mm_read_arc;
