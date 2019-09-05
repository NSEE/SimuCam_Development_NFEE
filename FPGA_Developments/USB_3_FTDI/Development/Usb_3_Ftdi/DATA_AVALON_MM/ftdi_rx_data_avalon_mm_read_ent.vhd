library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_data_avalon_mm_pkg.all;

entity ftdi_rx_data_avalon_mm_read_ent is
	port(
		clk_i                    : in  std_logic;
		rst_i                    : in  std_logic;
		ftdi_rx_data_avalon_mm_i : in  t_ftdi_rx_data_avalon_mm_read_in;
		buffer_stat_empty_i      : in  std_logic;
		buffer_rddata_i          : in  std_logic_vector(63 downto 0);
		buffer_rdready_i         : in  std_logic;
		ftdi_rx_data_avalon_mm_o : out t_ftdi_rx_data_avalon_mm_read_out;
		buffer_rdreq_o           : out std_logic;
		buffer_change_o          : out std_logic
	);
end entity ftdi_rx_data_avalon_mm_read_ent;

architecture rtl of ftdi_rx_data_avalon_mm_read_ent is

	signal s_readdata_fetched : std_logic;

begin

	p_ftdi_rx_data_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			buffer_rdreq_o     <= '0';
			buffer_change_o    <= '0';
			s_readdata_fetched <= '0';
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_buffer_control is
		begin
			buffer_rdreq_o  <= '0';
			buffer_change_o <= '0';
			-- check if there is no data fetched and if the tx data buffer is ready and not empty
			if ((s_readdata_fetched = '0') and (buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
				s_readdata_fetched <= '1';
				buffer_rdreq_o     <= '1';
			end if;
		end procedure p_buffer_control;

		procedure p_readdata(read_address_i : t_ftdi_data_avalon_mm_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when 0 to 1023 =>

					-- check if the readdata is fetched
					if (s_readdata_fetched = '1') then
						s_readdata_fetched                <= '0';
						ftdi_rx_data_avalon_mm_o.readdata <= buffer_rddata_i;
						buffer_rdreq_o                    <= '0';
						buffer_change_o                   <= '0';
						-- check if the tx data buffer is empty
						if (buffer_stat_empty_i = '1') then
							buffer_change_o <= '1';
						-- check if the tx data buffer is ready and not empty
						elsif ((buffer_rdready_i = '1') and (buffer_stat_empty_i = '0')) then
							s_readdata_fetched <= '1';
							buffer_rdreq_o     <= '1';
						end if;

					end if;

				when others =>
					ftdi_rx_data_avalon_mm_o.readdata <= (others => '0');

			end case;
		end procedure p_readdata;

		variable v_read_address : t_ftdi_data_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
			ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
			v_read_address                       := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			ftdi_rx_data_avalon_mm_o.readdata    <= (others => '0');
			ftdi_rx_data_avalon_mm_o.waitrequest <= '1';
			p_flags_hold;
			if (ftdi_rx_data_avalon_mm_i.read = '1') then
				v_read_address                       := to_integer(unsigned(ftdi_rx_data_avalon_mm_i.address));
				ftdi_rx_data_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
			p_buffer_control;
		end if;
	end process p_ftdi_rx_data_avalon_mm_read;

end architecture rtl;
