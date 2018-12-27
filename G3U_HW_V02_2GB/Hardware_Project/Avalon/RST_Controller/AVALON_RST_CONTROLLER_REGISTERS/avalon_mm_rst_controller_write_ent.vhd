library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity avalon_mm_rst_controller_write_ent is
	port(
		clk_i                            : in  std_logic;
		rst_i                            : in  std_logic;
		avalon_mm_spacewire_i            : in  t_avalon_mm_rst_controller_write_in;
		avalon_mm_spacewire_o            : out t_avalon_mm_rst_controller_write_out;
		rst_controller_write_registers_o : out t_rst_controller_write_registers
	);
end entity avalon_mm_rst_controller_write_ent;

architecture rtl of avalon_mm_rst_controller_write_ent is

begin

	p_avalon_mm_rst_controller_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			rst_controller_write_registers_o.reset_controller.reset <= '1';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			null;
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_rst_controller_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				--  Reset Controller Register                      (32 bits):
				when (c_RST_CONTROLLER_MM_REG_ADDRESS + c_RST_CONTROLLER_AVALON_MM_REG_OFFSET) =>
					--    31- 1 : Reserved                               [-/-]
					--     0- 0 : Reset control bit                      [R/W]
					rst_controller_write_registers_o.reset_controller.reset <= avalon_mm_spacewire_i.writedata(0);

				when others =>
					null;
			end case;
		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_rst_controller_address := 0;
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
	end process p_avalon_mm_rst_controller_write;

end architecture rtl;
