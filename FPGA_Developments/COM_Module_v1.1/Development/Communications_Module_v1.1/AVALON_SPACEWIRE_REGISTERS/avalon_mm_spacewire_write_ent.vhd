library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;

entity avalon_mm_spacewire_write_ent is
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		avalon_mm_spacewire_i       : in  t_avalon_mm_spacewire_write_in;
		avalon_mm_spacewire_o       : out t_avalon_mm_spacewire_write_out;
		spacewire_write_registers_o : out t_windowing_write_registers
	);
end entity avalon_mm_spacewire_write_ent;

architecture rtl of avalon_mm_spacewire_write_ent is

begin

	p_avalon_mm_spacewire_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			spacewire_write_registers_o.windowing_control.mask_enable       <= '0';
			spacewire_write_registers_o.windowing_control.autostart         <= '0';
			spacewire_write_registers_o.windowing_control.linkstart         <= '0';
			spacewire_write_registers_o.windowing_control.linkdis           <= '0';
			spacewire_write_registers_o.timecode_rx_flags.rx_received_clear <= '0';
			spacewire_write_registers_o.timecode_tx.tx_control              <= (others => '0');
			spacewire_write_registers_o.timecode_tx.tx_time                 <= (others => '0');
			spacewire_write_registers_o.timecode_tx.tx_send                 <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			spacewire_write_registers_o.timecode_tx.tx_send                 <= '0';
			spacewire_write_registers_o.timecode_rx_flags.rx_received_clear <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_spacewire_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				--  Windowing Control Register                     (32 bits):
				when (c_WINDOWING_CONTROL_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31- 9 : Reserved                               [-/-]
					--     8- 8 : Masking enable control bit             [R/W]
					spacewire_write_registers_o.windowing_control.mask_enable <= avalon_mm_spacewire_i.writedata(8);
					--     7- 3 : Reserved                               [-/-]
					--     2- 2 : Autostart control bit                  [R/W]
					spacewire_write_registers_o.windowing_control.autostart   <= avalon_mm_spacewire_i.writedata(2);
					--     1- 1 : Link Start control bit                 [R/W]
					spacewire_write_registers_o.windowing_control.linkstart   <= avalon_mm_spacewire_i.writedata(1);
					--     0- 0 : Link Disconnect control bit            [R/W]
					spacewire_write_registers_o.windowing_control.linkdis     <= avalon_mm_spacewire_i.writedata(0);

				--  Windowing Status Register                      (32 bits):
				when (c_WINDOWING_STATUS_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31-12 : Reserved                               [-/-]
					--    11-11 : Link Disconnect error bit              [R/-]
					--    10-10 : Link Parity error bit                  [R/-]
					--     9- 9 : Link Escape error bit                  [R/-]
					--     8- 8 : Link Credit error bit                  [R/-]
					--     7- 3 : Reserved                               [-/-]	
					--     2- 2 : Link Started status bit                [R/-]
					--     1- 1 : Link Connecting status bit             [R/-]
					--     0- 0 : Link Running status bit                [R/-]

					--  Timecode RX Register                           (32 bits):
				when (c_TIMECODE_RX_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31- 9 : Reserved                               [-/-]
					--     8- 7 : RX TimeCode Control bits               [R/-]
					--     6- 1 : RX TimeCode Counter value              [R/-]
					--     0- 0 : RX TimeCode status bit                 [R/-]
					--     0- 0 : RX TimeCode status bit clear           [-/W]
					spacewire_write_registers_o.timecode_rx_flags.rx_received_clear <= avalon_mm_spacewire_i.writedata(0);

				--  Timecode TX Register                           (32 bits):
				when (c_TIMECODE_TX_MM_REG_ADDRESS + c_WINDOWING_AVALON_MM_REG_OFFSET) =>
					--    31- 9 : Reserved                               [-/-]
					--     8- 7 : TX TimeCode Control bits               [R/W]
					spacewire_write_registers_o.timecode_tx.tx_control <= avalon_mm_spacewire_i.writedata(8 downto 7);
					--     6- 1 : TX TimeCode Counter value              [R/W]
					spacewire_write_registers_o.timecode_tx.tx_time    <= avalon_mm_spacewire_i.writedata(6 downto 1);
					--     0- 0 : TX TimeCode control bit                [R/W]
					spacewire_write_registers_o.timecode_tx.tx_send    <= avalon_mm_spacewire_i.writedata(0);

				when others =>
					null;
			end case;
		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_spacewire_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_write_address                   := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_spacewire_i.write = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_write_address                   := to_integer(unsigned(avalon_mm_spacewire_i.address));
				p_writedata(v_write_address);
			end if;
		end if;
	end process p_avalon_mm_spacewire_write;

end architecture rtl;
