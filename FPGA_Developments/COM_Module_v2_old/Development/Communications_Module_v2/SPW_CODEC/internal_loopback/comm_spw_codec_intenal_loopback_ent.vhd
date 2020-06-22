library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_codec_pkg.all;

entity comm_spw_codec_intenal_loopback_ent is
	port(
		-- basic inputs
		clk_i         : in  std_logic;
		rst_i         : in  std_logic;
		-- logic inputs
		control_i     : in  t_swil_control;
		codec_ds_tx_i : in  t_spwl_ds_encoding;
		spw_ds_rx_i   : in  t_spwl_ds_encoding;
		-- logic outputs
		codec_ds_rx_o : out t_spwl_ds_encoding;
		spw_ds_tx_o   : out t_spwl_ds_encoding
	);
end entity comm_spw_codec_intenal_loopback_ent;

architecture RTL of comm_spw_codec_intenal_loopback_ent is

	constant c_SPW_DS_TX_LOOPBACK : t_spwl_ds_encoding := (
		c_SPW_DS_TX_LOOPBACK.spw_d => '0',
		c_SPW_DS_TX_LOOPBACK.spw_s => '0'
	);

begin

	-- rx internal loopback
	--  en = 0 -> connect codec rx with spw rx
	--  en = 1 -> connect codec rx with codec tx
	codec_ds_rx_o <= (spw_ds_rx_i) when (control_i.enable = '0') else (codec_ds_tx_i);

	-- tx internal loopback
	--  en = 0 -> connect spw tx with codec tx 
	--  en = 1 -> connect spw tx with constant loopback value
	spw_ds_tx_o <= (codec_ds_tx_i) when (control_i.enable = '0') else (c_SPW_DS_TX_LOOPBACK);

end architecture RTL;
