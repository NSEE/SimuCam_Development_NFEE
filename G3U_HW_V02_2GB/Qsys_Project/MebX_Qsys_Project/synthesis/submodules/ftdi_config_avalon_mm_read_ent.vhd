library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_read_ent is
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		ftdi_config_avalon_mm_i       : in  t_ftdi_config_avalon_mm_read_in;
		ftdi_config_avalon_mm_o       : out t_ftdi_config_avalon_mm_read_out;
		ftdi_config_write_registers_i : in  t_ftdi_config_write_registers;
		ftdi_config_read_registers_i  : in  t_ftdi_config_read_registers
	);
end entity ftdi_config_avalon_mm_read_ent;

architecture rtl of ftdi_config_avalon_mm_read_ent is

begin

	p_ftdi_config_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			null;
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_ftdi_config_avalon_mm_address) is
		begin
			-- Registers Data Read

			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_write_registers_i.general_control_reg.clear;
					end if;

				when (16#01#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_write_registers_i.general_control_reg.stop;
					end if;

				when (16#02#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_write_registers_i.general_control_reg.start;
					end if;

				when (16#03#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.tx_dbuffer_status_reg.empty;
					end if;

				when (16#04#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.tx_dbuffer_status_reg.wrready;
					end if;

				when (16#05#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.tx_dbuffer_status_reg.full;
					end if;

				when (16#06#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.tx_dbuffer_status_reg.rdready;
					end if;

				when (16#07#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.rx_dbuffer_status_reg.empty;
					end if;

				when (16#08#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.rx_dbuffer_status_reg.wrready;
					end if;

				when (16#09#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.rx_dbuffer_status_reg.full;
					end if;

				when (16#0A#) =>
					if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
						ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_read_registers_i.rx_dbuffer_status_reg.rdready;
					end if;

				when others =>
					ftdi_config_avalon_mm_o.readdata <= (others => '0');

			end case;
		end procedure p_readdata;

		variable v_read_address : t_ftdi_config_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_config_avalon_mm_o.readdata    <= (others => '0');
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			v_read_address                      := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			ftdi_config_avalon_mm_o.readdata    <= (others => '0');
			ftdi_config_avalon_mm_o.waitrequest <= '1';
			p_flags_hold;
			if (ftdi_config_avalon_mm_i.read = '1') then
				v_read_address                      := to_integer(unsigned(ftdi_config_avalon_mm_i.address));
				ftdi_config_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_ftdi_config_avalon_mm_read;

end architecture rtl;
