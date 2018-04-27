library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;
use work.spwc_codec_pkg.all;
use work.spwc_mm_registers_pkg.all;
use work.spwc_rx_data_dc_fifo_pkg.all;
use work.spwc_tx_data_dc_fifo_pkg.all;

entity spwc_codec_loopback_ent is
	port(
		clk_100                       : in  std_logic;
		clk_200                       : in  std_logic;
		rst                           : in  std_logic;
		spwc_mm_write_registers       : in  spwc_mm_write_registers_type;
		spwc_codec_reset              : in  std_logic;
		spwc_codec_link_command_in    : in  spwc_codec_link_command_in_type;
		spwc_codec_link_status_out    : out spwc_codec_link_status_out_type;
		spwc_codec_ds_encoding_rx_in  : in  spwc_codec_ds_encoding_rx_in_type;
		spwc_codec_ds_encoding_tx_out : out spwc_codec_ds_encoding_tx_out_type;
		spwc_codec_link_error_out     : out spwc_codec_link_error_out_type;
		spwc_codec_timecode_rx_out    : out spwc_codec_timecode_rx_out_type;
		spwc_codec_timecode_tx_in     : in  spwc_codec_timecode_tx_in_type;
		spwc_codec_data_rx_in         : in  spwc_codec_data_rx_in_type;
		spwc_codec_data_rx_out        : out spwc_codec_data_rx_out_type;
		spwc_codec_data_tx_in         : in  spwc_codec_data_tx_in_type;
		spwc_codec_data_tx_out        : out spwc_codec_data_tx_out_type
	);
end entity spwc_codec_loopback_ent;

architecture spwc_codec_loopback_arc of spwc_codec_loopback_ent is

	-- Signals for SpaceWire Light Codec communication (loopback)
	-- Codec Link Control Signals
	signal spwc_codec_link_command_in_sig      : spwc_codec_link_command_in_type;
	-- Codec Receiver Data Control Signals
	signal spwc_codec_data_rx_in_sig           : spwc_codec_data_rx_in_type;
	signal spwc_codec_data_rx_in_loopback_sig  : spwc_codec_data_rx_in_type;
	-- Codec Receiver Data Status Signals
	signal spwc_codec_data_rx_out_sig          : spwc_codec_data_rx_out_type;
	signal spwc_codec_data_rx_out_loopback_sig : spwc_codec_data_rx_out_type;
	-- Codec Transmitter Data Control Signals
	signal spwc_codec_data_tx_in_sig           : spwc_codec_data_tx_in_type;
	signal spwc_codec_data_tx_in_loopback_sig  : spwc_codec_data_tx_in_type;
	-- Codec Transmitter Data Status Signals
	signal spwc_codec_data_tx_out_sig          : spwc_codec_data_tx_out_type;
	signal spwc_codec_data_tx_out_loopback_sig : spwc_codec_data_tx_out_type;

	signal txdiv_ff1_sig : std_logic_vector(7 downto 0);
	signal txdiv_ff2_sig : std_logic_vector(7 downto 0);

	signal loopback_ff1_sig : std_logic;
	signal loopback_ff2_sig : std_logic;

	signal external_loopback : std_logic;

begin

	-- SpaceWire Light Codec Encapsulation Component
	spwc_codec_ent_inst : entity work.spwc_codec_ent
		port map(
			clk_200                       => clk_200,
			rst                           => spwc_codec_reset,
			spwc_codec_link_command_in    => spwc_codec_link_command_in_sig,
			spwc_codec_link_status_out    => spwc_codec_link_status_out,
			spwc_codec_ds_encoding_rx_in  => spwc_codec_ds_encoding_rx_in,
			spwc_codec_ds_encoding_tx_out => spwc_codec_ds_encoding_tx_out,
			spwc_codec_link_error_out     => spwc_codec_link_error_out,
			spwc_codec_timecode_rx_out    => spwc_codec_timecode_rx_out,
			spwc_codec_timecode_tx_in     => spwc_codec_timecode_tx_in,
			spwc_codec_data_rx_in         => spwc_codec_data_rx_in_sig,
			spwc_codec_data_rx_out        => spwc_codec_data_rx_out_sig,
			spwc_codec_data_tx_in         => spwc_codec_data_tx_in_sig,
			spwc_codec_data_tx_out        => spwc_codec_data_tx_out_sig
		);

	spwc_codec_loopback_clk100_proc : process(clk_100, rst) is
	begin
		if (rst = '1') then
			txdiv_ff1_sig <= x"01";
			txdiv_ff2_sig <= x"01";

			loopback_ff1_sig <= '0';
			loopback_ff2_sig <= '0';

		elsif (rising_edge(clk_100)) then
			txdiv_ff1_sig <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV;
			txdiv_ff2_sig <= txdiv_ff1_sig;

			loopback_ff1_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT;
			loopback_ff2_sig <= loopback_ff1_sig;
		end if;
	end process spwc_codec_loopback_clk100_proc;

	spwc_codec_loopback_clk200_proc : process(clk_200, rst) is
	begin
		if (rst = '1') then
			spwc_codec_link_command_in_sig.txdivcnt <= x"01";
			external_loopback                       <= '0';

			spwc_codec_data_rx_in_loopback_sig.rxread   <= '0';
			spwc_codec_data_rx_out_loopback_sig.rxvalid <= '0';
			spwc_codec_data_rx_out_loopback_sig.rxhalff <= '0';
			spwc_codec_data_rx_out_loopback_sig.rxflag  <= '0';
			spwc_codec_data_rx_out_loopback_sig.rxdata  <= (others => '0');
			spwc_codec_data_tx_in_loopback_sig.txwrite  <= '0';
			spwc_codec_data_tx_in_loopback_sig.txflag   <= '0';
			spwc_codec_data_tx_in_loopback_sig.txdata   <= (others => '0');
			spwc_codec_data_tx_out_loopback_sig.txrdy   <= '0';
			spwc_codec_data_tx_out_loopback_sig.txhalff <= '0';

		elsif (rising_edge(clk_200)) then
			spwc_codec_link_command_in_sig.txdivcnt <= txdiv_ff2_sig;
			external_loopback                       <= loopback_ff2_sig;

			-- default tx data
			spwc_codec_data_rx_in_loopback_sig.rxread  <= '0';
			spwc_codec_data_tx_in_loopback_sig.txflag  <= '0';
			spwc_codec_data_tx_in_loopback_sig.txdata  <= (others => '0');
			spwc_codec_data_tx_in_loopback_sig.txwrite <= '0';

			-- check to see if the external loopback mode is on
			if (external_loopback = '1') then
				-- connect the RX output with the TX input
				-- check if the rx buffer has valid data
				if (spwc_codec_data_rx_out_sig.rxvalid = '1') then
					-- check if the tx buffer has available space
					if (spwc_codec_data_tx_out_sig.txrdy = '1') then
						-- transfer rx data to tx
						spwc_codec_data_rx_in_loopback_sig.rxread  <= '1';
						spwc_codec_data_tx_in_loopback_sig.txflag  <= spwc_codec_data_rx_out_sig.rxflag;
						spwc_codec_data_tx_in_loopback_sig.txdata  <= spwc_codec_data_rx_out_sig.rxdata;
						spwc_codec_data_tx_in_loopback_sig.txwrite <= '1';
					end if;
				end if;
			end if;

		end if;
	end process spwc_codec_loopback_clk200_proc;

	spwc_codec_link_command_in_sig.autostart <= spwc_codec_link_command_in.autostart;
	spwc_codec_link_command_in_sig.linkdis   <= spwc_codec_link_command_in.linkdis;
	spwc_codec_link_command_in_sig.linkstart <= spwc_codec_link_command_in.linkstart;

	spwc_codec_data_rx_in_sig <= (spwc_codec_data_rx_in) when (external_loopback = '0') else (spwc_codec_data_rx_in_loopback_sig);
	spwc_codec_data_rx_out    <= (spwc_codec_data_rx_out_sig) when (external_loopback = '0') else (spwc_codec_data_rx_out_loopback_sig);
	spwc_codec_data_tx_in_sig <= (spwc_codec_data_tx_in) when (external_loopback = '0') else (spwc_codec_data_tx_in_loopback_sig);
	spwc_codec_data_tx_out    <= (spwc_codec_data_tx_out_sig) when (external_loopback = '0') else (spwc_codec_data_tx_out_loopback_sig);

end architecture spwc_codec_loopback_arc;

