library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_registers_pck.all;

entity ftdi_avalon_read_ent is
	port(
		clk                   : in  std_logic;
		rst                   : in  std_logic;
		avalon_slave_address  : in  std_logic_vector(7 downto 0);
		avalon_slave_read     : in  std_logic;
		avalon_slave_readdata : out std_logic_vector(31 downto 0);
		avalon_slave_waitrequest : out std_logic;
		ftdi_read_register    : in  ftdi_read_type;
		ftdi_write_register   : in  ftdi_write_type
	);
end entity ftdi_avalon_read_ent;

architecture ftdi_avalon_read_arc of ftdi_avalon_read_ent is

begin

	ftdi_avalon_read_proc : process(clk, rst) is
		variable read_address : ftdi_address_type;
	begin
		if (rst = '1') then
			avalon_slave_waitrequest <= '1';
			avalon_slave_readdata <= x"00000000";
		elsif (rising_edge(clk)) then
			if (avalon_slave_read = '1') then
				avalon_slave_waitrequest <= '0';
			    read_address := to_integer(unsigned(avalon_slave_address));
				case read_address is
					when FTDI_DATA_REG_ADDRESS =>
						avalon_slave_readdata <= ftdi_read_register.DATA_REG_IN;
					when FTDI_BE_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto ftdi_read_register.BE_REG_IN'length => '0') & ftdi_read_register.BE_REG_IN;
					when FTDI_TXE_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_read_register.TXE_N_REG;
					when FTDI_RXF_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_read_register.RXF_N_REG;
					when FTDI_SIWU_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_write_register.SIWU_N_REG;
					when FTDI_WR_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_write_register.WR_N_REG;
					when FTDI_RD_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_write_register.RD_N_REG;
					when FTDI_OE_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_write_register.OE_N_REG;
					when FTDI_RESET_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_write_register.RESET_N_REG;
					when FTDI_WAKEUP_N_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto 1 => '0') & ftdi_read_register.WAKEUP_N_REG_IN;
					when FTDI_GPIO_REG_ADDRESS =>
						avalon_slave_readdata <= (31 downto ftdi_read_register.GPIO_REG_IN'length => '0') & ftdi_read_register.GPIO_REG_IN;
					when FTDI_OE_REG_ADDRESS_ADDRESS =>
						avalon_slave_readdata <= (31 downto ftdi_write_register.OE_REG'length => '0') & ftdi_write_register.OE_REG;
					when others =>
						avalon_slave_readdata <= x"00000000";
				end case;
			else
				avalon_slave_waitrequest <= '1';
			end if;
		end if;
	end process ftdi_avalon_read_proc;

end architecture ftdi_avalon_read_arc;
