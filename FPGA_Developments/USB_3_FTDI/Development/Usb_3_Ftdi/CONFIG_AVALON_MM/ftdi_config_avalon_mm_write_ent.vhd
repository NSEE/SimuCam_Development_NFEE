library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_write_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		ftdi_config_avalon_mm_i       : in  t_ftdi_config_avalon_mm_write_in;
		ftdi_config_avalon_mm_o       : out t_ftdi_config_avalon_mm_write_out;
		ftdi_config_write_registers_o : out t_ftdi_config_write_registers
	);
end entity ftdi_config_avalon_mm_write_ent;

architecture rtl of ftdi_config_avalon_mm_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_ftdi_config_avalon_mm_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			ftdi_config_write_registers_o.general_control_reg.clear <= '0';
			ftdi_config_write_registers_o.general_control_reg.stop  <= '0';
			ftdi_config_write_registers_o.general_control_reg.start <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			ftdi_config_write_registers_o.general_control_reg.clear <= '0';
			ftdi_config_write_registers_o.general_control_reg.stop  <= '0';
			ftdi_config_write_registers_o.general_control_reg.start <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_ftdi_config_avalon_mm_address) is
		begin
			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_write_registers_o.general_control_reg.clear <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#01#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_write_registers_o.general_control_reg.stop <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when (16#02#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_write_registers_o.general_control_reg.start <= ftdi_config_avalon_mm_i.writedata(0);
					end if;

				when others =>
					null;

			end case;
		end procedure p_writedata;

		variable v_write_address : t_ftdi_config_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			s_data_acquired                     <= '0';
			v_write_address                     := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			p_control_triggers;
			s_data_acquired <= '0';
			if (ftdi_config_avalon_mm_i.write = '1') then
				v_write_address                     := to_integer(unsigned(ftdi_config_avalon_mm_i.address));
				ftdi_config_avalon_mm_o.waitrequest <= '0';
				s_data_acquired                     <= '1';
				if (s_data_acquired = '0') then
					p_writedata(v_write_address);
				end if;
			end if;
		end if;
	end process p_ftdi_config_avalon_mm_write;

end architecture rtl;
