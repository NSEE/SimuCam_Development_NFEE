library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity avalon_mm_rst_controller_read_ent is
	port(
		clk_i                            : in  std_logic;
		rst_i                            : in  std_logic;
		avalon_mm_spacewire_i            : in  t_avalon_mm_rst_controller_read_in;
		avalon_mm_spacewire_o            : out t_avalon_mm_rst_controller_read_out;
		rst_controller_write_registers_i : in  t_rst_controller_write_registers
	);
end entity avalon_mm_rst_controller_read_ent;

architecture rtl of avalon_mm_rst_controller_read_ent is

begin

	p_avalon_mm_rst_controller_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			null;
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_rst_controller_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				--  Reset Controller Register                      (32 bits):
				when (c_RST_CONTROLLER_MM_REG_ADDRESS + c_RST_CONTROLLER_AVALON_MM_REG_OFFSET) =>
					--    31- 1 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 0) <= (others => '0');
					--     0- 0 : Reset control bit                      [R/W]
					avalon_mm_spacewire_o.readdata(0)           <= rst_controller_write_registers_i.reset_controller.reset;

				when others =>
					avalon_mm_spacewire_o.readdata <= (others => '0');
			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_rst_controller_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_read_address                    := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_spacewire_i.read = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_read_address                    := to_integer(unsigned(avalon_mm_spacewire_i.address));
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_rst_controller_read;

end architecture rtl;
