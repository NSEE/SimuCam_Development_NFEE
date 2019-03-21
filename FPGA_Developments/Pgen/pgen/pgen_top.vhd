--=============================================================================
--! @file pgen_top.vhd
--=============================================================================
--! Standard library
library ieee;
--! Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Specific packages
use work.pgen_mm_control_registers_pkg.all;
use work.pgen_mm_data_registers_pkg.all;
use work.pgen_avalon_mm_control_pkg.all;
use work.pgen_avalon_mm_data_pkg.all;
use work.pgen_pattern_generator_pkg.all;
use work.pgen_data_controller_pkg.all;
use work.pgen_data_fifo_pkg.all;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: Pgen Top (pgen_top)
--
--! @brief Top entity for the Pgen module developed to be used at  
--! Simucam.
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 21\02\2019
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 21\02\2019 RF File Creation\n
--!
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Entity declaration for Pgen Top
--============================================================================
entity pgen_component_ent is
	port(
		clock_i                               : in  std_logic                     := '0';
		reset_i                               : in  std_logic                     := '0';
		-- data port 64-bit
		avalon_mm_data_slave_address_i        : in  std_logic_vector(25 downto 0) := (others => '0');
		avalon_mm_data_slave_read_i           : in  std_logic                     := '0';
		avalon_mm_data_slave_readdata_o       : out std_logic_vector(63 downto 0);
		avalon_mm_data_slave_waitrequest_o    : out std_logic;
		-- control port 32-bit
		avalon_mm_control_slave_address_i     : in  std_logic_vector(7 downto 0)  := (others => '0');
		avalon_mm_control_slave_write_i       : in  std_logic                     := '0';
		avalon_mm_control_slave_writedata_i   : in  std_logic_vector(31 downto 0) := (others => '0');
		avalon_mm_control_slave_read_i        : in  std_logic                     := '0';
		avalon_mm_control_slave_readdata_o    : out std_logic_vector(31 downto 0);
		avalon_mm_control_slave_waitrequest_o : out std_logic
	);
end entity pgen_component_ent;

--============================================================================
-- ! architecture declaration
--============================================================================
architecture rtl of pgen_component_ent is

	alias a_avalon_clock is clock_i;
	alias a_reset is reset_i;

	signal s_mm_control_write_waitrequest : std_logic;
	signal s_mm_control_read_waitrequest  : std_logic;

	signal s_mm_control_write_registers : t_pgen_mm_control_write_registers;
	signal s_mm_control_read_registers  : t_pgen_mm_control_read_registers;

	signal s_mm_data_read_waitrequest : std_logic;

	signal s_mm_data_read_registers : t_pgen_mm_data_read_registers;

	signal s_data_controller_write_control : t_pgen_data_controller_write_control;
	signal s_data_controller_write_status  : t_pgen_data_controller_write_status;

	signal s_data_controller_read_control : t_pgen_data_controller_read_control;
	signal s_data_controller_read_status  : t_pgen_data_controller_read_status;

	signal s_pattern_generator_data : t_pgen_pattern_generator_data;

	--============================================================================
	-- architecture begin
	--============================================================================
begin
	-- Avalon data port read 64-bit
	pgen_avalon_mm_data_read_inst : entity work.pgen_avalon_mm_data_read
		port map(
			clk_i                                => a_avalon_clock,
			rst_i                                => a_reset,
			mm_read_registers_i                  => s_mm_data_read_registers,
			avalon_mm_read_inputs_i.address      => avalon_mm_data_slave_address_i,
			avalon_mm_read_inputs_i.read         => avalon_mm_data_slave_read_i,
			data_controller_read_status_i        => s_data_controller_read_status,
			avalon_mm_read_outputs_o.readdata    => avalon_mm_data_slave_readdata_o,
			avalon_mm_read_outputs_o.waitrequest => s_mm_data_read_waitrequest,
			data_controller_read_control_o       => s_data_controller_read_control
		);

	-- Avalon control port write 32-bit
	pgen_avalon_mm_control_write_inst : entity work.pgen_avalon_mm_control_write
		port map(
			clk_i                                 => a_avalon_clock,
			rst_i                                 => a_reset,
			avalon_mm_write_inputs_i.address      => avalon_mm_control_slave_address_i,
			avalon_mm_write_inputs_i.write        => avalon_mm_control_slave_write_i,
			avalon_mm_write_inputs_i.writedata    => avalon_mm_control_slave_writedata_i,
			mm_write_registers_o                  => s_mm_control_write_registers,
			avalon_mm_write_outputs_o.waitrequest => s_mm_control_write_waitrequest
		);

	-- Avalon control port read 32-bit
	pgen_avalon_mm_control_read_inst : entity work.pgen_avalon_mm_control_read
		port map(
			clk_i                                => a_avalon_clock,
			rst_i                                => a_reset,
			mm_read_registers_i                  => s_mm_control_read_registers,
			mm_write_registers_i                 => s_mm_control_write_registers,
			avalon_mm_read_inputs_i.address      => avalon_mm_control_slave_address_i,
			avalon_mm_read_inputs_i.read         => avalon_mm_control_slave_read_i,
			avalon_mm_read_outputs_o.readdata    => avalon_mm_control_slave_readdata_o,
			avalon_mm_read_outputs_o.waitrequest => s_mm_control_read_waitrequest
		);

	-- Data controller (manages generator writing access / avalon data port reading access) 
	pgen_data_controller_inst : entity work.pgen_data_controller
		port map(
			clk_i                    => a_avalon_clock,
			rst_i                    => a_reset,
			write_control_i          => s_data_controller_write_control,
			read_control_i           => s_data_controller_read_control,
			pattern_generator_data_i => s_pattern_generator_data,
			write_status_o           => s_data_controller_write_status,
			read_status_o            => s_data_controller_read_status,
			pattern_data_register_o  => s_mm_data_read_registers
		);

	-- Pattern generator
	pgen_pattern_generator_inst : entity work.pgen_pattern_generator
		port map(
			clk_i                           => a_avalon_clock,
			rst_i                           => a_reset,
			control_i.start                 => s_mm_control_write_registers.generator_control_register.start_bit,
			control_i.stop                  => s_mm_control_write_registers.generator_control_register.stop_bit,
			control_i.reset                 => s_mm_control_write_registers.generator_control_register.reset_bit,
			config_i.ccd_side               => s_mm_control_write_registers.pattern_parameters_register.ccd_side,
			config_i.ccd_number             => s_mm_control_write_registers.pattern_parameters_register.ccd_number,
			config_i.timecode               => s_mm_control_write_registers.pattern_parameters_register.timecode,
			config_i.rows_quantity          => s_mm_control_write_registers.pattern_size_register.rows_quantity,
			config_i.columns_quantity       => s_mm_control_write_registers.pattern_size_register.columns_quantity,
			data_controller_write_status_i  => s_data_controller_write_status,
			status_o.stopped                => s_mm_control_read_registers.generator_status_register.stopped_bit,
			status_o.resetted               => s_mm_control_read_registers.generator_status_register.reseted_bit,
			data_o                          => s_pattern_generator_data,
			data_controller_write_control_o => s_data_controller_write_control
		);

	-- Wait requests assignments
	avalon_mm_control_slave_waitrequest_o <= ('1') when (a_reset = '1') else ((s_mm_control_write_waitrequest) and (s_mm_control_read_waitrequest));
	avalon_mm_data_slave_waitrequest_o    <= ('1') when (a_reset = '1') else (s_mm_data_read_waitrequest);

end architecture rtl;                   -- of pgen_component_ent
--============================================================================
-- architecture end
--============================================================================
