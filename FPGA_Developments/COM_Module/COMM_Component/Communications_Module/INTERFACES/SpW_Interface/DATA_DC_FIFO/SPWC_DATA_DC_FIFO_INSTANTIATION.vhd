library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spwc_data_dc_fifo_instantiation_ent is
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
end entity spwc_data_dc_fifo_instantiation_ent;

architecture spwc_data_dc_fifo_instantiation_arc of spwc_data_dc_fifo_instantiation_ent is

	-- Signals for RX DATA DC FIFO Control
	signal spw_rx_dc_fifo_aclr_sig : std_logic;

	-- Signals for RX DATA DC FIFO Control
	signal spw_tx_dc_fifo_aclr_sig : std_logic;

begin

	-- RX : CLK200 (wr) --> CLK100 (rd)  (SpW --> Simucam)
	-- RX DATA DC FIFO Component
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
		-- RX DATA DC FIFO aClear Control
	spw_rx_dc_fifo_aclr_sig <= (rst) or ((spwc_rx_data_dc_fifo_clk100_inputs.aclr) or (spwc_rx_data_dc_fifo_clk200_inputs.aclr));

	-- TX : CLK100 (wr) -> CLK200 (rd)  (Simucam --> SpW)
	-- TX DATA DC FIFO Component
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
		-- TX DATA DC FIFO aClear Control
	spw_tx_dc_fifo_aclr_sig <= (rst) or ((spwc_tx_data_dc_fifo_clk100_inputs.aclr) or (spwc_tx_data_dc_fifo_clk200_inputs.aclr));

end architecture spwc_data_dc_fifo_instantiation_arc;
