library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pgen_data_controller_pkg.all;
use work.pgen_pattern_generator_pkg.all;
use work.pgen_burst_registers_pkg.all;
use work.pgen_data_fifo_pkg.all;

entity pgen_data_controller_ent is
	port(
		clk_i                    : in  std_logic;
		rst_i                    : in  std_logic;
		write_control_i          : in  t_pgen_data_write_control;
		read_control_i           : in  t_pgen_data_read_control;
		pattern_generator_data_i : in  t_pgen_pattern_generator_data;
		write_status_o           : out t_pgen_data_write_status;
		read_status_o            : out t_pgen_data_read_status;
		pattern_data_register_o  : out t_pgen_pattern_data_register
	);
end entity pgen_data_controller_ent;

architecture rtl of pgen_data_controller_ent is

	signal s_data_fifo_i : t_pgen_data_fifo_inputs;
	signal s_data_fifo_o : t_pgen_data_fifo_inputs;

begin

	pgen_data_sc_fifo_inst : entity work.data_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_data_fifo_i.data,
			rdreq => s_data_fifo_i.rdreq,
			sclr  => s_data_fifo_i.sclr,
			wrreq => s_data_fifo_i.wrreq,
			empty => s_data_fifo_o.empty,
			full  => s_data_fifo_o.full,
			q     => s_data_fifo_o.q
		);

	-- Signals assingments

	s_data_fifo_i.data(63 downto 48) <= pattern_generator_data_i.pattern_pixel_3;
	s_data_fifo_i.data(47 downto 32) <= pattern_generator_data_i.pattern_pixel_2;
	s_data_fifo_i.data(31 downto 16) <= pattern_generator_data_i.pattern_pixel_1;
	s_data_fifo_i.data(15 downto 0)  <= pattern_generator_data_i.pattern_pixel_0;
	s_data_fifo_i.rdreq              <= read_control_i.data_fetch;
	s_data_fifo_i.sclr               <= write_control_i.data_erase;
	s_data_fifo_i.wrreq              <= write_control_i.data_write;

	write_status_o.empty                    <= s_data_fifo_o.empty;
	read_status_o.data_available            <= not (s_data_fifo_o.empty);
	write_status_o.full                     <= s_data_fifo_o.full;
	read_status_o.full                      <= s_data_fifo_o.full;
	pattern_data_register_o.pattern_pixel_3 <= s_data_fifo_o.q(63 downto 48);
	pattern_data_register_o.pattern_pixel_2 <= s_data_fifo_o.q(47 downto 32);
	pattern_data_register_o.pattern_pixel_1 <= s_data_fifo_o.q(31 downto 16);
	pattern_data_register_o.pattern_pixel_0 <= s_data_fifo_o.q(15 downto 0);

end architecture rtl;
