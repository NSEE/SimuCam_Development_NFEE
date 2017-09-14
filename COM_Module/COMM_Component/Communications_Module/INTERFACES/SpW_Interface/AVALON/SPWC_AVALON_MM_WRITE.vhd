library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_avalon_mm_pkg.all;
use work.spwc_mm_registers_pkg.all;

entity spwc_avalon_mm_write_ent is
	port(
		clk                : in  std_logic;
		rst                : in  std_logic;
		avalon_mm_inputs   : in  spwc_avalon_mm_write_inputs_type;
		avalon_mm_outputs  : out spwc_avalon_mm_write_outputs_type;
		mm_write_registers : out spwc_mm_write_registers_type
	);
end entity spwc_avalon_mm_write_ent;

architecture spwc_avalon_mm_write_arc of spwc_avalon_mm_write_ent is

begin

	spwc_avalon_mm_write_proc : process(clk, rst) is
		procedure mm_reset_registers_procedure is
		begin
			mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT     <= '0';
			mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT  <= '0';
			mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT  <= '0';
			mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT    <= '0';
			mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT      <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR            <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED     <= '0';
			mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING          <= '0';
			mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT            <= '0';
			mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT           <= '0';
			mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT      <= '0';
			mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS      <= (others => '0');
			mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE     <= (others => '0');
			mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT         <= '0';
			mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR        <= '0';
			mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED <= '0';
			mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING      <= '0';
		end procedure mm_reset_registers_procedure;

		procedure mm_control_triggers_procedure is
		begin
			mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT      <= '0';
			mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT         <= '0';
			mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR        <= '0';
			mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED <= '0';
			mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING      <= '0';
		end procedure mm_control_triggers_procedure;

		procedure mm_writedata_procedure(mm_write_address : spwc_avalon_mm_address_type) is
		begin
			-- Registers Write Data
			case (mm_write_address) is
				-- Case for access to all registers address

				--  Interface Control and Status Register          (32 bits):
				when (SPWC_INTERFACE_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-11 : Reserved                               [-/-]
					--    10-10 : Codec Enable control bit               [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_ENABLE_BIT     <= avalon_mm_inputs.writedata(10);
					--     9- 9 : Codec RX Enable control bit            [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_RX_ENABLE_BIT  <= avalon_mm_inputs.writedata(9);
					--     8- 8 : Codec TX Enable control bit            [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.CODEC_TX_ENABLE_BIT  <= avalon_mm_inputs.writedata(8);
					--     7- 7 : Loopback Mode control bit              [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.LOOPBACK_MODE_BIT    <= avalon_mm_inputs.writedata(7);
					--     6- 6 : Codec Force Reset control bit          [R/W]
					mm_write_registers.INTERFACE_CONTROL_REGISTER.FORCE_RESET_BIT      <= avalon_mm_inputs.writedata(6);
					--     5- 5 : Link Error interrupt enable bit        [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_ERROR            <= avalon_mm_inputs.writedata(5);
					--     4- 4 : TimeCode Received interrupt enable bit [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.TIMECODE_RECEIVED     <= avalon_mm_inputs.writedata(4);
					--     3- 3 : Link Running interrupt enable bit      [R/W]
					mm_write_registers.INTERRUPT_ENABLE_REGISTER.LINK_RUNNING          <= avalon_mm_inputs.writedata(3);
					--     2- 2 : Link Error interrupt flag              [R/-]
					mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_ERROR        <= avalon_mm_inputs.writedata(2);
					--     1- 1 : TimeCode Received interrupt flag       [R/-]
					mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.TIMECODE_RECEIVED <= avalon_mm_inputs.writedata(1);
					--     0- 0 : Link Running interrupt flag            [R/-]
					mm_write_registers.INTERRUPT_FLAG_CLEAR_REGISTER.LINK_RUNNING      <= avalon_mm_inputs.writedata(0);

					--  SpW Link Control and Status Register           (32 bits):
				when (SPWC_SPW_LINK_CONTROL_STATUS_MM_REG_ADDRESS + SPWC_MM_REGISTERS_ADDRESS_OFFSET) =>
					--    31-10 : Reserved                               [-/-]
					--     9- 9 : Autostart control bit                  [R/W]
					mm_write_registers.SPW_LINK_MODE_REGISTER.AUTOSTART_BIT       <= avalon_mm_inputs.writedata(9);
					--     8- 8 : Link Start control bit                 [R/W]
					mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_START_BIT      <= avalon_mm_inputs.writedata(8);
					--     7- 7 : Link Disconnect control bit            [R/W]
					mm_write_registers.SPW_LINK_MODE_REGISTER.LINK_DISCONNECT_BIT <= avalon_mm_inputs.writedata(7);
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
					--    16-16 : RX TimeCode control bit                [R/-]
					--    15- 9 : Reserved                               [R/-]
					--     8- 7 : TX TimeCode Control bits               [R/W]
					mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_CONTROL_BITS  <= avalon_mm_inputs.writedata(8 downto 7);
					--     6- 1 : TX TimeCode Counter value              [R/W]
					mm_write_registers.TX_TIMECODE_REGISTER.TIMECODE_COUNTER_VALUE <= avalon_mm_inputs.writedata(6 downto 1);
					--     0- 0 : TX TimeCode status bit                 [R/W]
					mm_write_registers.TX_TIMECODE_REGISTER.CONTROL_STATUS_BIT     <= avalon_mm_inputs.writedata(0);

				when others =>
					null;
			end case;
		end procedure mm_writedata_procedure;

		variable mm_write_address : spwc_avalon_mm_address_type := 0;
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
	end process spwc_avalon_mm_write_proc;

end architecture spwc_avalon_mm_write_arc;
