-- comm_v1_01_top.vhd

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

use work.avalon_mm_windowing_pkg.all;
use work.avalon_mm_spacewire_pkg.all;
use work.avalon_mm_spacewire_registers_pkg.all;
use work.spw_codec_pkg.all;

entity comm_v1_01_top is
	port(
		reset_sink_reset                   : in  std_logic                     := '0'; --          --             reset_sink.a_reset
		data_in                            : in  std_logic                     := '0'; --          --            conduit_end.data_in_signal
		data_out                           : out std_logic; --                                     --                       .data_out_signal
		strobe_in                          : in  std_logic                     := '0'; --          --                       .strobe_in_signal
		strobe_out                         : out std_logic; --                                     --                       .strobe_out_signal
		interrupt_sender_irq               : out std_logic; --                                     --       interrupt_sender.irq
		clock_sink_200_clk                 : in  std_logic                     := '0'; --          --         clock_sink_200.clk
		avalon_slave_windowing_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_slave_windowing.address
		avalon_slave_windowing_write       : in  std_logic                     := '0'; --          --                       .write
		avalon_slave_windowing_read        : in  std_logic                     := '0'; --          --                       .read
		avalon_slave_windowing_readdata    : out std_logic_vector(31 downto 0); --                 --                       .readdata
		avalon_slave_windowing_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                       .writedata
		avalon_slave_windowing_waitrequest : out std_logic; --                                     --                       .waitrequest
		avalon_slave_L_buffer_address      : in  std_logic_vector(9 downto 0)  := (others => '0'); --  avalon_slave_L_buffer.address
		avalon_slave_L_buffer_waitrequest  : out std_logic; --                                     --                       .waitrequest
		avalon_slave_L_buffer_write        : in  std_logic                     := '0'; --          --                       .write
		avalon_slave_L_buffer_writedata    : in  std_logic_vector(63 downto 0) := (others => '0'); --                       .writedata
		avalon_slave_R_buffer_address      : in  std_logic_vector(9 downto 0)  := (others => '0'); --  avalon_slave_R_buffer.address
		avalon_slave_R_buffer_write        : in  std_logic                     := '0'; --          --                       .write
		avalon_slave_R_buffer_writedata    : in  std_logic_vector(63 downto 0) := (others => '0'); --                       .writedata
		avalon_slave_R_buffer_waitrequest  : out std_logic --                                      --                       .waitrequest
	);
end entity comm_v1_01_top;

architecture rtl of comm_v1_01_top is

	alias a_clock is clock_sink_200_clk;
	alias a_reset is reset_sink_reset;

	-- constants

	-- signals

	-- interrupt edge detection signals
	signal s_R_buffer_empty_delayed : std_logic;
	signal s_L_buffer_empty_delayed : std_logic;

	-- windowing avalon mm read signals
	signal s_avalon_mm_windwoing_read_waitrequest : std_logic;

	-- windowing avalon mm write signals
	signal s_avalon_mm_windwoing_write_waitrequest : std_logic;

	-- windowing avalon mm registers signals
	signal s_spacewire_write_registers : t_windowing_write_registers;
	signal s_spacewire_read_registers  : t_windowing_read_registers;

	-- rigth avalon mm windowing write signals
	signal s_R_window_data : std_logic_vector(63 downto 0);

	-- rigth windowing buffer signals
	signal s_R_window_data_write : std_logic;
	signal s_R_window_mask_write : std_logic;
	signal s_R_window_data_read  : std_logic;
	signal s_R_window_mask_read  : std_logic;
	signal s_R_window_data_out   : std_logic_vector(63 downto 0);
	signal s_R_window_mask_out   : std_logic_vector(63 downto 0);
	signal s_R_window_data_ready : std_logic;
	signal s_R_window_mask_ready : std_logic;

	-- left avalon mm windowing signals
	signal s_L_window_data : std_logic_vector(63 downto 0);

	-- left windowing buffer signals
	signal s_L_window_data_write : std_logic;
	signal s_L_window_mask_write : std_logic;
	signal s_L_window_data_read  : std_logic;
	signal s_L_window_mask_read  : std_logic;
	signal s_L_window_data_out   : std_logic_vector(63 downto 0);
	signal s_L_window_mask_out   : std_logic_vector(63 downto 0);
	signal s_L_window_data_ready : std_logic;
	signal s_L_window_mask_ready : std_logic;

	-- data controller signals

	-- spw codec signals
	signal s_spw_rxvalid : std_logic;
	signal s_spw_rxread  : std_logic;
	signal s_spw_txrdy   : std_logic;
	signal s_spw_txwrite : std_logic;
	signal s_spw_txflag  : std_logic;
	signal s_spw_txdata  : std_logic_vector(7 downto 0);

begin

	-- windowing avalon mm read instantiation
	avalon_mm_spacewire_read_ent_inst : entity work.avalon_mm_spacewire_read_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_windowing_address,
			avalon_mm_spacewire_i.read        => avalon_slave_windowing_read,
			avalon_mm_spacewire_o.readdata    => avalon_slave_windowing_readdata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_windwoing_read_waitrequest,
			spacewire_write_registers_i       => s_spacewire_write_registers,
			spacewire_read_registers_i        => s_spacewire_read_registers
		);

	-- windowing avalon mm write instantiation
	avalon_mm_spacewire_write_ent_inst : entity work.avalon_mm_spacewire_write_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_windowing_address,
			avalon_mm_spacewire_i.write       => avalon_slave_windowing_write,
			avalon_mm_spacewire_i.writedata   => avalon_slave_windowing_writedata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_windwoing_write_waitrequest,
			spacewire_write_registers_o       => s_spacewire_write_registers
		);

	-- rigth avalon mm windowing write instantiation
	rigth_avalon_mm_windowing_write_ent_inst : entity work.avalon_mm_windowing_write_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_windowing_i.address     => avalon_slave_R_buffer_address,
			avalon_mm_windowing_i.write       => avalon_slave_R_buffer_write,
			avalon_mm_windowing_i.writedata   => avalon_slave_R_buffer_writedata,
			mask_enable_i                     => s_spacewire_write_registers.windowing_control.mask_enable,
			avalon_mm_windowing_o.waitrequest => avalon_slave_R_buffer_waitrequest,
			window_data_write_o               => s_R_window_data_write,
			window_mask_write_o               => s_R_window_mask_write,
			window_data_o                     => s_R_window_data
		);

	-- rigth windowing buffer instantiation
	rigth_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                 => a_clock,
			rst_i                 => a_reset,
			window_data_write_i   => s_R_window_data_write,
			window_mask_write_i   => s_R_window_mask_write,
			window_data_i         => s_R_window_data,
			window_data_read_i    => s_R_window_data_read,
			window_mask_read_i    => s_R_window_mask_read,
			window_data_o         => s_R_window_data_out,
			window_mask_o         => s_R_window_mask_out,
			window_data_ready_o   => s_R_window_data_ready,
			window_mask_ready_o   => s_R_window_mask_ready,
			window_buffer_empty_o => s_spacewire_read_registers.windowing_buffer.R_buffer_empty
		);

	-- left avalon mm windowing write instantiation
	left_avalon_mm_windowing_write_ent_inst : entity work.avalon_mm_windowing_write_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_windowing_i.address     => avalon_slave_L_buffer_address,
			avalon_mm_windowing_i.write       => avalon_slave_L_buffer_write,
			avalon_mm_windowing_i.writedata   => avalon_slave_L_buffer_writedata,
			mask_enable_i                     => s_spacewire_write_registers.windowing_control.mask_enable,
			avalon_mm_windowing_o.waitrequest => avalon_slave_L_buffer_waitrequest,
			window_data_write_o               => s_L_window_data_write,
			window_mask_write_o               => s_L_window_mask_write,
			window_data_o                     => s_L_window_data
		);

	-- left windowing buffer instantiation
	left_windowing_buffer_ent_inst : entity work.windowing_buffer_ent
		port map(
			clk_i                 => a_clock,
			rst_i                 => a_reset,
			window_data_write_i   => s_L_window_data_write,
			window_mask_write_i   => s_L_window_mask_write,
			window_data_i         => s_L_window_data,
			window_data_read_i    => s_L_window_data_read,
			window_mask_read_i    => s_L_window_mask_read,
			window_data_o         => s_L_window_data_out,
			window_mask_o         => s_L_window_mask_out,
			window_data_ready_o   => s_L_window_data_ready,
			window_mask_ready_o   => s_L_window_mask_ready,
			window_buffer_empty_o => s_spacewire_read_registers.windowing_buffer.L_buffer_empty
		);

	-- data controller instantiation
	data_controller_ent_inst : entity work.data_controller_ent
		port map(
			clk_i                 => a_clock,
			rst_i                 => a_reset,
			mask_enable_i         => s_spacewire_write_registers.windowing_control.mask_enable,
			window_data_R_i       => s_R_window_data_out,
			window_mask_R_i       => s_R_window_mask_out,
			window_data_R_ready_i => s_R_window_data_ready,
			window_mask_R_ready_i => s_R_window_mask_ready,
			window_data_L_i       => s_L_window_data_out,
			window_mask_L_i       => s_L_window_mask_out,
			window_data_L_ready_i => s_L_window_data_ready,
			window_mask_L_ready_i => s_L_window_mask_ready,
			spw_txrdy_i           => s_spw_txrdy,
			window_data_R_read_o  => s_R_window_data_read,
			window_mask_R_read_o  => s_R_window_mask_read,
			window_data_L_read_o  => s_L_window_data_read,
			window_mask_L_read_o  => s_L_window_mask_read,
			spw_txwrite_o         => s_spw_txwrite,
			spw_txflag_o          => s_spw_txflag,
			spw_txdata_o          => s_spw_txdata
		);

	-- spw codec instantiation 
	spw_codec_ent_inst : entity work.spw_codec_ent
		port map(
			clk_200                             => a_clock,
			rst                                 => a_reset,
			spw_codec_link_command_i.autostart  => s_spacewire_write_registers.windowing_control.autostart,
			spw_codec_link_command_i.linkstart  => s_spacewire_write_registers.windowing_control.linkstart,
			spw_codec_link_command_i.linkdis    => s_spacewire_write_registers.windowing_control.linkdis,
			spw_codec_link_command_i.txdivcnt   => x"01",
			spw_codec_ds_encoding_rx_i.spw_di   => data_in,
			spw_codec_ds_encoding_rx_i.spw_si   => strobe_in,
			spw_codec_timecode_tx_i.tick_in     => s_spacewire_write_registers.timecode_tx.tx_send,
			spw_codec_timecode_tx_i.ctrl_in     => s_spacewire_write_registers.timecode_tx.tx_control,
			spw_codec_timecode_tx_i.time_in     => s_spacewire_write_registers.timecode_tx.tx_time,
			spw_codec_data_rx_command_i.rxread  => s_spw_rxread,
			spw_codec_data_tx_command_i.txwrite => s_spw_txwrite,
			spw_codec_data_tx_command_i.txflag  => s_spw_txflag,
			spw_codec_data_tx_command_i.txdata  => s_spw_txdata,
			spw_codec_link_status_o.started     => s_spacewire_read_registers.windowing_status.started,
			spw_codec_link_status_o.connecting  => s_spacewire_read_registers.windowing_status.connecting,
			spw_codec_link_status_o.running     => s_spacewire_read_registers.windowing_status.running,
			spw_codec_ds_encoding_tx_o.spw_do   => data_out,
			spw_codec_ds_encoding_tx_o.spw_so   => strobe_out,
			spw_codec_link_error_o.errdisc      => s_spacewire_read_registers.windowing_status.errdis,
			spw_codec_link_error_o.errpar       => s_spacewire_read_registers.windowing_status.errpar,
			spw_codec_link_error_o.erresc       => s_spacewire_read_registers.windowing_status.erresc,
			spw_codec_link_error_o.errcred      => s_spacewire_read_registers.windowing_status.errcred,
			spw_codec_timecode_rx_o.tick_out    => s_spacewire_read_registers.timecode_rx.rx_received,
			spw_codec_timecode_rx_o.ctrl_out    => s_spacewire_read_registers.timecode_rx.rx_control,
			spw_codec_timecode_rx_o.time_out    => s_spacewire_read_registers.timecode_rx.rx_time,
			spw_codec_data_rx_status_o.rxvalid  => s_spw_rxvalid,
			spw_codec_data_rx_status_o.rxhalff  => open,
			spw_codec_data_rx_status_o.rxflag   => open,
			spw_codec_data_rx_status_o.rxdata   => open,
			spw_codec_data_tx_status_o.txrdy    => s_spw_txrdy,
			spw_codec_data_tx_status_o.txhalff  => open
		);

	avalon_slave_windowing_waitrequest <= ((s_avalon_mm_windwoing_read_waitrequest) and (s_avalon_mm_windwoing_write_waitrequest)) when (a_reset = '0') else ('1');

	p_codec_dummy_read : process(a_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_spw_rxread <= '0';
		elsif rising_edge(a_clock) then
			if (s_spw_rxvalid = '1') then
				s_spw_rxread <= '1';
			end if;
		end if;
	end process p_codec_dummy_read;

	p_interrupt_manager : process(a_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_spacewire_read_registers.interrupt_flag.buffer_empty_flag <= '0';
			s_R_buffer_empty_delayed                                    <= '0';
			s_L_buffer_empty_delayed                                    <= '0';
		elsif rising_edge(a_clock) then
			-- flag clear
			if (s_spacewire_write_registers.interrupt_flag_clear.buffer_empty_flag = '1') then
				s_spacewire_read_registers.interrupt_flag.buffer_empty_flag <= '0';
			end if;
			-- check if the R empty buffer interrupt is activated
			if (s_spacewire_write_registers.interrupt_control.R_buffer_empty_enable = '1') then
				-- detect a rising edge in of the R buffer empty signals
				if (((s_R_buffer_empty_delayed = '0') and (s_spacewire_read_registers.windowing_buffer.R_buffer_empty = '1'))) then
					s_spacewire_read_registers.interrupt_flag.buffer_empty_flag <= '1';
				end if;
			end if;
			-- check if the L empty buffer interrupt is activated
			if (s_spacewire_write_registers.interrupt_control.L_buffer_empty_enable = '1') then
				-- detect a rising edge in of the L buffer empty signals
				if (((s_L_buffer_empty_delayed = '0') and (s_spacewire_read_registers.windowing_buffer.L_buffer_empty = '1'))) then
					s_spacewire_read_registers.interrupt_flag.buffer_empty_flag <= '1';
				end if;
			end if;
			-- delay signals
			s_R_buffer_empty_delayed <= s_spacewire_read_registers.windowing_buffer.R_buffer_empty;
			s_L_buffer_empty_delayed <= s_spacewire_read_registers.windowing_buffer.L_buffer_empty;
		end if;
	end process p_interrupt_manager;

	interrupt_sender_irq <= s_spacewire_read_registers.interrupt_flag.buffer_empty_flag;

end architecture rtl;                   -- of comm_v1_01_top
