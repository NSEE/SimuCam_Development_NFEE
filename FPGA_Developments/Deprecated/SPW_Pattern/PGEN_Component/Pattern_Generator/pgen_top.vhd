-- new_component.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_avalon_burst_pkg.all;
use work.pgen_avalon_mm_pkg.all;
use work.pgen_burst_registers_pkg.all;
use work.pgen_mm_registers_pkg.all;
use work.pgen_pattern_generator_pkg.all;
use work.pgen_data_controller_pkg.all;
use work.pgen_data_fifo_pkg.all;

entity pgen_component_ent is
	port(
		clock_sink_clk100_i                     : in  std_logic                     := '0'; --          -- clock_sink.clk_i
		reset_sink_reset_i                      : in  std_logic                     := '0'; --          -- reset_sink.a_reset
		avalon_mm_data_slave_address_i          : in  std_logic_vector(25 downto 0) := (others => '0'); -- avalon_mm_data_slave.address
		avalon_mm_data_slave_read_i             : in  std_logic                     := '0'; --          --                     .read
		avalon_mm_data_slave_readdata_o         : out std_logic_vector(63 downto 0); --                 --                     .readdata
		avalon_mm_data_slave_waitrequest_o      : out std_logic; --                                     --                     .waitrequest
		avalon_mm_data_slave_burstcount_i       : in  std_logic_vector(7 downto 0)  := (others => '0'); --                     .burstcount
		avalon_mm_data_slave_byteenable_i       : in  std_logic_vector(7 downto 0)  := (others => '0'); --                     .byteenable
		avalon_mm_data_slave_readdatavalid_o    : out std_logic; --                                     --                     .readdatavalid
		avalon_mm_registers_slave_address_i     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_mm_registers_slave.address
		avalon_mm_registers_slave_write_i       : in  std_logic                     := '0'; --          --                          .write
		avalon_mm_registers_slave_writedata_i   : in  std_logic_vector(31 downto 0) := (others => '0'); --                          .writedata
		avalon_mm_registers_slave_read_i        : in  std_logic                     := '0'; --          --                          .read
		avalon_mm_registers_slave_readdata_o    : out std_logic_vector(31 downto 0); --                 --                          .readdata
		avalon_mm_registers_slave_waitrequest_o : out std_logic --                                      --                          .waitrequest
	);
end entity pgen_component_ent;

architecture rtl of pgen_component_ent is

	alias a_avalon_clock is clock_sink_clk100;
	alias a_reset is reset_sink_reset;

	signal s_mm_write_waitrequest : std_logic;
	signal s_mm_read_waitrequest  : std_logic;

	signal s_mm_write_registers : t_pgen_mm_write_registers;
	signal s_mm_read_registers  : t_pgen_mm_read_registers;

	signal s_burst_read_waitrequest : std_logic;

	signal s_burst_read_registers : t_pgen_burst_read_registers;

	signal s_data_controller_write_control : t_pgen_data_controller_write_control;
	signal s_data_controller_write_status  : t_pgen_data_controller_write_status;

	signal s_data_controller_read_control : t_pgen_data_controller_read_control;
	signal s_data_controller_read_status  : t_pgen_data_controller_read_status;

	signal s_pattern_generator_data : t_pgen_pattern_generator_data;

begin

	pgen_avalon_burst_read_ent_inst : entity work.pgen_avalon_burst_read_ent
		port map(
			clk_i                                     => a_avalon_clock,
			rst_i                                     => a_reset,
			burst_read_registers_i                    => s_burst_read_registers,
			avalon_burst_read_inputs_i.address        => avalon_mm_data_slave_address_i,
			avalon_burst_read_inputs_i.read           => avalon_mm_data_slave_read_i,
			avalon_burst_read_inputs_i.byteenable     => avalon_mm_data_slave_byteenable_i,
			avalon_burst_read_inputs_i.burstcount     => avalon_mm_data_slave_burstcount_i,
			data_controller_read_status_i             => s_data_controller_read_status,
			avalon_burst_read_outputs_o.readdata      => avalon_mm_data_slave_readdata_o,
			avalon_burst_read_outputs_o.waitrequest   => s_burst_read_waitrequest,
			avalon_burst_read_outputs_o.readdatavalid => avalon_mm_data_slave_readdatavalid_o,
			data_controller_read_control_o            => s_data_controller_read_control
		);

	pgen_avalon_mm_write_ent_inst : entity work.pgen_avalon_mm_write_ent
		port map(
			clk_i                                 => a_avalon_clock,
			rst_i                                 => a_reset,
			avalon_mm_write_inputs_i.address      => avalon_mm_registers_slave_address_i,
			avalon_mm_write_inputs_i.write        => avalon_mm_registers_slave_write_i,
			avalon_mm_write_inputs_i.writedata    => avalon_mm_registers_slave_writedata_i,
			mm_write_registers_o                  => s_mm_write_registers,
			avalon_mm_write_outputs_o.waitrequest => s_mm_write_waitrequest
		);

	pgen_avalon_mm_read_ent_inst : entity work.pgen_avalon_mm_read_ent
		port map(
			clk_i                                => a_avalon_clock,
			rst_i                                => a_reset,
			mm_read_registers_i                  => s_mm_read_registers,
			mm_write_registers_i                 => s_mm_write_registers,
			avalon_mm_read_inputs_i.address      => avalon_mm_registers_slave_address_i,
			avalon_mm_read_inputs_i.read         => avalon_mm_registers_slave_read_i,
			avalon_mm_read_outputs_o.readdata    => avalon_mm_registers_slave_readdata_o,
			avalon_mm_read_outputs_o.waitrequest => s_mm_read_waitrequest
		);

	pgen_data_controller_ent_inst : entity work.pgen_data_controller_ent
		port map(
			clk_i                    => a_avalon_clock,
			rst_i                    => a_reset,
			write_control_i          => s_data_controller_write_control,
			read_control_i           => s_data_controller_read_control,
			pattern_generator_data_i => s_pattern_generator_data,
			write_status_o           => s_data_controller_write_status,
			read_status_o            => s_data_controller_read_status,
			pattern_data_register_o  => s_burst_read_registers.pattern_data_register
		);

	pgen_pattern_generator_ent_inst : entity work.pgen_pattern_generator_ent
		port map(
			clk_i                           => a_avalon_clock,
			rst_i                           => a_reset,
			control_i.start                 => s_mm_write_registers.generator_control_register.start_bit,
			control_i.stop                  => s_mm_write_registers.generator_control_register.stop_bit,
			control_i.reset                 => s_mm_write_registers.generator_control_register.reset_bit,
			config_i.ccd_side               => s_mm_write_registers.pattern_parameters_register.ccd_side,
			config_i.ccd_number             => s_mm_write_registers.pattern_parameters_register.ccd_number,
			config_i.timecode               => s_mm_write_registers.pattern_parameters_register.timecode,
			config_i.rows_quantity          => s_mm_write_registers.pattern_size_register.rows_quantity,
			config_i.columns_quantity       => s_mm_write_registers.pattern_size_register.columns_quantity,
			data_controller_write_status_i  => s_data_controller_write_status,
			status_o.stopped                => s_mm_read_registers.generator_status_register.stopped_bit,
			status_o.resetted               => s_mm_read_registers.generator_status_register.reseted_bit,
			data_o                          => s_pattern_generator_data,
			data_controller_write_control_o => s_data_controller_write_control
		);

	-- Waitrequests assingments
	avalon_mm_data_slave_waitrequest_o      <= ('1') when (a_reset = '1') else (s_burst_read_waitrequest);
	avalon_mm_registers_slave_waitrequest_o <= ('1') when (a_reset = '1') else ((s_mm_write_waitrequest) or (s_mm_read_waitrequest));

end architecture rtl;                   -- of pgen_component_ent
