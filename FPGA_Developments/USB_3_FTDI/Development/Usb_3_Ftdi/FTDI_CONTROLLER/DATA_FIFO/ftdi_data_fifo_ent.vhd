library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_data_fifo_pkg.all;

entity ftdi_data_fifo_ent is
	port(
		-- general signals
		reset_i      : in  std_logic;
		rd_clk_i     : in  std_logic;
		wr_clk_i     : in  std_logic;
		-- input signals
		rd_control_i : in  t_ftdi_data_fifo_rd_control;
		wr_control_i : in  t_ftdi_data_fifo_wr_control;
		wr_data_i    : in  t_ftdi_data_fifo_data;
		-- output signals
		rd_status_o  : out t_ftdi_data_fifo_rd_status;
		rd_data_o    : out t_ftdi_data_fifo_data;
		wr_status_o  : out t_ftdi_data_fifo_wr_status
	);
end entity ftdi_data_fifo_ent;

architecture RTL of ftdi_data_fifo_ent is

	signal s_rdreq   : std_logic;
	signal s_wrreq   : std_logic;
	signal s_rdempty : std_logic;
	signal s_wrfull  : std_logic;
	signal s_rddata  : std_logic_vector((c_FTDI_FIFO_WIDTH - 1) downto 0);
	signal s_wrdata  : std_logic_vector((c_FTDI_FIFO_WIDTH - 1) downto 0);

begin

	-- dc data fifo
	ftdi_data_dc_fifo_inst : entity work.ftdi_data_dc_fifo
		port map(
			aclr    => reset_i,
			data    => s_wrdata,
			rdclk   => rd_clk_i,
			rdreq   => s_rdreq,
			wrclk   => wr_clk_i,
			wrreq   => s_wrreq,
			q       => s_rddata,
			rdempty => s_rdempty,
			rdfull  => rd_status_o.rdfull,
			rdusedw => rd_status_o.rdusedw,
			wrempty => wr_status_o.wrempty,
			wrfull  => s_wrfull,
			wrusedw => wr_status_o.wrusedw
		);

	-- underflow/overflow protection
	s_rdreq <= (rd_control_i.rdreq) when (s_rdempty = '0') else ('0');
	s_wrreq <= (wr_control_i.wrreq) when (s_wrfull = '0') else ('0');

	rd_status_o.rdempty <= s_rdempty;
	wr_status_o.wrfull  <= s_wrfull;

	-- write data
	s_wrdata((c_FTDI_FIFO_WIDTH - 1) downto (c_FTDI_FIFO_WIDTH - c_FTDI_DATA_WIDTH)) <= wr_data_i.data;
	s_wrdata((c_FTDI_BE_WIDTH - 1) downto 0)                                         <= wr_data_i.be;

	-- read data
	rd_data_o.data <= s_rddata((c_FTDI_FIFO_WIDTH - 1) downto (c_FTDI_FIFO_WIDTH - c_FTDI_DATA_WIDTH));
	rd_data_o.be   <= s_rddata((c_FTDI_BE_WIDTH - 1) downto 0);

end architecture RTL;
