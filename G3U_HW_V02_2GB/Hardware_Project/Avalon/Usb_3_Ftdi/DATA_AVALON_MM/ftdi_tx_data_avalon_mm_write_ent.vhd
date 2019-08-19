library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_data_avalon_mm_pkg.all;

entity ftdi_tx_data_avalon_mm_write_ent is
	port(
		clk_i                    : in  std_logic;
		rst_i                    : in  std_logic;
		ftdi_tx_data_avalon_mm_i : in  t_ftdi_tx_data_avalon_mm_write_in;
		buffer_stat_full_i       : in  std_logic;
		buffer_wrready_i         : in  std_logic;
		ftdi_tx_data_avalon_mm_o : out t_ftdi_tx_data_avalon_mm_write_out;
		buffer_data_loaded_o     : out std_logic;
		buffer_wrdata_o          : out std_logic_vector(63 downto 0);
		buffer_wrreq_o           : out std_logic
	);
end entity ftdi_tx_data_avalon_mm_write_ent;

architecture rtl of ftdi_tx_data_avalon_mm_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_ftdi_tx_data_avalon_mm_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			buffer_wrdata_o      <= (others => '0');
			buffer_wrreq_o       <= '0';
			buffer_data_loaded_o <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			null;
		end procedure p_control_triggers;

		procedure p_buffer_control is
		begin
			buffer_wrdata_o      <= (others => '0');
			buffer_wrreq_o       <= '0';
			buffer_data_loaded_o <= '0';
		end procedure p_buffer_control;

		procedure p_writedata(write_address_i : t_ftdi_data_avalon_mm_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when 0 to 1023 =>

					-- check if the rx data buffer is ready to be written and not full
					if ((buffer_wrready_i = '1') and (buffer_stat_full_i = '0')) then
						buffer_wrdata_o      <= ftdi_tx_data_avalon_mm_i.writedata;
						buffer_wrreq_o       <= '1';
						buffer_data_loaded_o <= '0';
					end if;

				when others =>
					null;

			end case;

		end procedure p_writedata;

		variable v_write_address : t_ftdi_data_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_tx_data_avalon_mm_o.waitrequest <= '1';
			s_data_acquired                      <= '0';
			v_write_address                      := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			ftdi_tx_data_avalon_mm_o.waitrequest <= '1';
			p_control_triggers;
			p_buffer_control;
			s_data_acquired                      <= '0';
			if (ftdi_tx_data_avalon_mm_i.write = '1') then
				s_data_acquired <= '1';
				if (s_data_acquired = '0') then
					v_write_address                      := to_integer(unsigned(ftdi_tx_data_avalon_mm_i.address));
					ftdi_tx_data_avalon_mm_o.waitrequest <= '0';
					p_writedata(v_write_address);
				end if;
			end if;
		end if;
	end process p_ftdi_tx_data_avalon_mm_write;

end architecture rtl;
