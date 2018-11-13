library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- constants
	constant c_ADDRESS_WIDTH : natural range 1 to 64 := 8;
	constant c_DATA_WIDTH    : natural range 1 to 64 := 32;

	-- clk and rst signals
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';

	-- dut signals

	-- avs_stimuli signals
	signal s_avalon_mm_readdata    : std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- -- avalon_mm.readdata
	signal s_avalon_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_avalon_mm_address     : std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
	signal s_avalon_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_mm_writedata   : std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- --          .writedata
	signal s_avalon_mm_read        : std_logic; --                                     --          .read

begin

	clk <= not clk after 5 ns;          -- 100 MHz
	rst <= '0' after 100 ns;

	-- avs_stimuli intantiation
	avs_stimuli_inst : entity work.avs_stimuli
		generic map(
			g_ADDRESS_WIDTH => c_ADDRESS_WIDTH,
			g_DATA_WIDTH    => c_DATA_WIDTH
		)
		port map(
			clk_i                   => clk,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_avalon_mm_readdata,
			avalon_mm_waitrequest_i => s_avalon_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_mm_address,
			avalon_mm_write_o       => s_avalon_mm_write,
			avalon_mm_writedata_o   => s_avalon_mm_writedata,
			avalon_mm_read_o        => s_avalon_mm_read
		);

		-- dut intantiation

end architecture RTL;
