library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spwc_data_dc_fifo_ent is
	port(
		clk100                              : in  std_logic;
		clk200                              : in  std_logic;
		rst                                 : in  std_logic;
		spwc_rx_data_dc_fifo_clk100_inputs  : in  spwc_rx_data_dc_fifo_clk100_inputs_type;
		spwc_rx_data_dc_fifo_clk100_outputs : out spwc_rx_data_dc_fifo_clk100_outputs_type;
		spwc_rx_data_dc_fifo_clk200_inputs  : in  spwc_rx_data_dc_fifo_clk200_inputs_type;
		spwc_rx_data_dc_fifo_clk200_outputs : out spwc_rx_data_dc_fifo_clk200_outputs_type;
		spwc_tx_data_dc_fifo_clk100_inputs  : in  spwc_tx_data_dc_fifo_clk100_inputs_type;
		spwc_tx_data_dc_fifo_clk100_outputs : out spwc_tx_data_dc_fifo_clk100_outputs_type;
		spwc_tx_data_dc_fifo_clk200_inputs  : in  spwc_tx_data_dc_fifo_clk200_inputs_type;
		spwc_tx_data_dc_fifo_clk200_outputs : out spwc_tx_data_dc_fifo_clk200_outputs_type
	);
end entity spwc_data_dc_fifo_ent;

architecture spwc_data_dc_fifo_arc of spwc_data_dc_fifo_ent is

	signal spw_rx_dc_fifo_aclr_sig : std_logic;
	signal spw_tx_dc_fifo_aclr_sig : std_logic;

begin

	-- rx : clk200 (wr) -> clk100 (rd)
	spwc_rx_data_dc_fifo_inst : entity work.spwc_dc_data_fifo
		port map(
			aclr    => spw_rx_dc_fifo_aclr_sig,
			data    => spwc_rx_data_dc_fifo_clk200_inputs.data,
			rdclk   => clk100,
			rdreq   => spwc_rx_data_dc_fifo_clk100_inputs.rdreq,
			wrclk   => clk200,
			wrreq   => spwc_rx_data_dc_fifo_clk200_inputs.wrreq,
			q       => spwc_rx_data_dc_fifo_clk100_outputs.q,
			rdempty => spwc_rx_data_dc_fifo_clk100_outputs.rdempty,
			rdfull  => spwc_rx_data_dc_fifo_clk100_outputs.rdfull,
			wrempty => spwc_rx_data_dc_fifo_clk200_outputs.wrempty,
			wrfull  => spwc_rx_data_dc_fifo_clk200_outputs.wrfull
		);

		-- tx : clk100 (wr) -> clk200 (rd)
	spwc_tx_dc_data_fifo_inst : entity work.spwc_dc_data_fifo
		port map(
			aclr    => spw_tx_dc_fifo_aclr_sig,
			data    => spwc_tx_data_dc_fifo_clk100_inputs.data,
			rdclk   => clk200,
			rdreq   => spwc_tx_data_dc_fifo_clk200_inputs.rdreq,
			wrclk   => clk100,
			wrreq   => spwc_tx_data_dc_fifo_clk100_inputs.wrreq,
			q       => spwc_tx_data_dc_fifo_clk200_outputs.q,
			rdempty => spwc_tx_data_dc_fifo_clk200_outputs.rdempty,
			rdfull  => spwc_tx_data_dc_fifo_clk200_outputs.rdfull,
			wrempty => spwc_tx_data_dc_fifo_clk100_outputs.wrempty,
			wrfull  => spwc_tx_data_dc_fifo_clk100_outputs.wrfull
		);

		-- Signals Assignments and Port Mappings
	spw_rx_dc_fifo_aclr_sig <= (spwc_rx_data_dc_fifo_clk100_inputs.aclr) or (spwc_rx_data_dc_fifo_clk200_inputs.aclr) or (rst);
	spw_tx_dc_fifo_aclr_sig <= (spwc_tx_data_dc_fifo_clk100_inputs.aclr) or (spwc_tx_data_dc_fifo_clk200_inputs.aclr) or (rst);

end architecture spwc_data_dc_fifo_arc;
