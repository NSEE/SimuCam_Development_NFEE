library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_data_stimulli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 256
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- -- avalon_mm.readdata
		avalon_mm_waitrequest_i : in  std_logic; --                                     --          .waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_read_o        : out std_logic --                                      --          .read
	);
end entity rx_data_stimulli;

architecture RTL of rx_data_stimulli is

	signal s_counter : natural                                         := 0;
	signal s_times   : natural                                         := 0;
	signal s_rd_addr : natural range 0 to ((2 ** g_ADDRESS_WIDTH) - 1) := 0;

	constant c_START_CNT : natural := 7000;

begin

	p_rx_data_stimulli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o <= (others => '0');
			avalon_mm_read_o    <= '0';
			s_counter           <= 0;
			s_times             <= 0;
			s_rd_addr           <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o <= (others => '0');
			avalon_mm_read_o    <= '0';
			s_counter           <= s_counter + 1;

			case s_counter is

				--				when c_START_CNT to (c_START_CNT+1) =>
				--					-- register read
				--					--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
				--					avalon_mm_address_o <= std_logic_vector(to_unsigned(s_rd_addr, g_ADDRESS_WIDTH));
				--					avalon_mm_read_o    <= '1';
				--					if (s_counter = (c_START_CNT+1)) then
				--						if (s_rd_addr < 255) then
				--							s_rd_addr <= s_rd_addr + 1;
				--							s_counter <= c_START_CNT - 1;
				--						else
				--							s_rd_addr <= 0;
				--							if (s_times >= (10 - 1)) then
				--								s_times   <= 0;
				--								s_counter <= c_START_CNT + 2;
				--							else
				--								s_times   <= s_times + 1;
				--								s_counter <= c_START_CNT - 5000 - 1;
				--							end if;
				--						end if;
				--					end if;

				when c_START_CNT =>
					-- register read
					--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					if (avalon_mm_waitrequest_i = '1') then
						avalon_mm_address_o <= std_logic_vector(to_unsigned(s_rd_addr, g_ADDRESS_WIDTH));
						avalon_mm_read_o    <= '1';
						s_counter <= (c_START_CNT);
					else
						if (s_counter = (c_START_CNT)) then
							if (s_rd_addr < ((2 ** g_ADDRESS_WIDTH) - 1)) then
								s_rd_addr <= s_rd_addr + 1;
								s_counter <= c_START_CNT - 1;
							else
								s_rd_addr <= 0;
								if (s_times >= (10 - 1)) then
									s_times   <= 0;
									s_counter <= c_START_CNT + 1;
								else
									s_times   <= s_times + 1;
									s_counter <= c_START_CNT - 5000 - 1;
								end if;
							end if;
						end if;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_rx_data_stimulli;

end architecture RTL;
