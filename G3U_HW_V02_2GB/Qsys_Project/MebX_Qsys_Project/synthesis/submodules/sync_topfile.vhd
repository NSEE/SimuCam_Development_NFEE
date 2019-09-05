--=============================================================================
--! @file sync_topfile.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--! Specific packages
use work.sync_mm_registers_pkg.all;
use work.sync_avalon_mm_pkg.all;
use work.sync_gen_pkg.all;
use work.sync_outen_pkg.all;
use work.sync_int_pkg.all;

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
	port(
		reset_sink_reset            : in  std_logic                     := '0';
		clock_sink_clk              : in  std_logic                     := '0';
		conduit_sync_signal_syncin  : in  std_logic                     := '0';
		avalon_slave_address        : in  std_logic_vector(7 downto 0)  := (others => '0');
		avalon_slave_read           : in  std_logic                     := '0';
		avalon_slave_write          : in  std_logic                     := '0';
		avalon_slave_writedata      : in  std_logic_vector(31 downto 0) := (others => '0');
		avalon_slave_readdata       : out std_logic_vector(31 downto 0);
		avalon_slave_waitrequest    : out std_logic;
		conduit_sync_signal_spwa    : out std_logic;
		conduit_sync_signal_spwb    : out std_logic;
		conduit_sync_signal_spwc    : out std_logic;
		conduit_sync_signal_spwd    : out std_logic;
		conduit_sync_signal_spwe    : out std_logic;
		conduit_sync_signal_spwf    : out std_logic;
		conduit_sync_signal_spwg    : out std_logic;
		conduit_sync_signal_spwh    : out std_logic;
		conduit_sync_signal_syncout : out std_logic;
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

	signal s_avalon_mm_read_waitrequest  : std_logic;
	signal s_avalon_mm_write_waitrequest : std_logic;

	signal s_sync_mm_write_registers : t_sync_mm_write_registers;
	signal s_sync_mm_read_registers  : t_sync_mm_read_registers;

	signal s_sync_signal    : std_logic;
	signal s_syncgen_signal : std_logic;

	-- irq signas
	signal s_irq_sync         : std_logic;
	signal s_irq_sync_delayed : std_logic;

	signal s_irq_flag_clear : std_logic;
	signal s_irq_flag       : std_logic;

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	-- avalon_mm_read module instantiation
	sync_avalon_mm_read_inst : entity work.sync_avalon_mm_read
		port map(
			clk_i                   => a_clock,
			rst_i                   => a_reset,
			avalon_mm_i.address     => a_avalon_mm_address,
			avalon_mm_i.read        => a_avalon_mm_read,
			mm_write_reg_i          => s_sync_mm_write_registers,
			mm_read_reg_i           => s_sync_mm_read_registers,
			sync_irq_flag_i         => s_irq_flag,
			avalon_mm_o.readdata    => a_avalon_mm_readata,
			avalon_mm_o.waitrequest => s_avalon_mm_read_waitrequest
		);

	-- avalon_mm_write module instantiation
	sync_avalon_mm_write_inst : entity work.sync_avalon_mm_write
		port map(
			clk_i                   => a_clock,
			rst_i                   => a_reset,
			avalon_mm_i.address     => a_avalon_mm_address,
			avalon_mm_i.write       => a_avalon_mm_write,
			avalon_mm_i.writedata   => a_avalon_mm_writedata,
			avalon_mm_o.waitrequest => s_avalon_mm_write_waitrequest,
			mm_write_reg_o          => s_sync_mm_write_registers,
			sync_irq_trigger_o      => s_irq_flag_clear
		);

	-- Sync generator module instantiation
	sync_gen_inst : entity work.sync_gen
		port map(
			clk_i                      => a_clock,
			reset_n_i                  => s_reset_n,
			-- Control
			control_i.start            => s_sync_mm_write_registers.control_register.start,
			control_i.reset            => s_sync_mm_write_registers.control_register.reset,
			control_i.one_shot         => s_sync_mm_write_registers.control_register.one_shot,
			control_i.err_inj          => s_sync_mm_write_registers.control_register.err_inj,
			-- Config
			config_i.master_blank_time => s_sync_mm_write_registers.config_register.master_blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.blank_time        => s_sync_mm_write_registers.config_register.blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.period            => s_sync_mm_write_registers.config_register.period((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.one_shot_time     => s_sync_mm_write_registers.config_register.one_shot_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.signal_polarity   => s_sync_mm_write_registers.config_register.general.signal_polarity,
			config_i.number_of_cycles  => s_sync_mm_write_registers.config_register.general.number_of_cycles((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0),
			-- Error injection
			err_inj_i.error_injection  => s_sync_mm_write_registers.error_injection_register.error_injection,
			-- Status
			status_o.state             => s_sync_mm_read_registers.status_register.state,
			status_o.cycle_number      => s_sync_mm_read_registers.status_register.cycle_number,
			-- Final internal generated sync signal
			sync_gen_o                 => s_syncgen_signal
		);

	-- Output enable module instantiation
	sync_outen_inst : entity work.sync_outen
		port map(
			clk_i                            => a_clock,
			reset_n_i                        => s_reset_n,
			-- Post mux sync signal (ext/int)
			sync_signal_i                    => s_sync_signal,
			-- Blank pulse sync polarity
			sync_pol_i                       => s_sync_mm_write_registers.config_register.general.signal_polarity,
			-- Enable controls
			sync_control_i.channel_a_enable  => s_sync_mm_write_registers.control_register.channel_a_enable,
			sync_control_i.channel_b_enable  => s_sync_mm_write_registers.control_register.channel_b_enable,
			sync_control_i.channel_c_enable  => s_sync_mm_write_registers.control_register.channel_c_enable,
			sync_control_i.channel_d_enable  => s_sync_mm_write_registers.control_register.channel_d_enable,
			sync_control_i.channel_e_enable  => s_sync_mm_write_registers.control_register.channel_e_enable,
			sync_control_i.channel_f_enable  => s_sync_mm_write_registers.control_register.channel_f_enable,
			sync_control_i.channel_g_enable  => s_sync_mm_write_registers.control_register.channel_g_enable,
			sync_control_i.channel_h_enable  => s_sync_mm_write_registers.control_register.channel_h_enable,
			sync_control_i.sync_out_enable   => s_sync_mm_write_registers.control_register.out_enable,
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

	-- Sync Interrupt module instantiation
	sync_int_inst : entity work.sync_int
		port map(
			clk_i                                       => a_clock,
			reset_n_i                                   => s_reset_n,
			-- Int enable
			int_enable_i.error_int_enable               => s_sync_mm_write_registers.int_enable_register.error_int_enable,
			int_enable_i.blank_pulse_int_enable         => s_sync_mm_write_registers.int_enable_register.blank_pulse_int_enable,
			-- Int flag clear
			int_flag_clear_i.error_int_flag_clear       => s_sync_mm_write_registers.int_flag_clear_register.error_int_flag_clear,
			int_flag_clear_i.blank_pulse_int_flag_clear => s_sync_mm_write_registers.int_flag_clear_register.blank_pulse_int_flag_clear,
			-- Input watch signals (that can produce interrupts)
			int_watch_i.error_code_watch                => s_sync_mm_read_registers.status_register.error_code,
			int_watch_i.sync_wave_watch                 => s_sync_signal,
			-- Aux to inform sync polarity
			int_watch_i.sync_pol_watch                  => s_sync_mm_write_registers.config_register.general.signal_polarity,
			-- Int flag
			int_flag_o.error_int_flag                   => s_sync_mm_read_registers.int_flag_register.error_int_flag,
			int_flag_o.blank_pulse_int_flag             => s_sync_mm_read_registers.int_flag_register.blank_pulse_int_flag,
			irq_o                                       => s_irq_sync
		);

	-- Signals assignment (concurrent code)
	s_reset_n               <= not a_reset;
	a_avalon_mm_waitrequest <= ((s_avalon_mm_write_waitrequest) and (s_avalon_mm_read_waitrequest)) or (a_reset);

	-- Sync mux: internal ou external sync
	-- '1' -> internal sync
	-- '0' -> external sync
	s_sync_signal <= (s_syncgen_signal) when (s_sync_mm_write_registers.control_register.int_ext_n = '1') else (conduit_sync_signal_syncin);

	-- Sync mux status
	s_sync_mm_read_registers.status_register.int_ext_n <= s_sync_mm_write_registers.control_register.int_ext_n;

	-- Keep error code status reseted (no error) - It´s logic should be conceived
	s_sync_mm_read_registers.status_register.error_code <= (others => '0');

	-- Signals not used by ip logic. Initial levels made here, to suppress IDE "using don´t care ('x') value"
	s_sync_mm_read_registers.int_flag_register.error_int_enable           <= '0';
	s_sync_mm_read_registers.int_flag_register.blank_pulse_int_enable     <= '0';
	s_sync_mm_read_registers.int_flag_register.error_int_flag_clear       <= '0';
	s_sync_mm_read_registers.int_flag_register.blank_pulse_int_flag_clear <= '0';
	s_sync_mm_read_registers.error_injection_register.error_injection     <= (others => '0');
	s_sync_mm_read_registers.config_register.master_blank_time            <= (others => '0');
	s_sync_mm_read_registers.config_register.blank_time                   <= (others => '0');
	s_sync_mm_read_registers.config_register.period                       <= (others => '0');
	s_sync_mm_read_registers.config_register.one_shot_time                <= (others => '0');
	s_sync_mm_read_registers.config_register.general.signal_polarity      <= '0';
	s_sync_mm_read_registers.config_register.general.number_of_cycles     <= (others => '0');
	s_sync_mm_read_registers.control_register                             <= (others => '0');

	--		signal s_irq_flag_clear : std_logic;
	--	signal s_irq_flag : std_logic;

	-- ir manager
	p_sync_irq_manager : process(a_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_irq_flag         <= '0';
			s_irq_sync_delayed <= '0';
		elsif rising_edge(a_clock) then
			-- flag clear
			if (s_irq_flag_clear = '1') then
				s_irq_flag <= '0';
			end if;
			-- detect a rising edge in sync signal
			if (((s_irq_sync_delayed = '0') and (s_irq_sync = '1'))) then
				s_irq_flag <= '1';
			end if;
			-- delay signals
			s_irq_sync_delayed <= s_irq_sync;
		end if;
	end process p_sync_irq_manager;
	a_irq <= s_irq_flag;

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
