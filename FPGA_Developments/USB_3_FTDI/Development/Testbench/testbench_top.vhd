library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100Avs  : std_logic := '0';
	signal clk100Ftdi : std_logic := '1';
	signal rst        : std_logic := '1';

	-- dut signals

	-- usb_3_ftdi_top signals
	signal s_umft_data_bus                    : std_logic_vector(31 downto 0);
	signal s_umft_reset_n_pin                 : std_logic;
	signal s_umft_rxf_n_pin                   : std_logic;
	signal s_umft_wakeup_n_pin                : std_logic;
	signal s_umft_be_bus                      : std_logic_vector(3 downto 0);
	signal s_umft_txe_n_pin                   : std_logic;
	signal s_umft_gpio_bus                    : std_logic_vector(1 downto 0);
	signal s_umft_wr_n_pin                    : std_logic;
	signal s_umft_rd_n_pin                    : std_logic;
	signal s_umft_oe_n_pin                    : std_logic;
	signal s_umft_siwu_n_pin                  : std_logic;
	signal s_avalon_burst_slave_address       : std_logic_vector(15 downto 0);
	signal s_avalon_burst_slave_read          : std_logic;
	signal s_avalon_burst_slave_readdata      : std_logic_vector(31 downto 0);
	signal s_avalon_burst_slave_waitrequest   : std_logic;
	signal s_avalon_burst_slave_burstcount    : std_logic_vector(7 downto 0);
	signal s_avalon_burst_slave_byteenable    : std_logic_vector(3 downto 0);
	signal s_avalon_burst_slave_readdatavalid : std_logic;
	signal s_avalon_burst_slave_write         : std_logic;
	signal s_avalon_burst_slave_writedata     : std_logic_vector(31 downto 0);

	--dummy

begin

	clk100Avs  <= not clk100Avs after 5 ns; -- 100 MHz
	clk100Ftdi <= not clk100Ftdi after 5 ns; -- 100 MHz
	rst        <= '0' after 100 ns;

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

	usb_3_ftdi_top_inst : entity work.USB_3_FTDI_top
		port map(
			clock_sink_clk                   => clk100Avs,
			reset_sink_reset                 => rst,
			umft_data_bus                    => s_umft_data_bus,
			umft_reset_n_pin                 => s_umft_reset_n_pin,
			umft_rxf_n_pin                   => s_umft_rxf_n_pin,
			umft_clock_pin                   => clk100Ftdi,
			umft_wakeup_n_pin                => s_umft_wakeup_n_pin,
			umft_be_bus                      => s_umft_be_bus,
			umft_txe_n_pin                   => s_umft_txe_n_pin,
			umft_gpio_bus                    => s_umft_gpio_bus,
			umft_wr_n_pin                    => s_umft_wr_n_pin,
			umft_rd_n_pin                    => s_umft_rd_n_pin,
			umft_oe_n_pin                    => s_umft_oe_n_pin,
			umft_siwu_n_pin                  => s_umft_siwu_n_pin,
			avalon_burst_slave_address       => s_avalon_burst_slave_address,
			avalon_burst_slave_read          => s_avalon_burst_slave_read,
			avalon_burst_slave_readdata      => s_avalon_burst_slave_readdata,
			avalon_burst_slave_waitrequest   => s_avalon_burst_slave_waitrequest,
			avalon_burst_slave_burstcount    => s_avalon_burst_slave_burstcount,
			avalon_burst_slave_byteenable    => s_avalon_burst_slave_byteenable,
			avalon_burst_slave_readdatavalid => s_avalon_burst_slave_readdatavalid,
			avalon_burst_slave_write         => s_avalon_burst_slave_write,
			avalon_burst_slave_writedata     => s_avalon_burst_slave_writedata
		);

end architecture RTL;
