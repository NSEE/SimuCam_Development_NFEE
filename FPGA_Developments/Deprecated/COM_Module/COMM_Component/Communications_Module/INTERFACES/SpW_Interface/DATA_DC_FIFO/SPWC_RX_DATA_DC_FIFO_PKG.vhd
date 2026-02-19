-- TODO Atualizar valores das contantes
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spwc_rx_data_dc_fifo_pkg is

	constant SPWC_RX_DATA_DC_FIFO_WIDTH  : natural := 9;
	constant SPWC_RX_DATA_DC_FIFO_LENGTH : natural := 1024;

	type spwc_rx_data_dc_fifo_data_type is record
		spacewire_flag : std_logic;
		spacewire_data : std_logic_vector(7 downto 0);
	end record spwc_rx_data_dc_fifo_data_type;

	type spwc_rx_data_dc_fifo_clk100_inputs_type is record
		aclr  : std_logic;
		rdreq : std_logic;
	end record spwc_rx_data_dc_fifo_clk100_inputs_type;

	type spwc_rx_data_dc_fifo_clk100_outputs_type is record
		q       : std_logic_vector((SPWC_RX_DATA_DC_FIFO_WIDTH - 1) downto 0);
		rdempty : std_logic;
		rdfull  : std_logic;
	end record spwc_rx_data_dc_fifo_clk100_outputs_type;

	type spwc_rx_data_dc_fifo_clk200_inputs_type is record
		aclr  : std_logic;
		data  : std_logic_vector((SPWC_RX_DATA_DC_FIFO_WIDTH - 1) downto 0);
		wrreq : std_logic;
	end record spwc_rx_data_dc_fifo_clk200_inputs_type;

	type spwc_rx_data_dc_fifo_clk200_outputs_type is record
		wrempty : std_logic;
		wrfull  : std_logic;
	end record spwc_rx_data_dc_fifo_clk200_outputs_type;

end package spwc_rx_data_dc_fifo_pkg;
