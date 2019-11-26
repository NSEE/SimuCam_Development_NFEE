library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_clk_reconstructor_ent is
	generic(
		g_CLKDIV : natural range 1 to 32 := 4
	);
	port(
		clk_base_i          : in  std_logic;
		rst_i               : in  std_logic;
		trigger_i           : in  std_logic;
		clk_reconstructed_o : out std_logic
	);
end entity ftdi_clk_reconstructor_ent;

architecture RTL of ftdi_clk_reconstructor_ent is

	constant c_CLK_CNT_TOOGLE : natural range 0 to 31 := (g_CLKDIV / 2) - 1;

	signal s_clk_reconstructed : std_logic;

	signal s_clk_cnt : natural range 0 to 31 := c_CLK_CNT_TOOGLE;

	signal s_trigger_ant : std_logic;

	signal s_trigger_flag : std_logic;

begin

	p_clk_reconstruction : process(clk_base_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_clk_reconstructed <= '1';
			s_clk_cnt           <= c_CLK_CNT_TOOGLE;
			s_trigger_ant       <= trigger_i;

		elsif rising_edge(clk_base_i) then

			if (s_trigger_flag = '1') then
				s_clk_reconstructed <= '1';
				s_clk_cnt           <= c_CLK_CNT_TOOGLE;
			else

				if (s_clk_cnt = 0) then
					s_clk_reconstructed <= not s_clk_reconstructed;
					s_clk_cnt           <= c_CLK_CNT_TOOGLE;
				else
					s_clk_cnt <= s_clk_cnt - 1;
				end if;

			end if;

			s_trigger_ant <= trigger_i;

		end if;
	end process p_clk_reconstruction;

	clk_reconstructed_o <= s_clk_reconstructed;
	s_trigger_flag      <= (trigger_i) xor (s_trigger_ant);

end architecture RTL;
