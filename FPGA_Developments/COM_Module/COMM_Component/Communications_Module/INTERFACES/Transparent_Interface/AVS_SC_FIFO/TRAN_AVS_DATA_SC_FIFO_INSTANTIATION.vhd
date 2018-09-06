library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tran_avs_sc_fifo_pkg.all;

entity tran_avs_sc_fifo_instantiation_ent is
	port(
		clk                              : in  std_logic;
		rst                              : in  std_logic;
		tran_rx_inputs_avs_sc_fifo_type  : in  tran_fifo_intputs_avs_sc_fifo_type;
		tran_rx_outputs_avs_sc_fifo_type : out tran_fifo_outputs_avs_sc_fifo_type;
		tran_tx_inputs_avs_sc_fifo_type  : in  tran_fifo_intputs_avs_sc_fifo_type;
		tran_tx_outputs_avs_sc_fifo_type : out tran_fifo_outputs_avs_sc_fifo_type
	);
end entity tran_avs_sc_fifo_instantiation_ent;

architecture tran_avs_sc_fifo_instantiation_arc of tran_avs_sc_fifo_instantiation_ent is

	-- Signals for RX AVS SC FIFO Control
	signal rx_sclr_sig : std_logic;

	-- Signals for TX AVS SC FIFO Control
	signal tx_sclr_sig : std_logic;

begin

	-- RX : fifo --> avs  (SpW --> Simucam);
	-- RX AVS SC FIFO Component
	tran_rx_avs_sc_fifo_inst : entity work.tran_avs_sc_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => tran_rx_inputs_avs_sc_fifo_type.write.data,
			rdreq => tran_rx_inputs_avs_sc_fifo_type.read.rdreq,
			sclr  => rx_sclr_sig,
			wrreq => tran_rx_inputs_avs_sc_fifo_type.write.wrreq,
			empty => tran_rx_outputs_avs_sc_fifo_type.read.empty,
			full  => tran_rx_outputs_avs_sc_fifo_type.write.full,
			q     => tran_rx_outputs_avs_sc_fifo_type.read.q,
			usedw => tran_rx_outputs_avs_sc_fifo_type.read.usedw
		);
	-- RX AVS SC FIFO sClear Control		
	rx_sclr_sig <= (tran_rx_inputs_avs_sc_fifo_type.read.sclr) or (tran_rx_inputs_avs_sc_fifo_type.write.sclr);

	-- TX : avs  --> fifo (Simucam --> SpW);
	-- TX AVS SC FIFO Component
	tran_tx_avs_sc_fifo_inst : entity work.tran_avs_sc_fifo
		port map(
			aclr  => rst,
			clock => clk,
			data  => tran_tx_inputs_avs_sc_fifo_type.write.data,
			rdreq => tran_tx_inputs_avs_sc_fifo_type.read.rdreq,
			sclr  => tx_sclr_sig,
			wrreq => tran_tx_inputs_avs_sc_fifo_type.write.wrreq,
			empty => tran_tx_outputs_avs_sc_fifo_type.read.empty,
			full  => tran_tx_outputs_avs_sc_fifo_type.write.full,
			q     => tran_tx_outputs_avs_sc_fifo_type.read.q,
			usedw => tran_tx_outputs_avs_sc_fifo_type.read.usedw
		);
	-- TX AVS SC FIFO sClear Control
	tx_sclr_sig <= (tran_tx_inputs_avs_sc_fifo_type.read.sclr) or (tran_tx_inputs_avs_sc_fifo_type.write.sclr);

end architecture tran_avs_sc_fifo_instantiation_arc;
