-- sync_topfile.vhd

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

use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;
use work.sync_syncgen_pkg.all;
use work.sync_outmux_pkg.all;

entity sync_component_ent is
	generic(
		Clock_Frequency_MHz : integer := 200
	);
	port(
		reset_sink_reset            : in  std_logic                     := '0'; --          --          reset_sink.reset
		clock_sink_clk              : in  std_logic                     := '0'; --          --          clock_sink.clk
		avalon_slave_address        : in  std_logic_vector(7 downto 0)  := (others => '0'); --        avalon_slave.address
		avalon_slave_read           : in  std_logic                     := '0'; --          --                    .read
		avalon_slave_write          : in  std_logic                     := '0'; --          --                    .write
		avalon_slave_writedata      : in  std_logic_vector(31 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_readdata       : out std_logic_vector(31 downto 0); --                 --                    .readdata
		avalon_slave_waitrequest    : out std_logic; --                                     --                    .waitrequest
		conduit_sync_signal_spwa    : out std_logic_vector(1 downto 0); --                  -- conduit_sync_signal.conduit_sync_signal_spwa_signal
		conduit_sync_signal_spwb    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwb_signal
		conduit_sync_signal_spwc    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwc_signal
		conduit_sync_signal_spwd    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwd_signal
		conduit_sync_signal_spwe    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwe_signal
		conduit_sync_signal_spwf    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwf_signal
		conduit_sync_signal_spwg    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwg_signal
		conduit_sync_signal_spwh    : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_spwh_signal
		conduit_sync_signal_syncin  : in  std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_syncin_signal
		conduit_sync_signal_syncout : out std_logic_vector(1 downto 0); --                  --                    .conduit_sync_signal_syncout_signal
		interrupt_sender_irq        : out std_logic --                                      --    interrupt_sender.irq
	);
end entity sync_component_ent;

architecture rtl of sync_component_ent is

	alias a_reset is reset_sink_reset;
	alias a_clock is clock_sink_clk;
	alias a_irq is interrupt_sender_irq;

	alias a_avalon_mm_address is avalon_slave_address;
	alias a_avalon_mm_read is avalon_slave_read;
	alias a_avalon_mm_readata is avalon_slave_readdata;
	alias a_avalon_mm_write is avalon_slave_write;
	alias a_avalon_mm_writedata is avalon_slave_writedata;
	alias a_avalon_mm_waitrequest is avalon_slave_waitrequest;

	signal s_reset_n : std_logic;

	signal s_avalon_mm_read_waitrequest  : std_logic_vector;
	signal s_avalon_mm_write_waitrequest : std_logic_vector;

	signal s_sync_mm_write_registers : t_sync_mm_write_registers;
	signal s_sync_mm_read_registers  : t_sync_mm_read_registers;

	signal s_sync_signal    : std_logic_vector(1 downto 0);
	signal s_syncgen_signal : std_logic_vector(1 downto 0);

begin

	-- TODO: Auto-generated HDL template

	avalon_slave_readdata <= "00000000000000000000000000000000";

	avalon_slave_waitrequest <= '0';

	interrupt_sender_irq <= '0';

	sync_avalon_mm_read_inst : entity work.sync_avalon_mm_read
		port map(
			clk_i                   => a_clock,
			rst_i                   => a_reset,
			avalon_mm_i.address     => a_avalon_mm_address,
			avalon_mm_i.read        => a_avalon_mm_read,
			mm_write_reg_i          => s_sync_mm_write_registers,
			mm_read_reg_i           => s_sync_mm_read_registers,
			avalon_mm_o.readdata    => a_avalon_mm_readata,
			avalon_mm_o.waitrequest => s_avalon_mm_read_waitrequest
		);

	sync_avalon_mm_write_inst : entity work.sync_avalon_mm_write
		port map(
			clk_i                   => a_clock,
			rst_i                   => a_reset,
			avalon_mm_i.address     => a_avalon_mm_address,
			avalon_mm_i.write       => a_avalon_mm_write,
			avalon_mm_i.writedata   => a_avalon_mm_writedata,
			avalon_mm_o.waitrequest => s_avalon_mm_write_waitrequest,
			mm_write_reg_o          => s_sync_mm_write_registers
		);

	sync_syncgen_ent_inst : entity work.sync_syncgen_ent
		generic map(
			g_SYNC_COUNTER_WIDTH => c_SYNC_COUNTER_WIDTH,
			g_SYNC_POLARITY      => c_SYNC_POLARITY
		)
		port map(
			clk_i                  => a_clock,
			reset_n_i              => s_reset_n,
			control_i.start        => s_sync_mm_write_registers.module_control_register.sync_start,
			control_i.stop         => s_sync_mm_write_registers.module_control_register.sync_stop,
			control_i.reset        => s_sync_mm_write_registers.module_control_register.sync_reset,
			configs_i.pulse_period => s_sync_mm_write_registers.signal_pulse_period_register.signal_pulse_period((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			configs_i.pulse_number => s_sync_mm_write_registers.signal_configuration_register.signal_number_pulses((c_SYNC_PULSE_NUMBER_WIDTH - 1) downto 0),
			configs_i.master_width => s_sync_mm_write_registers.signal_master_width_register.signal_master_width((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			configs_i.pulse_width  => s_sync_mm_write_registers.signal_pulse_width_register.signal_pulse_width((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			flags_o.running        => s_sync_mm_read_registers.module_status_register.sync_running,
			flags_o.stopped        => s_sync_mm_read_registers.module_status_register.sync_stopped,
			error_o                => open,
			sync_output_o          => s_syncgen_signal
		);

	sync_outmux_ent_inst : entity work.sync_outmux_ent
		generic map(
			g_SYNC_POLARITY => c_SYNC_POLARITY
		)
		port map(
			clk_i                            => a_clock,
			reset_n_i                        => s_reset_n,
			sync_signal_i                    => s_sync_signal,
			sync_control_i.channel_a_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_a_enable,
			sync_control_i.channel_b_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_b_enable,
			sync_control_i.channel_c_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_c_enable,
			sync_control_i.channel_d_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_d_enable,
			sync_control_i.channel_e_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_e_enable,
			sync_control_i.channel_f_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_f_enable,
			sync_control_i.channel_g_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_g_enable,
			sync_control_i.channel_h_enable  => s_sync_mm_write_registers.signal_configuration_register.channel_h_enable,
			sync_control_i.sync_out_enable   => s_sync_mm_write_registers.signal_configuration_register.sync_out_enable,
			sync_channels_o.channel_a_signal => conduit_sync_signal_spwa,
			sync_channels_o.channel_b_signal => conduit_sync_signal_spwb,
			sync_channels_o.channel_c_signal => conduit_sync_signal_spwc,
			sync_channels_o.channel_d_signal => conduit_sync_signal_spwd,
			sync_channels_o.channel_e_signal => conduit_sync_signal_spwe,
			sync_channels_o.channel_f_signal => conduit_sync_signal_spwf,
			sync_channels_o.channel_g_signal => conduit_sync_signal_spwg,
			sync_channels_o.channel_h_signal => conduit_sync_signal_spwh,
			sync_channels_o.sync_out_signal  => conduit_sync_signal_syncout
		);

	-- signals assingment
	s_reset_n               <= not a_reset;
	a_avalon_mm_waitrequest <= (s_avalon_mm_write_waitrequest) or (s_avalon_mm_read_waitrequest);
	s_sync_signal           <= (s_syncgen_signal) when (s_sync_mm_write_registers.signal_configuration_register.sync_in_enable = '1') else (conduit_sync_signal_syncin);

end architecture rtl;                   -- of sync_component_ent
