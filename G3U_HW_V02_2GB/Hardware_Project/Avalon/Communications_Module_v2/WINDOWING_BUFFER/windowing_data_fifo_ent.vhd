library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.windowing_fifo_pkg.all;

entity windowing_data_fifo_ent is
	port(
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		fifo_control_i : in  t_windowing_fifo_control;
		fifo_wr_data   : in  t_windowing_data_fifo_wr_data;
		fifo_status_o  : out t_windowing_fifo_status;
		fifo_rd_data   : out t_windowing_data_fifo_rd_data
	);
end entity windowing_data_fifo_ent;

architecture RTL of windowing_data_fifo_ent is

	signal s_aclr  : std_logic;
	signal s_sclr  : std_logic;
	signal s_usedw : std_logic_vector(7 downto 0);

begin

	-- windowing data fifo instantiation
	windowing_data_sc_fifo_inst : entity work.windowing_data_sc_fifo
		port map(
			aclr  => s_aclr,
			clock => clk_i,
			data  => fifo_wr_data.data,
			rdreq => fifo_control_i.read.rdreq,
			sclr  => s_sclr,
			wrreq => fifo_control_i.write.wrreq,
			empty => fifo_status_o.read.empty,
			full  => fifo_status_o.write.full,
			q     => fifo_rd_data.q,
			usedw => s_usedw
		);

	-- windowing data fifo clear signals
	s_aclr <= rst_i;
	s_sclr <= (fifo_control_i.read.sclr) or (fifo_control_i.write.sclr);

	-- windowing data fifo usedw signals
	fifo_status_o.read.usedw  <= s_usedw;
	fifo_status_o.write.usedw <= s_usedw;

end architecture RTL;
