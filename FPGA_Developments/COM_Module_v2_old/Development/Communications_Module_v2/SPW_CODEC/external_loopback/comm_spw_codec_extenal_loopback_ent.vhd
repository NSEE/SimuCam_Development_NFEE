library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_spw_codec_pkg.all;

entity comm_spw_codec_extenal_loopback_ent is
	port(
		-- basic inputs
		clk_i              : in  std_logic;
		rst_i              : in  std_logic;
		-- logic inputs
		control_i          : in  t_swel_control;
		codec_status_rx_i  : in  t_spwl_data_rx_status;
		codec_payload_rx_i : in  t_spwl_data_payload;
		codec_status_tx_i  : in  t_spwl_data_tx_status;
		spw_control_rx_i   : in  t_spwl_data_rx_control;
		spw_control_tx_i   : in  t_spwl_data_tx_control;
		spw_payload_tx_i   : in  t_spwl_data_payload;
		-- logic outputs
		codec_control_rx_o : out t_spwl_data_rx_control;
		codec_control_tx_o : out t_spwl_data_tx_control;
		codec_payload_tx_o : out t_spwl_data_payload;
		spw_status_rx_o    : out t_spwl_data_rx_status;
		spw_payload_rx_o   : out t_spwl_data_payload;
		spw_status_tx_o    : out t_spwl_data_tx_status
	);
end entity comm_spw_codec_extenal_loopback_ent;

architecture RTL of comm_spw_codec_extenal_loopback_ent is

	-- signals for external loopback rx
	signal s_loopback_control_rx : t_spwl_data_rx_control;
	signal s_loopback_status_rx  : t_spwl_data_rx_status;
	signal s_loopback_payload_rx : t_spwl_data_payload;

	-- signals for external loopback tx
	signal s_loopback_control_tx : t_spwl_data_tx_control;
	signal s_loopback_status_tx  : t_spwl_data_tx_status;
	signal s_loopback_payload_tx : t_spwl_data_payload;

	-- constant for extenal loopback reset
	constant c_LOOPBACK_CONTROL_RX_RESET : t_spwl_data_rx_control := (
		c_LOOPBACK_CONTROL_RX_RESET.rxread => '0'
	);
	constant c_LOOPBACK_STATUS_RX_RESET  : t_spwl_data_rx_status  := (
		c_LOOPBACK_STATUS_RX_RESET.rxhalff => '0',
		c_LOOPBACK_STATUS_RX_RESET.rxvalid => '0'
	);
	constant c_LOOPBACK_CONTROL_TX_RESET : t_spwl_data_tx_control := (
		c_LOOPBACK_CONTROL_TX_RESET.txwrite => '0'
	);
	constant c_LOOPBACK_STATUS_TX_RESET  : t_spwl_data_tx_status  := (
		c_LOOPBACK_STATUS_TX_RESET.txhalff => '0',
		c_LOOPBACK_STATUS_TX_RESET.txrdy   => '0'
	);
	constant c_LOOPBACK_PAYLOAD_RESET    : t_spwl_data_payload    := (
		c_LOOPBACK_PAYLOAD_RESET.flag => '0',
		c_LOOPBACK_PAYLOAD_RESET.data => x"00"
	);

begin

	p_comm_spw_codec_extenal_loopback : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_loopback_control_rx <= c_LOOPBACK_CONTROL_RX_RESET;
			s_loopback_status_rx  <= c_LOOPBACK_STATUS_RX_RESET;
			s_loopback_payload_rx <= c_LOOPBACK_PAYLOAD_RESET;
			s_loopback_control_tx <= c_LOOPBACK_CONTROL_TX_RESET;
			s_loopback_status_tx  <= c_LOOPBACK_PAYLOAD_RESET;
			s_loopback_payload_tx <= c_LOOPBACK_STATUS_TX_RESET;
		elsif (rising_edge(clk_i)) then

			-- keep the signals in the reset state
			s_loopback_control_rx <= c_LOOPBACK_CONTROL_RX_RESET;
			s_loopback_status_rx  <= c_LOOPBACK_STATUS_RX_RESET;
			s_loopback_payload_rx <= c_LOOPBACK_PAYLOAD_RESET;
			s_loopback_control_tx <= c_LOOPBACK_CONTROL_TX_RESET;
			s_loopback_status_tx  <= c_LOOPBACK_PAYLOAD_RESET;
			s_loopback_payload_tx <= c_LOOPBACK_STATUS_TX_RESET;

			-- check if the external loopback is enabled
			if (control_i.enable = '1') then -- external loopback enabled
				-- check if the rx data is valid and the tx buffer is ready
				if ((codec_status_rx_i.rxvalid = '1') and (codec_status_tx_i.txrdy = '1')) then -- both rx data is valid and the tx buffer is ready
					-- check if the rx and tx control signals are both high
					if ((s_loopback_control_rx.rxread = '1') or (s_loopback_control_tx.txwrite = '1')) then -- both the rx and tx control signals are high
						-- clear the control signals (stop multiple reads/writes)
						s_loopback_control_rx.rxread  <= '0';
						s_loopback_control_tx.txwrite <= '0';
						-- fill the tx payload with dummy data (reset data)
						s_loopback_payload_tx         <= c_LOOPBACK_PAYLOAD_RESET;
					else                -- either the rx or tx control signals is low
					-- set the control signals (transfer data)
						s_loopback_control_rx.rxread  <= '1';
						s_loopback_control_tx.txwrite <= '1';
						-- fill the tx payload with the rx payload
						s_loopback_payload_tx         <= codec_payload_rx_i;
					end if;
				end if;
			end if;
		end if;
	end process p_comm_spw_codec_extenal_loopback;

	-- rx external loopback
	--  en = 0 -> connect codec rx fifo with spw rx fifo
	--  en = 1 -> connect codec rx fifo with loopback tx fifo
	codec_control_rx_o <= (spw_control_rx_i) when (control_i.enable = '0') else (s_loopback_control_rx);
	spw_status_rx_o    <= (codec_status_rx_i) when (control_i.enable = '0') else (s_loopback_status_rx);
	spw_payload_rx_o   <= (codec_payload_rx_i) when (control_i.enable = '0') else (s_loopback_payload_rx);

	-- tx external loopback
	--  en = 0 -> connect spw tx fifo with codec tx fifo 
	--  en = 1 -> connect spw tx fifo with loopback rx fifo
	codec_control_tx_o <= (spw_control_tx_i) when (control_i.enable = '0') else (s_loopback_control_tx);
	codec_payload_tx_o <= (spw_payload_tx_i) when (control_i.enable = '0') else (s_loopback_payload_tx);
	spw_status_tx_o    <= (codec_status_tx_i) when (control_i.enable = '0') else (s_loopback_status_tx);

end architecture RTL;
