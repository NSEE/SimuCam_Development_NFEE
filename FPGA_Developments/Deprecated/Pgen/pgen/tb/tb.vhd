library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb is
end entity tb;

architecture rtl of tb is
	-- clk and rst signals
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';

	-- avs_stimuli <-> dut signals
	-- Data port 64-bit
	signal s_avalon_mm_d_readdata    : std_logic_vector((c_DT_DATA_WIDTH - 1) downto 0);
	signal s_avalon_mm_d_waitrequest : std_logic;
	signal s_avalon_mm_d_address     : std_logic_vector((c_DT_ADDRESS_WIDTH - 1) downto 0);
	signal s_avalon_mm_d_read        : std_logic;
	-- Control port 32-bit
	signal s_avalon_mm_c_readdata    : std_logic_vector((c_CTR_DATA_WIDTH - 1) downto 0);
	signal s_avalon_mm_c_waitrequest : std_logic;
	signal s_avalon_mm_c_address     : std_logic_vector((c_CTR_ADDRESS_WIDTH - 1) downto 0);
	signal s_avalon_mm_c_write       : std_logic;
	signal s_avalon_mm_c_writedata   : std_logic_vector((c_CTR_DATA_WIDTH - 1) downto 0);
	signal s_avalon_mm_c_read        : std_logic;

begin
	-- Clock: 100 MHz
	clk <= not clk after 5 ns;
	-- Initial rst active level, release after that
	rst <= '0' after 100 ns;

	-- avs_stimuli instantiation
	avs_stimuli_inst : entity work.avs_stimuli
		generic map(
			g_CTR_ADDRESS_WIDTH => c_CTR_ADDRESS_WIDTH,
			g_CTR_DATA_WIDTH    => c_CTR_DATA_WIDTH,
			g_DT_ADDRESS_WIDTH  => c_DT_ADDRESS_WIDTH,
			g_DT_DATA_WIDTH     => c_DT_DATA_WIDTH
		)
		port map(
			clk_i                     => clk,
			rst_i                     => rst,
			-- Data port 64-bit
			avalon_mm_d_readdata_i    => s_avalon_mm_d_readdata,
			avalon_mm_d_waitrequest_i => s_avalon_mm_d_waitrequest,
			avalon_mm_d_address_o     => s_avalon_mm_d_address,
			avalon_mm_d_read_o        => s_avalon_mm_d_read,
			-- Control port 32-bit
			avalon_mm_c_readdata_i    => s_avalon_mm_c_readdata,
			avalon_mm_c_waitrequest_i => s_avalon_mm_c_waitrequest,
			avalon_mm_c_address_o     => s_avalon_mm_c_address,
			avalon_mm_c_write_o       => s_avalon_mm_c_write,
			avalon_mm_c_writedata_o   => s_avalon_mm_c_writedata,
			avalon_mm_c_read_o        => s_avalon_mm_c_read
		);

	-- dut instantiation
	pgen_component_ent_inst : entity work.pgen_component_ent
		port map(
			clock_i                               => clk,
			reset_i                               => rst,
			-- Data port 64-bit
			avalon_mm_data_slave_address_i        => s_avalon_mm_d_address,
			avalon_mm_data_slave_read_i           => s_avalon_mm_d_read,
			avalon_mm_data_slave_readdata_o       => s_avalon_mm_d_readdata,
			avalon_mm_data_slave_waitrequest_o    => s_avalon_mm_d_waitrequest,
			-- Control port 32-bit
			avalon_mm_control_slave_address_i     => s_avalon_mm_c_address,
			avalon_mm_control_slave_write_i       => s_avalon_mm_c_write,
			avalon_mm_control_slave_writedata_i   => s_avalon_mm_c_writedata,
			avalon_mm_control_slave_read_i        => s_avalon_mm_c_read,
			avalon_mm_control_slave_readdata_o    => s_avalon_mm_c_readdata,
			avalon_mm_control_slave_waitrequest_o => s_avalon_mm_c_waitrequest
		);

end architecture rtl;
