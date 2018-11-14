library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avs_stimuli is
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
end entity avs_stimuli;

architecture RTL of avs_stimuli is

	signal s_counter : natural := 0;

	-- Registers Here
	-- Ex: 
	alias a_wr_reg0_bit0  : std_logic is avalon_mm_writedata_o(0);
	alias a_wr_reg0_bits1 : std_logic_vector(30 downto 0) is avalon_mm_writedata_o(31 downto 1);
	alias a_wr_reg1_bits0 : std_logic_vector(15 downto 0) is avalon_mm_writedata_o(15 downto 0);
	alias a_wr_reg1_bits1 : std_logic_vector(15 downto 0) is avalon_mm_writedata_o(31 downto 16);

begin

	p_avs_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= 0;

		elsif rising_edge(clk) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= s_counter + 1;

			case s_counter is

				when 100 to 101 =>
					-- register write
					avalon_mm_address_o <= (others => '0');
					avalon_mm_write_o   <= '1';
					-- avalon_mm_writedata_o <= (others => '0');
					-- Ex:
					a_wr_reg0_bit0      <= '1';
					a_wr_reg0_bits1     <= (others => '1');
					avalon_mm_read_o    <= '0';

				when 150 to 151 =>
					-- register read
					avalon_mm_address_o <= (others => '0');
					avalon_mm_write_o   <= '0';
					avalon_mm_read_o    <= '1';

				when others =>
					null;

			end case;

		end if;
	end process p_avs_stimuli;

end architecture RTL;
