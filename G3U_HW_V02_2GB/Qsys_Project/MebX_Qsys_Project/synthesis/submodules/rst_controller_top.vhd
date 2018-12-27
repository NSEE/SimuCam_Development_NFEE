-- rst_controller_top.vhd

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

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity rst_controller_top is
	port(
		avalon_slave_rst_controller_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); -- avalon_slave_rst_controller.address
		avalon_slave_rst_controller_write       : in  std_logic                     := '0'; --          --                            .write
		avalon_slave_rst_controller_read        : in  std_logic                     := '0'; --          --                            .read
		avalon_slave_rst_controller_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                            .writedata
		avalon_slave_rst_controller_readdata    : out std_logic_vector(31 downto 0); --                 --                            .readdata
		avalon_slave_rst_controller_waitrequest : out std_logic; --                                     --                            .waitrequest
		clock_sink_clk                          : in  std_logic                     := '0'; --          --                  clock_sink.clk
		reset_sink_reset                        : in  std_logic                     := '0'; --          --                  reset_sink.reset
		reset_source_reset                      : out std_logic --                                      --                reset_source.reset
	);
end entity rst_controller_top;

architecture rtl of rst_controller_top is

	alias a_clock is clock_sink_clk;
	alias a_reset is reset_sink_reset;

	-- constants

	-- signals

	-- rst controller avalon mm read signals
	signal s_avalon_mm_rst_controller_read_waitrequest : std_logic;

	-- rst controller avalon mm write signals
	signal s_avalon_mm_rst_controller_write_waitrequest : std_logic;

	-- windowing avalon mm registers signals
	signal s_rst_controller_write_registers : t_rst_controller_write_registers;

begin

	-- rst_controller avalon mm read instantiation
	avalon_mm_rst_controller_read_ent_inst : entity work.avalon_mm_rst_controller_read_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_rst_controller_address,
			avalon_mm_spacewire_i.read        => avalon_slave_rst_controller_read,
			avalon_mm_spacewire_o.readdata    => avalon_slave_rst_controller_readdata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_rst_controller_read_waitrequest,
			rst_controller_write_registers_i  => s_rst_controller_write_registers
		);

	-- rst_controller avalon mm write instantiation
	avalon_mm_rst_controller_write_ent_inst : entity work.avalon_mm_rst_controller_write_ent
		port map(
			clk_i                             => a_clock,
			rst_i                             => a_reset,
			avalon_mm_spacewire_i.address     => avalon_slave_rst_controller_address,
			avalon_mm_spacewire_i.write       => avalon_slave_rst_controller_write,
			avalon_mm_spacewire_i.writedata   => avalon_slave_rst_controller_writedata,
			avalon_mm_spacewire_o.waitrequest => s_avalon_mm_rst_controller_write_waitrequest,
			rst_controller_write_registers_o  => s_rst_controller_write_registers
		);

	avalon_slave_rst_controller_waitrequest <= ((s_avalon_mm_rst_controller_read_waitrequest) and (s_avalon_mm_rst_controller_write_waitrequest)) when (a_reset = '0') else ('1');

	reset_source_reset <= (s_rst_controller_write_registers.reset_controller.reset) when (a_reset = '0') else ('1');

end architecture rtl;                   -- of rst_controller_top
