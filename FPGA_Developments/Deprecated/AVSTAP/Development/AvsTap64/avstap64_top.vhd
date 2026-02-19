-- avstap64_top.vhd

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

use work.avalon_mm_64_pkg.all;
use work.avalon_mm_32_pkg.all;
use work.avalon_mm_32_registers_pkg.all;

entity avstap64_top is
	port(
		reset_sink_reset            : in  std_logic                     := '0'; --          --      reset_sink.a_reset
		clock_sink_100_clk          : in  std_logic                     := '0'; --          --  clock_sink_100.clk
		avalon_slave_32_address     : in  std_logic_vector(11 downto 0) := (others => '0'); -- avalon_slave_32.address
		avalon_slave_32_write       : in  std_logic                     := '0'; --          --                .write
		avalon_slave_32_read        : in  std_logic                     := '0'; --          --                .read
		avalon_slave_32_readdata    : out std_logic_vector(31 downto 0); --                 --                .readdata
		avalon_slave_32_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --                .writedata
		avalon_slave_32_waitrequest : out std_logic; --                                     --                .waitrequest
		avalon_slave_64_address     : in  std_logic_vector(10 downto 0) := (others => '0'); -- avalon_slave_64.address
		avalon_slave_64_write       : in  std_logic                     := '0'; --          --                .write
		avalon_slave_64_writedata   : in  std_logic_vector(63 downto 0) := (others => '0'); --                .writedata
		avalon_slave_64_waitrequest : out std_logic --                                      --                .waitrequest
	);
end entity avstap64_top;

architecture rtl of avstap64_top is

	-- dummy ports
	alias a_avs_clock is clock_sink_100_clk;
	alias a_reset is reset_sink_reset;

	-- 32 avalon mm read signals
	signal s_avalon_mm_32_read_waitrequest : std_logic;

	-- 32 avalon mm write signals
	signal s_avalon_mm_32_write_waitrequest : std_logic;

	-- avstap avalon mm registers signals
	signal s_avstap_write_registers : t_avstap_write_registers;
	signal s_avstap_read_registers  : t_avstap_read_registers;

begin

	-- 32 avalon mm read instantiation
	avalon_mm_32_read_ent_inst : entity work.avalon_mm_32_read_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			avalon_mm_32_i.address     => avalon_slave_32_address,
			avalon_mm_32_i.read        => avalon_slave_32_read,
			avalon_mm_32_o.readdata    => avalon_slave_32_readdata,
			avalon_mm_32_o.waitrequest => s_avalon_mm_32_read_waitrequest,
			write_registers_i          => s_avstap_write_registers,
			read_registers_i           => s_avstap_read_registers
		);

	-- 32 avalon mm write instantiation
	avalon_mm_32_write_ent_inst : entity work.avalon_mm_32_write_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			avalon_mm_32_i.address     => avalon_slave_32_address,
			avalon_mm_32_i.write       => avalon_slave_32_write,
			avalon_mm_32_i.writedata   => avalon_slave_32_writedata,
			avalon_mm_32_o.waitrequest => s_avalon_mm_32_write_waitrequest,
			write_registers_o          => s_avstap_write_registers
		);

	-- 64 avalon mm write instantiation
	avalon_mm_64_write_ent_inst : entity work.avalon_mm_64_write_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			avalon_mm_64_i.address     => avalon_slave_64_address,
			avalon_mm_64_i.write       => avalon_slave_64_write,
			avalon_mm_64_i.writedata   => avalon_slave_64_writedata,
			avstap_clear_i             => s_avstap_write_registers.avstap_control.avstap_clear,
			avalon_mm_64_o.waitrequest => avalon_slave_64_waitrequest,
			write_registers_o          => s_avstap_read_registers
		);

	avalon_slave_32_waitrequest <= ((s_avalon_mm_32_read_waitrequest) and (s_avalon_mm_32_write_waitrequest)) when (a_reset = '0') else ('1');

end architecture rtl;                   -- of avstap64_top
