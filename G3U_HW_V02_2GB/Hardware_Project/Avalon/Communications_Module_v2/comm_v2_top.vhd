-- comm_v2_top.vhd

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

use work.avalon_mm_spacewire_pkg.all;
use work.comm_avm_buffers_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.spw_codec_pkg.all;
use work.rmap_target_pkg.all;
use work.windowing_dataset_pkg.all;
use work.comm_irq_manager_pkg.all;

entity comm_v2_top is
	generic(
		g_COMM_TESTBENCH_MODE   : std_logic := '0';
		g_COMM_OPERATIONAL_MODE : std_logic := '0' -- '0' = N-FEE Mode / '1' = F-FEE Mode  
	);
	port(
		reset_sink_reset_i                  : in  std_logic                      := '0'; --          --                              reset_sink.reset
		clock_sink_clk_i                    : in  std_logic                      := '0'; --          --                              clock_sink.clk
		channel_sync_i                      : in  std_logic                      := '0'; --          --                conduit_end_channel_sync.sync_signal
		avs_config_address_i                : in  std_logic_vector(7 downto 0)   := (others => '0'); --                  avalon_mm_config_slave.address
		avs_config_byteenable_i             : in  std_logic_vector(3 downto 0)   := (others => '0'); --                                        .byteenable
		avs_config_write_i                  : in  std_logic                      := '0'; --          --                                        .write
		avs_config_writedata_i              : in  std_logic_vector(31 downto 0)  := (others => '0'); --                                        .writedata
		avs_config_read_i                   : in  std_logic                      := '0'; --          --                                        .read
		avs_config_readdata_o               : out std_logic_vector(31 downto 0); --                  --                                        .readdata
		avs_config_waitrequest_o            : out std_logic; --                                      --                                        .waitrequest
		avm_left_buffer_readdata_i          : in  std_logic_vector(255 downto 0) := (others => '0'); --            avalon_mm_left_buffer_master.readdata
		avm_left_buffer_waitrequest_i       : in  std_logic                      := '0'; --          --                                        .waitrequest
		avm_left_buffer_address_o           : out std_logic_vector(63 downto 0); --                  --                                        .address
		avm_left_buffer_read_o              : out std_logic; --                                      --                                        .read
		avm_right_buffer_readdata_i         : in  std_logic_vector(255 downto 0) := (others => '0'); --           avalon_mm_right_buffer_master.readdata
		avm_right_buffer_waitrequest_i      : in  std_logic                      := '0'; --          --                                        .waitrequest
		avm_right_buffer_address_o          : out std_logic_vector(63 downto 0); --                  --                                        .address
		avm_right_buffer_read_o             : out std_logic; --                                      --                                        .read
		feeb_interrupt_sender_irq_o         : out std_logic; --                                      --                   feeb_interrupt_sender.irq
		rmap_interrupt_sender_irq_o         : out std_logic; --                                      --                   rmap_interrupt_sender.irq
		spw_link_status_started_i           : in  std_logic                      := '0'; --          --        conduit_end_spacewire_controller.spw_link_status_started_signal
		spw_link_status_connecting_i        : in  std_logic                      := '0'; --          --                                        .spw_link_status_connecting_signal
		spw_link_status_running_i           : in  std_logic                      := '0'; --          --                                        .spw_link_status_running_signal
		spw_link_error_errdisc_i            : in  std_logic                      := '0'; --          --                                        .spw_link_error_errdisc_signal
		spw_link_error_errpar_i             : in  std_logic                      := '0'; --          --                                        .spw_link_error_errpar_signal
		spw_link_error_erresc_i             : in  std_logic                      := '0'; --          --                                        .spw_link_error_erresc_signal
		spw_link_error_errcred_i            : in  std_logic                      := '0'; --          --                                        .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_i          : in  std_logic                      := '0'; --          --                                        .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_i          : in  std_logic_vector(1 downto 0)   := (others => '0'); --                                        .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_i          : in  std_logic_vector(5 downto 0)   := (others => '0'); --                                        .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_i        : in  std_logic                      := '0'; --          --                                        .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_i        : in  std_logic                      := '0'; --          --                                        .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_i         : in  std_logic                      := '0'; --          --                                        .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_i         : in  std_logic_vector(7 downto 0)   := (others => '0'); --                                        .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_i          : in  std_logic                      := '0'; --          --                                        .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_i        : in  std_logic                      := '0'; --          --                                        .spw_data_tx_status_txhalff_signal
		spw_link_command_autostart_o        : out std_logic; --                                      --                                        .spw_link_command_autostart_signal
		spw_link_command_linkstart_o        : out std_logic; --                                      --                                        .spw_link_command_linkstart_signal
		spw_link_command_linkdis_o          : out std_logic; --                                      --                                        .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_o         : out std_logic_vector(7 downto 0); --                   --                                        .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_o           : out std_logic; --                                      --                                        .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_o           : out std_logic_vector(1 downto 0); --                   --                                        .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_o           : out std_logic_vector(5 downto 0); --                   --                                        .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_o        : out std_logic; --                                      --                                        .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_o       : out std_logic; --                                      --                                        .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_o        : out std_logic; --                                      --                                        .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_o        : out std_logic_vector(7 downto 0); --                   --                                        .spw_data_tx_command_txdata_signal
		rmap_echo_echo_en_o                 : out std_logic; --                                      --               conduit_end_rmap_echo_out.echo_en_signal
		rmap_echo_echo_id_en_o              : out std_logic; --                                      --                                        .echo_id_en_signal
		rmap_echo_in_fifo_wrflag_o          : out std_logic; --                                      --                                        .in_fifo_wrflag_signal
		rmap_echo_in_fifo_wrdata_o          : out std_logic_vector(7 downto 0); --                   --                                        .in_fifo_wrdata_signal
		rmap_echo_in_fifo_wrreq_o           : out std_logic; --                                      --                                        .in_fifo_wrreq_signal
		rmap_echo_out_fifo_wrflag_o         : out std_logic; --                                      --                                        .out_fifo_wrflag_signal
		rmap_echo_out_fifo_wrdata_o         : out std_logic_vector(7 downto 0); --                   --                                        .out_fifo_wrdata_signal
		rmap_echo_out_fifo_wrreq_o          : out std_logic; --                                      --                                        .out_fifo_wrreq_signal
		rmm_rmap_target_wr_waitrequest_i    : in  std_logic                      := '0'; --          -- conduit_end_rmap_mem_master_rmap_target.wr_waitrequest_signal
		rmm_rmap_target_readdata_i          : in  std_logic_vector(7 downto 0)   := (others => '0'); --                                        .readdata_signal
		rmm_rmap_target_rd_waitrequest_i    : in  std_logic                      := '0'; --          --                                        .rd_waitrequest_signal
		rmm_rmap_target_wr_address_o        : out std_logic_vector(31 downto 0); --                  --                                        .wr_address_signal
		rmm_rmap_target_write_o             : out std_logic; --                                      --                                        .write_signal
		rmm_rmap_target_writedata_o         : out std_logic_vector(7 downto 0); --                   --                                        .writedata_signal
		rmm_rmap_target_rd_address_o        : out std_logic_vector(31 downto 0); --                  --                                        .rd_address_signal
		rmm_rmap_target_read_o              : out std_logic; --                                      --                                        .read_signal
		rmm_fee_hk_wr_waitrequest_i         : in  std_logic                      := '0'; --          --      conduit_end_rmap_mem_master_fee_hk.wr_waitrequest_signal
		rmm_fee_hk_readdata_i               : in  std_logic_vector(7 downto 0)   := (others => '0'); --                                        .readdata_signal
		rmm_fee_hk_rd_waitrequest_i         : in  std_logic                      := '0'; --          --                                        .rd_waitrequest_signal
		rmm_fee_hk_wr_address_o             : out std_logic_vector(31 downto 0); --                  --                                        .wr_address_signal
		rmm_fee_hk_write_o                  : out std_logic; --                                      --                                        .write_signal
		rmm_fee_hk_writedata_o              : out std_logic_vector(7 downto 0); --                   --                                        .writedata_signal
		rmm_fee_hk_rd_address_o             : out std_logic_vector(31 downto 0); --                  --                                        .rd_address_signal
		rmm_fee_hk_read_o                   : out std_logic; --                                      --                                        .read_signal
		channel_hk_timecode_control_o       : out std_logic_vector(1 downto 0); --                   --              conduit_end_channel_hk_out.timecode_control_signal
		channel_hk_timecode_time_o          : out std_logic_vector(5 downto 0); --                   --                                        .timecode_time_signal
		channel_hk_rmap_target_status_o     : out std_logic_vector(7 downto 0); --                   --                                        .rmap_target_status_signal
		channel_hk_rmap_target_indicate_o   : out std_logic; --                                      --                                        .rmap_target_indicate_signal
		channel_hk_spw_link_escape_err_o    : out std_logic; --                                      --                                        .spw_link_escape_err_signal
		channel_hk_spw_link_credit_err_o    : out std_logic; --                                      --                                        .spw_link_credit_err_signal
		channel_hk_spw_link_parity_err_o    : out std_logic; --                                      --                                        .spw_link_parity_err_signal
		channel_hk_spw_link_disconnect_o    : out std_logic; --                                      --                                        .spw_link_disconnect_signal
		channel_hk_spw_link_running_o       : out std_logic; --                                      --                                        .spw_link_running_signal
		channel_hk_frame_counter_o          : out std_logic_vector(15 downto 0); --                  --                                        .frame_counter_signal
		channel_hk_frame_number_o           : out std_logic_vector(1 downto 0); --                   --                                        .frame_number_signal
		channel_hk_err_win_wrong_x_coord_o  : out std_logic; --                                      --                                        .err_win_wrong_x_coord_signal
		channel_hk_err_win_wrong_y_coord_o  : out std_logic; --                                      --                                        .err_win_wrong_y_coord_signal
		channel_hk_err_e_side_buffer_full_o : out std_logic; --                                      --                                        .err_e_side_buffer_full_signal
		channel_hk_err_f_side_buffer_full_o : out std_logic; --                                      --                                        .err_f_side_buffer_full_signal
		channel_hk_err_invalid_ccd_mode_o   : out std_logic; --                                      --                                        .err_invalid_ccd_mode_signal
		channel_win_mem_addr_offset_o       : out std_logic_vector(63 downto 0); --                  --        conduit_end_rmap_avm_configs_out.win_mem_addr_offset_signal
		comm_measurements_o                 : out std_logic_vector(7 downto 0) ---                   --           conduit_end_comm_measurements.measurements_signal
	);
end entity comm_v2_top;

architecture rtl of comm_v2_top is

	-- dummy ports
	alias a_avs_clock is clock_sink_clk_i;
	alias a_reset is reset_sink_reset_i;

	-- constants

	-- signals

	signal rst_n : std_logic;

	-- windowing internal buffers empty
	signal s_R_buffer_empty : std_logic;
	signal s_L_buffer_empty : std_logic;

	-- windowing avalon mm read signals
	signal s_avalon_mm_windwoing_read_waitrequest : std_logic;

	-- windowing avalon mm write signals
	signal s_avalon_mm_windwoing_write_waitrequest : std_logic;

	-- windowing avalon mm registers signals
	signal s_spacewire_write_registers : t_windowing_write_registers;
	signal s_spacewire_read_registers  : t_windowing_read_registers;

	-- right windowing buffer signals
	signal s_R_window_data_read  : std_logic;
	signal s_R_window_mask_read  : std_logic;
	signal s_R_window_data_out   : std_logic_vector(15 downto 0);
	signal s_R_window_mask_out   : std_logic;
	signal s_R_window_data_valid : std_logic;
	signal s_R_window_mask_valid : std_logic;
	signal s_R_window_data_ready : std_logic;
	signal s_R_window_mask_ready : std_logic;

	-- left windowing buffer signals
	signal s_L_window_data_read  : std_logic;
	signal s_L_window_mask_read  : std_logic;
	signal s_L_window_data_out   : std_logic_vector(15 downto 0);
	signal s_L_window_mask_out   : std_logic;
	signal s_L_window_data_valid : std_logic;
	signal s_L_window_mask_valid : std_logic;
	signal s_L_window_data_ready : std_logic;
	signal s_L_window_mask_ready : std_logic;

	-- right fee data controller signals --
	-- windowing buffer right fee data controller signals
	signal s_R_fee_data_controller_window_data_read  : std_logic;
	signal s_R_fee_data_controller_window_mask_read  : std_logic;
	signal s_R_fee_data_controller_window_data_out   : std_logic_vector(15 downto 0);
	signal s_R_fee_data_controller_window_mask_out   : std_logic;
	signal s_R_fee_data_controller_window_data_valid : std_logic;
	signal s_R_fee_data_controller_window_mask_valid : std_logic;
	signal s_R_fee_data_controller_window_data_ready : std_logic;
	signal s_R_fee_data_controller_window_mask_ready : std_logic;

	-- left fee data controller signals --
	-- windowing buffer left fee data controller signals
	signal s_L_fee_data_controller_window_data_read  : std_logic;
	signal s_L_fee_data_controller_window_mask_read  : std_logic;
	signal s_L_fee_data_controller_window_data_out   : std_logic_vector(15 downto 0);
	signal s_L_fee_data_controller_window_mask_out   : std_logic;
	signal s_L_fee_data_controller_window_data_valid : std_logic;
	signal s_L_fee_data_controller_window_mask_valid : std_logic;
	signal s_L_fee_data_controller_window_data_ready : std_logic;
	signal s_L_fee_data_controller_window_mask_ready : std_logic;

	-- spw codec fee data controller signals
	signal s_fee_data_controller_spw_txrdy   : std_logic;
	signal s_fee_data_controller_spw_txwrite : std_logic;
	signal s_fee_data_controller_spw_txflag  : std_logic;
	signal s_fee_data_controller_spw_txdata  : std_logic_vector(7 downto 0);

	-- fee master data controller signals --
	-- rmap memory fee master data controller signals
	signal s_fee_rd_rmap_address : std_logic_vector(31 downto 0);
	signal s_fee_rd_rmap_read    : std_logic;

	-- fee slave data controller signals --
	signal s_fee_frame_counter : std_logic_vector(15 downto 0);
	signal s_fee_frame_number  : std_logic_vector(1 downto 0);

	-- rmap signals (TEMP)

	signal s_rmap_spw_control : t_rmap_target_spw_control;
	signal s_rmap_spw_flag    : t_rmap_target_spw_flag;

	signal s_rmap_mem_control : t_rmap_target_mem_control;
	signal s_rmap_mem_flag    : t_rmap_target_mem_flag;

	signal s_rmap_mem_wr_byte_address : std_logic_vector((32 + 0 - 1) downto 0);
	signal s_rmap_mem_rd_byte_address : std_logic_vector((32 + 0 - 1) downto 0);

	signal s_rmap_write_data_finished : std_logic;
	signal s_rmap_read_data_finished  : std_logic;

	signal s_rmap_win_area_write_flag : std_logic;

	constant c_COMM_NFEE_RMAP_WIN_OFFSET_BIT : natural := 23;

	-- timecode manager
	signal s_tx_timecode_tick : std_logic;

	-- sync edge detection
	signal s_ch_sync_trigger : std_logic;
	signal s_ch_sync_clear   : std_logic;

	-- spw mux
	-- "spw mux" to "codec" signals
	signal s_mux_rx_channel_command : t_spw_codec_data_rx_command;
	signal s_mux_rx_channel_status  : t_spw_codec_data_rx_status;
	signal s_mux_tx_channel_command : t_spw_codec_data_tx_command;
	signal s_mux_tx_channel_status  : t_spw_codec_data_tx_status;
	-- spw mux tx 1 signals
	signal s_mux_tx_1_command       : t_spw_codec_data_tx_command;
	signal s_mux_tx_1_status        : t_spw_codec_data_tx_status;
	-- spw mux tx 2 signals
	signal s_mux_tx_2_command       : t_spw_codec_data_tx_command;
	signal s_mux_tx_2_status        : t_spw_codec_data_tx_status;

	-- dummy
	signal s_dummy_spw_mux_rx0_rxhalff : std_logic;
	signal s_dummy_spw_mux_tx0_txhalff : std_logic;
	signal s_rx_timecode_tick          : std_logic;
	signal s_rx_timecode_control       : std_logic_vector(1 downto 0);
	signal s_rx_timecode_counter       : std_logic_vector(5 downto 0);

	signal s_right_side_activated : std_logic;
	signal s_left_side_activated  : std_logic;

	-- window double buffer
	signal s_R_window_buffer         : t_windowing_buffer;
	signal s_R_window_buffer_control : t_windowing_buffer_control;
	signal s_L_window_buffer         : t_windowing_buffer;
	signal s_L_window_buffer_control : t_windowing_buffer_control;

	-- avm
	signal s_avm_right_buffer_master_rd_control : t_comm_avm_buffers_master_rd_control;
	signal s_avm_right_buffer_master_rd_status  : t_comm_avm_buffers_master_rd_status;
	signal s_avm_left_buffer_master_rd_control  : t_comm_avm_buffers_master_rd_control;
	signal s_avm_left_buffer_master_rd_status   : t_comm_avm_buffers_master_rd_status;

	-- rmap hk
	signal s_fee_left_output_buffer_overflowed  : std_logic;
	signal s_fee_right_output_buffer_overflowed : std_logic;

begin

	-- reset_n creation
	rst_n <= not a_reset;

	-- windowing avalon mm read instantiation
	avalon_mm_spacewire_read_ent_inst : entity work.avalon_mm_spacewire_read_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avs_config_address_i,
			avalon_mm_spacewire_i.read        => avs_config_read_i,
			avalon_mm_spacewire_i.byteenable  => avs_config_byteenable_i,
			avalon_mm_spacewire_o.readdata    => avs_config_readdata_o,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_windwoing_read_waitrequest,
			spacewire_write_registers_i       => s_spacewire_write_registers,
			spacewire_read_registers_i        => s_spacewire_read_registers
		);

	-- windowing avalon mm write instantiation
	avalon_mm_spacewire_write_ent_inst : entity work.avalon_mm_spacewire_write_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avs_config_address_i,
			avalon_mm_spacewire_i.write       => avs_config_write_i,
			avalon_mm_spacewire_i.writedata   => avs_config_writedata_i,
			avalon_mm_spacewire_i.byteenable  => avs_config_byteenable_i,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_windwoing_write_waitrequest,
			spacewire_write_registers_o       => s_spacewire_write_registers
		);

	-- right avm buffers reader instantiation
	comm_right_avm_buffers_reader_ent_inst : entity work.comm_avm_buffers_reader_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_rd_control_i           => s_avm_right_buffer_master_rd_control,
			avm_slave_rd_status_i.readdata    => avm_right_buffer_readdata_i,
			avm_slave_rd_status_i.waitrequest => avm_right_buffer_waitrequest_i,
			avm_master_rd_status_o            => s_avm_right_buffer_master_rd_status,
			avm_slave_rd_control_o.address    => avm_right_buffer_address_o,
			avm_slave_rd_control_o.read       => avm_right_buffer_read_o
		);

	-- right avm buffers controller instantiation
	comm_right_avm_buffers_controller_ent_inst : entity work.comm_avm_buffers_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			fee_clear_signal_i                         => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_clear,
			fee_stop_signal_i                          => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			fee_start_signal_i                         => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			controller_rd_start_i                      => s_spacewire_write_registers.fee_buffers_data_control_reg.right_rd_start,
			controller_rd_reset_i                      => s_spacewire_write_registers.fee_buffers_data_control_reg.right_rd_reset,
			controller_rd_initial_addr_i(63 downto 32) => s_spacewire_write_registers.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword,
			controller_rd_initial_addr_i(31 downto 0)  => s_spacewire_write_registers.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword,
			controller_rd_length_bytes_i               => s_spacewire_write_registers.fee_buffers_data_control_reg.right_rd_data_length_bytes,
			avm_master_rd_status_i                     => s_avm_right_buffer_master_rd_status,
			window_buffer_control_i                    => s_R_window_buffer_control,
			controller_rd_busy_o                       => s_spacewire_read_registers.fee_buffers_data_status_reg.right_rd_busy,
			avm_master_rd_control_o                    => s_avm_right_buffer_master_rd_control,
			window_buffer_o                            => s_R_window_buffer
		);

	-- right windowing buffer instantiation
	right_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                   => a_avs_clock,
			rst_i                   => a_reset,
			fee_clear_signal_i      => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_clear,
			fee_stop_signal_i       => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			fee_start_signal_i      => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			fee_sync_signal_i       => s_ch_sync_trigger,
			window_buffer_i         => s_R_window_buffer,
			window_buffer_control_o => s_R_window_buffer_control,
			window_data_read_i      => s_R_window_data_read,
			window_mask_read_i      => s_R_window_mask_read,
			window_data_o           => s_R_window_data_out,
			window_mask_o           => s_R_window_mask_out,
			window_data_valid_o     => s_R_window_data_valid,
			window_mask_valid_o     => s_R_window_mask_valid,
			window_data_ready_o     => s_R_window_data_ready,
			window_mask_ready_o     => s_R_window_mask_ready,
			window_buffer_empty_o   => s_spacewire_read_registers.fee_buffers_status_reg.fee_right_buffer_empty,
			window_buffer_0_empty_o => s_R_buffer_empty,
			window_buffer_1_empty_o => open
		);

	-- left avm buffers reader instantiation
	comm_left_avm_buffers_reader_ent_inst : entity work.comm_avm_buffers_reader_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_rd_control_i           => s_avm_left_buffer_master_rd_control,
			avm_slave_rd_status_i.readdata    => avm_left_buffer_readdata_i,
			avm_slave_rd_status_i.waitrequest => avm_left_buffer_waitrequest_i,
			avm_master_rd_status_o            => s_avm_left_buffer_master_rd_status,
			avm_slave_rd_control_o.address    => avm_left_buffer_address_o,
			avm_slave_rd_control_o.read       => avm_left_buffer_read_o
		);

	-- left avm buffers controller instantiation
	comm_left_avm_buffers_controller_ent_inst : entity work.comm_avm_buffers_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			fee_clear_signal_i                         => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_clear,
			fee_stop_signal_i                          => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			fee_start_signal_i                         => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			controller_rd_start_i                      => s_spacewire_write_registers.fee_buffers_data_control_reg.left_rd_start,
			controller_rd_reset_i                      => s_spacewire_write_registers.fee_buffers_data_control_reg.left_rd_reset,
			controller_rd_initial_addr_i(63 downto 32) => s_spacewire_write_registers.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword,
			controller_rd_initial_addr_i(31 downto 0)  => s_spacewire_write_registers.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword,
			controller_rd_length_bytes_i               => s_spacewire_write_registers.fee_buffers_data_control_reg.left_rd_data_length_bytes,
			avm_master_rd_status_i                     => s_avm_left_buffer_master_rd_status,
			window_buffer_control_i                    => s_L_window_buffer_control,
			controller_rd_busy_o                       => s_spacewire_read_registers.fee_buffers_data_status_reg.left_rd_busy,
			avm_master_rd_control_o                    => s_avm_left_buffer_master_rd_control,
			window_buffer_o                            => s_L_window_buffer
		);

	-- left windowing buffer instantiation
	left_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                   => a_avs_clock,
			rst_i                   => a_reset,
			fee_clear_signal_i      => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_clear,
			fee_stop_signal_i       => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			fee_start_signal_i      => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			fee_sync_signal_i       => s_ch_sync_trigger,
			window_buffer_i         => s_L_window_buffer,
			window_buffer_control_o => s_L_window_buffer_control,
			window_data_read_i      => s_L_window_data_read,
			window_mask_read_i      => s_L_window_mask_read,
			window_data_o           => s_L_window_data_out,
			window_mask_o           => s_L_window_mask_out,
			window_data_valid_o     => s_L_window_data_valid,
			window_mask_valid_o     => s_L_window_mask_valid,
			window_data_ready_o     => s_L_window_data_ready,
			window_mask_ready_o     => s_L_window_mask_ready,
			window_buffer_empty_o   => s_spacewire_read_registers.fee_buffers_status_reg.fee_left_buffer_empty,
			window_buffer_0_empty_o => s_L_buffer_empty,
			window_buffer_1_empty_o => open
		);

	-- right windowing buffer control muxing
	s_R_window_data_read                      <= (s_R_fee_data_controller_window_data_read);
	s_R_window_mask_read                      <= (s_R_fee_data_controller_window_mask_read);
	-- right windowing buffer status muxing
	s_R_fee_data_controller_window_data_out   <= (s_R_window_data_out);
	s_R_fee_data_controller_window_mask_out   <= (s_R_window_mask_out);
	s_R_fee_data_controller_window_data_valid <= (s_R_window_data_valid);
	s_R_fee_data_controller_window_mask_valid <= (s_R_window_mask_valid);
	s_R_fee_data_controller_window_data_ready <= (s_R_window_data_ready);
	s_R_fee_data_controller_window_mask_ready <= (s_R_window_mask_ready);
	-- left windowing buffer control muxing
	s_L_window_data_read                      <= (s_L_fee_data_controller_window_data_read);
	s_L_window_mask_read                      <= (s_L_fee_data_controller_window_mask_read);
	-- left windowing buffer status muxing
	s_L_fee_data_controller_window_data_out   <= (s_L_window_data_out);
	s_L_fee_data_controller_window_mask_out   <= (s_L_window_mask_out);
	s_L_fee_data_controller_window_data_valid <= (s_L_window_data_valid);
	s_L_fee_data_controller_window_mask_valid <= (s_L_window_mask_valid);
	s_L_fee_data_controller_window_data_ready <= (s_L_window_data_ready);
	s_L_fee_data_controller_window_mask_ready <= (s_L_window_mask_ready);
	-- spw mux tx 1 command muxing
	s_mux_tx_1_command.txwrite                <= (s_fee_data_controller_spw_txwrite);
	s_mux_tx_1_command.txflag                 <= (s_fee_data_controller_spw_txflag);
	s_mux_tx_1_command.txdata                 <= (s_fee_data_controller_spw_txdata);
	-- spw mux tx 1 status muxing
	s_fee_data_controller_spw_txrdy           <= (s_mux_tx_1_status.txrdy);
	-- spw mux tx 2 command muxing
	s_mux_tx_2_command.txwrite                <= '0';
	s_mux_tx_2_command.txflag                 <= '0';
	s_mux_tx_2_command.txdata                 <= (others => '0');
	-- spw mux tx 2 status muxing

	-- fee data controller instantiation
	fee_data_controller_top_inst : entity work.fee_data_controller_top
		port map(
			clk_i                                         => a_avs_clock,
			rst_i                                         => a_reset,
			fee_sync_signal_i                             => s_ch_sync_trigger,
			fee_clear_signal_i                            => s_ch_sync_clear,
			fee_current_timecode_i(7 downto 6)            => s_spacewire_read_registers.spw_timecode_status_reg.timecode_control,
			fee_current_timecode_i(5 downto 0)            => s_spacewire_read_registers.spw_timecode_status_reg.timecode_time,
			fee_clear_frame_i                             => s_spacewire_write_registers.spw_timecode_config_reg.timecode_clear,
			fee_left_side_activated_i                     => s_left_side_activated,
			fee_right_side_activated_i                    => s_right_side_activated,
			fee_machine_clear_i                           => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_clear,
			fee_machine_stop_i                            => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			fee_machine_start_i                           => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			fee_digitalise_en_i                           => s_spacewire_write_registers.fee_machine_config_reg.fee_digitalise_en,
			fee_readout_en_i                              => s_spacewire_write_registers.fee_machine_config_reg.fee_readout_en,
			fee_windowing_en_i                            => s_spacewire_write_registers.fee_machine_config_reg.fee_windowing_en,
			fee_left_window_data_i                        => s_L_fee_data_controller_window_data_out,
			fee_left_window_mask_i                        => s_L_fee_data_controller_window_mask_out,
			fee_left_window_data_valid_i                  => s_L_fee_data_controller_window_data_valid,
			fee_left_window_mask_valid_i                  => s_L_fee_data_controller_window_mask_valid,
			fee_left_window_data_ready_i                  => s_L_fee_data_controller_window_data_ready,
			fee_left_window_mask_ready_i                  => s_L_fee_data_controller_window_mask_ready,
			fee_right_window_data_i                       => s_R_fee_data_controller_window_data_out,
			fee_right_window_mask_i                       => s_R_fee_data_controller_window_mask_out,
			fee_right_window_data_valid_i                 => s_R_fee_data_controller_window_data_valid,
			fee_right_window_mask_valid_i                 => s_R_fee_data_controller_window_mask_valid,
			fee_right_window_data_ready_i                 => s_R_fee_data_controller_window_data_ready,
			fee_right_window_mask_ready_i                 => s_R_fee_data_controller_window_mask_ready,
			fee_hk_mem_waitrequest_i                      => rmm_fee_hk_rd_waitrequest_i,
			fee_hk_mem_data_i                             => rmm_fee_hk_readdata_i,
			fee_spw_tx_ready_i                            => s_fee_data_controller_spw_txrdy,
			fee_spw_link_running_i                        => s_spacewire_read_registers.spw_link_status_reg.spw_link_running,
			data_pkt_ccd_x_size_i                         => s_spacewire_write_registers.data_packet_config_reg.data_pkt_ccd_x_size,
			data_pkt_ccd_y_size_i                         => s_spacewire_write_registers.data_packet_config_reg.data_pkt_ccd_y_size,
			data_pkt_data_y_size_i                        => s_spacewire_write_registers.data_packet_config_reg.data_pkt_data_y_size,
			data_pkt_overscan_y_size_i                    => s_spacewire_write_registers.data_packet_config_reg.data_pkt_overscan_y_size,
			data_pkt_packet_length_i                      => s_spacewire_write_registers.data_packet_config_reg.data_pkt_packet_length,
			data_pkt_fee_mode_i                           => s_spacewire_write_registers.data_packet_config_reg.data_pkt_fee_mode,
			data_pkt_ccd_number_i                         => s_spacewire_write_registers.data_packet_config_reg.data_pkt_ccd_number,
			data_pkt_ccd_v_start_i                        => s_spacewire_write_registers.data_packet_config_reg.data_pkt_ccd_v_start,
			data_pkt_ccd_v_end_i                          => s_spacewire_write_registers.data_packet_config_reg.data_pkt_ccd_v_end,
			data_pkt_protocol_id_i                        => s_spacewire_write_registers.data_packet_config_reg.data_pkt_protocol_id,
			data_pkt_logical_addr_i                       => s_spacewire_write_registers.data_packet_config_reg.data_pkt_logical_addr,
			data_pkt_start_delay_i                        => s_spacewire_write_registers.data_packet_pixel_delay_reg.data_pkt_start_delay,
			data_pkt_skip_delay_i                         => s_spacewire_write_registers.data_packet_pixel_delay_reg.data_pkt_skip_delay,
			data_pkt_line_delay_i                         => s_spacewire_write_registers.data_packet_pixel_delay_reg.data_pkt_line_delay,
			data_pkt_adc_delay_i                          => s_spacewire_write_registers.data_packet_pixel_delay_reg.data_pkt_adc_delay,
			masking_buffer_overflow_i                     => s_spacewire_write_registers.fee_machine_config_reg.fee_buffer_overflow_en,
			windowing_packet_order_list_i(511 downto 480) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_15,
			windowing_packet_order_list_i(479 downto 448) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_14,
			windowing_packet_order_list_i(447 downto 416) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_13,
			windowing_packet_order_list_i(415 downto 384) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_12,
			windowing_packet_order_list_i(383 downto 352) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_11,
			windowing_packet_order_list_i(351 downto 320) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_10,
			windowing_packet_order_list_i(319 downto 288) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_9,
			windowing_packet_order_list_i(287 downto 256) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_8,
			windowing_packet_order_list_i(255 downto 224) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_7,
			windowing_packet_order_list_i(223 downto 192) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_6,
			windowing_packet_order_list_i(191 downto 160) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_5,
			windowing_packet_order_list_i(159 downto 128) => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_4,
			windowing_packet_order_list_i(127 downto 96)  => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_3,
			windowing_packet_order_list_i(95 downto 64)   => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_2,
			windowing_packet_order_list_i(63 downto 32)   => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_1,
			windowing_packet_order_list_i(31 downto 0)    => s_spacewire_write_registers.windowing_parameters_reg.windowing_packet_order_list_0,
			windowing_last_left_packet_i                  => s_spacewire_write_registers.windowing_parameters_reg.windowing_last_e_packet,
			windowing_last_right_packet_i                 => s_spacewire_write_registers.windowing_parameters_reg.windowing_last_f_packet,
			errinj_tx_disabled_i                          => s_spacewire_write_registers.error_injection_control_reg.errinj_tx_disabled,
			errinj_missing_pkts_i                         => s_spacewire_write_registers.error_injection_control_reg.errinj_missing_pkts,
			errinj_missing_data_i                         => s_spacewire_write_registers.error_injection_control_reg.errinj_missing_data,
			errinj_frame_num_i                            => s_spacewire_write_registers.error_injection_control_reg.errinj_frame_num,
			errinj_sequence_cnt_i                         => s_spacewire_write_registers.error_injection_control_reg.errinj_sequence_cnt,
			errinj_data_cnt_i                             => s_spacewire_write_registers.error_injection_control_reg.errinj_data_cnt,
			errinj_n_repeat_i                             => s_spacewire_write_registers.error_injection_control_reg.errinj_n_repeat,
			fee_machine_busy_o                            => s_spacewire_read_registers.fee_buffers_status_reg.fee_left_machine_busy,
			fee_frame_counter_o                           => s_fee_frame_counter,
			fee_frame_number_o                            => s_fee_frame_number,
			fee_left_output_buffer_overflowed_o           => s_fee_left_output_buffer_overflowed,
			fee_right_output_buffer_overflowed_o          => s_fee_right_output_buffer_overflowed,
			fee_left_window_data_read_o                   => s_L_fee_data_controller_window_data_read,
			fee_left_window_mask_read_o                   => s_L_fee_data_controller_window_mask_read,
			fee_right_window_data_read_o                  => s_R_fee_data_controller_window_data_read,
			fee_right_window_mask_read_o                  => s_R_fee_data_controller_window_mask_read,
			fee_hk_mem_byte_address_o                     => s_fee_rd_rmap_address,
			fee_hk_mem_read_o                             => s_fee_rd_rmap_read,
			fee_spw_tx_write_o                            => s_fee_data_controller_spw_txwrite,
			fee_spw_tx_flag_o                             => s_fee_data_controller_spw_txflag,
			fee_spw_tx_data_o                             => s_fee_data_controller_spw_txdata
		);
	s_spacewire_read_registers.fee_buffers_status_reg.fee_right_machine_busy <= s_spacewire_read_registers.fee_buffers_status_reg.fee_left_machine_busy;

	-- RMAP (TEMP)
	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => 8,
			g_MEMORY_ADDRESS_WIDTH => 32,
			g_DATA_LENGTH_WIDTH    => 24,
			g_MEMORY_ACCESS_WIDTH  => 0
		)
		port map(
			clk_i                      => a_avs_clock,
			reset_n_i                  => rst_n,
			spw_flag_i                 => s_rmap_spw_flag,
			mem_flag_i                 => s_rmap_mem_flag,
			spw_control_o              => s_rmap_spw_control,
			conf_target_logical_addr_i => s_spacewire_write_registers.rmap_codec_config_reg.rmap_target_logical_addr,
			conf_target_key_i          => s_spacewire_write_registers.rmap_codec_config_reg.rmap_target_key,
			mem_control_o              => s_rmap_mem_control,
			mem_wr_byte_address_o      => s_rmap_mem_wr_byte_address,
			mem_rd_byte_address_o      => s_rmap_mem_rd_byte_address,
			stat_command_received_o    => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_command_received,
			stat_write_requested_o     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_requested,
			stat_write_authorized_o    => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized,
			stat_write_finished_o      => s_rmap_write_data_finished,
			stat_read_requested_o      => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_requested,
			stat_read_authorized_o     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_authorized,
			stat_read_finished_o       => s_rmap_read_data_finished,
			stat_reply_sended_o        => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_reply_sended,
			stat_discarded_package_o   => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_discarded_package,
			err_early_eop_o            => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_early_eop,
			err_eep_o                  => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_eep,
			err_header_crc_o           => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_header_crc,
			err_unused_packet_type_o   => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_unused_packet_type,
			err_invalid_command_code_o => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_invalid_command_code,
			err_too_much_data_o        => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_too_much_data,
			err_invalid_data_crc_o     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_err_invalid_data_crc
		);

	-- rmap memory area master signals assignments
	-- rmap master codec
	rmm_rmap_target_wr_address_o      <= s_rmap_mem_wr_byte_address;
	rmm_rmap_target_write_o           <= s_rmap_mem_control.write.write;
	rmm_rmap_target_writedata_o       <= s_rmap_mem_control.write.data;
	s_rmap_mem_flag.write.error       <= '0';
	s_rmap_mem_flag.write.waitrequest <= rmm_rmap_target_wr_waitrequest_i;
	rmm_rmap_target_rd_address_o      <= s_rmap_mem_rd_byte_address;
	rmm_rmap_target_read_o            <= s_rmap_mem_control.read.read;
	s_rmap_mem_flag.read.error        <= '0';
	s_rmap_mem_flag.read.data         <= rmm_rmap_target_readdata_i;
	s_rmap_mem_flag.read.waitrequest  <= rmm_rmap_target_rd_waitrequest_i;
	-- rmap master hk
	rmm_fee_hk_wr_address_o           <= (others => '0');
	rmm_fee_hk_write_o                <= '0';
	rmm_fee_hk_writedata_o            <= (others => '0');
	rmm_fee_hk_rd_address_o           <= s_fee_rd_rmap_address;
	rmm_fee_hk_read_o                 <= s_fee_rd_rmap_read;

	-- spw mux
	-- tx 0 / rx 0 -> rmap
	-- tx 1        -> "right fee data controller" or "data controller"
	-- tx 2        -> "left fee data controller"  or nothing 
	spw_mux_ent_inst : entity work.spw_mux_ent
		port map(
			clk_i                          => a_avs_clock,
			rst_i                          => a_reset,
			fee_clear_signal_i             => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_clear,
			fee_stop_signal_i              => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			fee_start_signal_i             => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			spw_codec_rx_status_i          => s_mux_rx_channel_status,
			spw_codec_tx_status_i          => s_mux_tx_channel_status,
			spw_mux_rx_0_command_i.rxread  => s_rmap_spw_control.receiver.read,
			spw_mux_tx_0_command_i.txwrite => s_rmap_spw_control.transmitter.write,
			spw_mux_tx_0_command_i.txflag  => s_rmap_spw_control.transmitter.flag,
			spw_mux_tx_0_command_i.txdata  => s_rmap_spw_control.transmitter.data,
			spw_mux_tx_1_command_i         => s_mux_tx_1_command,
			spw_mux_tx_2_command_i         => s_mux_tx_2_command,
			spw_codec_rx_command_o         => s_mux_rx_channel_command,
			spw_codec_tx_command_o         => s_mux_tx_channel_command,
			spw_mux_rx_0_status_o.rxvalid  => s_rmap_spw_flag.receiver.valid,
			spw_mux_rx_0_status_o.rxhalff  => s_dummy_spw_mux_rx0_rxhalff,
			spw_mux_rx_0_status_o.rxflag   => s_rmap_spw_flag.receiver.flag,
			spw_mux_rx_0_status_o.rxdata   => s_rmap_spw_flag.receiver.data,
			spw_mux_tx_0_status_o.txrdy    => s_rmap_spw_flag.transmitter.ready,
			spw_mux_tx_0_status_o.txhalff  => s_dummy_spw_mux_tx0_txhalff,
			spw_mux_tx_1_status_o          => s_mux_tx_1_status,
			spw_mux_tx_2_status_o          => s_mux_tx_2_status
		);

	avs_config_waitrequest_o <= ((s_avalon_mm_windwoing_read_waitrequest) and (s_avalon_mm_windwoing_write_waitrequest)) when (a_reset = '0') else ('1');

	comm_rmap_rw_manager_ent_inst : entity work.comm_rmap_rw_manager_ent
		generic map(
			g_RMAP_WIN_OFFSET_BIT => c_COMM_NFEE_RMAP_WIN_OFFSET_BIT
		)
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			rmap_write_authorized_i    => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized,
			rmap_write_i               => s_rmap_mem_control.write.write,
			rmap_write_address_i       => s_rmap_mem_wr_byte_address,
			rmap_read_authorized_i     => s_spacewire_read_registers.rmap_codec_status_reg.rmap_stat_read_authorized,
			rmap_read_i                => s_rmap_mem_control.read.read,
			rmap_read_address_i        => s_rmap_mem_rd_byte_address,
			rmap_last_write_addr_o     => s_spacewire_read_registers.rmap_memory_status_reg.rmap_last_write_addr,
			rmap_last_write_length_o   => s_spacewire_read_registers.rmap_memory_status_reg.rmap_last_write_length_bytes,
			rmap_last_write_win_area_o => s_rmap_win_area_write_flag,
			rmap_last_read_addr_o      => s_spacewire_read_registers.rmap_memory_status_reg.rmap_last_read_addr,
			rmap_last_read_length_o    => s_spacewire_read_registers.rmap_memory_status_reg.rmap_last_read_length_bytes,
			rmap_last_read_win_area_o  => open
		);

	comm_timecode_manager_ent_inst : entity work.comm_timecode_manager_ent
		port map(
			clk_i                 => a_avs_clock,
			rst_i                 => a_reset,
			ch_sync_trigger_i     => s_ch_sync_trigger,
			tx_timecode_clear_i   => s_spacewire_write_registers.spw_timecode_config_reg.timecode_clear,
			tx_timecode_en_i      => s_spacewire_write_registers.spw_timecode_config_reg.timecode_en,
			rx_timecode_tick_i    => s_rx_timecode_tick,
			rx_timecode_control_i => s_rx_timecode_control,
			rx_timecode_counter_i => s_rx_timecode_counter,
			tx_timecode_tick_o    => s_tx_timecode_tick,
			tx_timecode_control_o => s_spacewire_read_registers.spw_timecode_status_reg.timecode_control,
			tx_timecode_counter_o => s_spacewire_read_registers.spw_timecode_status_reg.timecode_time
		);

	comm_feeb_irq_manager_ent_inst : entity work.comm_feeb_irq_manager_ent
		port map(
			clk_i                              => a_avs_clock,
			rst_i                              => a_reset,
			irq_manager_stop_i                 => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			irq_manager_start_i                => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			global_irq_en_i                    => s_spacewire_write_registers.comm_irq_control_reg.comm_global_irq_en,
			irq_watches_i.left_buffer_empty    => s_L_buffer_empty,
			irq_watches_i.right_buffer_empty   => s_R_buffer_empty,
			irq_flags_en_i.left_buffer_empty   => s_spacewire_write_registers.fee_buffers_irq_control_reg.fee_left_buffer_empty_en,
			irq_flags_en_i.right_buffer_empty  => s_spacewire_write_registers.fee_buffers_irq_control_reg.fee_right_buffer_empty_en,
			irq_flags_clr_i.left_buffer_empty  => s_spacewire_write_registers.fee_buffers_irq_flags_clear_reg.fee_left_buffer_0_empty_flag_clear,
			irq_flags_clr_i.right_buffer_empty => s_spacewire_write_registers.fee_buffers_irq_flags_clear_reg.fee_right_buffer_0_empty_flag_clear,
			irq_flags_o.left_buffer_empty      => s_spacewire_read_registers.fee_buffers_irq_flags_reg.fee_left_buffer_0_empty_flag,
			irq_flags_o.right_buffer_empty     => s_spacewire_read_registers.fee_buffers_irq_flags_reg.fee_right_buffer_0_empty_flag,
			irq_o                              => feeb_interrupt_sender_irq_o
		);

	comm_rmap_irq_manager_ent_inst : entity work.comm_rmap_irq_manager_ent
		port map(
			clk_i                                   => a_avs_clock,
			rst_i                                   => a_reset,
			irq_manager_stop_i                      => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_stop,
			irq_manager_start_i                     => s_spacewire_write_registers.fee_machine_config_reg.fee_machine_start,
			global_irq_en_i                         => s_spacewire_write_registers.comm_irq_control_reg.comm_global_irq_en,
			irq_watches_i.rmap_write_data_finished  => s_rmap_write_data_finished,
			irq_contexts_i.rmap_win_area_write_flag => s_rmap_win_area_write_flag,
			irq_flags_en_i.rmap_write_config_flag   => s_spacewire_write_registers.rmap_irq_control_reg.rmap_write_config_en,
			irq_flags_en_i.rmap_write_window_flag   => s_spacewire_write_registers.rmap_irq_control_reg.rmap_write_window_en,
			irq_flags_clr_i.rmap_write_config_flag  => s_spacewire_write_registers.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear,
			irq_flags_clr_i.rmap_write_window_flag  => s_spacewire_write_registers.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear,
			irq_flags_o.rmap_write_config_flag      => s_spacewire_read_registers.rmap_irq_flags_reg.rmap_write_config_flag,
			irq_flags_o.rmap_write_window_flag      => s_spacewire_read_registers.rmap_irq_flags_reg.rmap_write_window_flag,
			irq_o                                   => rmap_interrupt_sender_irq_o
		);

	-- sync in trigger generation
	comm_sync_manager_ent_inst : entity work.comm_sync_manager_ent
		port map(
			clk_i                  => a_avs_clock,
			rst_i                  => a_reset,
			channel_sync_i         => channel_sync_i,
			left_buffer_empty_i    => s_spacewire_read_registers.fee_buffers_status_reg.fee_left_buffer_empty,
			right_buffer_empty_i   => s_spacewire_read_registers.fee_buffers_status_reg.fee_right_buffer_empty,
			ch_sync_trigger_o      => s_ch_sync_trigger,
			ch_sync_clear_o        => s_ch_sync_clear,
			left_side_activated_o  => s_left_side_activated,
			right_side_activated_o => s_right_side_activated
		);

	-- fee statistics manager
	comm_statistics_manager_ent_inst : entity work.comm_statistics_manager_ent
		port map(
			clk_i                     => a_avs_clock,
			rst_i                     => a_reset,
			statistics_clear_i        => s_spacewire_write_registers.fee_machine_config_reg.fee_statistics_clear,
			spw_rx_channel_rxread_i   => s_mux_rx_channel_command.rxread,
			spw_rx_channel_rxflag_i   => s_mux_rx_channel_status.rxflag,
			spw_rx_channel_rxdata_i   => s_mux_rx_channel_status.rxdata,
			spw_tx_channel_txwrite_i  => s_mux_tx_channel_command.txwrite,
			spw_tx_channel_txflag_i   => s_mux_tx_channel_command.txflag,
			spw_tx_channel_txdata_i   => s_mux_tx_channel_command.txdata,
			spw_err_escape_i          => s_spacewire_read_registers.spw_link_status_reg.spw_err_escape,
			spw_err_credit_i          => s_spacewire_read_registers.spw_link_status_reg.spw_err_credit,
			spw_err_parity_i          => s_spacewire_read_registers.spw_link_status_reg.spw_err_parity,
			spw_err_disconnect_i      => s_spacewire_read_registers.spw_link_status_reg.spw_err_disconnect,
			incoming_pkts_cnt_o       => s_spacewire_read_registers.fee_machine_statistics_reg.fee_incoming_pkts_cnt,
			incoming_bytes_cnt_o      => s_spacewire_read_registers.fee_machine_statistics_reg.fee_incoming_bytes_cnt,
			outgoing_pkts_cnt_o       => s_spacewire_read_registers.fee_machine_statistics_reg.fee_outgoing_pkts_cnt,
			outgoing_bytes_cnt_o      => s_spacewire_read_registers.fee_machine_statistics_reg.fee_outgoing_bytes_cnt,
			spw_link_escape_err_cnt_o => s_spacewire_read_registers.fee_machine_statistics_reg.fee_spw_link_escape_err_cnt,
			spw_link_credit_err_cnt_o => s_spacewire_read_registers.fee_machine_statistics_reg.fee_spw_link_credit_err_cnt,
			spw_link_parity_err_cnt_o => s_spacewire_read_registers.fee_machine_statistics_reg.fee_spw_link_parity_err_cnt,
			spw_link_disconnect_cnt_o => s_spacewire_read_registers.fee_machine_statistics_reg.fee_spw_link_disconnect_cnt,
			spw_eep_cnt_o             => s_spacewire_read_registers.fee_machine_statistics_reg.fee_spw_eep_cnt
		);

	-- SpaceWire Controller Signals Assignments
	s_spacewire_read_registers.spw_link_status_reg.spw_link_started    <= spw_link_status_started_i;
	s_spacewire_read_registers.spw_link_status_reg.spw_link_connecting <= spw_link_status_connecting_i;
	s_spacewire_read_registers.spw_link_status_reg.spw_link_running    <= spw_link_status_running_i;
	s_spacewire_read_registers.spw_link_status_reg.spw_err_disconnect  <= spw_link_error_errdisc_i;
	s_spacewire_read_registers.spw_link_status_reg.spw_err_parity      <= spw_link_error_errpar_i;
	s_spacewire_read_registers.spw_link_status_reg.spw_err_escape      <= spw_link_error_erresc_i;
	s_spacewire_read_registers.spw_link_status_reg.spw_err_credit      <= spw_link_error_errcred_i;
	s_rx_timecode_tick                                                 <= spw_timecode_rx_tick_out_i;
	s_rx_timecode_control                                              <= spw_timecode_rx_ctrl_out_i;
	s_rx_timecode_counter                                              <= spw_timecode_rx_time_out_i;
	s_mux_rx_channel_status.rxvalid                                    <= spw_data_rx_status_rxvalid_i;
	s_mux_rx_channel_status.rxhalff                                    <= spw_data_rx_status_rxhalff_i;
	s_mux_rx_channel_status.rxflag                                     <= spw_data_rx_status_rxflag_i;
	s_mux_rx_channel_status.rxdata                                     <= spw_data_rx_status_rxdata_i;
	s_mux_tx_channel_status.txrdy                                      <= spw_data_tx_status_txrdy_i;
	s_mux_tx_channel_status.txhalff                                    <= spw_data_tx_status_txhalff_i;
	spw_link_command_autostart_o                                       <= s_spacewire_write_registers.spw_link_config_reg.spw_lnkcfg_autostart;
	spw_link_command_linkstart_o                                       <= s_spacewire_write_registers.spw_link_config_reg.spw_lnkcfg_linkstart;
	spw_link_command_linkdis_o                                         <= s_spacewire_write_registers.spw_link_config_reg.spw_lnkcfg_disconnect;
	spw_link_command_txdivcnt_o                                        <= s_spacewire_write_registers.spw_link_config_reg.spw_lnkcfg_txdivcnt;
	spw_timecode_tx_tick_in_o                                          <= s_tx_timecode_tick;
	spw_timecode_tx_ctrl_in_o                                          <= s_spacewire_read_registers.spw_timecode_status_reg.timecode_control;
	spw_timecode_tx_time_in_o                                          <= s_spacewire_read_registers.spw_timecode_status_reg.timecode_time;
	spw_data_rx_command_rxread_o                                       <= s_mux_rx_channel_command.rxread;
	spw_data_tx_command_txwrite_o                                      <= s_mux_tx_channel_command.txwrite;
	spw_data_tx_command_txflag_o                                       <= s_mux_tx_channel_command.txflag;
	spw_data_tx_command_txdata_o                                       <= s_mux_tx_channel_command.txdata;

	-- measurements channel outputs
	-- measurement 0 : right empty buffer signal
	comm_measurements_o(0) <= s_spacewire_read_registers.fee_buffers_status_reg.fee_right_buffer_empty;
	-- measurement 1 : right write signal
	comm_measurements_o(1) <= '0';
	-- measurement 2 : left empty  buffer signal
	comm_measurements_o(2) <= s_spacewire_read_registers.fee_buffers_status_reg.fee_left_buffer_empty;
	-- measurement 3 : left write signal
	comm_measurements_o(3) <= '0';
	-- measurement 4 : right fee busy signal
	comm_measurements_o(4) <= s_spacewire_read_registers.fee_buffers_status_reg.fee_right_machine_busy;
	-- measurement 5 : left fee busy signal
	comm_measurements_o(5) <= s_spacewire_read_registers.fee_buffers_status_reg.fee_left_machine_busy;
	-- measurement 6 : fee busy signal
	comm_measurements_o(6) <= (s_spacewire_read_registers.fee_buffers_status_reg.fee_right_machine_busy) or (s_spacewire_read_registers.fee_buffers_status_reg.fee_left_machine_busy);
	-- not used measurements will be logical 0
	comm_measurements_o(7) <= '0';

	-- mock irq numbers (TODO: need to create generics later)
	s_spacewire_read_registers.fee_buffers_irq_number_reg.fee_buffers_irq_number <= (others => '0');
	s_spacewire_read_registers.rmap_irq_number_reg.rmap_irq_number               <= (others => '0');

	-- channel hk for rmap read area
	channel_hk_timecode_control_o       <= s_spacewire_read_registers.spw_timecode_status_reg.timecode_control;
	channel_hk_timecode_time_o          <= s_spacewire_read_registers.spw_timecode_status_reg.timecode_time;
	channel_hk_rmap_target_status_o     <= x"00";
	channel_hk_rmap_target_indicate_o   <= '0';
	channel_hk_spw_link_escape_err_o    <= s_spacewire_read_registers.spw_link_status_reg.spw_err_escape;
	channel_hk_spw_link_credit_err_o    <= s_spacewire_read_registers.spw_link_status_reg.spw_err_credit;
	channel_hk_spw_link_parity_err_o    <= s_spacewire_read_registers.spw_link_status_reg.spw_err_parity;
	channel_hk_spw_link_disconnect_o    <= s_spacewire_read_registers.spw_link_status_reg.spw_err_disconnect;
	channel_hk_spw_link_running_o       <= s_spacewire_read_registers.spw_link_status_reg.spw_link_running;
	channel_hk_frame_counter_o          <= s_fee_frame_counter;
	channel_hk_frame_number_o           <= s_fee_frame_number;
	channel_hk_err_win_wrong_x_coord_o  <= s_spacewire_write_registers.windowing_parameters_reg.windowing_x_coordinate_error;
	channel_hk_err_win_wrong_y_coord_o  <= s_spacewire_write_registers.windowing_parameters_reg.windowing_y_coordinate_error;
	channel_hk_err_e_side_buffer_full_o <= s_fee_left_output_buffer_overflowed;
	channel_hk_err_f_side_buffer_full_o <= s_fee_right_output_buffer_overflowed;
	channel_hk_err_invalid_ccd_mode_o   <= s_spacewire_write_registers.data_packet_errors_reg.data_pkt_invalid_ccd_mode;

	-- channel memory offset for rmap windowing area
	channel_win_mem_addr_offset_o(63 downto 32) <= s_spacewire_write_registers.rmap_memory_config_reg.rmap_win_area_offset_high_dword;
	channel_win_mem_addr_offset_o(31 downto 0)  <= s_spacewire_write_registers.rmap_memory_config_reg.rmap_win_area_offset_low_dword;

	-- rmap echoing
	rmap_echo_echo_en_o         <= s_spacewire_write_registers.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable;
	rmap_echo_echo_id_en_o      <= s_spacewire_write_registers.rmap_echoing_mode_config_reg.rmap_echoing_id_enable;
	rmap_echo_in_fifo_wrflag_o  <= s_rmap_spw_flag.receiver.flag;
	rmap_echo_in_fifo_wrdata_o  <= s_rmap_spw_flag.receiver.data;
	rmap_echo_in_fifo_wrreq_o   <= s_rmap_spw_control.receiver.read;
	rmap_echo_out_fifo_wrflag_o <= s_rmap_spw_control.transmitter.flag;
	rmap_echo_out_fifo_wrdata_o <= s_rmap_spw_control.transmitter.data;
	rmap_echo_out_fifo_wrreq_o  <= s_rmap_spw_control.transmitter.write;

end architecture rtl;                   -- of comm_v2_top
