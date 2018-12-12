library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_buffer_R_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_waitrequest_i : in  std_logic; --                                     -- avalon_mm.waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0) --  --          .writedata
	);
end entity avalon_buffer_R_stimuli;

architecture RTL of avalon_buffer_R_stimuli is

	signal s_counter : natural := 0;

	signal s_address_cnt : natural range 0 to (2**g_ADDRESS_WIDTH - 1) := 0;

begin

	p_avalon_buffer_R_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= 0;
			s_address_cnt         <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= s_counter + 1;

			case s_counter is

				when 1500 to 1501 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
					avalon_mm_writedata_o <= x"0123456789ABCDEF";

				when 1502 =>
					s_counter     <= 1500;
					s_address_cnt <= s_address_cnt + 1;
					if (s_address_cnt = 127) then
						s_counter <= 2000;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_avalon_buffer_R_stimuli;

end architecture RTL;
