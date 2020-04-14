-- ftdi_usb3_top.vhd

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
use work.ftdi_protocol_pkg.all;

entity ftdi_usb3_top is
	generic(
		g_FTDI_TESTBENCH_MODE : std_logic := '0'
	);
	port(
		clock_sink_clk                  : in    std_logic                      := '0'; --          --               clock_sink.clk
		ftdi_clock_sink_clk             : in    std_logic                      := '0'; --          --          ftdi_clock_sink.clk
		reset_sink_reset                : in    std_logic                      := '0'; --          --               reset_sink.reset
		umft_data_bus                   : inout std_logic_vector(31 downto 0)  := (others => 'Z'); --        conduit_umft_pins.umft_data_signal
		umft_reset_n_pin                : out   std_logic; --                                      --                         .umft_reset_n_signal
		umft_rxf_n_pin                  : in    std_logic                      := '1'; --          --                         .umft_rxf_n_signal
		umft_clock_pin                  : in    std_logic                      := '1'; --          --                         .umft_clock_signal
		umft_wakeup_n_pin               : inout std_logic                      := 'Z'; --          --                         .umft_wakeup_n_signal
		umft_be_bus                     : inout std_logic_vector(3 downto 0)   := (others => 'Z'); --                         .umft_be_signal
		umft_txe_n_pin                  : in    std_logic                      := '1'; --          --                         .umft_txe_n_signal
		umft_gpio_bus                   : inout std_logic_vector(1 downto 0)   := (others => 'Z'); --                         .umft_gpio_bus_signal
		umft_wr_n_pin                   : out   std_logic; --                                      --                         .umft_wr_n_signal
		umft_rd_n_pin                   : out   std_logic; --                                      --                         .umft_rd_n_signal
		umft_oe_n_pin                   : out   std_logic; --                                      --                         .umft_oe_n_signal
		umft_siwu_n_pin                 : out   std_logic; --                                      --                         .umft_siwu_n_signal
		avalon_slave_config_address     : in    std_logic_vector(7 downto 0)   := (others => '0'); --      avalon_slave_config.address
		avalon_slave_config_write       : in    std_logic                      := '0'; --          --                         .write
		avalon_slave_config_read        : in    std_logic                      := '0'; --          --                         .read
		avalon_slave_config_readdata    : out   std_logic_vector(31 downto 0); --                  --                         .readdata
		avalon_slave_config_writedata   : in    std_logic_vector(31 downto 0)  := (others => '0'); --                         .writedata
		avalon_slave_config_waitrequest : out   std_logic; --                                      --                         .waitrequest
		avalon_slave_config_byteenable  : in    std_logic_vector(3 downto 0)   := (others => '0'); --                         .byteenable
		avalon_slave_data_address       : in    std_logic_vector(20 downto 0)  := (others => '0'); --        avalon_slave_data.address
		avalon_slave_data_write         : in    std_logic                      := '0'; --          --                         .write
		avalon_slave_data_read          : in    std_logic                      := '0'; --          --                         .read
		avalon_slave_data_writedata     : in    std_logic_vector(255 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_data_readdata      : out   std_logic_vector(255 downto 0); --                 --                         .readdata
		avalon_slave_data_waitrequest   : out   std_logic; --                                      --                         .waitrequest
		ftdi_rx_interrupt_sender_irq    : out   std_logic; --                                      -- ftdi_rx_interrupt_sender.irq
		ftdi_tx_interrupt_sender_irq    : out   std_logic ---                                      -- ftdi_tx_interrupt_sender.irq
	);
end entity ftdi_usb3_top;

architecture rtl of ftdi_usb3_top is

	-- Alias --

	-- Basic Alias
	alias a_avs_clock is clock_sink_clk;
	alias a_reset is reset_sink_reset;

	-- IRQ Alias --
	alias a_irq_rx is ftdi_rx_interrupt_sender_irq;
	alias a_irq_tx is ftdi_tx_interrupt_sender_irq;

	-- Constants --

	-- Signals --

	-- Config Avalon MM Signals
	signal s_config_avalon_mm_read_waitrequest  : std_logic;
	signal s_config_avalon_mm_write_waitrequest : std_logic;

	-- Config Avalon MM Registers Signals
	signal s_config_write_registers : t_ftdi_config_wr_registers;
	signal s_config_read_registers  : t_ftdi_config_rd_registers;

	-- Data Avalon MM Signals
	signal s_data_avalon_mm_read_waitrequest  : std_logic;
	signal s_data_avalon_mm_write_waitrequest : std_logic;

	-- Tx Data Buffer Signals
	signal s_tx_dbuffer_data_loaded : std_logic;
	signal s_tx_dbuffer_wrdata      : std_logic_vector(255 downto 0);
	signal s_tx_dbuffer_wrreq       : std_logic;
	signal s_tx_dbuffer_rdreq       : std_logic;
	signal s_tx_dbuffer_stat_empty  : std_logic;
	signal s_tx_dbuffer_stat_full   : std_logic;
	signal s_tx_dbuffer_wrready     : std_logic;
	signal s_tx_dbuffer_rddata      : std_logic_vector(255 downto 0);
	signal s_tx_dbuffer_rdready     : std_logic;

	-- Avalon Tx DC Data FIFO Signals
	signal s_avalon_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	signal s_avalon_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	signal s_avalon_tx_dc_data_fifo_wrreq       : std_logic;
	signal s_avalon_tx_dc_data_fifo_wrempty     : std_logic;
	signal s_avalon_tx_dc_data_fifo_wrfull      : std_logic;
	signal s_avalon_tx_dc_data_fifo_wrusedw     : std_logic_vector(11 downto 0);

	-- Rx Data Buffer Signals	
	signal s_rx_dbuffer_data_loaded : std_logic;
	signal s_rx_dbuffer_wrdata      : std_logic_vector(255 downto 0);
	signal s_rx_dbuffer_wrreq       : std_logic;
	signal s_rx_dbuffer_rdreq       : std_logic;
	signal s_rx_dbuffer_stat_empty  : std_logic;
	signal s_rx_dbuffer_stat_full   : std_logic;
	signal s_rx_dbuffer_wrready     : std_logic;
	signal s_rx_dbuffer_rddata      : std_logic_vector(255 downto 0);
	signal s_rx_dbuffer_rdready     : std_logic;

	-- Avalon Rx DC Data FIFO Signals
	signal s_avalon_rx_dc_data_fifo_rdreq       : std_logic;
	signal s_avalon_rx_dc_data_fifo_rddata_data : std_logic_vector(31 downto 0);
	signal s_avalon_rx_dc_data_fifo_rddata_be   : std_logic_vector(3 downto 0);
	signal s_avalon_rx_dc_data_fifo_rdempty     : std_logic;
	signal s_avalon_rx_dc_data_fifo_rdfull      : std_logic;
	signal s_avalon_rx_dc_data_fifo_rdusedw     : std_logic_vector(11 downto 0);

	-- FTDI Protocol Controller Top Signals
	signal s_lut_winparams_ccd1_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;
	signal s_lut_winparams_ccd2_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;
	signal s_lut_winparams_ccd3_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;
	signal s_lut_winparams_ccd4_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;

	-- Loopback Tx DC Data FIFO Signals
	--	signal s_loopback_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	--	signal s_loopback_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	--	signal s_loopback_tx_dc_data_fifo_wrreq       : std_logic;
	--	signal s_loopback_tx_dc_data_fifo_wrempty     : std_logic;
	--	signal s_loopback_tx_dc_data_fifo_wrfull      : std_logic;
	--	signal s_loopback_tx_dc_data_fifo_wrusedw     : std_logic_vector(11 downto 0);

	-- Loopback Rx DC Data FIFO Signals
	--	signal s_loopback_rx_dc_data_fifo_rdreq       : std_logic;
	--	signal s_loopback_rx_dc_data_fifo_rddata_data : std_logic_vector(31 downto 0);
	--	signal s_loopback_rx_dc_data_fifo_rddata_be   : std_logic_vector(3 downto 0);
	--	signal s_loopback_rx_dc_data_fifo_rdempty     : std_logic;
	--	signal s_loopback_rx_dc_data_fifo_rdfull      : std_logic;
	--	signal s_loopback_rx_dc_data_fifo_rdusedw     : std_logic_vector(11 downto 0);

	-- Tx/Rx Mux Signals
	--	signal s_tx_mux_select : std_logic_vector(1 downto 0);
	--	signal s_rx_mux_select : std_logic_vector(1 downto 0);

	-- FTDI Tx DC Data FIFO Signals
	--	signal s_ftdi_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	--	signal s_ftdi_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	--	signal s_ftdi_tx_dc_data_fifo_wrreq       : std_logic;
	--	signal s_ftdi_tx_dc_data_fifo_wrempty     : std_logic;
	--	signal s_ftdi_tx_dc_data_fifo_wrfull      : std_logic;
	--	signal s_ftdi_tx_dc_data_fifo_wrusedw     : std_logic_vector(11 downto 0);

	-- FTDI Rx DC Data FIFO Signals
	--	signal s_ftdi_rx_dc_data_fifo_rdreq       : std_logic;
	--	signal s_ftdi_rx_dc_data_fifo_rddata_data : std_logic_vector(31 downto 0);
	--	signal s_ftdi_rx_dc_data_fifo_rddata_be   : std_logic_vector(3 downto 0);
	--	signal s_ftdi_rx_dc_data_fifo_rdempty     : std_logic;
	--	signal s_ftdi_rx_dc_data_fifo_rdfull      : std_logic;
	--	signal s_ftdi_rx_dc_data_fifo_rdusedw     : std_logic_vector(11 downto 0);

	-- TEST -- Remove Later

	--	signal s_test_tx_dc_data_fifo_aclr : std_logic;
	--	signal s_test_rx_dc_data_fifo_aclr : std_logic;

	signal s_rx_payload_written_flag : std_logic;

	signal s_rx_buffer_0_rdable_delayed : std_logic;
	signal s_rx_buffer_1_rdable_delayed : std_logic;
	signal s_rx_dbuffer_rdable_delayed  : std_logic;
	signal s_rx_payload_written_delayed : std_logic;
	signal s_rx_buffer_empty_delayed    : std_logic;
	signal s_rx_comm_err_delayed        : std_logic;

	signal s_tx_lut_finished_delayed : std_logic;
	signal s_tx_lut_comm_err_delayed : std_logic;

begin

	-- Config Avalon MM Testbench Stimulli Generate
	g_ftdi_avs_config_testbench_stimulli : if (g_FTDI_TESTBENCH_MODE = '1') generate

		-- Config Avalon MM Testbench Stimulli
		ftdi_config_avalon_mm_stimulli_inst : entity work.ftdi_config_avalon_mm_stimulli
			port map(
				clk_i                       => a_avs_clock,
				rst_i                       => a_reset,
				avs_config_rd_regs_i        => s_config_read_registers,
				avs_config_wr_regs_o        => s_config_write_registers,
				avs_config_rd_readdata_o    => avalon_slave_config_readdata,
				avs_config_rd_waitrequest_o => s_config_avalon_mm_read_waitrequest,
				avs_config_wr_waitrequest_o => s_config_avalon_mm_write_waitrequest
			);

	end generate g_ftdi_avs_config_testbench_stimulli;

	-- Config Avalon MM Read and Write Generate
	g_ftdi_avs_config_read_write : if (g_FTDI_TESTBENCH_MODE = '0') generate

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
				ftdi_config_wr_regs_i               => s_config_write_registers,
				ftdi_config_rd_regs_i               => s_config_read_registers
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
				ftdi_config_wr_regs_o               => s_config_write_registers
			);

	end generate g_ftdi_avs_config_read_write;

	-- Tx Data Avalon MM Write Instantiation
	ftdi_tx_data_avalon_mm_write_ent_inst : entity work.ftdi_tx_data_avalon_mm_write_ent
		port map(
			clk_i                                => a_avs_clock,
			rst_i                                => a_reset,
			ftdi_tx_data_avalon_mm_i.address     => avalon_slave_data_address,
			ftdi_tx_data_avalon_mm_i.write       => avalon_slave_data_write,
			ftdi_tx_data_avalon_mm_i.writedata   => avalon_slave_data_writedata,
			buffer_stat_full_i                   => s_tx_dbuffer_stat_full,
			buffer_wrready_i                     => s_tx_dbuffer_wrready,
			ftdi_tx_data_avalon_mm_o.waitrequest => s_data_avalon_mm_write_waitrequest,
			buffer_data_loaded_o                 => s_tx_dbuffer_data_loaded,
			buffer_wrdata_o                      => s_tx_dbuffer_wrdata,
			buffer_wrreq_o                       => s_tx_dbuffer_wrreq
		);

	-- Tx (Double) Data Buffer Instantiation (Tx: FPGA => FTDI)	
	tx_data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			double_buffer_clear_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear,
			double_buffer_stop_i  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			double_buffer_start_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			buffer_wrdata_i       => s_tx_dbuffer_wrdata,
			buffer_wrreq_i        => s_tx_dbuffer_wrreq,
			buffer_rdreq_i        => s_tx_dbuffer_rdreq,
			buffer_wrable_o       => s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_wrable,
			buffer_rdable_o       => open,
			buffer_empty_o        => s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_empty,
			buffer_used_bytes_o   => open,
			buffer_full_o         => s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_full,
			buffer_stat_empty_o   => s_tx_dbuffer_stat_empty,
			buffer_stat_full_o    => s_tx_dbuffer_stat_full,
			buffer_rddata_o       => s_tx_dbuffer_rddata,
			buffer_rdready_o      => s_tx_dbuffer_rdready,
			buffer_wrready_o      => s_tx_dbuffer_wrready
		);
	s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_space_bytes  <= (others => '0');
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_0_wrable      <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_wrable;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_0_empty       <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_empty;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_0_space_bytes <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_space_bytes;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_0_full        <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_full;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_1_wrable      <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_wrable;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_1_empty       <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_empty;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_1_space_bytes <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_space_bytes;
	s_config_read_registers.tx_buffer_status_reg.tx_buffer_1_full        <= s_config_read_registers.tx_buffer_status_reg.tx_dbuffer_full;

	--	-- FTDI Data Transmitter Instantiation (Tx: FPGA => FTDI)	
	--	ftdi_data_transmitter_ent_inst : entity work.ftdi_data_transmitter_ent
	--		port map(
	--			clk_i                         => a_avs_clock,
	--			rst_i                         => a_reset,
	--			data_tx_stop_i                => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
	--			data_tx_start_i               => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
	--			buffer_stat_empty_i           => s_tx_dbuffer_stat_empty,
	--			buffer_rddata_i               => s_tx_dbuffer_rddata,
	--			buffer_rdready_i              => s_tx_dbuffer_rdready,
	--			tx_dc_data_fifo_wrfull_i      => s_avalon_tx_dc_data_fifo_wrfull,
	--			tx_dc_data_fifo_wrusedw_i     => s_avalon_tx_dc_data_fifo_wrusedw,
	--			buffer_rdreq_o                => s_tx_dbuffer_rdreq,
	--			buffer_change_o               => s_tx_dbuffer_change,
	--			tx_dc_data_fifo_wrdata_data_o => s_avalon_tx_dc_data_fifo_wrdata_data,
	--			tx_dc_data_fifo_wrdata_be_o   => s_avalon_tx_dc_data_fifo_wrdata_be,
	--			tx_dc_data_fifo_wrreq_o       => s_avalon_tx_dc_data_fifo_wrreq
	--		);

	-- Rx Data Avalon MM Read Instantiation
	ftdi_rx_data_avalon_mm_read_ent_inst : entity work.ftdi_rx_data_avalon_mm_read_ent
		port map(
			clk_i                                => a_avs_clock,
			rst_i                                => a_reset,
			data_rx_stop_i                       => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			data_rx_start_i                      => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			ftdi_rx_data_avalon_mm_i.address     => avalon_slave_data_address,
			ftdi_rx_data_avalon_mm_i.read        => avalon_slave_data_read,
			buffer_stat_empty_i                  => s_rx_dbuffer_stat_empty,
			buffer_rddata_i                      => s_rx_dbuffer_rddata,
			buffer_rdready_i                     => s_rx_dbuffer_rdready,
			ftdi_rx_data_avalon_mm_o.readdata    => avalon_slave_data_readdata,
			ftdi_rx_data_avalon_mm_o.waitrequest => s_data_avalon_mm_read_waitrequest,
			buffer_rdreq_o                       => s_rx_dbuffer_rdreq
		);

	-- Rx (Double) Data Buffer Instantiation (Rx: FTDI => FPGA)
	rx_data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			double_buffer_clear_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear,
			double_buffer_stop_i  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			double_buffer_start_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			buffer_wrdata_i       => s_rx_dbuffer_wrdata,
			buffer_wrreq_i        => s_rx_dbuffer_wrreq,
			buffer_rdreq_i        => s_rx_dbuffer_rdreq,
			buffer_wrable_o       => open,
			buffer_rdable_o       => s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_rdable,
			buffer_empty_o        => s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_empty,
			buffer_used_bytes_o   => s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_used_bytes,
			buffer_full_o         => s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_full,
			buffer_stat_empty_o   => s_rx_dbuffer_stat_empty,
			buffer_stat_full_o    => s_rx_dbuffer_stat_full,
			buffer_rddata_o       => s_rx_dbuffer_rddata,
			buffer_rdready_o      => s_rx_dbuffer_rdready,
			buffer_wrready_o      => s_rx_dbuffer_wrready
		);
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_0_rdable     <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_rdable;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_0_empty      <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_empty;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_0_used_bytes <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_used_bytes;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_0_full       <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_full;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_1_rdable     <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_rdable;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_1_empty      <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_empty;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_1_used_bytes <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_used_bytes;
	s_config_read_registers.rx_buffer_status_reg.rx_buffer_1_full       <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_full;

	--	-- FTDI Data Receiver Instantiation (Rx: FTDI => FPGA)
	--	ftdi_data_receiver_ent_inst : entity work.ftdi_data_receiver_ent
	--		port map(
	--			clk_i                         => a_avs_clock,
	--			rst_i                         => a_reset,
	--			data_rx_stop_i                => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
	--			data_rx_start_i               => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
	--			rx_dc_data_fifo_rddata_data_i => s_avalon_rx_dc_data_fifo_rddata_data,
	--			rx_dc_data_fifo_rddata_be_i   => s_avalon_rx_dc_data_fifo_rddata_be,
	--			rx_dc_data_fifo_rdempty_i     => s_avalon_rx_dc_data_fifo_rdempty,
	--			rx_dc_data_fifo_rdusedw_i     => s_avalon_rx_dc_data_fifo_rdusedw,
	--			buffer_stat_full_i            => s_rx_dbuffer_stat_full,
	--			buffer_wrready_i              => s_rx_dbuffer_wrready,
	--			rx_dc_data_fifo_rdreq_o       => s_avalon_rx_dc_data_fifo_rdreq,
	--			buffer_data_loaded_o          => s_rx_dbuffer_data_loaded,
	--			buffer_wrdata_o               => s_rx_dbuffer_wrdata,
	--			buffer_wrreq_o                => s_rx_dbuffer_wrreq
	--		);

	-- FTDI Protocol Controller Top Instantiation
	ftdi_protocol_top_inst : entity work.ftdi_protocol_top
		port map(
			clk_i                                => a_avs_clock,
			rst_i                                => a_reset,
			ftdi_module_stop_i                   => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			ftdi_module_start_i                  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			req_half_ccd_request_timeout_i       => s_config_write_registers.hccd_req_control_reg.req_hccd_req_timeout,
			req_half_ccd_fee_number_i            => s_config_write_registers.hccd_req_control_reg.req_hccd_fee_number,
			req_half_ccd_ccd_number_i            => s_config_write_registers.hccd_req_control_reg.req_hccd_ccd_number,
			req_half_ccd_ccd_side_i              => s_config_write_registers.hccd_req_control_reg.req_hccd_ccd_side,
			req_half_ccd_height_i                => s_config_write_registers.hccd_req_control_reg.req_hccd_ccd_height,
			req_half_ccd_width_i                 => s_config_write_registers.hccd_req_control_reg.req_hccd_ccd_width,
			req_half_ccd_exposure_number_i       => s_config_write_registers.hccd_req_control_reg.req_hccd_exposure_number,
			req_half_ccd_request_i               => s_config_write_registers.hccd_req_control_reg.req_request_hccd,
			req_half_ccd_abort_request_i         => s_config_write_registers.hccd_req_control_reg.req_abort_hccd_req,
			req_half_ccd_reset_controller_i      => s_config_write_registers.hccd_req_control_reg.req_reset_hccd_controller,
			trans_lut_transmission_timeout_i     => s_config_write_registers.lut_trans_control_reg.lut_trans_timeout,
			trans_lut_fee_number_i               => s_config_write_registers.lut_trans_control_reg.lut_fee_number,
			trans_lut_ccd_number_i               => s_config_write_registers.lut_trans_control_reg.lut_ccd_number,
			trans_lut_ccd_side_i                 => s_config_write_registers.lut_trans_control_reg.lut_ccd_side,
			trans_lut_height_i                   => s_config_write_registers.lut_trans_control_reg.lut_ccd_height,
			trans_lut_width_i                    => s_config_write_registers.lut_trans_control_reg.lut_ccd_width,
			trans_lut_exposure_number_i          => s_config_write_registers.lut_trans_control_reg.lut_exposure_number,
			trans_lut_payload_length_bytes_i     => s_config_write_registers.lut_trans_control_reg.lut_length_bytes,
			trans_lut_transmit_i                 => s_config_write_registers.lut_trans_control_reg.lut_transmit,
			trans_lut_abort_transmit_i           => s_config_write_registers.lut_trans_control_reg.lut_abort_transmission,
			trans_lut_reset_controller_i         => s_config_write_registers.lut_trans_control_reg.lut_reset_controller,
			lut_winparams_ccd1_wincfg_i          => s_lut_winparams_ccd1_wincfg,
			lut_winparams_ccd2_wincfg_i          => s_lut_winparams_ccd2_wincfg,
			lut_winparams_ccd3_wincfg_i          => s_lut_winparams_ccd3_wincfg,
			lut_winparams_ccd4_wincfg_i          => s_lut_winparams_ccd4_wincfg,
			tx_dc_data_fifo_wrempty_i            => s_avalon_tx_dc_data_fifo_wrempty,
			tx_dc_data_fifo_wrfull_i             => s_avalon_tx_dc_data_fifo_wrfull,
			tx_dc_data_fifo_wrusedw_i            => s_avalon_tx_dc_data_fifo_wrusedw,
			rx_dc_data_fifo_rddata_data_i        => s_avalon_rx_dc_data_fifo_rddata_data,
			rx_dc_data_fifo_rddata_be_i          => s_avalon_rx_dc_data_fifo_rddata_be,
			rx_dc_data_fifo_rdempty_i            => s_avalon_rx_dc_data_fifo_rdempty,
			rx_dc_data_fifo_rdfull_i             => s_avalon_rx_dc_data_fifo_rdfull,
			rx_dc_data_fifo_rdusedw_i            => s_avalon_rx_dc_data_fifo_rdusedw,
			tx_dbuffer_stat_empty_i              => s_tx_dbuffer_stat_empty,
			tx_dbuffer_rddata_i                  => s_tx_dbuffer_rddata,
			tx_dbuffer_rdready_i                 => s_tx_dbuffer_rdready,
			rx_dbuffer_stat_full_i               => s_rx_dbuffer_stat_full,
			rx_dbuffer_wrready_i                 => s_rx_dbuffer_wrready,
			rly_half_ccd_fee_number_o            => s_config_read_registers.hccd_reply_status_reg.rly_hccd_fee_number,
			rly_half_ccd_ccd_number_o            => s_config_read_registers.hccd_reply_status_reg.rly_hccd_ccd_number,
			rly_half_ccd_ccd_side_o              => s_config_read_registers.hccd_reply_status_reg.rly_hccd_ccd_side,
			rly_half_ccd_height_o                => s_config_read_registers.hccd_reply_status_reg.rly_hccd_ccd_height,
			rly_half_ccd_width_o                 => s_config_read_registers.hccd_reply_status_reg.rly_hccd_ccd_width,
			rly_half_ccd_exposure_number_o       => s_config_read_registers.hccd_reply_status_reg.rly_hccd_exposure_number,
			rly_half_ccd_image_length_bytes_o    => s_config_read_registers.hccd_reply_status_reg.rly_hccd_image_length_bytes,
			rly_half_ccd_received_o              => s_config_read_registers.hccd_reply_status_reg.rly_hccd_received,
			rly_half_ccd_controller_busy_o       => s_config_read_registers.hccd_reply_status_reg.rly_hccd_controller_busy,
			rly_half_ccd_last_rx_buffer_o        => s_config_read_registers.hccd_reply_status_reg.rly_hccd_last_rx_buffer,
			trans_lut_transmitted_o              => s_config_read_registers.lut_trans_status_reg.lut_transmitted,
			trans_lut_controller_busy_o          => s_config_read_registers.lut_trans_status_reg.lut_controller_busy,
			err_rx_comm_err_state_o              => s_config_read_registers.rx_comm_error_reg.rx_comm_err_state,
			err_rx_comm_err_code_o               => s_config_read_registers.rx_comm_error_reg.rx_comm_err_code,
			err_half_ccd_request_nack_err_o      => s_config_read_registers.rx_comm_error_reg.err_hccd_req_nack_err,
			err_half_ccd_reply_header_crc_err_o  => s_config_read_registers.rx_comm_error_reg.err_hccd_reply_header_crc_err,
			err_half_ccd_reply_eoh_err_o         => s_config_read_registers.rx_comm_error_reg.err_hccd_reply_eoh_err,
			err_half_ccd_reply_payload_crc_err_o => s_config_read_registers.rx_comm_error_reg.err_hccd_reply_payload_crc_err,
			err_half_ccd_reply_eop_err_o         => s_config_read_registers.rx_comm_error_reg.err_hccd_reply_eop_err,
			err_half_ccd_req_max_tries_err_o     => s_config_read_registers.rx_comm_error_reg.err_hccd_req_max_tries_err,
			err_half_ccd_reply_ccd_size_err_o    => s_config_read_registers.rx_comm_error_reg.err_hccd_reply_ccd_size_err,
			err_half_ccd_req_timeout_err_o       => s_config_read_registers.rx_comm_error_reg.err_hccd_req_timeout_err,
			err_tx_comm_err_state_o              => s_config_read_registers.tx_comm_error_reg.tx_lut_comm_err_state,
			err_tx_comm_err_code_o               => s_config_read_registers.tx_comm_error_reg.tx_lut_comm_err_code,
			err_lut_transmit_nack_err_o          => s_config_read_registers.tx_comm_error_reg.err_lut_transmit_nack,
			err_lut_reply_eoh_err_o              => s_config_read_registers.tx_comm_error_reg.err_lut_reply_head_eoh,
			err_lut_reply_header_crc_err_o       => s_config_read_registers.tx_comm_error_reg.err_lut_reply_head_crc,
			err_lut_trans_max_tries_err_o        => s_config_read_registers.tx_comm_error_reg.err_lut_trans_max_tries,
			err_lut_payload_nack_err_o           => s_config_read_registers.tx_comm_error_reg.err_lut_payload_nack,
			err_lut_trans_timeout_err_o          => s_config_read_registers.tx_comm_error_reg.err_lut_trans_timeout,
			tx_dc_data_fifo_wrdata_data_o        => s_avalon_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_o          => s_avalon_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_o              => s_avalon_tx_dc_data_fifo_wrreq,
			rx_dc_data_fifo_rdreq_o              => s_avalon_rx_dc_data_fifo_rdreq,
			tx_dbuffer_rdreq_o                   => s_tx_dbuffer_rdreq,
			tx_dbuffer_change_o                  => open,
			rx_dbuffer_data_loaded_o             => s_rx_dbuffer_data_loaded,
			rx_dbuffer_wrdata_o                  => s_rx_dbuffer_wrdata,
			rx_dbuffer_wrreq_o                   => s_rx_dbuffer_wrreq
		);

	--	-- FTDI Data Loopback  Instantiation (Loopback: FTDI => FTDI)
	--	ftdi_data_loopback_ent_inst : entity work.ftdi_data_loopback_ent
	--		port map(
	--			clk_i                         => a_avs_clock,
	--			rst_i                         => a_reset,
	--			tx_dc_data_fifo_wrempty_i     => s_loopback_tx_dc_data_fifo_wrempty,
	--			tx_dc_data_fifo_wrfull_i      => s_loopback_tx_dc_data_fifo_wrfull,
	--			tx_dc_data_fifo_wrusedw_i     => s_loopback_tx_dc_data_fifo_wrusedw,
	--			rx_dc_data_fifo_rddata_data_i => s_loopback_rx_dc_data_fifo_rddata_data,
	--			rx_dc_data_fifo_rddata_be_i   => s_loopback_rx_dc_data_fifo_rddata_be,
	--			rx_dc_data_fifo_rdempty_i     => s_loopback_rx_dc_data_fifo_rdempty,
	--			rx_dc_data_fifo_rdfull_i      => s_loopback_rx_dc_data_fifo_rdfull,
	--			rx_dc_data_fifo_rdusedw_i     => s_loopback_rx_dc_data_fifo_rdusedw,
	--			tx_dc_data_fifo_wrdata_data_o => s_loopback_tx_dc_data_fifo_wrdata_data,
	--			tx_dc_data_fifo_wrdata_be_o   => s_loopback_tx_dc_data_fifo_wrdata_be,
	--			tx_dc_data_fifo_wrreq_o       => s_loopback_tx_dc_data_fifo_wrreq,
	--			rx_dc_data_fifo_rdreq_o       => s_loopback_rx_dc_data_fifo_rdreq
	--		);

	--	-- FTDI Tx Data Mux  Instantiation (Tx: FPGA => FTDI)
	--	ftdi_tx_data_mux_ent_inst : entity work.ftdi_tx_data_mux_ent
	--		port map(
	--			mux_scr_select_i               => s_tx_mux_select,
	--			mux_ftdi_tx_data_wrempty_i     => s_ftdi_tx_dc_data_fifo_wrempty,
	--			mux_ftdi_tx_data_wrfull_i      => s_ftdi_tx_dc_data_fifo_wrfull,
	--			mux_ftdi_tx_data_wrusedw_i     => s_ftdi_tx_dc_data_fifo_wrusedw,
	--			mux_scr0_tx_data_wrdata_data_i => s_avalon_tx_dc_data_fifo_wrdata_data,
	--			mux_scr0_tx_data_wrdata_be_i   => s_avalon_tx_dc_data_fifo_wrdata_be,
	--			mux_scr0_tx_data_wrreq_i       => s_avalon_tx_dc_data_fifo_wrreq,
	--			mux_scr1_tx_data_wrdata_data_i => s_loopback_tx_dc_data_fifo_wrdata_data,
	--			mux_scr1_tx_data_wrdata_be_i   => s_loopback_tx_dc_data_fifo_wrdata_be,
	--			mux_scr1_tx_data_wrreq_i       => s_loopback_tx_dc_data_fifo_wrreq,
	--			mux_ftdi_tx_data_wrdata_data_o => s_ftdi_tx_dc_data_fifo_wrdata_data,
	--			mux_ftdi_tx_data_wrdata_be_o   => s_ftdi_tx_dc_data_fifo_wrdata_be,
	--			mux_ftdi_tx_data_wrreq_o       => s_ftdi_tx_dc_data_fifo_wrreq,
	--			mux_scr0_tx_data_wrempty_o     => s_avalon_tx_dc_data_fifo_wrempty,
	--			mux_scr0_tx_data_wrfull_o      => s_avalon_tx_dc_data_fifo_wrfull,
	--			mux_scr0_tx_data_wrusedw_o     => s_avalon_tx_dc_data_fifo_wrusedw,
	--			mux_scr1_tx_data_wrempty_o     => s_loopback_tx_dc_data_fifo_wrempty,
	--			mux_scr1_tx_data_wrfull_o      => s_loopback_tx_dc_data_fifo_wrfull,
	--			mux_scr1_tx_data_wrusedw_o     => s_loopback_tx_dc_data_fifo_wrusedw
	--		);
	--
	--	-- FTDI Rx Data Mux  Instantiation (Rx: FTDI => FPGA)
	--	ftdi_rx_data_mux_ent_inst : entity work.ftdi_rx_data_mux_ent
	--		port map(
	--			mux_scr_select_i               => s_rx_mux_select,
	--			mux_ftdi_rx_data_rddata_data_i => s_ftdi_rx_dc_data_fifo_rddata_data,
	--			mux_ftdi_rx_data_rddata_be_i   => s_ftdi_rx_dc_data_fifo_rddata_be,
	--			mux_ftdi_rx_data_rdempty_i     => s_ftdi_rx_dc_data_fifo_rdempty,
	--			mux_ftdi_rx_data_rdfull_i      => s_ftdi_rx_dc_data_fifo_rdfull,
	--			mux_ftdi_rx_data_rdusedw_i     => s_ftdi_rx_dc_data_fifo_rdusedw,
	--			mux_scr0_rx_data_rdreq_i       => s_avalon_rx_dc_data_fifo_rdreq,
	--			mux_scr1_rx_data_rdreq_i       => s_loopback_rx_dc_data_fifo_rdreq,
	--			mux_ftdi_rx_data_rdreq_o       => s_ftdi_rx_dc_data_fifo_rdreq,
	--			mux_scr0_rx_data_rddata_data_o => s_avalon_rx_dc_data_fifo_rddata_data,
	--			mux_scr0_rx_data_rddata_be_o   => s_avalon_rx_dc_data_fifo_rddata_be,
	--			mux_scr0_rx_data_rdempty_o     => s_avalon_rx_dc_data_fifo_rdempty,
	--			mux_scr0_rx_data_rdfull_o      => s_avalon_rx_dc_data_fifo_rdfull,
	--			mux_scr0_rx_data_rdusedw_o     => s_avalon_rx_dc_data_fifo_rdusedw,
	--			mux_scr1_rx_data_rddata_data_o => s_loopback_rx_dc_data_fifo_rddata_data,
	--			mux_scr1_rx_data_rddata_be_o   => s_loopback_rx_dc_data_fifo_rddata_be,
	--			mux_scr1_rx_data_rdempty_o     => s_loopback_rx_dc_data_fifo_rdempty,
	--			mux_scr1_rx_data_rdfull_o      => s_loopback_rx_dc_data_fifo_rdfull,
	--			mux_scr1_rx_data_rdusedw_o     => s_loopback_rx_dc_data_fifo_rdusedw
	--		);

	-- FTDI UMFT601A Controller Instantiation
	ftdi_umft601a_controller_ent_inst : entity work.ftdi_umft601a_controller_ent
		port map(
			clk_i                         => a_avs_clock,
			ftdi_clk_i                    => ftdi_clock_sink_clk,
			rst_i                         => a_reset,
			ftdi_module_clear_i           => s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear,
			ftdi_module_stop_i            => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			ftdi_module_start_i           => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			umft_rxf_n_pin_i              => umft_rxf_n_pin,
			umft_clock_pin_i              => umft_clock_pin,
			umft_txe_n_pin_i              => umft_txe_n_pin,
			tx_dc_data_fifo_wrdata_data_i => s_avalon_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_i   => s_avalon_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_i       => s_avalon_tx_dc_data_fifo_wrreq,
			rx_dc_data_fifo_rdreq_i       => s_avalon_rx_dc_data_fifo_rdreq,
			umft_data_bus_io              => umft_data_bus,
			umft_wakeup_n_pin_io          => umft_wakeup_n_pin,
			umft_be_bus_io                => umft_be_bus,
			umft_gpio_bus_io              => umft_gpio_bus,
			umft_reset_n_pin_o            => umft_reset_n_pin,
			umft_wr_n_pin_o               => umft_wr_n_pin,
			umft_rd_n_pin_o               => umft_rd_n_pin,
			umft_oe_n_pin_o               => umft_oe_n_pin,
			umft_siwu_n_pin_o             => umft_siwu_n_pin,
			tx_dc_data_fifo_wrempty_o     => s_avalon_tx_dc_data_fifo_wrempty,
			tx_dc_data_fifo_wrfull_o      => s_avalon_tx_dc_data_fifo_wrfull,
			tx_dc_data_fifo_wrusedw_o     => s_avalon_tx_dc_data_fifo_wrusedw,
			rx_dc_data_fifo_rddata_data_o => s_avalon_rx_dc_data_fifo_rddata_data,
			rx_dc_data_fifo_rddata_be_o   => s_avalon_rx_dc_data_fifo_rddata_be,
			rx_dc_data_fifo_rdempty_o     => s_avalon_rx_dc_data_fifo_rdempty,
			rx_dc_data_fifo_rdfull_o      => s_avalon_rx_dc_data_fifo_rdfull,
			rx_dc_data_fifo_rdusedw_o     => s_avalon_rx_dc_data_fifo_rdusedw
		);

	-- TEST -- Remove Later

	--	-- tx dc data fifo instantiation, for data synchronization (fpga --> umft601a)
	--	ftdi_tx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
	--		port map(
	--			aclr              => s_test_tx_dc_data_fifo_aclr,
	--			data(35 downto 4) => s_tx_dc_data_fifo_wrdata_data,
	--			data(3 downto 0)  => s_tx_dc_data_fifo_wrdata_be,
	--			rdclk             => a_avs_clock,
	--			rdreq             => s_config_write_registers.test_fifo_control_reg.tx_rdreq,
	--			wrclk             => a_avs_clock,
	--			wrreq             => s_tx_dc_data_fifo_wrreq,
	--			q(35 downto 4)    => s_config_read_registers.test_fifo_status_reg.tx_rddata_data,
	--			q(3 downto 0)     => s_config_read_registers.test_fifo_status_reg.tx_rddata_be,
	--			rdempty           => s_config_read_registers.test_fifo_status_reg.tx_rdempty,
	--			rdfull            => s_config_read_registers.test_fifo_status_reg.tx_rdfull,
	--			rdusedw           => s_config_read_registers.test_fifo_status_reg.tx_rdusedw,
	--			wrempty           => s_tx_dc_data_fifo_wrempty,
	--			wrfull            => s_tx_dc_data_fifo_wrfull,
	--			wrusedw           => s_tx_dc_data_fifo_wrusedw
	--		);
	--	s_test_tx_dc_data_fifo_aclr <= (a_reset) or (s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear);
	--
	--	-- rx dc data fifo instantiation, for data synchronization (fpga <-- umft601a)
	--	ftdi_rx_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
	--		port map(
	--			aclr              => s_test_rx_dc_data_fifo_aclr,
	--			data(35 downto 4) => s_config_write_registers.test_fifo_control_reg.rx_wrdata_data,
	--			data(3 downto 0)  => s_config_write_registers.test_fifo_control_reg.rx_wrdata_be,
	--			rdclk             => a_avs_clock,
	--			rdreq             => s_rx_dc_data_fifo_rdreq,
	--			wrclk             => a_avs_clock,
	--			wrreq             => s_config_write_registers.test_fifo_control_reg.rx_wrreq,
	--			q(35 downto 4)    => s_rx_dc_data_fifo_rddata_data,
	--			q(3 downto 0)     => s_rx_dc_data_fifo_rddata_be,
	--			rdempty           => s_rx_dc_data_fifo_rdempty,
	--			rdfull            => s_rx_dc_data_fifo_rdfull,
	--			rdusedw           => s_rx_dc_data_fifo_rdusedw,
	--			wrempty           => s_config_read_registers.test_fifo_status_reg.rx_wrempty,
	--			wrfull            => s_config_read_registers.test_fifo_status_reg.rx_wrfull,
	--			wrusedw           => s_config_read_registers.test_fifo_status_reg.rx_wrusedw
	--		);
	--	s_test_rx_dc_data_fifo_aclr <= (a_reset) or (s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear);

	-- RX IRQ Manager (need to become a module)
	p_rx_irq_manager : process(a_avs_clock, a_reset) is
		variable v_started             : std_logic := '0';
		variable v_last_rx_buffer      : std_logic := '0';
		variable v_last_rx_buffer_full : std_logic := '0';
	begin
		if (a_reset) = '1' then
			s_config_read_registers.rx_irq_flag_reg.rx_buffer_0_rdable_irq_flag    <= '0';
			s_config_read_registers.rx_irq_flag_reg.rx_buffer_1_rdable_irq_flag    <= '0';
			s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_rdable_irq_flag <= '0';
			s_rx_payload_written_flag                                              <= '0';
			s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag  <= '0';
			s_config_read_registers.rx_irq_flag_reg.rx_comm_err_irq_flag           <= '0';
			s_rx_buffer_0_rdable_delayed                                           <= '0';
			s_rx_buffer_1_rdable_delayed                                           <= '0';
			s_rx_payload_written_delayed                                           <= '0';
			s_rx_buffer_empty_delayed                                              <= '0';
			s_rx_comm_err_delayed                                                  <= '0';
			v_started                                                              := '0';
			v_last_rx_buffer                                                       := '0';
			v_last_rx_buffer_full                                                  := '0';
		elsif rising_edge(a_avs_clock) then

			-- manage start/stop
			if (s_config_write_registers.ftdi_module_control_reg.ftdi_module_start = '1') then
				v_started := '1';
			elsif (s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop = '1') then
				v_started := '0';
			end if;

			-- set last buffer variable
			if (s_config_read_registers.hccd_reply_status_reg.rly_hccd_last_rx_buffer = '1') then
				v_last_rx_buffer := '1';
			end if;

			if (v_started = '0') then
				-- keep flags cleared
				s_config_read_registers.rx_irq_flag_reg.rx_buffer_0_rdable_irq_flag    <= '0';
				s_config_read_registers.rx_irq_flag_reg.rx_buffer_1_rdable_irq_flag    <= '0';
				s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_rdable_irq_flag <= '0';
				s_rx_payload_written_flag                                              <= '0';
				s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag  <= '0';
				s_config_read_registers.rx_irq_flag_reg.rx_comm_err_irq_flag           <= '0';
				v_last_rx_buffer                                                       := '0';
				v_last_rx_buffer_full                                                  := '0';
			else
				-- clear flags --
				if (s_config_write_registers.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr = '1') then
					s_config_read_registers.rx_irq_flag_reg.rx_buffer_0_rdable_irq_flag <= '0';
				end if;
				if (s_config_write_registers.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr = '1') then
					s_config_read_registers.rx_irq_flag_reg.rx_buffer_1_rdable_irq_flag <= '0';
				end if;
				if (s_config_write_registers.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr = '1') then
					s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_rdable_irq_flag <= '0';
				end if;
				if (s_config_write_registers.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr = '1') then
					s_rx_payload_written_flag                                             <= '0';
					s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag <= '0';
				end if;
				if (s_config_write_registers.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr = '1') then
					s_config_read_registers.rx_irq_flag_reg.rx_comm_err_irq_flag <= '0';
				end if;
				-- set flags --
				-- check if the global interrupt is enabled
				if (s_config_write_registers.ftdi_irq_control_reg.ftdi_global_irq_en = '1') then
					if (s_config_write_registers.rx_irq_control_reg.rx_buffer_0_rdable_irq_en = '1') then
						if ((s_rx_buffer_0_rdable_delayed = '0') and (s_config_read_registers.rx_buffer_status_reg.rx_buffer_0_rdable = '1') and (v_last_rx_buffer = '0')) then
							--							s_config_read_registers.rx_irq_flag_reg.rx_buffer_0_rdable_irq_flag <= '1';
						end if;
					end if;
					if (s_config_write_registers.rx_irq_control_reg.rx_buffer_1_rdable_irq_en = '1') then
						if ((s_rx_buffer_1_rdable_delayed = '0') and (s_config_read_registers.rx_buffer_status_reg.rx_buffer_1_rdable = '1') and (v_last_rx_buffer = '0')) then
							--							s_config_read_registers.rx_irq_flag_reg.rx_buffer_1_rdable_irq_flag <= '1';
						end if;

					end if;
					if (s_config_write_registers.rx_irq_control_reg.rx_buffer_last_rdable_irq_en = '1') then
						if ((s_rx_dbuffer_rdable_delayed = '0') and (s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_rdable = '1') and (v_last_rx_buffer = '1')) then
							--							s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_rdable_irq_flag <= '1';
							v_last_rx_buffer := '0';
						end if;

					end if;
					--					if (s_config_write_registers.rx_irq_control_reg.rx_buffer_last_empty_irq_en = '1') then
					--						if ((s_rx_buffer_empty_delayed = '0') and (s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_empty = '1') and (v_last_rx_buffer_full = '1')) then
					--							s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag <= '1';
					--							v_last_rx_buffer                                                      := '0';
					--							v_last_rx_buffer_full                                                 := '0';
					--						end if;

					if (s_config_write_registers.rx_irq_control_reg.rx_buffer_last_empty_irq_en = '1') then
						if (s_rx_payload_written_delayed = '0') and (s_config_read_registers.hccd_reply_status_reg.rly_hccd_last_rx_buffer = '1') then
							s_rx_payload_written_flag <= '1';
						end if;
						if ((s_rx_buffer_empty_delayed = '0') and (s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_empty = '1') and (s_rx_payload_written_flag = '1')) then
							s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag <= '1';
						end if;
					end if;

					if (s_config_write_registers.rx_irq_control_reg.rx_comm_err_irq_en = '1') then
						if ((s_rx_comm_err_delayed = '0') and (s_config_read_registers.rx_comm_error_reg.rx_comm_err_state = '1')) then
							s_config_read_registers.rx_irq_flag_reg.rx_comm_err_irq_flag <= '1';
						end if;

					end if;
				end if;
			end if;

			-- delay signals
			s_rx_buffer_0_rdable_delayed <= s_config_read_registers.rx_buffer_status_reg.rx_buffer_0_rdable;
			s_rx_buffer_1_rdable_delayed <= s_config_read_registers.rx_buffer_status_reg.rx_buffer_1_rdable;
			s_rx_dbuffer_rdable_delayed  <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_rdable;
			s_rx_payload_written_delayed <= s_config_read_registers.hccd_reply_status_reg.rly_hccd_last_rx_buffer;
			s_rx_buffer_empty_delayed    <= s_config_read_registers.rx_buffer_status_reg.rx_dbuffer_empty;
			s_rx_comm_err_delayed        <= s_config_read_registers.rx_comm_error_reg.rx_comm_err_state;

		end if;
	end process p_rx_irq_manager;
	a_irq_rx <= ('0') when (a_reset = '1')
	            else ('1') when ((s_config_read_registers.rx_irq_flag_reg.rx_buffer_0_rdable_irq_flag = '1') or (s_config_read_registers.rx_irq_flag_reg.rx_buffer_1_rdable_irq_flag = '1') or (s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_rdable_irq_flag = '1') or (s_config_read_registers.rx_irq_flag_reg.rx_buffer_last_empty_irq_flag = '1') or (s_config_read_registers.rx_irq_flag_reg.rx_comm_err_irq_flag = '1'))
	            else ('0');

	-- TX IRQ Manager (need to become a module)
	p_tx_irq_manager : process(a_avs_clock, a_reset) is
		variable v_started : std_logic := '0';
	begin
		if (a_reset) = '1' then
			s_config_read_registers.tx_irq_flag_reg.tx_lut_finished_irq_flag <= '0';
			s_config_read_registers.tx_irq_flag_reg.tx_lut_comm_err_irq_flag <= '0';
			s_tx_lut_finished_delayed                                        <= '0';
			s_tx_lut_comm_err_delayed                                        <= '0';
			v_started                                                        := '0';
		elsif rising_edge(a_avs_clock) then

			-- manage start/stop
			if (s_config_write_registers.ftdi_module_control_reg.ftdi_module_start = '1') then
				v_started := '1';
			elsif (s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop = '1') then
				v_started := '0';
			end if;

			-- manage flags
			if (v_started = '0') then
				-- keep flags cleared
				s_config_read_registers.tx_irq_flag_reg.tx_lut_finished_irq_flag <= '0';
				s_config_read_registers.tx_irq_flag_reg.tx_lut_comm_err_irq_flag <= '0';
			else
				-- clear flags --
				if (s_config_write_registers.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear = '1') then
					s_config_read_registers.tx_irq_flag_reg.tx_lut_finished_irq_flag <= '0';
				end if;
				if (s_config_write_registers.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear = '1') then
					s_config_read_registers.tx_irq_flag_reg.tx_lut_comm_err_irq_flag <= '0';
				end if;
				-- set flags --
				-- check if the global interrupt is enabled
				if (s_config_write_registers.ftdi_irq_control_reg.ftdi_global_irq_en = '1') then
					if (s_config_write_registers.tx_irq_control_reg.tx_lut_finished_irq_en = '1') then
						if (s_tx_lut_finished_delayed = '0') and (s_config_read_registers.lut_trans_status_reg.lut_transmitted = '1') then
							s_config_read_registers.tx_irq_flag_reg.tx_lut_finished_irq_flag <= '1';
						end if;
					end if;
					if (s_config_write_registers.tx_irq_control_reg.tx_lut_comm_err_irq_en = '1') then
						if (s_tx_lut_comm_err_delayed = '0') and (s_config_read_registers.tx_comm_error_reg.tx_lut_comm_err_state = '1') then
							s_config_read_registers.tx_irq_flag_reg.tx_lut_comm_err_irq_flag <= '1';
						end if;
					end if;
				end if;
			end if;

			-- delay signals
			s_tx_lut_finished_delayed <= s_config_read_registers.lut_trans_status_reg.lut_transmitted;
			s_tx_lut_comm_err_delayed <= s_config_read_registers.tx_comm_error_reg.tx_lut_comm_err_state;

		end if;
	end process p_tx_irq_manager;
	a_irq_tx <= ('0') when (a_reset = '1')
	            else ('1') when ((s_config_read_registers.tx_irq_flag_reg.tx_lut_finished_irq_flag = '1') or (s_config_read_registers.tx_irq_flag_reg.tx_lut_comm_err_irq_flag = '1'))
	            else ('0');

	-- Signals Assignments --

	-- Config Avalon Assignments
	avalon_slave_config_waitrequest <= ((s_config_avalon_mm_read_waitrequest) and (s_config_avalon_mm_write_waitrequest)) when (a_reset = '0') else ('1');

	-- Data Avalon Assignments
	avalon_slave_data_waitrequest <= ((s_data_avalon_mm_read_waitrequest) and (s_data_avalon_mm_write_waitrequest)) when (a_reset = '0') else ('1');

	-- Tx/Rx Mux Assignments
	--	s_tx_mux_select <= ("01") when (s_config_write_registers.ftdi_module_control_reg.ftdi_module_loopback_en = '1') else ("00");
	--	s_rx_mux_select <= ("01") when (s_config_write_registers.ftdi_module_control_reg.ftdi_module_loopback_en = '1') else ("00");

	-- FTDI Protocol Controller Top Assignments
	s_lut_winparams_ccd1_wincfg.ccdx_window_list_pointer              <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer;
	s_lut_winparams_ccd1_wincfg.ccdx_packet_order_list_pointer        <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer;
	s_lut_winparams_ccd1_wincfg.ccdx_window_list_length(31 downto 16) <= (others => '0');
	s_lut_winparams_ccd1_wincfg.ccdx_window_list_length(15 downto 0)  <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length;
	s_lut_winparams_ccd1_wincfg.ccdx_windows_size_x(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd1_wincfg.ccdx_windows_size_x(5 downto 0)       <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x;
	s_lut_winparams_ccd1_wincfg.ccdx_windows_size_y(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd1_wincfg.ccdx_windows_size_y(5 downto 0)       <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y;
	s_lut_winparams_ccd1_wincfg.ccdx_last_e_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd1_wincfg.ccdx_last_e_packet(9 downto 0)        <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet;
	s_lut_winparams_ccd1_wincfg.ccdx_last_f_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd1_wincfg.ccdx_last_f_packet(9 downto 0)        <= s_config_write_registers.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet;
	s_lut_winparams_ccd2_wincfg.ccdx_window_list_pointer              <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer;
	s_lut_winparams_ccd2_wincfg.ccdx_packet_order_list_pointer        <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer;
	s_lut_winparams_ccd2_wincfg.ccdx_window_list_length(31 downto 16) <= (others => '0');
	s_lut_winparams_ccd2_wincfg.ccdx_window_list_length(15 downto 0)  <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length;
	s_lut_winparams_ccd2_wincfg.ccdx_windows_size_x(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd2_wincfg.ccdx_windows_size_x(5 downto 0)       <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x;
	s_lut_winparams_ccd2_wincfg.ccdx_windows_size_y(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd2_wincfg.ccdx_windows_size_y(5 downto 0)       <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y;
	s_lut_winparams_ccd2_wincfg.ccdx_last_e_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd2_wincfg.ccdx_last_e_packet(9 downto 0)        <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet;
	s_lut_winparams_ccd2_wincfg.ccdx_last_f_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd2_wincfg.ccdx_last_f_packet(9 downto 0)        <= s_config_write_registers.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet;
	s_lut_winparams_ccd3_wincfg.ccdx_window_list_pointer              <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer;
	s_lut_winparams_ccd3_wincfg.ccdx_packet_order_list_pointer        <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer;
	s_lut_winparams_ccd3_wincfg.ccdx_window_list_length(31 downto 16) <= (others => '0');
	s_lut_winparams_ccd3_wincfg.ccdx_window_list_length(15 downto 0)  <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length;
	s_lut_winparams_ccd3_wincfg.ccdx_windows_size_x(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd3_wincfg.ccdx_windows_size_x(5 downto 0)       <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x;
	s_lut_winparams_ccd3_wincfg.ccdx_windows_size_y(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd3_wincfg.ccdx_windows_size_y(5 downto 0)       <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y;
	s_lut_winparams_ccd3_wincfg.ccdx_last_e_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd3_wincfg.ccdx_last_e_packet(9 downto 0)        <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet;
	s_lut_winparams_ccd3_wincfg.ccdx_last_f_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd3_wincfg.ccdx_last_f_packet(9 downto 0)        <= s_config_write_registers.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet;
	s_lut_winparams_ccd4_wincfg.ccdx_window_list_pointer              <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer;
	s_lut_winparams_ccd4_wincfg.ccdx_packet_order_list_pointer        <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer;
	s_lut_winparams_ccd4_wincfg.ccdx_window_list_length(31 downto 16) <= (others => '0');
	s_lut_winparams_ccd4_wincfg.ccdx_window_list_length(15 downto 0)  <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length;
	s_lut_winparams_ccd4_wincfg.ccdx_windows_size_x(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd4_wincfg.ccdx_windows_size_x(5 downto 0)       <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x;
	s_lut_winparams_ccd4_wincfg.ccdx_windows_size_y(31 downto 6)      <= (others => '0');
	s_lut_winparams_ccd4_wincfg.ccdx_windows_size_y(5 downto 0)       <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y;
	s_lut_winparams_ccd4_wincfg.ccdx_last_e_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd4_wincfg.ccdx_last_e_packet(9 downto 0)        <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet;
	s_lut_winparams_ccd4_wincfg.ccdx_last_f_packet(31 downto 10)      <= (others => '0');
	s_lut_winparams_ccd4_wincfg.ccdx_last_f_packet(9 downto 0)        <= s_config_write_registers.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet;
	-- Reserved Signals Assignments

end architecture rtl;                   -- of ftdi_usb3_top
