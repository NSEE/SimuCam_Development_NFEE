-- USB_3_FTDI_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;
use work.ftdi_data_avalon_mm_pkg.all;

entity USB_3_FTDI_top is
	port(
		clock_sink_clk                  : in    std_logic                     := '0'; --          --          clock_sink.clk
		reset_sink_reset                : in    std_logic                     := '0'; --          --          reset_sink.reset
		umft_data_bus                   : inout std_logic_vector(31 downto 0) := (others => 'Z'); --   conduit_umft_pins.umft_data_signal
		umft_reset_n_pin                : out   std_logic; --                                     --                    .umft_reset_n_signal
		umft_rxf_n_pin                  : in    std_logic                     := '1'; --          --                    .umft_rxf_n_signal
		umft_clock_pin                  : in    std_logic                     := '1'; --          --                    .umft_clock_signal
		umft_wakeup_n_pin               : inout std_logic                     := 'Z'; --          --                    .umft_wakeup_n_signal
		umft_be_bus                     : inout std_logic_vector(3 downto 0)  := (others => 'Z'); --                    .umft_be_signal
		umft_txe_n_pin                  : in    std_logic                     := '1'; --          --                    .umft_txe_n_signal
		umft_gpio_bus                   : inout std_logic_vector(1 downto 0)  := (others => 'Z'); --                    .umft_gpio_bus_signal
		umft_wr_n_pin                   : out   std_logic; --                                     --                    .umft_wr_n_signal
		umft_rd_n_pin                   : out   std_logic; --                                     --                    .umft_rd_n_signal
		umft_oe_n_pin                   : out   std_logic; --                                     --                    .umft_oe_n_signal
		umft_siwu_n_pin                 : out   std_logic; --                                     --                    .umft_siwu_n_signal
		avalon_slave_config_address     : in    std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_slave_config.address
		avalon_slave_config_write       : in    std_logic                     := '0'; --          --                    .write
		avalon_slave_config_read        : in    std_logic                     := '0'; --          --                    .read
		avalon_slave_config_readdata    : out   std_logic_vector(31 downto 0); --                 --                    .readdata
		avalon_slave_config_writedata   : in    std_logic_vector(31 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_config_waitrequest : out   std_logic; --                                     --                    .waitrequest
		avalon_slave_config_byteenable  : in    std_logic_vector(3 downto 0)  := (others => '0'); --                    .byteenable
		avalon_slave_data_address       : in    std_logic_vector(9 downto 0)  := (others => '0'); --   avalon_slave_data.address
		avalon_slave_data_write         : in    std_logic                     := '0'; --          --                    .write
		avalon_slave_data_read          : in    std_logic                     := '0'; --          --                    .read
		avalon_slave_data_writedata     : in    std_logic_vector(63 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_data_readdata      : out   std_logic_vector(63 downto 0); --                 --                    .readdata
		avalon_slave_data_waitrequest   : out   std_logic --                                      --                    .waitrequest
	);
end entity USB_3_FTDI_top;

architecture rtl of USB_3_FTDI_top is

	-- Alias --

	-- Basic Alias
	alias a_avs_clock is clock_sink_clk;
	alias a_reset is reset_sink_reset;

	-- Constants --

	-- Signals --

	-- Config Avalon MM Signals
	signal s_config_avalon_mm_read_waitrequest  : std_logic;
	signal s_config_avalon_mm_write_waitrequest : std_logic;

	-- Config Avalon MM Registers Signals
	signal s_config_write_registers : t_ftdi_config_write_registers;
	signal s_config_read_registers  : t_ftdi_config_read_registers;

	-- Data Avalon MM Signals
	signal s_data_avalon_mm_read_waitrequest  : std_logic;
	signal s_data_avalon_mm_write_waitrequest : std_logic;

	-- Tx Data Buffer Signals
	signal s_tx_dbuffer_data_loaded : std_logic;
	signal s_tx_dbuffer_wrdata      : std_logic_vector(63 downto 0);
	signal s_tx_dbuffer_wrreq       : std_logic;
	signal s_tx_dbuffer_rdreq       : std_logic;
	signal s_tx_dbuffer_change      : std_logic;
	signal s_tx_dbuffer_stat_empty  : std_logic;
	signal s_tx_dbuffer_stat_full   : std_logic;
	signal s_tx_dbuffer_rddata      : std_logic_vector(63 downto 0);

	-- Tx DC Data FIFO Signals
	signal s_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	signal s_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	signal s_tx_dc_data_fifo_wrreq       : std_logic;
	signal s_tx_dc_data_fifo_wrempty     : std_logic;
	signal s_tx_dc_data_fifo_wrfull      : std_logic;
	signal s_tx_dc_data_fifo_wrusedw     : std_logic_vector(11 downto 0);

	-- Rx Data Buffer Signals	
	signal s_rx_dbuffer_data_loaded : std_logic;
	signal s_rx_dbuffer_wrdata      : std_logic_vector(63 downto 0);
	signal s_rx_dbuffer_wrreq       : std_logic;
	signal s_rx_dbuffer_rdreq       : std_logic;
	signal s_rx_dbuffer_change      : std_logic;
	signal s_rx_dbuffer_stat_empty  : std_logic;
	signal s_rx_dbuffer_stat_full   : std_logic;
	signal s_rx_dbuffer_rddata      : std_logic_vector(63 downto 0);

	-- Rx DC Data FIFO Signals
	signal s_rx_dc_data_fifo_rdreq       : std_logic;
	signal s_rx_dc_data_fifo_rddata_data : std_logic_vector(31 downto 0);
	signal s_rx_dc_data_fifo_rddata_be   : std_logic_vector(3 downto 0);
	signal s_rx_dc_data_fifo_rdempty     : std_logic;
	signal s_rx_dc_data_fifo_rdfull      : std_logic;
	signal s_rx_dc_data_fifo_rdusedw     : std_logic_vector(11 downto 0);

	-- TEST -- Remove Later

	signal s_test_tx_dc_data_fifo_aclr : std_logic;
	signal s_test_rx_dc_data_fifo_aclr : std_logic;

begin

	-- Config Avalon MM Read Instantiation
	ftdi_config_avalon_mm_read_ent_inst : entity work.ftdi_config_avalon_mm_read_ent
		port map(
			clk_i                               => a_avs_clock,
			rst_i                               => a_reset,
			ftdi_config_avalon_mm_i.address     => avalon_slave_config_address,
			ftdi_config_avalon_mm_i.read        => avalon_slave_config_read,
			ftdi_config_avalon_mm_i.byteenable  => avalon_slave_config_byteenable,
			ftdi_config_avalon_mm_o.readdata    => avalon_slave_config_readdata,
			ftdi_config_avalon_mm_o.waitrequest => s_config_avalon_mm_read_waitrequest,
			ftdi_config_write_registers_i       => s_config_write_registers,
			ftdi_config_read_registers_i        => s_config_read_registers
		);

	-- Config Avalon MM Write Instantiation
	ftdi_config_avalon_mm_write_ent_inst : entity work.ftdi_config_avalon_mm_write_ent
		port map(
			clk_i                               => a_avs_clock,
			rst_i                               => a_reset,
			ftdi_config_avalon_mm_i.address     => avalon_slave_config_address,
			ftdi_config_avalon_mm_i.write       => avalon_slave_config_write,
			ftdi_config_avalon_mm_i.writedata   => avalon_slave_config_writedata,
			ftdi_config_avalon_mm_i.byteenable  => avalon_slave_config_byteenable,
			ftdi_config_avalon_mm_o.waitrequest => s_config_avalon_mm_write_waitrequest,
			ftdi_config_write_registers_o       => s_config_write_registers
		);

	-- Tx Data Avalon MM Write Instantiation
	ftdi_tx_data_avalon_mm_write_ent_inst : entity work.ftdi_tx_data_avalon_mm_write_ent
		port map(
			clk_i                                => a_avs_clock,
			rst_i                                => a_reset,
			ftdi_tx_data_avalon_mm_i.address     => avalon_slave_data_address,
			ftdi_tx_data_avalon_mm_i.write       => avalon_slave_data_write,
			ftdi_tx_data_avalon_mm_i.writedata   => avalon_slave_data_writedata,
			buffer_stat_full_i                   => s_tx_dbuffer_stat_full,
			buffer_wrready_i                     => s_config_read_registers.tx_dbuffer_status_reg.wrready,
			ftdi_tx_data_avalon_mm_o.waitrequest => s_data_avalon_mm_write_waitrequest,
			buffer_data_loaded_o                 => s_tx_dbuffer_data_loaded,
			buffer_wrdata_o                      => s_tx_dbuffer_wrdata,
			buffer_wrreq_o                       => s_tx_dbuffer_wrreq
		);

	-- Tx (Double) Data Buffer Instantiation (Tx: FPGA => FTDI)	
	tx_data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			double_buffer_clear_i      => s_config_write_registers.general_control_reg.clear,
			double_buffer_stop_i       => s_config_write_registers.general_control_reg.stop,
			double_buffer_start_i      => s_config_write_registers.general_control_reg.start,
			buffer_data_loaded_i       => s_tx_dbuffer_data_loaded,
			buffer_cfg_length_i        => "10000000000",
			buffer_wrdata_i            => s_tx_dbuffer_wrdata,
			buffer_wrreq_i             => s_tx_dbuffer_wrreq,
			buffer_rdreq_i             => s_tx_dbuffer_rdreq,
			buffer_change_i            => s_tx_dbuffer_change,
			double_buffer_empty_o      => s_config_read_registers.tx_dbuffer_status_reg.empty,
			double_buffer_full_o       => s_config_read_registers.tx_dbuffer_status_reg.full,
			buffer_stat_almost_empty_o => open,
			buffer_stat_almost_full_o  => open,
			buffer_stat_empty_o        => s_tx_dbuffer_stat_empty,
			buffer_stat_full_o         => s_tx_dbuffer_stat_full,
			buffer_rddata_o            => s_tx_dbuffer_rddata,
			buffer_rdready_o           => s_config_read_registers.tx_dbuffer_status_reg.rdready,
			buffer_wrready_o           => s_config_read_registers.tx_dbuffer_status_reg.wrready
		);

	-- FTDI Data Transmitter Instantiation (Tx: FPGA => FTDI)	
	ftdi_data_transmitter_ent_inst : entity work.ftdi_data_transmitter_ent
		port map(
			clk_i                         => a_avs_clock,
			rst_i                         => a_reset,
			data_tx_stop_i                => s_config_write_registers.general_control_reg.stop,
			data_tx_start_i               => s_config_write_registers.general_control_reg.start,
			buffer_stat_empty_i           => s_tx_dbuffer_stat_empty,
			buffer_rddata_i               => s_tx_dbuffer_rddata,
			buffer_rdready_i              => s_config_read_registers.tx_dbuffer_status_reg.rdready,
			tx_dc_data_fifo_wrfull_i      => s_tx_dc_data_fifo_wrfull,
			tx_dc_data_fifo_wrusedw_i     => s_tx_dc_data_fifo_wrusedw,
			buffer_rdreq_o                => s_tx_dbuffer_rdreq,
			buffer_change_o               => s_tx_dbuffer_change,
			tx_dc_data_fifo_wrdata_data_o => s_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_o   => s_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_o       => s_tx_dc_data_fifo_wrreq
		);

	-- Rx Data Avalon MM Read Instantiation
	ftdi_rx_data_avalon_mm_read_ent_inst : entity work.ftdi_rx_data_avalon_mm_read_ent
		port map(
			clk_i                                => a_avs_clock,
			rst_i                                => a_reset,
			ftdi_rx_data_avalon_mm_i.address     => avalon_slave_data_address,
			ftdi_rx_data_avalon_mm_i.read        => avalon_slave_data_read,
			buffer_stat_empty_i                  => s_rx_dbuffer_stat_empty,
			buffer_rddata_i                      => s_rx_dbuffer_rddata,
			buffer_rdready_i                     => s_config_read_registers.rx_dbuffer_status_reg.rdready,
			ftdi_rx_data_avalon_mm_o.readdata    => avalon_slave_data_readdata,
			ftdi_rx_data_avalon_mm_o.waitrequest => s_data_avalon_mm_read_waitrequest,
			buffer_rdreq_o                       => s_rx_dbuffer_rdreq,
			buffer_change_o                      => s_rx_dbuffer_change
		);

	-- Rx (Double) Data Buffer Instantiation (Rx: FTDI => FPGA)
	rx_data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			double_buffer_clear_i      => s_config_write_registers.general_control_reg.clear,
			double_buffer_stop_i       => s_config_write_registers.general_control_reg.stop,
			double_buffer_start_i      => s_config_write_registers.general_control_reg.start,
			buffer_data_loaded_i       => s_rx_dbuffer_data_loaded,
			buffer_cfg_length_i        => "10000000000",
			buffer_wrdata_i            => s_rx_dbuffer_wrdata,
			buffer_wrreq_i             => s_rx_dbuffer_wrreq,
			buffer_rdreq_i             => s_rx_dbuffer_rdreq,
			buffer_change_i            => s_rx_dbuffer_change,
			double_buffer_empty_o      => s_config_read_registers.rx_dbuffer_status_reg.empty,
			double_buffer_full_o       => s_config_read_registers.rx_dbuffer_status_reg.full,
			buffer_stat_almost_empty_o => open,
			buffer_stat_almost_full_o  => open,
			buffer_stat_empty_o        => s_rx_dbuffer_stat_empty,
			buffer_stat_full_o         => s_rx_dbuffer_stat_full,
			buffer_rddata_o            => s_rx_dbuffer_rddata,
			buffer_rdready_o           => s_config_read_registers.rx_dbuffer_status_reg.rdready,
			buffer_wrready_o           => s_config_read_registers.rx_dbuffer_status_reg.wrready
		);

	-- FTDI Data Receiver Instantiation (Rx: FTDI => FPGA)
	ftdi_data_receiver_ent_inst : entity work.ftdi_data_receiver_ent
		port map(
			clk_i                         => a_avs_clock,
			rst_i                         => a_reset,
			data_rx_stop_i                => s_config_write_registers.general_control_reg.stop,
			data_rx_start_i               => s_config_write_registers.general_control_reg.start,
			rx_dc_data_fifo_rddata_data_i => s_rx_dc_data_fifo_rddata_data,
			rx_dc_data_fifo_rddata_be_i   => s_rx_dc_data_fifo_rddata_be,
			rx_dc_data_fifo_rdempty_i     => s_rx_dc_data_fifo_rdempty,
			rx_dc_data_fifo_rdusedw_i     => s_rx_dc_data_fifo_rdusedw,
			buffer_stat_full_i            => s_rx_dbuffer_stat_full,
			buffer_wrready_i              => s_config_read_registers.rx_dbuffer_status_reg.wrready,
			rx_dc_data_fifo_rdreq_o       => s_rx_dc_data_fifo_rdreq,
			buffer_data_loaded_o          => s_rx_dbuffer_data_loaded,
			buffer_wrdata_o               => s_rx_dbuffer_wrdata,
			buffer_wrreq_o                => s_rx_dbuffer_wrreq
		);

--		-- FTDI UMFT601A Controller Instantiation
--		ftdi_umft601a_controller_ent_inst : entity work.ftdi_umft601a_controller_ent
--			port map(
--				clk_i                         => a_avs_clock,
--				rst_i                         => a_reset,
--				umft_rxf_n_pin_i              => umft_rxf_n_pin,
--				umft_clock_pin_i              => umft_clock_pin,
--				umft_txe_n_pin_i              => umft_txe_n_pin,
--				tx_dc_data_fifo_wrdata_data_i => s_tx_dc_data_fifo_wrdata_data,
--				tx_dc_data_fifo_wrdata_be_i   => s_tx_dc_data_fifo_wrdata_be,
--				tx_dc_data_fifo_wrreq_i       => s_tx_dc_data_fifo_wrreq,
--				rx_dc_data_fifo_rdreq_i       => s_rx_dc_data_fifo_rdreq,
--				umft_data_bus_io              => umft_data_bus,
--				umft_wakeup_n_pin_io          => umft_wakeup_n_pin,
--				umft_be_bus_io                => umft_be_bus,
--				umft_gpio_bus_io              => umft_gpio_bus,
--				umft_reset_n_pin_o            => umft_reset_n_pin,
--				umft_wr_n_pin_o               => umft_wr_n_pin,
--				umft_rd_n_pin_o               => umft_rd_n_pin,
--				umft_oe_n_pin_o               => umft_oe_n_pin,
--				umft_siwu_n_pin_o             => umft_siwu_n_pin,
--				tx_dc_data_fifo_wrempty_o     => s_tx_dc_data_fifo_wrempty,
--				tx_dc_data_fifo_wrfull_o      => s_tx_dc_data_fifo_wrfull,
--				tx_dc_data_fifo_wrusedw_o     => s_tx_dc_data_fifo_wrusedw,
--				rx_dc_data_fifo_rddata_data_o => s_rx_dc_data_fifo_rddata_data,
--				rx_dc_data_fifo_rddata_be_o   => s_rx_dc_data_fifo_rddata_be,
--				rx_dc_data_fifo_rdempty_o     => s_rx_dc_data_fifo_rdempty,
--				rx_dc_data_fifo_rdfull_o      => s_rx_dc_data_fifo_rdfull,
--				rx_dc_data_fifo_rdusedw_o     => s_rx_dc_data_fifo_rdusedw
--			);

	-- TEST -- Remove Later

	-- tx dc data fifo instantiation, for data synchronization (fpga --> umft601a)
	ftdi_tx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
		port map(
			aclr              => s_test_tx_dc_data_fifo_aclr,
			data(35 downto 4) => s_tx_dc_data_fifo_wrdata_data,
			data(3 downto 0)  => s_tx_dc_data_fifo_wrdata_be,
			rdclk             => a_avs_clock,
			rdreq             => s_config_write_registers.test_fifo_control_reg.tx_rdreq,
			wrclk             => a_avs_clock,
			wrreq             => s_tx_dc_data_fifo_wrreq,
			q(35 downto 4)    => s_config_read_registers.test_fifo_status_reg.tx_rddata_data,
			q(3 downto 0)     => s_config_read_registers.test_fifo_status_reg.tx_rddata_be,
			rdempty           => s_config_read_registers.test_fifo_status_reg.tx_rdempty,
			rdfull            => s_config_read_registers.test_fifo_status_reg.tx_rdfull,
			rdusedw           => s_config_read_registers.test_fifo_status_reg.tx_rdusedw,
			wrempty           => s_tx_dc_data_fifo_wrempty,
			wrfull            => s_tx_dc_data_fifo_wrfull,
			wrusedw           => s_tx_dc_data_fifo_wrusedw
		);
	s_test_tx_dc_data_fifo_aclr <= (a_reset) or (s_config_write_registers.general_control_reg.clear);

	-- rx dc data fifo instantiation, for data synchronization (fpga <-- umft601a)
	ftdi_rx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
		port map(
			aclr              => s_test_rx_dc_data_fifo_aclr,
			data(35 downto 4) => s_config_write_registers.test_fifo_control_reg.rx_wrdata_data,
			data(3 downto 0)  => s_config_write_registers.test_fifo_control_reg.rx_wrdata_be,
			rdclk             => a_avs_clock,
			rdreq             => s_rx_dc_data_fifo_rdreq,
			wrclk             => a_avs_clock,
			wrreq             => s_config_write_registers.test_fifo_control_reg.rx_wrreq,
			q(35 downto 4)    => s_rx_dc_data_fifo_rddata_data,
			q(3 downto 0)     => s_rx_dc_data_fifo_rddata_be,
			rdempty           => s_rx_dc_data_fifo_rdempty,
			rdfull            => s_rx_dc_data_fifo_rdfull,
			rdusedw           => s_rx_dc_data_fifo_rdusedw,
			wrempty           => s_config_read_registers.test_fifo_status_reg.rx_wrempty,
			wrfull            => s_config_read_registers.test_fifo_status_reg.rx_wrfull,
			wrusedw           => s_config_read_registers.test_fifo_status_reg.rx_wrusedw
		);
	s_test_rx_dc_data_fifo_aclr <= (a_reset) or (s_config_write_registers.general_control_reg.clear);

	-- Signals Assignments --

	-- Config Avalon Assignments
	avalon_slave_config_waitrequest <= ((s_config_avalon_mm_read_waitrequest) and (s_config_avalon_mm_write_waitrequest)) when (a_reset = '0') else ('1');

	-- Data Avalon Assignments
	avalon_slave_data_waitrequest <= ((s_data_avalon_mm_read_waitrequest) and (s_data_avalon_mm_write_waitrequest)) when (a_reset = '0') else ('1');

end architecture rtl;                   -- of USB_3_FTDI_top
