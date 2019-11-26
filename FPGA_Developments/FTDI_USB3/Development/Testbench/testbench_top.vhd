library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_registers_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100Avs  : std_logic := '0';
	signal clk100Ftdi : std_logic := '1';
	signal rst        : std_logic := '1';

	-- dut signals

	-- usb_3_ftdi_top signals
	signal s_umft_data_bus                   : std_logic_vector(31 downto 0);
	signal s_umft_reset_n_pin                : std_logic;
	signal s_umft_rxf_n_pin                  : std_logic;
	signal s_umft_wakeup_n_pin               : std_logic;
	signal s_umft_be_bus                     : std_logic_vector(3 downto 0);
	signal s_umft_txe_n_pin                  : std_logic;
	signal s_umft_gpio_bus                   : std_logic_vector(1 downto 0);
	signal s_umft_wr_n_pin                   : std_logic;
	signal s_umft_rd_n_pin                   : std_logic;
	signal s_umft_oe_n_pin                   : std_logic;
	signal s_umft_siwu_n_pin                 : std_logic;
	signal s_avalon_slave_config_address     : std_logic_vector(7 downto 0);
	signal s_avalon_slave_config_write       : std_logic;
	signal s_avalon_slave_config_read        : std_logic;
	signal s_avalon_slave_config_readdata    : std_logic_vector(31 downto 0);
	signal s_avalon_slave_config_writedata   : std_logic_vector(31 downto 0);
	signal s_avalon_slave_config_waitrequest : std_logic;
	signal s_avalon_slave_config_byteenable  : std_logic_vector(3 downto 0);
	signal s_avalon_slave_data_address       : std_logic_vector(9 downto 0);
	signal s_avalon_slave_data_write         : std_logic;
	signal s_avalon_slave_data_read          : std_logic;
	signal s_avalon_slave_data_writedata     : std_logic_vector(255 downto 0);
	signal s_avalon_slave_data_readdata      : std_logic_vector(255 downto 0);
	signal s_avalon_slave_data_waitrequest   : std_logic;

	signal s_tx_avalon_slave_data_address : std_logic_vector(9 downto 0);
	signal s_rx_avalon_slave_data_address : std_logic_vector(9 downto 0);

	--dummy

begin

	clk100Avs  <= not clk100Avs after 5 ns; -- 100 MHz
	clk100Ftdi <= not clk100Ftdi after 5 ns; -- 100 MHz
	rst        <= '0' after 100 ns;

	tx_data_stimulli_inst : entity work.tx_data_stimulli
		generic map(
			g_ADDRESS_WIDTH => 10,
			g_DATA_WIDTH    => 256
		)
		port map(
			clk_i                   => clk100Avs,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_slave_data_waitrequest,
			avalon_mm_address_o     => s_tx_avalon_slave_data_address,
			avalon_mm_write_o       => s_avalon_slave_data_write,
			avalon_mm_writedata_o   => s_avalon_slave_data_writedata
		);

	rx_data_stimulli_inst : entity work.rx_data_stimulli
		generic map(
			g_ADDRESS_WIDTH => 10,
			g_DATA_WIDTH    => 256
		)
		port map(
			clk_i                   => clk100Avs,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_avalon_slave_data_readdata,
			avalon_mm_waitrequest_i => s_avalon_slave_data_waitrequest,
			avalon_mm_address_o     => s_rx_avalon_slave_data_address,
			avalon_mm_read_o        => s_avalon_slave_data_read
		);

	s_avalon_slave_data_address <= (s_tx_avalon_slave_data_address) or (s_rx_avalon_slave_data_address);

	usb3_fifo_master_stimuli_inst : entity work.usb3_fifo_master_stimuli
		port map(
			clk_i                => clk100Ftdi,
			rst_i                => rst,
			umft_wr_n_pin_i      => s_umft_wr_n_pin,
			umft_rd_n_pin_i      => s_umft_rd_n_pin,
			umft_oe_n_pin_i      => s_umft_oe_n_pin,
			umft_data_bus_io     => s_umft_data_bus,
			umft_wakeup_n_pin_io => s_umft_wakeup_n_pin,
			umft_be_bus_io       => s_umft_be_bus,
			umft_gpio_bus_io     => s_umft_gpio_bus,
			umft_rxf_n_pin_o     => s_umft_rxf_n_pin,
			umft_txe_n_pin_o     => s_umft_txe_n_pin
		);

	USB_3_FTDI_top_inst : entity work.ftdi_usb3_top
		generic map(
			g_FTDI_TESTBENCH_MODE => '1'
		)
		port map(
			clock_sink_clk                  => clk100Avs,
			ftdi_clock_sink_clk             => clk100Ftdi,
			reset_sink_reset                => rst,
			umft_data_bus                   => s_umft_data_bus,
			umft_reset_n_pin                => s_umft_reset_n_pin,
			umft_rxf_n_pin                  => s_umft_rxf_n_pin,
			umft_clock_pin                  => '0',
			umft_wakeup_n_pin               => s_umft_wakeup_n_pin,
			umft_be_bus                     => s_umft_be_bus,
			umft_txe_n_pin                  => s_umft_txe_n_pin,
			umft_gpio_bus                   => s_umft_gpio_bus,
			umft_wr_n_pin                   => s_umft_wr_n_pin,
			umft_rd_n_pin                   => s_umft_rd_n_pin,
			umft_oe_n_pin                   => s_umft_oe_n_pin,
			umft_siwu_n_pin                 => s_umft_siwu_n_pin,
			avalon_slave_config_address     => s_avalon_slave_config_address,
			avalon_slave_config_write       => s_avalon_slave_config_write,
			avalon_slave_config_read        => s_avalon_slave_config_read,
			avalon_slave_config_readdata    => s_avalon_slave_config_readdata,
			avalon_slave_config_writedata   => s_avalon_slave_config_writedata,
			avalon_slave_config_waitrequest => s_avalon_slave_config_waitrequest,
			avalon_slave_config_byteenable  => s_avalon_slave_config_byteenable,
			avalon_slave_data_address       => s_avalon_slave_data_address,
			avalon_slave_data_write         => s_avalon_slave_data_write,
			avalon_slave_data_read          => s_avalon_slave_data_read,
			avalon_slave_data_writedata     => s_avalon_slave_data_writedata,
			avalon_slave_data_readdata      => s_avalon_slave_data_readdata,
			avalon_slave_data_waitrequest   => s_avalon_slave_data_waitrequest
		);

end architecture RTL;
