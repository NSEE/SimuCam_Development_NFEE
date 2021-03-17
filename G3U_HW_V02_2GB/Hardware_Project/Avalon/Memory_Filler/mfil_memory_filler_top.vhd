-- mfil_memory_filler_top.vhd

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

use work.mfil_config_avalon_mm_pkg.all;
use work.mfil_config_avalon_mm_registers_pkg.all;
use work.mfil_avm_data_pkg.all;

entity mfil_memory_filler_top is
	generic(
		g_MFIL_TESTBENCH_MODE : std_logic := '0'
	);
	port(
		clock_sink_clk_i                  : in  std_logic                     := '0'; --          --          clock_sink.clk
		reset_sink_reset_i                : in  std_logic                     := '0'; --          --          reset_sink.reset
		avalon_slave_config_address_i     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_slave_config.address
		avalon_slave_config_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                    .byteenable
		avalon_slave_config_write_i       : in  std_logic                     := '0'; --          --                    .write
		avalon_slave_config_writedata_i   : in  std_logic_vector(31 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_config_read_i        : in  std_logic                     := '0'; --          --                    .read
		avalon_slave_config_readdata_o    : out std_logic_vector(31 downto 0); --                  --                    .readdata
		avalon_slave_config_waitrequest_o : out std_logic; --                                      --                    .waitrequest
		avalon_master_data_waitrequest_i  : in  std_logic                     := '0'; --          --  avalon_master_data.waitrequest
		avalon_master_data_address_o      : out std_logic_vector(63 downto 0); --                  --                    .address
		avalon_master_data_write_o        : out std_logic; --                                      --                    .write
		avalon_master_data_writedata_o    : out std_logic_vector(255 downto 0) ---                 --                    .writedata
	);
end entity mfil_memory_filler_top;

architecture rtl of mfil_memory_filler_top is

	-- Alias --

	-- Basic Alias
	alias a_avs_clock is clock_sink_clk_i;
	alias a_reset is reset_sink_reset_i;

	-- IRQ Alias --

	-- Constants --

	-- Signals --

	-- Config Avalon MM Signals
	signal s_config_avalon_mm_read_waitrequest  : std_logic;
	signal s_config_avalon_mm_write_waitrequest : std_logic;

	-- Config Avalon MM Registers Signals
	signal s_config_write_registers : t_mfil_config_wr_registers;
	signal s_config_read_registers  : t_mfil_config_rd_registers;

	-- MFIL DATA AVM Controller Signals
	signal s_avm_data_master_wr_control   : t_mfil_avm_data_master_wr_control;
	signal s_avm_data_master_wr_status    : t_mfil_avm_data_master_wr_status;
	signal s_avm_slave_wr_control_address : std_logic_vector((c_MFIL_AVM_DATA_ADRESS_SIZE - 1) downto 0);

begin

	-- MFIL Config Avalon MM Testbench Stimulli Generate
	g_mfil_avs_config_testbench_stimulli : if (g_MFIL_TESTBENCH_MODE = '1') generate

		-- MFIL Config Avalon MM Testbench Stimulli
		mfil_config_avalon_mm_stimulli_inst : entity work.mfil_config_avalon_mm_stimulli
			port map(
				clk_i                       => a_avs_clock,
				rst_i                       => a_reset,
				avs_config_rd_regs_i        => s_config_read_registers,
				avs_config_wr_regs_o        => s_config_write_registers,
				avs_config_rd_readdata_o    => avalon_slave_config_readdata_o,
				avs_config_rd_waitrequest_o => s_config_avalon_mm_read_waitrequest,
				avs_config_wr_waitrequest_o => s_config_avalon_mm_write_waitrequest
			);

	end generate g_mfil_avs_config_testbench_stimulli;

	-- MFIL Config Avalon MM Read and Write Generate
	g_mfil_avs_config_read_write : if (g_MFIL_TESTBENCH_MODE = '0') generate

		-- MFIL Config Avalon MM Read Instantiation
		mfil_config_avalon_mm_read_ent_inst : entity work.mfil_config_avalon_mm_read_ent
			port map(
				clk_i                               => a_avs_clock,
				rst_i                               => a_reset,
				mfil_config_avalon_mm_i.address     => avalon_slave_config_address_i,
				mfil_config_avalon_mm_i.read        => avalon_slave_config_read_i,
				mfil_config_avalon_mm_i.byteenable  => avalon_slave_config_byteenable_i,
				mfil_config_avalon_mm_o.readdata    => avalon_slave_config_readdata_o,
				mfil_config_avalon_mm_o.waitrequest => s_config_avalon_mm_read_waitrequest,
				mfil_config_wr_regs_i               => s_config_write_registers,
				mfil_config_rd_regs_i               => s_config_read_registers
			);

		-- MFIL Config Avalon MM Write Instantiation
		mfil_config_avalon_mm_write_ent_inst : entity work.mfil_config_avalon_mm_write_ent
			port map(
				clk_i                               => a_avs_clock,
				rst_i                               => a_reset,
				mfil_config_avalon_mm_i.address     => avalon_slave_config_address_i,
				mfil_config_avalon_mm_i.write       => avalon_slave_config_write_i,
				mfil_config_avalon_mm_i.writedata   => avalon_slave_config_writedata_i,
				mfil_config_avalon_mm_i.byteenable  => avalon_slave_config_byteenable_i,
				mfil_config_avalon_mm_o.waitrequest => s_config_avalon_mm_write_waitrequest,
				mfil_config_wr_regs_o               => s_config_write_registers
			);

	end generate g_mfil_avs_config_read_write;

	-- MFIL Avalon MM Master (AVM) Writer Instantiation
	mfil_avm_data_writer_ent_inst : entity work.mfil_avm_data_writer_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_wr_control_i           => s_avm_data_master_wr_control,
			avm_slave_wr_status_i.waitrequest => avalon_master_data_waitrequest_i,
			avm_master_wr_status_o            => s_avm_data_master_wr_status,
			avm_slave_wr_control_o.address    => s_avm_slave_wr_control_address,
			avm_slave_wr_control_o.write      => avalon_master_data_write_o,
			avm_slave_wr_control_o.writedata  => avalon_master_data_writedata_o
		);

	-- MFIL Avalon MM Master (AVM) Writer Controller Instantiation
	mfil_avm_writer_controller_ent_inst : entity work.mfil_avm_writer_controller_ent
		generic map(
			g_DELAY_TIMEOUT_CLKDIV => 49999 -- [100 MHz / 50000 = 2 kHz = 0,5 ms]
		)
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			controller_wr_start_i                      => s_config_write_registers.data_control_reg.wr_start,
			controller_wr_reset_i                      => s_config_write_registers.data_control_reg.wr_reset,
			controller_wr_initial_addr_i(63 downto 32) => s_config_write_registers.data_control_reg.wr_initial_addr_high_dword,
			controller_wr_initial_addr_i(31 downto 0)  => s_config_write_registers.data_control_reg.wr_initial_addr_low_dword,
			controller_wr_length_bytes_i               => s_config_write_registers.data_control_reg.wr_data_length_bytes,
			controller_wr_data_i(255 downto 224)       => s_config_write_registers.data_control_reg.wr_data_value_dword_7,
			controller_wr_data_i(223 downto 192)       => s_config_write_registers.data_control_reg.wr_data_value_dword_6,
			controller_wr_data_i(191 downto 160)       => s_config_write_registers.data_control_reg.wr_data_value_dword_5,
			controller_wr_data_i(159 downto 128)       => s_config_write_registers.data_control_reg.wr_data_value_dword_4,
			controller_wr_data_i(127 downto 96)        => s_config_write_registers.data_control_reg.wr_data_value_dword_3,
			controller_wr_data_i(95 downto 64)         => s_config_write_registers.data_control_reg.wr_data_value_dword_2,
			controller_wr_data_i(63 downto 32)         => s_config_write_registers.data_control_reg.wr_data_value_dword_1,
			controller_wr_data_i(31 downto 0)          => s_config_write_registers.data_control_reg.wr_data_value_dword_0,
			controller_wr_timeout_i                    => s_config_write_registers.data_control_reg.wr_timeout,
			avm_master_wr_status_i                     => s_avm_data_master_wr_status,
			controller_wr_busy_o                       => s_config_read_registers.data_status_reg.wr_busy,
			controller_wr_timeout_err_o                => s_config_read_registers.data_status_reg.wr_timeout_err,
			avm_master_wr_control_o                    => s_avm_data_master_wr_control
		);

	-- Signals Assignments --

	-- Config Avalon Assignments
	avalon_slave_config_waitrequest_o <= ((s_config_avalon_mm_read_waitrequest) and (s_config_avalon_mm_write_waitrequest)) when (a_reset = '0') else ('1');

	-- Data Avalon Assignments
	avalon_master_data_address_o <= (s_avm_slave_wr_control_address) when (a_reset = '0') else ((others => '0'));

end architecture rtl;                   -- of mfil_memory_filler_top
