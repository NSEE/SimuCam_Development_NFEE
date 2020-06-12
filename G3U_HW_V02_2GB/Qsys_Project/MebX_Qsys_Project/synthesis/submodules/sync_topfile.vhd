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
use work.sync_common_pkg.all;
use work.sync_gen_pkg.all;
use work.sync_outen_pkg.all;
use work.sync_irq_pkg.all;

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
	generic(
		g_SYNC_IRQ_NUMBER     : natural := 0;
		g_PRE_SYNC_IRQ_NUMBER : natural := 0
	);
	port(
		reset_sink_reset_i              : in  std_logic                     := '0';
		clock_sink_clk_i                : in  std_logic                     := '0';
		conduit_sync_signal_syncin_i    : in  std_logic                     := '0';
		avalon_slave_address_i          : in  std_logic_vector(7 downto 0)  := (others => '0');
		avalon_slave_read_i             : in  std_logic                     := '0';
		avalon_slave_write_i            : in  std_logic                     := '0';
		avalon_slave_writedata_i        : in  std_logic_vector(31 downto 0) := (others => '0');
		avalon_slave_byteenable_i       : in  std_logic_vector(3 downto 0);
		avalon_slave_readdata_o         : out std_logic_vector(31 downto 0);
		avalon_slave_waitrequest_o      : out std_logic;
		conduit_sync_signal_spw1_o      : out std_logic;
		conduit_sync_signal_spw2_o      : out std_logic;
		conduit_sync_signal_spw3_o      : out std_logic;
		conduit_sync_signal_spw4_o      : out std_logic;
		conduit_sync_signal_spw5_o      : out std_logic;
		conduit_sync_signal_spw6_o      : out std_logic;
		conduit_sync_signal_spw7_o      : out std_logic;
		conduit_sync_signal_spw8_o      : out std_logic;
		conduit_sync_signal_syncout_o   : out std_logic;
		sync_interrupt_sender_irq_o     : out std_logic;
		pre_sync_interrupt_sender_irq_o : out std_logic
	);
end entity sync_ent;

--============================================================================
--! architecture declaration
--============================================================================
architecture rtl of sync_ent is

	alias a_reset is reset_sink_reset_i;
	alias a_clock is clock_sink_clk_i;
	alias a_sync_irq is sync_interrupt_sender_irq_o;
	alias a_pre_sync_irq is pre_sync_interrupt_sender_irq_o;

	alias a_avalon_mm_address is avalon_slave_address_i;
	alias a_avalon_mm_read is avalon_slave_read_i;
	alias a_avalon_mm_readata is avalon_slave_readdata_o;
	alias a_avalon_mm_write is avalon_slave_write_i;
	alias a_avalon_mm_writedata is avalon_slave_writedata_i;
	alias a_avalon_mm_waitrequest is avalon_slave_waitrequest_o;
	alias a_avalon_mm_byteenable is avalon_slave_byteenable_i;

	signal s_reset_n : std_logic;

	signal s_avalon_mm_read_waitrequest  : std_logic;
	signal s_avalon_mm_write_waitrequest : std_logic;

	signal s_sync_mm_write_registers : t_sync_mm_write_registers;
	signal s_sync_mm_read_registers  : t_sync_mm_read_registers;

	signal s_sync_signal    : std_logic;
	signal s_syncgen_signal : std_logic;

	signal s_pre_sync_signal   : std_logic;
	signal s_next_cycle_number : std_logic_vector(7 downto 0);

	signal s_sync_processed                   : std_logic;
	signal s_sync_delay                       : std_logic;
	signal s_sync_processed_cycle_number      : std_logic_vector(7 downto 0);
	signal s_sync_processed_next_cycle_number : std_logic_vector(7 downto 0);
	signal s_sync_processed_time_counting     : std_logic;
	signal s_sync_processed_time_cnt          : std_logic_vector(31 downto 0);

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
			avalon_mm_i.byteenable  => a_avalon_mm_byteenable,
			mm_write_reg_i          => s_sync_mm_write_registers,
			mm_read_reg_i           => s_sync_mm_read_registers,
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
			avalon_mm_i.byteenable  => a_avalon_mm_byteenable,
			avalon_mm_o.waitrequest => s_avalon_mm_write_waitrequest,
			mm_write_reg_o          => s_sync_mm_write_registers
		);

	-- Sync generator module instantiation
	sync_gen_inst : entity work.sync_gen
		port map(
			clk_i                      => a_clock,
			reset_n_i                  => s_reset_n,
			-- Control
			control_i.start            => s_sync_mm_write_registers.sync_control_reg.start,
			control_i.reset            => s_sync_mm_write_registers.sync_control_reg.reset,
			control_i.one_shot         => s_sync_mm_write_registers.sync_control_reg.one_shot,
			control_i.err_inj          => s_sync_mm_write_registers.sync_control_reg.err_inj,
			-- Config
			config_i.master_blank_time => s_sync_mm_write_registers.sync_config_reg.master_blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.blank_time        => s_sync_mm_write_registers.sync_config_reg.blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.last_blank_time   => s_sync_mm_write_registers.sync_config_reg.last_blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.pre_blank_time    => s_sync_mm_write_registers.sync_config_reg.pre_blank_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.period            => s_sync_mm_write_registers.sync_config_reg.period((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.last_period       => s_sync_mm_write_registers.sync_config_reg.last_period((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.one_shot_time     => s_sync_mm_write_registers.sync_config_reg.one_shot_time((c_SYNC_COUNTER_WIDTH - 1) downto 0),
			config_i.signal_polarity   => s_sync_mm_write_registers.sync_general_config_reg.signal_polarity,
			config_i.number_of_cycles  => s_sync_mm_write_registers.sync_general_config_reg.number_of_cycles((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0),
			-- Error injection
			err_inj_i.error_injection  => s_sync_mm_write_registers.sync_error_injection_reg.error_injection,
			-- Status
			status_o.state             => s_sync_mm_read_registers.sync_status_reg.state,
			status_o.cycle_number      => s_sync_mm_read_registers.sync_status_reg.cycle_number,
			status_o.next_cycle_number => s_next_cycle_number,
			-- Final internal generated sync signal
			sync_gen_o                 => s_syncgen_signal,
			pre_sync_gen_o             => s_pre_sync_signal
		);

	-- Output enable module instantiation
	sync_outen_inst : entity work.sync_outen
		port map(
			clk_i                            => a_clock,
			reset_n_i                        => s_reset_n,
			-- Post mux sync signal (ext/int)
			sync_signal_i                    => s_sync_signal,
			-- Blank pulse sync polarity
			sync_pol_i                       => s_sync_mm_write_registers.sync_general_config_reg.signal_polarity,
			-- Enable controls
			sync_control_i.channel_1_enable  => s_sync_mm_write_registers.sync_control_reg.channel_1_enable,
			sync_control_i.channel_2_enable  => s_sync_mm_write_registers.sync_control_reg.channel_2_enable,
			sync_control_i.channel_3_enable  => s_sync_mm_write_registers.sync_control_reg.channel_3_enable,
			sync_control_i.channel_4_enable  => s_sync_mm_write_registers.sync_control_reg.channel_4_enable,
			sync_control_i.channel_5_enable  => s_sync_mm_write_registers.sync_control_reg.channel_5_enable,
			sync_control_i.channel_6_enable  => s_sync_mm_write_registers.sync_control_reg.channel_6_enable,
			sync_control_i.channel_7_enable  => s_sync_mm_write_registers.sync_control_reg.channel_7_enable,
			sync_control_i.channel_8_enable  => s_sync_mm_write_registers.sync_control_reg.channel_8_enable,
			sync_control_i.sync_out_enable   => s_sync_mm_write_registers.sync_control_reg.out_enable,
			-- Sync signal routing
			sync_channels_o.channel_1_signal => conduit_sync_signal_spw1_o,
			sync_channels_o.channel_2_signal => conduit_sync_signal_spw2_o,
			sync_channels_o.channel_3_signal => conduit_sync_signal_spw3_o,
			sync_channels_o.channel_4_signal => conduit_sync_signal_spw4_o,
			sync_channels_o.channel_5_signal => conduit_sync_signal_spw5_o,
			sync_channels_o.channel_6_signal => conduit_sync_signal_spw6_o,
			sync_channels_o.channel_7_signal => conduit_sync_signal_spw7_o,
			sync_channels_o.channel_8_signal => conduit_sync_signal_spw8_o,
			sync_channels_o.sync_out_signal  => conduit_sync_signal_syncout_o
		);

	-- Sync Interrupt module instantiation
	sync_irq_inst : entity work.sync_irq
		generic map(
			g_SYNC_DEFAULT_STBY_POLARITY => c_SYNC_DEFAULT_STBY_POLARITY,
			g_SYNC_DEFAULT_IRQ_POLARITY  => c_SYNC_DEFAULT_IRQ_POLARITY
		)
		port map(
			clk_i                                        => a_clock,
			reset_n_i                                    => s_reset_n,
			-- Irq enable
			irq_enable_i.error_irq_enable                => s_sync_mm_write_registers.sync_irq_enable_reg.error_irq_enable,
			irq_enable_i.blank_pulse_irq_enable          => s_sync_mm_write_registers.sync_irq_enable_reg.blank_pulse_irq_enable,
			irq_enable_i.master_pulse_irq_enable         => s_sync_mm_write_registers.sync_irq_enable_reg.master_pulse_irq_enable,
			irq_enable_i.normal_pulse_irq_enable         => s_sync_mm_write_registers.sync_irq_enable_reg.normal_pulse_irq_enable,
			irq_enable_i.last_pulse_irq_enable           => s_sync_mm_write_registers.sync_irq_enable_reg.last_pulse_irq_enable,
			-- Irq flag clear
			irq_flag_clear_i.error_irq_flag_clear        => s_sync_mm_write_registers.sync_irq_flag_clear_reg.error_irq_flag_clear,
			irq_flag_clear_i.blank_pulse_irq_flag_clear  => s_sync_mm_write_registers.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear,
			irq_flag_clear_i.master_pulse_irq_flag_clear => s_sync_mm_write_registers.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear,
			irq_flag_clear_i.normal_pulse_irq_flag_clear => s_sync_mm_write_registers.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear,
			irq_flag_clear_i.last_pulse_irq_flag_clear   => s_sync_mm_write_registers.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear,
			-- Input watch signals (that can produce interrupts)
			irq_watch_i.error_code_watch                 => s_sync_mm_read_registers.sync_status_reg.error_code,
			irq_watch_i.sync_cycle_number                => s_sync_processed_cycle_number((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0),
			irq_watch_i.sync_wave_watch                  => s_sync_processed,
			-- Aux to inform sync polarity
			irq_watch_i.sync_pol_watch                   => s_sync_mm_write_registers.sync_general_config_reg.signal_polarity,
			-- Aux to inform sync number of cycles
			irq_watch_i.sync_number_of_cycles            => s_sync_mm_write_registers.sync_general_config_reg.number_of_cycles((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0),
			-- Irq flag
			irq_flag_o.error_irq_flag                    => s_sync_mm_read_registers.sync_irq_flag_reg.error_irq_flag,
			irq_flag_o.blank_pulse_irq_flag              => s_sync_mm_read_registers.sync_irq_flag_reg.blank_pulse_irq_flag,
			irq_flag_o.master_pulse_irq_flag             => s_sync_mm_read_registers.sync_irq_flag_reg.master_pulse_irq_flag,
			irq_flag_o.normal_pulse_irq_flag             => s_sync_mm_read_registers.sync_irq_flag_reg.normal_pulse_irq_flag,
			irq_flag_o.last_pulse_irq_flag               => s_sync_mm_read_registers.sync_irq_flag_reg.last_pulse_irq_flag,
			irq_o                                        => a_sync_irq
		);

	-- Pre-Sync Interrupt module instantiation
	pre_sync_irq_inst : entity work.pre_sync_irq
		generic map(
			g_SYNC_DEFAULT_STBY_POLARITY => c_SYNC_DEFAULT_STBY_POLARITY,
			g_SYNC_DEFAULT_IRQ_POLARITY  => c_SYNC_DEFAULT_IRQ_POLARITY
		)
		port map(
			clk_i                                            => a_clock,
			reset_n_i                                        => s_reset_n,
			-- Irq enable
			irq_enable_i.pre_blank_pulse_irq_enable          => s_sync_mm_write_registers.pre_sync_irq_enable_reg.pre_blank_pulse_irq_enable,
			irq_enable_i.pre_master_pulse_irq_enable         => s_sync_mm_write_registers.pre_sync_irq_enable_reg.pre_master_pulse_irq_enable,
			irq_enable_i.pre_normal_pulse_irq_enable         => s_sync_mm_write_registers.pre_sync_irq_enable_reg.pre_normal_pulse_irq_enable,
			irq_enable_i.pre_last_pulse_irq_enable           => s_sync_mm_write_registers.pre_sync_irq_enable_reg.pre_last_pulse_irq_enable,
			-- Irq flag clear
			irq_flag_clear_i.pre_blank_pulse_irq_flag_clear  => s_sync_mm_write_registers.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear,
			irq_flag_clear_i.pre_master_pulse_irq_flag_clear => s_sync_mm_write_registers.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear,
			irq_flag_clear_i.pre_normal_pulse_irq_flag_clear => s_sync_mm_write_registers.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear,
			irq_flag_clear_i.pre_last_pulse_irq_flag_clear   => s_sync_mm_write_registers.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear,
			-- Input watch signals (that can produce interrupts)
			irq_watch_i.pre_sync_cycle_number                => s_sync_processed_next_cycle_number((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0),
			--			irq_watch_i.pre_sync_wave_watch                  => s_pre_sync_signal,
			irq_watch_i.pre_sync_wave_watch                  => s_sync_processed,
			-- Aux to inform pre-sync polarity
			irq_watch_i.pre_sync_pol_watch                   => '0',
			-- Aux to inform sync number of cycles
			irq_watch_i.pre_sync_number_of_cycles            => s_sync_mm_write_registers.sync_general_config_reg.number_of_cycles((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0),
			-- Irq flag
			irq_flag_o.pre_blank_pulse_irq_flag              => s_sync_mm_read_registers.pre_sync_irq_flag_reg.pre_blank_pulse_irq_flag,
			irq_flag_o.pre_master_pulse_irq_flag             => s_sync_mm_read_registers.pre_sync_irq_flag_reg.pre_master_pulse_irq_flag,
			irq_flag_o.pre_normal_pulse_irq_flag             => s_sync_mm_read_registers.pre_sync_irq_flag_reg.pre_normal_pulse_irq_flag,
			irq_flag_o.pre_last_pulse_irq_flag               => s_sync_mm_read_registers.pre_sync_irq_flag_reg.pre_last_pulse_irq_flag,
			irq_o                                            => a_pre_sync_irq
		);

	-- Sync process sigal
	p_sync_process_signal : process(a_clock, s_reset_n) is
		variable v_reseted_cnt : std_logic := '1';
	begin
		if (s_reset_n = '0') then
			s_sync_processed                   <= '0';
			s_sync_delay                       <= '0';
			s_sync_processed_cycle_number      <= std_logic_vector(to_unsigned(0, s_sync_processed_cycle_number'length));
			s_sync_processed_next_cycle_number <= std_logic_vector(to_unsigned(1, s_sync_processed_next_cycle_number'length));
			s_sync_processed_time_counting     <= '0';
			s_sync_processed_time_cnt          <= (others => '0');
			v_reseted_cnt                      := '1';
		elsif (rising_edge(a_clock)) then

			-- delay sync signal
			s_sync_delay     <= s_sync_signal;
			s_sync_processed <= s_sync_signal;

			-- check if a rising edge ocurred
			if ((s_sync_signal = '1') and (s_sync_delay = '0')) then
				-- rising edge ocurred
				-- check if the cnt was just reseted (no need to increment)
				if (v_reseted_cnt = '1') then
					v_reseted_cnt := '0';
				else
					-- increment counters
					if (s_sync_processed_cycle_number = std_logic_vector(unsigned(s_sync_mm_write_registers.sync_general_config_reg.number_of_cycles((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0)) - 1)) then
						s_sync_processed_cycle_number <= (others => '0');
					else
						s_sync_processed_cycle_number <= std_logic_vector(unsigned(s_sync_processed_cycle_number) + 1);
					end if;
					if (s_sync_processed_next_cycle_number = std_logic_vector(unsigned(s_sync_mm_write_registers.sync_general_config_reg.number_of_cycles((c_SYNC_CYCLE_NUMBER_WIDTH - 1) downto 0)) - 1)) then
						s_sync_processed_next_cycle_number <= (others => '0');
					else
						s_sync_processed_next_cycle_number <= std_logic_vector(unsigned(s_sync_processed_next_cycle_number) + 1);
					end if;
				end if;
			-- check if a falling edge ocurred
			elsif ((s_sync_signal = '0') and (s_sync_delay = '1')) then
				-- initiate 300 ms counter
				s_sync_processed_time_counting <= '1';
				s_sync_processed_time_cnt      <= std_logic_vector(unsigned(s_sync_mm_write_registers.sync_config_reg.master_detection_time) - 1);
				--				s_sync_processed_time_cnt      <= std_logic_vector(to_unsigned(15 - 1, s_sync_processed_time_cnt'length));
			end if;

			-- check if the timer is counting
			if (s_sync_processed_time_counting = '1') then
				-- check if the timer is finished
				if (s_sync_processed_time_cnt = std_logic_vector(to_unsigned(0, s_sync_processed_time_cnt'length))) then
					-- stop timer
					s_sync_processed_time_counting <= '0';
					s_sync_processed_time_cnt      <= (others => '0');
					-- check sync value
					if (s_sync_signal = '0') then
						-- reset counters to initial value
						s_sync_processed_cycle_number      <= std_logic_vector(to_unsigned(0, s_sync_processed_cycle_number'length));
						s_sync_processed_next_cycle_number <= std_logic_vector(to_unsigned(1, s_sync_processed_next_cycle_number'length));
						v_reseted_cnt                      := '1';
					end if;
				else
					-- decrement timer
					s_sync_processed_time_cnt <= std_logic_vector(unsigned(s_sync_processed_time_cnt) - 1);
				end if;
			end if;

		end if;
	end process p_sync_process_signal;

	-- Signals assignment (concurrent code)
	s_reset_n               <= not a_reset;
	a_avalon_mm_waitrequest <= ((s_avalon_mm_write_waitrequest) and (s_avalon_mm_read_waitrequest)) or (a_reset);

	-- Sync mux: internal ou external sync
	-- '1' -> internal sync
	-- '0' -> external sync
	s_sync_signal <= (s_syncgen_signal) when (s_sync_mm_write_registers.sync_control_reg.int_ext_n = '1') else (conduit_sync_signal_syncin_i);

	-- Sync mux status
	s_sync_mm_read_registers.sync_status_reg.int_ext_n <= s_sync_mm_write_registers.sync_control_reg.int_ext_n;

	-- Keep error code status reseted (no error) - It´s logic should be conceived
	s_sync_mm_read_registers.sync_status_reg.error_code <= (others => '0');

	-- Sync IRQ Number assignment
	s_sync_mm_read_registers.sync_irq_number_reg.sync_irq_number     <= std_logic_vector(to_unsigned(g_SYNC_IRQ_NUMBER, s_sync_mm_read_registers.sync_irq_number_reg.sync_irq_number'length));
	s_sync_mm_read_registers.sync_irq_number_reg.pre_sync_irq_number <= std_logic_vector(to_unsigned(g_PRE_SYNC_IRQ_NUMBER, s_sync_mm_read_registers.sync_irq_number_reg.pre_sync_irq_number'length));

	--	-- Signals not used by ip logic. Initial levels made here, to suppress IDE "using don´t care ('x') value"
	--	s_sync_mm_read_registers.irq_enable_register.error_irq_enable               <= '0';
	--	s_sync_mm_read_registers.irq_enable_register.blank_pulse_irq_enable         <= '0';
	--	s_sync_mm_read_registers.irq_flag_clear_register.error_irq_flag_clear       <= '0';
	--	s_sync_mm_read_registers.irq_flag_clear_register.blank_pulse_irq_flag_clear <= '0';
	--	s_sync_mm_read_registers.error_injection_register.error_injection           <= (others => '0');
	--	s_sync_mm_read_registers.config_register.master_blank_time                  <= (others => '0');
	--	s_sync_mm_read_registers.config_register.blank_time                         <= (others => '0');
	--	s_sync_mm_read_registers.config_register.period                             <= (others => '0');
	--	s_sync_mm_read_registers.config_register.one_shot_time                      <= (others => '0');
	--	s_sync_mm_read_registers.config_register.general.signal_polarity            <= '0';
	--	s_sync_mm_read_registers.config_register.general.number_of_cycles           <= (others => '0');
	--	s_sync_mm_read_registers.control_register                                   <= (others => '0');

end architecture rtl;
--============================================================================
-- architecture end
--============================================================================
