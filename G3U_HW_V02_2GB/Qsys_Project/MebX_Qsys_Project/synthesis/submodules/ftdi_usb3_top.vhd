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
use work.ftdi_avm_usb3_pkg.all;
use work.ftdi_protocol_pkg.all;
use work.ftdi_irq_manager_pkg.all;

entity ftdi_usb3_top is
	generic(
		g_FTDI_TESTBENCH_MODE : std_logic := '0'
	);
	port(
		clock_sink_clk_i                  : in    std_logic                      := '0'; --          --               clock_sink.clk
		reset_sink_reset_i                : in    std_logic                      := '0'; --          --               reset_sink.reset
		umft601a_clock_sink_clk_i         : in    std_logic                      := '0'; --          --      umft601a_clock_sink.clk
		umft601a_clock_pin_i              : in    std_logic                      := '1'; --          --    conduit_umft601a_pins.umft_clock_signal
		umft601a_txe_n_pin_i              : in    std_logic                      := '1'; --          --                         .umft_txe_n_signal
		umft601a_rxf_n_pin_i              : in    std_logic                      := '1'; --          --                         .umft_rxf_n_signal
		umft601a_data_bus_io              : inout std_logic_vector(31 downto 0)  := (others => 'Z'); --                         .umft_data_signal
		umft601a_be_bus_io                : inout std_logic_vector(3 downto 0)   := (others => 'Z'); --                         .umft_be_signal
		umft601a_wakeup_n_pin_io          : inout std_logic                      := 'Z'; --          --                         .umft_wakeup_n_signal
		umft601a_gpio_bus_io              : inout std_logic_vector(1 downto 0)   := (others => 'Z'); --                         .umft_gpio_bus_signal
		umft601a_reset_n_pin_o            : out   std_logic; --                                      --                         .umft_reset_n_signal
		umft601a_wr_n_pin_o               : out   std_logic; --                                      --                         .umft_wr_n_signal
		umft601a_rd_n_pin_o               : out   std_logic; --                                      --                         .umft_rd_n_signal
		umft601a_oe_n_pin_o               : out   std_logic; --                                      --                         .umft_oe_n_signal
		umft601a_siwu_n_pin_o             : out   std_logic; --                                      --                         .umft_siwu_n_signal
		avalon_slave_config_address_i     : in    std_logic_vector(7 downto 0)   := (others => '0'); --      avalon_slave_config.address
		avalon_slave_config_byteenable_i  : in    std_logic_vector(3 downto 0)   := (others => '0'); --                         .byteenable
		avalon_slave_config_write_i       : in    std_logic                      := '0'; --          --                         .write
		avalon_slave_config_writedata_i   : in    std_logic_vector(31 downto 0)  := (others => '0'); --                         .writedata
		avalon_slave_config_read_i        : in    std_logic                      := '0'; --          --                         .read
		avalon_slave_config_readdata_o    : out   std_logic_vector(31 downto 0); --                  --                         .readdata
		avalon_slave_config_waitrequest_o : out   std_logic; --                                      --                         .waitrequest
		avalon_master_data_readdata_i     : in    std_logic_vector(255 downto 0) := (others => '0'); --       avalon_master_data.readdata
		avalon_master_data_waitrequest_i  : in    std_logic                      := '0'; --          --                         .waitrequest
		avalon_master_data_address_o      : out   std_logic_vector(63 downto 0); --                  --                         .address
		avalon_master_data_write_o        : out   std_logic; --                                      --                         .write
		avalon_master_data_writedata_o    : out   std_logic_vector(255 downto 0); --                 --                         .writedata
		avalon_master_data_read_o         : out   std_logic; --                                      --                         .read
		rx_interrupt_sender_irq_o         : out   std_logic; --                                      --      rx_interrupt_sender.irq
		tx_interrupt_sender_irq_o         : out   std_logic ---                                      --      tx_interrupt_sender.irq
	);
end entity ftdi_usb3_top;

architecture rtl of ftdi_usb3_top is

	-- Alias --

	-- Basic Alias
	alias a_avs_clock is clock_sink_clk_i;
	alias a_reset is reset_sink_reset_i;

	-- IRQ Alias --
	alias a_irq_rx is rx_interrupt_sender_irq_o;
	alias a_irq_tx is tx_interrupt_sender_irq_o;

	-- Constants --

	-- Signals --

	-- Config Avalon MM Signals
	signal s_config_avalon_mm_read_waitrequest  : std_logic;
	signal s_config_avalon_mm_write_waitrequest : std_logic;

	-- Config Avalon MM Registers Signals
	signal s_config_write_registers : t_ftdi_config_wr_registers;
	signal s_config_read_registers  : t_ftdi_config_rd_registers;

	-- FTDI USB3 AVM Controller Signals
	signal s_avm_usb3_master_rd_control   : t_ftdi_avm_usb3_master_rd_control;
	signal s_avm_usb3_master_rd_status    : t_ftdi_avm_usb3_master_rd_status;
	signal s_avm_slave_rd_control_address : std_logic_vector((c_FTDI_AVM_USB3_ADRESS_SIZE - 1) downto 0);
	signal s_avm_usb3_master_wr_control   : t_ftdi_avm_usb3_master_wr_control;
	signal s_avm_usb3_master_wr_status    : t_ftdi_avm_usb3_master_wr_status;
	signal s_avm_slave_wr_control_address : std_logic_vector((c_FTDI_AVM_USB3_ADRESS_SIZE - 1) downto 0);

	-- Tx Data Buffer Signals
	signal s_tx_buffer_wrdata     : std_logic_vector(255 downto 0);
	signal s_tx_buffer_wrreq      : std_logic;
	signal s_tx_buffer_rdreq      : std_logic;
	signal s_tx_buffer_stat_empty : std_logic;
	signal s_tx_buffer_stat_full  : std_logic;
	signal s_tx_buffer_wrready    : std_logic;
	signal s_tx_buffer_rddata     : std_logic_vector(255 downto 0);
	signal s_tx_buffer_rdready    : std_logic;

	-- Rx Data Buffer Signals	
	signal s_rx_buffer_data_loaded : std_logic;
	signal s_rx_buffer_wrdata      : std_logic_vector(255 downto 0);
	signal s_rx_buffer_wrreq       : std_logic;
	signal s_rx_buffer_rdreq       : std_logic;
	signal s_rx_buffer_stat_empty  : std_logic;
	signal s_rx_buffer_stat_full   : std_logic;
	signal s_rx_buffer_wrready     : std_logic;
	signal s_rx_buffer_rddata      : std_logic_vector(255 downto 0);
	signal s_rx_buffer_rdready     : std_logic;

	-- FTDI LUT Parameters Signals
	signal s_lut_winparams_ccd1_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;
	signal s_lut_winparams_ccd2_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;
	signal s_lut_winparams_ccd3_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;
	signal s_lut_winparams_ccd4_wincfg : t_ftdi_lut_winparams_ccdx_wincfg;

	-- UMFT601A Tx DC Data FIFO Signals
	signal s_umft601a_tx_dc_data_fifo_wrdata_data : std_logic_vector(31 downto 0);
	signal s_umft601a_tx_dc_data_fifo_wrdata_be   : std_logic_vector(3 downto 0);
	signal s_umft601a_tx_dc_data_fifo_wrreq       : std_logic;
	signal s_umft601a_tx_dc_data_fifo_wrempty     : std_logic;
	signal s_umft601a_tx_dc_data_fifo_wrfull      : std_logic;
	signal s_umft601a_tx_dc_data_fifo_wrusedw     : std_logic_vector(11 downto 0);

	-- UMFT601A Rx DC Data FIFO Signals
	signal s_umft601a_rx_dc_data_fifo_rdreq       : std_logic;
	signal s_umft601a_rx_dc_data_fifo_rddata_data : std_logic_vector(31 downto 0);
	signal s_umft601a_rx_dc_data_fifo_rddata_be   : std_logic_vector(3 downto 0);
	signal s_umft601a_rx_dc_data_fifo_rdempty     : std_logic;
	signal s_umft601a_rx_dc_data_fifo_rdfull      : std_logic;
	signal s_umft601a_rx_dc_data_fifo_rdusedw     : std_logic_vector(11 downto 0);

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
				avs_config_rd_readdata_o    => avalon_slave_config_readdata_o,
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
				ftdi_config_avalon_mm_i.address     => avalon_slave_config_address_i,
				ftdi_config_avalon_mm_i.read        => avalon_slave_config_read_i,
				ftdi_config_avalon_mm_i.byteenable  => avalon_slave_config_byteenable_i,
				ftdi_config_avalon_mm_o.readdata    => avalon_slave_config_readdata_o,
				ftdi_config_avalon_mm_o.waitrequest => s_config_avalon_mm_read_waitrequest,
				ftdi_config_wr_regs_i               => s_config_write_registers,
				ftdi_config_rd_regs_i               => s_config_read_registers
			);

		-- Config Avalon MM Write Instantiation
		ftdi_config_avalon_mm_write_ent_inst : entity work.ftdi_config_avalon_mm_write_ent
			port map(
				clk_i                               => a_avs_clock,
				rst_i                               => a_reset,
				ftdi_config_avalon_mm_i.address     => avalon_slave_config_address_i,
				ftdi_config_avalon_mm_i.write       => avalon_slave_config_write_i,
				ftdi_config_avalon_mm_i.writedata   => avalon_slave_config_writedata_i,
				ftdi_config_avalon_mm_i.byteenable  => avalon_slave_config_byteenable_i,
				ftdi_config_avalon_mm_o.waitrequest => s_config_avalon_mm_write_waitrequest,
				ftdi_config_wr_regs_o               => s_config_write_registers
			);

	end generate g_ftdi_avs_config_read_write;

	-- FTDI Avalon MM Master (AVM) Reader Instantiation (Tx: FPGA => FTDI)
	ftdi_avm_usb3_reader_ent_inst : entity work.ftdi_avm_usb3_reader_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_rd_control_i           => s_avm_usb3_master_rd_control,
			avm_slave_rd_status_i.readdata    => avalon_master_data_readdata_i,
			avm_slave_rd_status_i.waitrequest => avalon_master_data_waitrequest_i,
			avm_master_rd_status_o            => s_avm_usb3_master_rd_status,
			avm_slave_rd_control_o.address    => s_avm_slave_rd_control_address,
			avm_slave_rd_control_o.read       => avalon_master_data_read_o
		);

	-- FTDI Tx Avalon MM Master (AVM) Reader Controller Instantiation (Tx: FPGA => FTDI)
	ftdi_tx_avm_reader_controller_ent_inst : entity work.ftdi_tx_avm_reader_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			ftdi_module_stop_i                         => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			ftdi_module_start_i                        => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			controller_rd_start_i                      => s_config_write_registers.tx_data_control_reg.tx_rd_start,
			controller_rd_reset_i                      => s_config_write_registers.tx_data_control_reg.tx_rd_reset,
			controller_rd_initial_addr_i(63 downto 32) => s_config_write_registers.tx_data_control_reg.tx_rd_initial_addr_high_dword,
			controller_rd_initial_addr_i(31 downto 0)  => s_config_write_registers.tx_data_control_reg.tx_rd_initial_addr_low_dword,
			controller_rd_length_bytes_i               => s_config_write_registers.tx_data_control_reg.tx_rd_data_length_bytes,
			controller_wr_busy_i                       => s_config_read_registers.rx_data_status_reg.rx_wr_busy,
			avm_master_rd_status_i                     => s_avm_usb3_master_rd_status,
			buffer_stat_full_i                         => s_tx_buffer_stat_full,
			buffer_wrready_i                           => s_tx_buffer_wrready,
			controller_rd_busy_o                       => s_config_read_registers.tx_data_status_reg.tx_rd_busy,
			avm_master_rd_control_o                    => s_avm_usb3_master_rd_control,
			buffer_wrdata_o                            => s_tx_buffer_wrdata,
			buffer_wrreq_o                             => s_tx_buffer_wrreq
		);

	-- Tx Data Buffer Instantiation (Tx: FPGA => FTDI)	
	tx_data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			double_buffer_clear_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear,
			double_buffer_stop_i  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			double_buffer_start_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			buffer_wrdata_i       => s_tx_buffer_wrdata,
			buffer_wrreq_i        => s_tx_buffer_wrreq,
			buffer_rdreq_i        => s_tx_buffer_rdreq,
			buffer_wrable_o       => s_config_read_registers.tx_buffer_status_reg.tx_buffer_wrable,
			buffer_rdable_o       => open,
			buffer_empty_o        => s_config_read_registers.tx_buffer_status_reg.tx_buffer_empty,
			buffer_used_bytes_o   => s_config_read_registers.tx_buffer_status_reg.tx_buffer_used_bytes,
			buffer_full_o         => s_config_read_registers.tx_buffer_status_reg.tx_buffer_full,
			buffer_stat_empty_o   => s_tx_buffer_stat_empty,
			buffer_stat_full_o    => s_tx_buffer_stat_full,
			buffer_rddata_o       => s_tx_buffer_rddata,
			buffer_rdready_o      => s_tx_buffer_rdready,
			buffer_wrready_o      => s_tx_buffer_wrready
		);

	-- FTDI Avalon MM Master (AVM) Writer Instantiation (Rx: FTDI => FPGA)
	ftdi_avm_usb3_writer_ent_inst : entity work.ftdi_avm_usb3_writer_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_wr_control_i           => s_avm_usb3_master_wr_control,
			avm_slave_wr_status_i.waitrequest => avalon_master_data_waitrequest_i,
			avm_master_wr_status_o            => s_avm_usb3_master_wr_status,
			avm_slave_wr_control_o.address    => s_avm_slave_wr_control_address,
			avm_slave_wr_control_o.write      => avalon_master_data_write_o,
			avm_slave_wr_control_o.writedata  => avalon_master_data_writedata_o
		);

	-- FTDI Rx Avalon MM Master (AVM) Writer Controller Instantiation (Rx: FTDI => FPGA)
	ftdi_rx_avm_writer_controller_ent_inst : entity work.ftdi_rx_avm_writer_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			ftdi_module_stop_i                         => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			ftdi_module_start_i                        => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			controller_wr_start_i                      => s_config_write_registers.rx_data_control_reg.rx_wr_start,
			controller_wr_reset_i                      => s_config_write_registers.rx_data_control_reg.rx_wr_reset,
			controller_wr_initial_addr_i(63 downto 32) => s_config_write_registers.rx_data_control_reg.rx_wr_initial_addr_high_dword,
			controller_wr_initial_addr_i(31 downto 0)  => s_config_write_registers.rx_data_control_reg.rx_wr_initial_addr_low_dword,
			controller_wr_length_bytes_i               => s_config_write_registers.rx_data_control_reg.rx_wr_data_length_bytes,
			controller_rd_busy_i                       => s_config_read_registers.tx_data_status_reg.tx_rd_busy,
			avm_master_wr_status_i                     => s_avm_usb3_master_wr_status,
			buffer_stat_empty_i                        => s_rx_buffer_stat_empty,
			buffer_rddata_i                            => s_rx_buffer_rddata,
			buffer_rdready_i                           => s_rx_buffer_rdready,
			controller_wr_busy_o                       => s_config_read_registers.rx_data_status_reg.rx_wr_busy,
			avm_master_wr_control_o                    => s_avm_usb3_master_wr_control,
			buffer_rdreq_o                             => s_rx_buffer_rdreq
		);

	-- Rx Data Buffer Instantiation (Rx: FTDI => FPGA)
	rx_data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			double_buffer_clear_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear,
			double_buffer_stop_i  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			double_buffer_start_i => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			buffer_wrdata_i       => s_rx_buffer_wrdata,
			buffer_wrreq_i        => s_rx_buffer_wrreq,
			buffer_rdreq_i        => s_rx_buffer_rdreq,
			buffer_wrable_o       => open,
			buffer_rdable_o       => s_config_read_registers.rx_buffer_status_reg.rx_buffer_rdable,
			buffer_empty_o        => s_config_read_registers.rx_buffer_status_reg.rx_buffer_empty,
			buffer_used_bytes_o   => s_config_read_registers.rx_buffer_status_reg.rx_buffer_used_bytes,
			buffer_full_o         => s_config_read_registers.rx_buffer_status_reg.rx_buffer_full,
			buffer_stat_empty_o   => s_rx_buffer_stat_empty,
			buffer_stat_full_o    => s_rx_buffer_stat_full,
			buffer_rddata_o       => s_rx_buffer_rddata,
			buffer_rdready_o      => s_rx_buffer_rdready,
			buffer_wrready_o      => s_rx_buffer_wrready
		);

	-- FTDI Protocol Controller Instantiation
	ftdi_protocol_top_inst : entity work.ftdi_protocol_top
		port map(
			clk_i                                => a_avs_clock,
			rst_i                                => a_reset,
			ftdi_module_stop_i                   => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			ftdi_module_start_i                  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			rx_payload_reader_qqword_delay_i     => s_config_write_registers.payload_delay_reg.rx_payload_reader_qqword_delay,
			tx_payload_writer_qqword_delay_i     => s_config_write_registers.payload_delay_reg.tx_payload_writer_qqword_delay,
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
			tx_dc_data_fifo_wrempty_i            => s_umft601a_tx_dc_data_fifo_wrempty,
			tx_dc_data_fifo_wrfull_i             => s_umft601a_tx_dc_data_fifo_wrfull,
			tx_dc_data_fifo_wrusedw_i            => s_umft601a_tx_dc_data_fifo_wrusedw,
			rx_dc_data_fifo_rddata_data_i        => s_umft601a_rx_dc_data_fifo_rddata_data,
			rx_dc_data_fifo_rddata_be_i          => s_umft601a_rx_dc_data_fifo_rddata_be,
			rx_dc_data_fifo_rdempty_i            => s_umft601a_rx_dc_data_fifo_rdempty,
			rx_dc_data_fifo_rdfull_i             => s_umft601a_rx_dc_data_fifo_rdfull,
			rx_dc_data_fifo_rdusedw_i            => s_umft601a_rx_dc_data_fifo_rdusedw,
			tx_dbuffer_stat_empty_i              => s_tx_buffer_stat_empty,
			tx_dbuffer_rddata_i                  => s_tx_buffer_rddata,
			tx_dbuffer_rdready_i                 => s_tx_buffer_rdready,
			rx_dbuffer_stat_full_i               => s_rx_buffer_stat_full,
			rx_dbuffer_wrready_i                 => s_rx_buffer_wrready,
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
			tx_dc_data_fifo_wrdata_data_o        => s_umft601a_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_o          => s_umft601a_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_o              => s_umft601a_tx_dc_data_fifo_wrreq,
			rx_dc_data_fifo_rdreq_o              => s_umft601a_rx_dc_data_fifo_rdreq,
			tx_dbuffer_rdreq_o                   => s_tx_buffer_rdreq,
			tx_dbuffer_change_o                  => open,
			rx_dbuffer_data_loaded_o             => s_rx_buffer_data_loaded,
			rx_dbuffer_wrdata_o                  => s_rx_buffer_wrdata,
			rx_dbuffer_wrreq_o                   => s_rx_buffer_wrreq
		);

	-- FTDI UMFT601A Controller Instantiation
	ftdi_umft601a_controller_ent_inst : entity work.ftdi_umft601a_controller_ent
		port map(
			clk_i                         => a_avs_clock,
			ftdi_clk_i                    => umft601a_clock_sink_clk_i,
			rst_i                         => a_reset,
			ftdi_module_clear_i           => s_config_write_registers.ftdi_module_control_reg.ftdi_module_clear,
			ftdi_module_stop_i            => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			ftdi_module_start_i           => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			umft_rxf_n_pin_i              => umft601a_rxf_n_pin_i,
			umft_clock_pin_i              => umft601a_clock_pin_i,
			umft_txe_n_pin_i              => umft601a_txe_n_pin_i,
			tx_dc_data_fifo_wrdata_data_i => s_umft601a_tx_dc_data_fifo_wrdata_data,
			tx_dc_data_fifo_wrdata_be_i   => s_umft601a_tx_dc_data_fifo_wrdata_be,
			tx_dc_data_fifo_wrreq_i       => s_umft601a_tx_dc_data_fifo_wrreq,
			rx_dc_data_fifo_rdreq_i       => s_umft601a_rx_dc_data_fifo_rdreq,
			umft_data_bus_io              => umft601a_data_bus_io,
			umft_wakeup_n_pin_io          => umft601a_wakeup_n_pin_io,
			umft_be_bus_io                => umft601a_be_bus_io,
			umft_gpio_bus_io              => umft601a_gpio_bus_io,
			umft_reset_n_pin_o            => umft601a_reset_n_pin_o,
			umft_wr_n_pin_o               => umft601a_wr_n_pin_o,
			umft_rd_n_pin_o               => umft601a_rd_n_pin_o,
			umft_oe_n_pin_o               => umft601a_oe_n_pin_o,
			umft_siwu_n_pin_o             => umft601a_siwu_n_pin_o,
			tx_dc_data_fifo_wrempty_o     => s_umft601a_tx_dc_data_fifo_wrempty,
			tx_dc_data_fifo_wrfull_o      => s_umft601a_tx_dc_data_fifo_wrfull,
			tx_dc_data_fifo_wrusedw_o     => s_umft601a_tx_dc_data_fifo_wrusedw,
			rx_dc_data_fifo_rddata_data_o => s_umft601a_rx_dc_data_fifo_rddata_data,
			rx_dc_data_fifo_rddata_be_o   => s_umft601a_rx_dc_data_fifo_rddata_be,
			rx_dc_data_fifo_rdempty_o     => s_umft601a_rx_dc_data_fifo_rdempty,
			rx_dc_data_fifo_rdfull_o      => s_umft601a_rx_dc_data_fifo_rdfull,
			rx_dc_data_fifo_rdusedw_o     => s_umft601a_rx_dc_data_fifo_rdusedw
		);

	-- RX IRQ Manager
	ftdi_rx_irq_manager_ent_inst : entity work.ftdi_rx_irq_manager_ent
		port map(
			clk_i                                 => a_avs_clock,
			rst_i                                 => a_reset,
			irq_manager_stop_i                    => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			irq_manager_start_i                   => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			global_irq_en_i                       => s_config_write_registers.ftdi_irq_control_reg.ftdi_global_irq_en,
			irq_watches_i.rx_buffer_empty         => s_config_read_registers.rx_buffer_status_reg.rx_buffer_empty,
			irq_watches_i.rly_hccd_last_rx_buffer => s_config_read_registers.hccd_reply_status_reg.rly_hccd_last_rx_buffer,
			irq_watches_i.rx_hccd_comm_err_state  => s_config_read_registers.rx_comm_error_reg.rx_comm_err_state,
			irq_flags_en_i.rx_hccd_received       => s_config_write_registers.rx_irq_control_reg.rx_hccd_received_irq_en,
			irq_flags_en_i.rx_hccd_comm_err       => s_config_write_registers.rx_irq_control_reg.rx_hccd_comm_err_irq_en,
			irq_flags_clr_i.rx_hccd_received      => s_config_write_registers.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr,
			irq_flags_clr_i.rx_hccd_comm_err      => s_config_write_registers.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr,
			irq_flags_o.rx_hccd_received          => s_config_read_registers.rx_irq_flag_reg.rx_hccd_received_irq_flag,
			irq_flags_o.rx_hccd_comm_err          => s_config_read_registers.rx_irq_flag_reg.rx_hccd_comm_err_irq_flag,
			irq_o                                 => a_irq_rx
		);

	-- TX IRQ Manager
	ftdi_tx_irq_manager_ent_inst : entity work.ftdi_tx_irq_manager_ent
		port map(
			clk_i                               => a_avs_clock,
			rst_i                               => a_reset,
			irq_manager_stop_i                  => s_config_write_registers.ftdi_module_control_reg.ftdi_module_stop,
			irq_manager_start_i                 => s_config_write_registers.ftdi_module_control_reg.ftdi_module_start,
			global_irq_en_i                     => s_config_write_registers.ftdi_irq_control_reg.ftdi_global_irq_en,
			irq_watches_i.tx_lut_transmitted    => s_config_read_registers.lut_trans_status_reg.lut_transmitted,
			irq_watches_i.tx_lut_comm_err_state => s_config_read_registers.tx_comm_error_reg.tx_lut_comm_err_state,
			irq_flags_en_i.tx_lut_finished      => s_config_write_registers.tx_irq_control_reg.tx_lut_finished_irq_en,
			irq_flags_en_i.tx_lut_comm_err      => s_config_write_registers.tx_irq_control_reg.tx_lut_comm_err_irq_en,
			irq_flags_clr_i.tx_lut_finished     => s_config_write_registers.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear,
			irq_flags_clr_i.tx_lut_comm_err     => s_config_write_registers.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear,
			irq_flags_o.tx_lut_finished         => s_config_read_registers.tx_irq_flag_reg.tx_lut_finished_irq_flag,
			irq_flags_o.tx_lut_comm_err         => s_config_read_registers.tx_irq_flag_reg.tx_lut_comm_err_irq_flag,
			irq_o                               => a_irq_tx
		);

	-- Signals Assignments --

	-- Config Avalon Assignments
	avalon_slave_config_waitrequest_o <= ((s_config_avalon_mm_read_waitrequest) and (s_config_avalon_mm_write_waitrequest)) when (a_reset = '0') else ('1');

	-- Data Avalon Assignments
	avalon_master_data_address_o <= (s_avm_slave_rd_control_address) or (s_avm_slave_wr_control_address);

	-- FTDI Protocol Controller Assignments
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

end architecture rtl;                   -- of ftdi_usb3_top
