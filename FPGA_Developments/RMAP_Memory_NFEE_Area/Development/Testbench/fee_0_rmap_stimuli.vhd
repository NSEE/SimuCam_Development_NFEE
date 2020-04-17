library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity fee_0_rmap_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		fee_0_rmap_wr_waitrequest_i : in  std_logic;
		fee_0_rmap_readdata_i       : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		fee_0_rmap_rd_waitrequest_i : in  std_logic;
		fee_0_rmap_wr_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0);
		fee_0_rmap_write_o          : out std_logic;
		fee_0_rmap_writedata_o      : out std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		fee_0_rmap_rd_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0);
		fee_0_rmap_read_o           : out std_logic
	);
end entity fee_0_rmap_stimuli;

architecture RTL of fee_0_rmap_stimuli is

	signal s_counter : natural := 0;

begin

	p_fee_0_rmap_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			fee_0_rmap_wr_address_o <= (others => '0');
			fee_0_rmap_write_o      <= '0';
			fee_0_rmap_writedata_o  <= (others => '0');
			fee_0_rmap_rd_address_o <= (others => '0');
			fee_0_rmap_read_o       <= '0';
			s_counter               <= 0;

		elsif rising_edge(clk_i) then

			fee_0_rmap_wr_address_o <= (others => '0');
			fee_0_rmap_write_o      <= '0';
			fee_0_rmap_writedata_o  <= (others => '0');
			fee_0_rmap_rd_address_o <= (others => '0');
			fee_0_rmap_read_o       <= '0';
			s_counter               <= s_counter + 1;

			case s_counter is

				when (500) =>
					-- rmap write
					fee_0_rmap_wr_address_o <= std_logic_vector(to_unsigned(16#00000000#, g_ADDRESS_WIDTH));
					fee_0_rmap_write_o      <= '1';
					fee_0_rmap_writedata_o  <= x"CD";

				when (500 + 1) =>
					if (fee_0_rmap_wr_waitrequest_i = '1') then
						fee_0_rmap_wr_address_o <= std_logic_vector(to_unsigned(16#00000000#, g_ADDRESS_WIDTH));
						fee_0_rmap_write_o      <= '1';
						fee_0_rmap_writedata_o  <= x"CD";
						s_counter               <= 500 + 1;
					end if;

				when (1000) =>
					-- register read
					fee_0_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#00000000#, g_ADDRESS_WIDTH));
					fee_0_rmap_read_o       <= '1';

				when (1000 + 1) =>
					if (fee_0_rmap_rd_waitrequest_i = '1') then
						fee_0_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#00000000#, g_ADDRESS_WIDTH));
						fee_0_rmap_read_o       <= '1';
						s_counter               <= 1000 + 1;
					end if;

				when (1500) =>
					-- rmap write
					fee_0_rmap_wr_address_o <= std_logic_vector(to_unsigned(16#00800000#, g_ADDRESS_WIDTH));
					fee_0_rmap_write_o      <= '1';
					fee_0_rmap_writedata_o  <= x"AB";

				when (1500 + 1) =>
					if (fee_0_rmap_wr_waitrequest_i = '1') then
						fee_0_rmap_wr_address_o <= std_logic_vector(to_unsigned(16#008000AA#, g_ADDRESS_WIDTH));
						fee_0_rmap_write_o      <= '1';
						fee_0_rmap_writedata_o  <= x"AB";
						s_counter               <= 1500 + 1;
					end if;

				when (2000) =>
					-- register read
					fee_0_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#00800000#, g_ADDRESS_WIDTH));
					fee_0_rmap_read_o       <= '1';

				when (2000 + 1) =>
					if (fee_0_rmap_rd_waitrequest_i = '1') then
						fee_0_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#008000AA#, g_ADDRESS_WIDTH));
						fee_0_rmap_read_o       <= '1';
						s_counter               <= 2000 + 1;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_fee_0_rmap_stimuli;

end architecture RTL;
