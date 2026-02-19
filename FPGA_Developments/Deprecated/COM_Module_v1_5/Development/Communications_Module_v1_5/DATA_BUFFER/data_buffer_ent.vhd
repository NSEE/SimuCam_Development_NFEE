library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_controller_pkg.all;

entity data_buffer_ent is
	port(
		clk_i          : in  std_logic;
		rst_i          : in  std_logic;
		fifo_control_i : in  t_data_fifo_control;
		fifo_wr_data   : in  t_data_fifo_wr_data;
		fifo_status_o  : out t_data_fifo_status;
		fifo_rd_data   : out t_data_fifo_rd_data
	);
end entity data_buffer_ent;

architecture RTL of data_buffer_ent is

	signal s_aclr  : std_logic;
	signal s_sclr  : std_logic;
	signal s_usedw : std_logic_vector(8 downto 0);

begin

	-- data fifo instantiation
	scfifo_data_buffer_inst : entity work.scfifo_data_buffer
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

	-- data fifo clear signals
	s_aclr <= rst_i;
	s_sclr <= (fifo_control_i.read.sclr) or (fifo_control_i.write.sclr);

	-- data fifo usedw signals
	fifo_status_o.read.usedw  <= s_usedw;
	fifo_status_o.write.usedw <= s_usedw;

end architecture RTL;
