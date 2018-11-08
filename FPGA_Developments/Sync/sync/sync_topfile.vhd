-- sync_topfile.vhd
-- Top level file of Sync ip module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;
use work.sync_gen_pkg.all;
use work.sync_outen_pkg.all;

entity sync_ent is
	generic (
		CLOCK_MHZ : integer := 50
	);
	port (
		reset_sink_reset            : in  std_logic                     := '0';
		clock_sink_clk              : in  std_logic                     := '0';
		avalon_slave_address        : in  std_logic_vector(7 downto 0)  := (others => '0');
		avalon_slave_read           : in  std_logic                     := '0';
		avalon_slave_write          : in  std_logic                     := '0';
		avalon_slave_writedata      : in  std_logic_vector(31 downto 0) := (others => '0');
		avalon_slave_readdata       : out std_logic_vector(31 downto 0);
		avalon_slave_waitrequest    : out std_logic;
		conduit_sync_signal_spwa    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwb    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwc    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwd    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwe    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwf    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwg    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_spwh    : out std_logic_vector(0 downto 0);
		conduit_sync_signal_syncin  : in  std_logic_vector(0 downto 0);
		conduit_sync_signal_syncout : out std_logic_vector(0 downto 0);
		interrupt_sender_irq        : out std_logic
	);
end entity sync_ent;

architecture rtl of sync_ent is

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

	signal s_avalon_mm_read_waitrequest  : std_logic_vector(0 downto 0);
	signal s_avalon_mm_write_waitrequest : std_logic_vector(0 downto 0);

	signal s_sync_mm_write_registers : t_sync_mm_write_registers;
	signal s_sync_mm_read_registers  : t_sync_mm_read_registers;

	signal s_sync_signal    : std_logic_vector(0 downto 0);
	signal s_syncgen_signal : std_logic_vector(0 downto 0);

begin
	a_avalon_mm_readata <= "00000000000000000000000000000000";

	a_avalon_mm_waitrequest <= '0';

	a_irq <= '0';

	sync_avalon_mm_read_inst : entity work.sync_avalon_mm_read
		port map (
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
		port map (
			clk_i                   => a_clock,
			rst_i                   => a_reset,
			avalon_mm_i.address     => a_avalon_mm_address,
			avalon_mm_i.write       => a_avalon_mm_write,
			avalon_mm_i.writedata   => a_avalon_mm_writedata,
			avalon_mm_o.waitrequest => s_avalon_mm_write_waitrequest,
			mm_write_reg_o          => s_sync_mm_write_registers
		);

	sync_gen_ent_inst : entity work.sync_gen_ent
		generic map (
			g_SYNC_COUNTER_WIDTH => c_SYNC_COUNTER_WIDTH
		)
		port map (
			clk_i                  	=> a_clock,
			reset_n_i             	=> s_reset_n,

			control_i.start        	=> s_sync_mm_write_registers.control_register.sync_start,
			control_i.reset        	=> s_sync_mm_write_registers.control_register.sync_reset,
			control_i.one_shot     	=> s_sync_mm_write_registers.control_register.sync_one_shot,
			control_i.err_inj	   	=> s_sync_mm_write_registers.control_register.sync_err_inj,

			configs_i.master_blank_time => s_sync_mm_write_registers.config_register.master_blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			configs_i.blank_time 		=> s_sync_mm_write_registers.config_register.blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			configs_i.period 			=> s_sync_mm_write_registers.config_register.period((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			configs_i.one_shot_time 	=> s_sync_mm_write_registers.config_register.one_shot_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			configs_i.number_of_cycles 	=> s_sync_mm_write_registers.config_register.general.number_of_cycles((c_SYNC_PULSE_NUMBER_WIDTH - 1) downto 0),
			configs_i.polarity		 	=> s_sync_mm_write_registers.config_register.general.signal_polarity,

			error_injection_i		=> s_sync_mm_write_registers.error_injection_register.error_injection(31 downto 0),

-- TODO - port map do interrupt register

-- TODO - revisar port map do status register
			flags_o.running        	=> s_sync_mm_read_registers.module_status_register.sync_running,
			error_o                	=> open,
--			
			sync_gen_o				=> s_syncgen_signal
		);

	sync_outen_ent_inst : entity work.sync_outen_ent
		port map (
			clk_i                            => a_clock,
			reset_n_i                        => s_reset_n,

			-- Post mux sync signal (ext/int)
			sync_signal_i                    => s_sync_signal,

			sync_control_i.channel_a_enable  => s_sync_mm_write_registers.control_register.channel_a_enable,
			sync_control_i.channel_b_enable  => s_sync_mm_write_registers.control_register.channel_b_enable,
			sync_control_i.channel_c_enable  => s_sync_mm_write_registers.control_register.channel_c_enable,
			sync_control_i.channel_d_enable  => s_sync_mm_write_registers.control_register.channel_d_enable,
			sync_control_i.channel_e_enable  => s_sync_mm_write_registers.control_register.channel_e_enable,
			sync_control_i.channel_f_enable  => s_sync_mm_write_registers.control_register.channel_f_enable,
			sync_control_i.channel_g_enable  => s_sync_mm_write_registers.control_register.channel_g_enable,
			sync_control_i.channel_h_enable  => s_sync_mm_write_registers.control_register.channel_h_enable,
			sync_control_i.sync_out_enable   => s_sync_mm_write_registers.control_register.sync_out_enable,

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

	-- Signals assignment
	s_reset_n               <= not a_reset;
	a_avalon_mm_waitrequest <= (s_avalon_mm_write_waitrequest) or (s_avalon_mm_read_waitrequest);
	
	-- Selection mux: internal ou external sync
	-- '1' -> internal sync
	-- '0' -> external sync
	s_sync_signal           <= (s_syncgen_signal) when (s_sync_mm_write_registers.control_register.sync_int_ext_n = '1') else (conduit_sync_signal_syncin);

end architecture rtl;                   -- of sync_ent
