library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_registers_pck.all;

entity ftdi_avalon_write_ent is
	port(
		clk                    : in  std_logic;
		rst                    : in  std_logic;
		avalon_slave_address   : in  std_logic_vector(7 downto 0);
		avalon_slave_write     : in  std_logic;
		avalon_slave_writedata : in  std_logic_vector(31 downto 0);
		avalon_slave_waitrequest : out std_logic;
		ftdi_write_register    : out ftdi_write_type
	);
end entity ftdi_avalon_write_ent;

architecture ftdi_avalon_write_arc of ftdi_avalon_write_ent is

begin

	ftdi_avalon_write_proc : process(clk, rst) is
		variable write_address : ftdi_address_type;
	begin
		if (rst = '1') then
			avalon_slave_waitrequest <= '1';
			ftdi_write_register.DATA_REG_OUT     <= (others => '0');
			ftdi_write_register.BE_REG_OUT       <= (others => '0');
			ftdi_write_register.SIWU_N_REG       <= '1';
			ftdi_write_register.WR_N_REG         <= '1';
			ftdi_write_register.RD_N_REG         <= '1';
			ftdi_write_register.OE_N_REG         <= '1';
			ftdi_write_register.RESET_N_REG      <= '1';
			ftdi_write_register.WAKEUP_N_REG_OUT <= '1';
			ftdi_write_register.GPIO_REG_OUT     <= (others => '0');
			ftdi_write_register.OE_REG           <= (others => '0');
		elsif (rising_edge(clk)) then
			if (avalon_slave_write = '1') then
				avalon_slave_waitrequest <= '0';
				write_address := to_integer(unsigned(avalon_slave_address));
				case write_address is
					when FTDI_DATA_REG_ADDRESS =>
						ftdi_write_register.DATA_REG_OUT <= avalon_slave_writedata;
					when FTDI_BE_REG_ADDRESS =>
						ftdi_write_register.BE_REG_OUT <= avalon_slave_writedata(ftdi_write_register.BE_REG_OUT'length - 1 downto 0);
					when FTDI_SIWU_N_REG_ADDRESS =>
						ftdi_write_register.SIWU_N_REG <= avalon_slave_writedata(0);
					when FTDI_WR_N_REG_ADDRESS =>
						ftdi_write_register.WR_N_REG <= avalon_slave_writedata(0);
					when FTDI_RD_N_REG_ADDRESS =>
						ftdi_write_register.RD_N_REG <= avalon_slave_writedata(0);
					when FTDI_OE_N_REG_ADDRESS =>
						ftdi_write_register.OE_N_REG <= avalon_slave_writedata(0);
					when FTDI_RESET_N_REG_ADDRESS =>
						ftdi_write_register.RESET_N_REG <= avalon_slave_writedata(0);
					when FTDI_WAKEUP_N_REG_ADDRESS =>
						ftdi_write_register.WAKEUP_N_REG_OUT <= avalon_slave_writedata(0);
					when FTDI_GPIO_REG_ADDRESS =>
						ftdi_write_register.GPIO_REG_OUT <= avalon_slave_writedata(ftdi_write_register.GPIO_REG_OUT'length - 1 downto 0);
					when FTDI_OE_REG_ADDRESS_ADDRESS =>
						ftdi_write_register.OE_REG <= avalon_slave_writedata(ftdi_write_register.OE_REG'length - 1 downto 0);
					when FTDI_DATA_OE_MASK_REG_ADDRESS =>
						ftdi_write_register.OE_REG(0) <= avalon_slave_writedata(0);
					when FTDI_BE_OE_MASK_REG_ADDRESS =>
						ftdi_write_register.OE_REG(1) <= avalon_slave_writedata(0);
					when FTDI_WAKEUP_OE_MASK_REG_ADDRESS =>
						ftdi_write_register.OE_REG(2) <= avalon_slave_writedata(0);
					when FTDI_GPIO_OE_MASK_REG_ADDRESS =>
						ftdi_write_register.OE_REG(3) <= avalon_slave_writedata(0);
					when others =>
						null;
				end case;
			else
				avalon_slave_waitrequest <= '1';
			end if;
		end if;
	end process ftdi_avalon_write_proc;

end architecture ftdi_avalon_write_arc;
