library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;

entity spw_mux_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		spw_codec_rx_status_i  : in  t_spw_codec_data_rx_status;
		spw_codec_tx_status_i  : in  t_spw_codec_data_tx_status;
		spw_mux_rx_0_command_i : in  t_spw_codec_data_rx_command;
		spw_mux_tx_0_command_i : in  t_spw_codec_data_tx_command;
		spw_codec_rx_command_o : out t_spw_codec_data_rx_command;
		spw_codec_tx_command_o : out t_spw_codec_data_tx_command;
		spw_mux_rx_0_status_o  : out t_spw_codec_data_rx_status;
		spw_mux_tx_0_status_o  : out t_spw_codec_data_tx_status
	);
end entity spw_mux_ent;

architecture RTL of spw_mux_ent is

	constant c_SPW_RESET_RX_COMMAND : t_spw_codec_data_rx_command := (
		rxread => '0'
	);
	constant c_SPW_RESET_TX_COMMAND : t_spw_codec_data_tx_command := (
		txwrite => '0',
		txflag  => '0',
		txdata  => (others => '0')
	);
	constant c_SPW_RESET_RX_STATUS  : t_spw_codec_data_rx_status  := (
		rxvalid => '0',
		rxhalff => '0',
		rxflag  => '0',
		rxdata  => (others => '0')
	);
	constant c_SPW_RESET_TX_STATUS  : t_spw_codec_data_tx_status  := (
		txrdy   => '0',
		txhalff => '0'
	);

	signal s_mux_selection : natural range 0 to 7 := 0;

begin

	p_spw_mux : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_mux_selection <= 7;
		elsif rising_edge(clk_i) then
			s_mux_selection <= 0;
		end if;
	end process p_spw_mux;

	-- spw codec rx 
	spw_codec_rx_command_o <= (spw_mux_rx_0_command_i) when (s_mux_selection = 0) else (c_SPW_RESET_RX_COMMAND);

	-- spw codec tx
	spw_codec_tx_command_o <= (spw_mux_tx_0_command_i) when (s_mux_selection = 0) else (c_SPW_RESET_TX_COMMAND);

	-- spw mux port 0 rx
	spw_mux_rx_0_status_o <= (spw_codec_rx_status_i) when (s_mux_selection = 0) else (c_SPW_RESET_RX_STATUS);

	-- spw mux port 0 tx
	spw_mux_tx_0_status_o <= (spw_codec_tx_status_i) when (s_mux_selection = 0) else (c_SPW_RESET_TX_STATUS);

end architecture RTL;
