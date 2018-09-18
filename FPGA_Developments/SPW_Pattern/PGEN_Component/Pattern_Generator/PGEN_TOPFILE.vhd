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
use work.pgen_controller_pkg.all;
use work.pgen_data_fifo_pkg.all;
use work.pgen_mm_registers_pkg.all;
use work.pgen_pattern_pkg.all;
use work.pgen_pipeline_fifo_pkg.all;

entity pgen_component_ent is
	port(
		clock_sink_clk100                     : in  std_logic                     := '0'; --           -- clock_sink.clk_i
		reset_sink_reset                      : in  std_logic                     := '0'; --           -- reset_sink.a_reset
		avalon_mm_data_slave_address          : in  std_logic_vector(25 downto 0) := (others => '0'); -- avalon_mm_data_slave.address
		avalon_mm_data_slave_read             : in  std_logic                     := '0'; --           --                     .read
		avalon_mm_data_slave_readdata         : out std_logic_vector(63 downto 0); --                  --                     .readdata
		avalon_mm_data_slave_waitrequest      : out std_logic; --                                      --                     .waitrequest
		avalon_mm_data_slave_burstcount       : in  std_logic_vector(7 downto 0)  := (others => '0'); --                     .burstcount
		avalon_mm_data_slave_byteenable       : in  std_logic_vector(7 downto 0)  := (others => '0'); --                     .byteenable
		avalon_mm_data_slave_readdatavalid    : out std_logic; --                                      --                     .readdatavalid
		avalon_mm_registers_slave_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_mm_registers_slave.address
		avalon_mm_registers_slave_write       : in  std_logic                     := '0'; --           --                          .write
		avalon_mm_registers_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                          .writedata
		avalon_mm_registers_slave_read        : in  std_logic                     := '0'; --           --                          .read
		avalon_mm_registers_slave_readdata    : out std_logic_vector(31 downto 0); --                  --                          .readdata
		avalon_mm_registers_slave_waitrequest : out std_logic --                                       --                          .waitrequest
	);
end entity pgen_component_ent;

architecture rtl of pgen_component_ent is

	alias a_avalon_clock is clock_sink_clk100;
	alias a_reset is reset_sink_reset;

	signal s_waitrequest_reset : std_logic;

	signal s_pgen_avalon_mm_write_inputs  : t_pgen_avalon_mm_write_inputs;
	signal s_pgen_avalon_mm_write_outputs : t_pgen_avalon_mm_write_outputs;

	signal s_pgen_avalon_mm_read_inputs  : t_pgen_avalon_mm_read_inputs;
	signal s_pgen_avalon_mm_read_outputs : t_pgen_avalon_mm_read_outputs;

	signal s_pgen_mm_write_registers : t_pgen_mm_write_registers;
	signal s_pgen_mm_read_registers  : t_pgen_mm_read_registers;

	signal s_pgen_avalon_burst_read_inputs  : t_pgen_avalon_burst_read_inputs;
	signal s_pgen_avalon_burst_read_outputs : t_pgen_avalon_burst_read_outputs;

	signal s_pgen_burst_read_registers : t_pgen_burst_read_registers;

	signal s_pgen_controller_inputs  : t_pgen_controller_inputs;
	signal s_pgen_controller_outputs : t_pgen_controller_outputs;

begin

	pgen_avalon_mm_write_ent_inst : entity work.pgen_avalon_mm_write_ent
		port map(
			clk_i                     => a_avalon_clock,
			rst_i                     => a_reset,
			avalon_mm_write_inputs_i  => s_pgen_avalon_mm_write_inputs,
			mm_write_registers_o      => s_pgen_mm_write_registers,
			avalon_mm_write_outputs_o => s_pgen_avalon_mm_write_outputs
		);

	pgen_avalon_mm_read_ent_inst : entity work.pgen_avalon_mm_read_ent
		port map(
			clk_i                    => a_avalon_clock,
			rst_i                    => a_reset,
			mm_read_registers_i      => s_pgen_mm_read_registers,
			mm_write_registers_i     => s_pgen_mm_write_registers,
			avalon_mm_read_inputs_i  => s_pgen_avalon_mm_read_inputs,
			avalon_mm_read_outputs_o => s_pgen_avalon_mm_read_outputs
		);

	pgen_avalon_burst_read_ent_inst : entity work.pgen_avalon_burst_read_ent
		port map(
			clk_i                       => a_avalon_clock,
			rst_i                       => a_reset,
			burst_read_registers_i      => s_pgen_burst_read_registers,
			avalon_burst_read_inputs_i  => s_pgen_avalon_burst_read_inputs,
			pgen_controller_outputs_i   => s_pgen_controller_outputs,
			avalon_burst_read_outputs_o => s_pgen_avalon_burst_read_outputs,
			pgen_controller_inputs_o    => s_pgen_controller_inputs
		);

	pgen_controller_ent_inst : entity work.pgen_controller_ent
		port map(
			clk_i                       => a_avalon_clock,
			rst_i                       => a_reset,
			pgen_mm_write_registers_i   => s_pgen_mm_write_registers,
			pgen_controller_inputs_i    => s_pgen_controller_inputs,
			pgen_mm_read_registers_o    => s_pgen_mm_read_registers,
			pgen_burst_read_registers_o => s_pgen_burst_read_registers,
			pgen_controller_outputs_o   => s_pgen_controller_outputs
		);

	p_reset_procedure : process(a_reset) is
	begin
		if (a_reset = '1') then
			s_waitrequest_reset <= '1';
		else
			s_waitrequest_reset <= '0';
		end if;
	end process p_reset_procedure;

	--Signals assignments and port mapping
	s_pgen_avalon_mm_write_inputs.address   <= avalon_mm_registers_slave_address;
	s_pgen_avalon_mm_write_inputs.write     <= avalon_mm_registers_slave_write;
	s_pgen_avalon_mm_write_inputs.writedata <= avalon_mm_registers_slave_writedata;
	s_pgen_avalon_mm_read_inputs.address    <= avalon_mm_registers_slave_address;
	s_pgen_avalon_mm_read_inputs.read       <= avalon_mm_registers_slave_read;
	avalon_mm_registers_slave_readdata      <= s_pgen_avalon_mm_read_outputs.readdata;
	avalon_mm_registers_slave_waitrequest   <= (s_waitrequest_reset) or ((s_pgen_avalon_mm_write_outputs.waitrequest) and (s_pgen_avalon_mm_read_outputs.waitrequest));

	s_pgen_avalon_burst_read_inputs.address    <= avalon_mm_data_slave_address;
	s_pgen_avalon_burst_read_inputs.read       <= avalon_mm_data_slave_read;
	s_pgen_avalon_burst_read_inputs.byteenable <= avalon_mm_data_slave_byteenable;
	s_pgen_avalon_burst_read_inputs.burstcount <= avalon_mm_data_slave_burstcount;
	avalon_mm_data_slave_readdata              <= s_pgen_avalon_burst_read_outputs.readdata;
	avalon_mm_data_slave_waitrequest           <= (s_waitrequest_reset) or (s_pgen_avalon_burst_read_outputs.waitrequest);
	avalon_mm_data_slave_readdatavalid         <= s_pgen_avalon_burst_read_outputs.readdatavalid;

end architecture rtl;                   -- of pgen_component_ent
