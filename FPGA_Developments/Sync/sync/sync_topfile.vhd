--=============================================================================
--! @file sync_topfile.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;
use work.sync_gen_pkg.all;
use work.sync_outen_pkg.all;

-------------------------------------------------------------------------------
-- --
-- Maua Institute of Technology - Embedded Electronic Systems Nucleous --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: sync top level file (sync_topfile)
--
--! @brief 
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Cassio Berni (ccberni@hotmail.com)
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 29\03\2018 RF File Creation\n
--! 08\11\2018 CB Module optimization & revision\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for sync top level
--============================================================================
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

--============================================================================
--! architecture declaration
--============================================================================
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

--============================================================================
-- architecture begin
--============================================================================
begin
	-- Init
	a_avalon_mm_readata <= "00000000_00000000_00000000_00000000";
	a_avalon_mm_waitrequest <= '0';
	a_irq <= '0';

	-- avalon_mm_read module instantiation
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

	-- avalon_mm_write module instantiation
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

	-- Sync generator module instantiation
	sync_gen_ent_inst : entity work.sync_gen_ent
		generic map (
			g_SYNC_COUNTER_WIDTH => c_SYNC_COUNTER_WIDTH
		)
		port map (
			clk_i                  	=> a_clock,
			reset_n_i             	=> s_reset_n,

			-- Control
			control_i.start        	=> s_sync_mm_write_registers.control_register.sync_start,
			control_i.reset        	=> s_sync_mm_write_registers.control_register.sync_reset,
			control_i.one_shot     	=> s_sync_mm_write_registers.control_register.sync_one_shot,
			control_i.err_inj	   	=> s_sync_mm_write_registers.control_register.sync_err_inj,

			-- Config
			config_i.master_blank_time	=> s_sync_mm_write_registers.config_register.master_blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.blank_time 		=> s_sync_mm_write_registers.config_register.blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.period 			=> s_sync_mm_write_registers.config_register.period((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.one_shot_time		=> s_sync_mm_write_registers.config_register.one_shot_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.polarity		 	=> s_sync_mm_write_registers.config_register.general.signal_polarity,
			config_i.number_of_cycles 	=> s_sync_mm_write_registers.config_register.general.number_of_cycles((c_SYNC_PULSE_NUMBER_WIDTH - 1) downto 0),

			-- Error injection
			err_inj_i				=> s_sync_mm_write_registers.error_injection_register.error_injection(31 downto 0),

			-- Isr enable and flag clear
			isr_i.blank_pulse_isr_enable => s_sync_mm_write_registers.interrupt_enable_register.blank_pulse_isr_en,
			isr_i.blank_pulse_isr_flag   => s_sync_mm_write_registers.interrupt_enable_register.blank_pulse_isr_flag,
			
			-- Status
			status_o.state     		=> s_sync_mm_read_registers.status_register.state,
			status_o.cycle_number	=> s_sync_mm_read_registers.status_register.cycle_number,

			-- Isr flag
			isr_o.blank_pulse_isr_flag   => s_sync_mm_read_registers.interrupt_enable_register.blank_pulse_isr_flag,

			-- Final internal generated sync signal
			sync_gen_o				=> s_syncgen_signal
		);

	-- Output enable module instantiation
	sync_outen_ent_inst : entity work.sync_outen_ent
		port map (
			clk_i                            => a_clock,
			reset_n_i                        => s_reset_n,

			-- Post mux sync signal (ext/int)
			sync_signal_i                    => s_sync_signal,

			-- Blank pulse sync polarity
			sync_pol_i						 => s_sync_mm_write_registers.config_register.general.signal_polarity,

			-- Enable controls
			sync_control_i.channel_a_enable  => s_sync_mm_write_registers.control_register.channel_a_enable,
			sync_control_i.channel_b_enable  => s_sync_mm_write_registers.control_register.channel_b_enable,
			sync_control_i.channel_c_enable  => s_sync_mm_write_registers.control_register.channel_c_enable,
			sync_control_i.channel_d_enable  => s_sync_mm_write_registers.control_register.channel_d_enable,
			sync_control_i.channel_e_enable  => s_sync_mm_write_registers.control_register.channel_e_enable,
			sync_control_i.channel_f_enable  => s_sync_mm_write_registers.control_register.channel_f_enable,
			sync_control_i.channel_g_enable  => s_sync_mm_write_registers.control_register.channel_g_enable,
			sync_control_i.channel_h_enable  => s_sync_mm_write_registers.control_register.channel_h_enable,
			sync_control_i.sync_out_enable   => s_sync_mm_write_registers.control_register.sync_out_enable,

			-- Sync signal routing
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

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
