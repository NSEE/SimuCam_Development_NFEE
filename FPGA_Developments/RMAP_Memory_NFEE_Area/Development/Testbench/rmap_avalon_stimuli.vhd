library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity rmap_avalon_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- -- avalon_mm.readdata
		avalon_mm_waitrequest_i : in  std_logic; --                                     --          .waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- --          .writedata
		avalon_mm_read_o        : out std_logic --                                      --          .read
	);
end entity rmap_avalon_stimuli;

architecture RTL of rmap_avalon_stimuli is

	signal s_counter : natural := 0;

begin

	p_rmap_avalon_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
--			s_counter             <= s_counter + 1;

			case s_counter is

				when 500 to 503 =>
					-- register write
--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_address_o      <= x"0000800000";
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(15 downto 0) <= std_logic_vector(to_unsigned(541, 16)); -- v-start
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(4897, 16)); -- v-end
					
				when 1500 to 1503 =>
					-- register read
--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_address_o      <= x"0000800000";
					avalon_mm_read_o        <= '1';



				when others =>
					null;

			end case;

		end if;
	end process p_rmap_avalon_stimuli;

end architecture RTL;
