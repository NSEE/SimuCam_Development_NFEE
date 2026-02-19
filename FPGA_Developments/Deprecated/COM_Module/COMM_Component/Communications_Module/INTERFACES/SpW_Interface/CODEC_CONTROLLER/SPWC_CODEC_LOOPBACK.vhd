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
		spwc_mm_read_registers        : out spwc_mm_read_registers_type;
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

	signal backdoor_ff1_sig : std_logic;
	signal backdoor_ff2_sig : std_logic;

	signal external_loopback_sig : std_logic;
	signal backdoor_sig          : std_logic;
	signal delay_sig             : std_logic;
	signal delay100tx_sig        : std_logic;
	signal delay100rx_sig        : std_logic;
	signal delay200tx_sig        : std_logic;
	signal delay200rx_sig        : std_logic;

	signal rx_control_trigger : std_logic;
	signal tx_control_trigger : std_logic;

	type spw_backdoor_dc_fifo_write_type is record
		data    : std_logic_vector(8 downto 0);
		wrreq   : std_logic;
		wrempty : std_logic;
		wrfull  : std_logic;
	end record spw_backdoor_dc_fifo_write_type;

	type spw_backdoor_dc_fifo_read_type is record
		rdreq   : std_logic;
		q       : std_logic_vector(8 downto 0);
		rdempty : std_logic;
		rdfull  : std_logic;
	end record spw_backdoor_dc_fifo_read_type;

	signal rx_backdoor_fifo_write : spw_backdoor_dc_fifo_write_type;
	signal rx_backdoor_fifo_read  : spw_backdoor_dc_fifo_read_type;
	signal tx_backdoor_fifo_write : spw_backdoor_dc_fifo_write_type;
	signal tx_backdoor_fifo_read  : spw_backdoor_dc_fifo_read_type;

begin

	spw_rx_backdoor_dc_fifo_inst : entity work.spw_backdoor_dc_fifo
		port map(
			aclr    => rst,
			data    => rx_backdoor_fifo_write.data,
			rdclk   => clk_100,
			rdreq   => rx_backdoor_fifo_read.rdreq,
			wrclk   => clk_200,
			wrreq   => rx_backdoor_fifo_write.wrreq,
			q       => rx_backdoor_fifo_read.q,
			rdempty => rx_backdoor_fifo_read.rdempty,
			rdfull  => rx_backdoor_fifo_read.rdfull,
			wrempty => rx_backdoor_fifo_write.wrempty,
			wrfull  => rx_backdoor_fifo_write.wrfull
		);

	spw_tx_backdoor_dc_fifo_inst : entity work.spw_backdoor_dc_fifo
		port map(
			aclr    => rst,
			data    => tx_backdoor_fifo_write.data,
			rdclk   => clk_200,
			rdreq   => tx_backdoor_fifo_read.rdreq,
			wrclk   => clk_100,
			wrreq   => tx_backdoor_fifo_write.wrreq,
			q       => tx_backdoor_fifo_read.q,
			rdempty => tx_backdoor_fifo_read.rdempty,
			rdfull  => tx_backdoor_fifo_read.rdfull,
			wrempty => tx_backdoor_fifo_write.wrempty,
			wrfull  => tx_backdoor_fifo_write.wrfull
		);

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

			backdoor_ff1_sig <= '0';
			backdoor_ff2_sig <= '0';

			delay100tx_sig <= '0';
			delay100rx_sig <= '0';

			rx_control_trigger <= '0';
			tx_control_trigger <= '0';

			rx_backdoor_fifo_read.rdreq  <= '0';
			tx_backdoor_fifo_write.data  <= (others => '0');
			tx_backdoor_fifo_write.wrreq <= '0';

			spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY <= '0';
			spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG          <= '0';
			spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA          <= (others => '0');
			spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY <= '0';

		elsif (rising_edge(clk_100)) then
			txdiv_ff1_sig <= spwc_mm_write_registers.SPW_LINK_MODE_REGISTER.TX_CLOCK_DIV;
			txdiv_ff2_sig <= txdiv_ff1_sig;

			loopback_ff1_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.EXTERNAL_LOOPBACK_MODE_BIT;
			loopback_ff2_sig <= loopback_ff1_sig;

			backdoor_ff1_sig <= spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT;
			backdoor_ff2_sig <= backdoor_ff1_sig;

			if (spwc_mm_write_registers.INTERFACE_CONTROL_REGISTER.BACKDOOR_MODE_BIT = '1') then

				-- tx fifo write

				spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY <= '0';
				tx_control_trigger                                                       <= spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE;
				tx_backdoor_fifo_write.wrreq                                             <= '0';
				tx_backdoor_fifo_write.data(8)                                           <= spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG;
				tx_backdoor_fifo_write.data(7 downto 0)                                  <= spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA;
				delay100tx_sig                                                           <= '0';
				if (delay100tx_sig = '0') then
					if (tx_backdoor_fifo_write.wrfull = '0') then
						spwc_mm_read_registers.TX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY <= '1';
						if ((spwc_mm_write_registers.TX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE = '1') and (tx_control_trigger = '0')) then
							tx_backdoor_fifo_write.wrreq            <= '1';
							tx_backdoor_fifo_write.data(8)          <= spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG;
							tx_backdoor_fifo_write.data(7 downto 0) <= spwc_mm_write_registers.TX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA;
							delay100tx_sig                          <= '1';
						end if;
					end if;
				end if;

				-- rx fifo read
				spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY <= '0';
				rx_control_trigger                                                       <= spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE;
				rx_backdoor_fifo_read.rdreq                                              <= '0';
				spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG          <= rx_backdoor_fifo_read.q(8);
				spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA          <= rx_backdoor_fifo_read.q(7 downto 0);
				delay100rx_sig                                                           <= '0';
				if (delay100rx_sig = '0') then
					if (rx_backdoor_fifo_read.rdempty = '0') then
						spwc_mm_read_registers.RX_BACKDOOR_STATUS_REGISTER.CODEC_DATAVALID_READY <= '1';
						if ((spwc_mm_write_registers.RX_BACKDOOR_CONTROL_REGISTER.CODEC_READ_WRITE = '1') and (rx_control_trigger = '0')) then
							rx_backdoor_fifo_read.rdreq                                     <= '1';
							spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_FLAG <= rx_backdoor_fifo_read.q(8);
							spwc_mm_read_registers.RX_BACKDOOR_DATA_REGISTER.CODEC_SPW_DATA <= rx_backdoor_fifo_read.q(7 downto 0);
							delay100rx_sig                                                  <= '1';
						end if;
					end if;
				end if;

			end if;
		end if;
	end process spwc_codec_loopback_clk100_proc;

	spwc_codec_loopback_clk200_proc : process(clk_200, rst) is
	begin
		if (rst = '1') then
			spwc_codec_link_command_in_sig.txdivcnt <= x"01";
			external_loopback_sig                   <= '0';
			backdoor_sig                            <= '0';
			delay_sig                               <= '0';

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

			rx_backdoor_fifo_write.data  <= (others => '0');
			rx_backdoor_fifo_write.wrreq <= '0';
			tx_backdoor_fifo_read.rdreq  <= '0';

		elsif (rising_edge(clk_200)) then
			spwc_codec_link_command_in_sig.txdivcnt <= txdiv_ff2_sig;
			external_loopback_sig                   <= loopback_ff2_sig;
			backdoor_sig                            <= backdoor_ff2_sig;

			-- default tx data
			spwc_codec_data_rx_in_loopback_sig.rxread  <= '0';
			spwc_codec_data_tx_in_loopback_sig.txflag  <= '0';
			spwc_codec_data_tx_in_loopback_sig.txdata  <= (others => '0');
			spwc_codec_data_tx_in_loopback_sig.txwrite <= '0';

			-- check to see if the external loopback mode is on
			if (external_loopback_sig = '1') then
				-- connect the RX output with the TX input
				-- check if the transmission delay is active
				if (delay_sig = '1') then
					delay_sig <= '0';
				-- no delay necessary
				else
					-- check if the rx buffer has valid data
					if (spwc_codec_data_rx_out_sig.rxvalid = '1') then
						-- check if the tx buffer has available space
						if (spwc_codec_data_tx_out_sig.txrdy = '1') then
							-- transfer rx data to tx
							spwc_codec_data_rx_in_loopback_sig.rxread  <= '1';
							spwc_codec_data_tx_in_loopback_sig.txflag  <= spwc_codec_data_rx_out_sig.rxflag;
							spwc_codec_data_tx_in_loopback_sig.txdata  <= spwc_codec_data_rx_out_sig.rxdata;
							spwc_codec_data_tx_in_loopback_sig.txwrite <= '1';
							delay_sig                                  <= '1';
						end if;
					end if;
				end if;
			elsif (backdoor_sig = '1') then
				-- backdoor mode, connect the codec data in/out with the avalon mm registers

				-- rx fifo write
				rx_backdoor_fifo_write.wrreq              <= '0';
				rx_backdoor_fifo_write.data               <= (others => '0');
				spwc_codec_data_rx_in_loopback_sig.rxread <= '0';
				delay200rx_sig                            <= '0';
				if (delay200rx_sig = '0') then
					if (rx_backdoor_fifo_write.wrfull = '0') then
						if (spwc_codec_data_rx_out_sig.rxvalid = '1') then
							rx_backdoor_fifo_write.wrreq              <= '1';
							rx_backdoor_fifo_write.data(8)            <= spwc_codec_data_rx_out_sig.rxflag;
							rx_backdoor_fifo_write.data(7 downto 0)   <= spwc_codec_data_rx_out_sig.rxdata;
							spwc_codec_data_rx_in_loopback_sig.rxread <= '1';
							delay200rx_sig                            <= '1';
						end if;
					end if;
				end if;

				-- tx fifo read
				tx_backdoor_fifo_read.rdreq                <= '0';
				spwc_codec_data_tx_in_loopback_sig.txflag  <= '0';
				spwc_codec_data_tx_in_loopback_sig.txdata  <= (others => '0');
				spwc_codec_data_tx_in_loopback_sig.txwrite <= '0';
				delay200tx_sig                             <= '0';
				if (delay200tx_sig = '0') then
					if (tx_backdoor_fifo_read.rdempty = '0') then
						if (spwc_codec_data_tx_out_sig.txrdy = '1') then
							tx_backdoor_fifo_read.rdreq                <= '1';
							spwc_codec_data_tx_in_loopback_sig.txflag  <= tx_backdoor_fifo_read.q(8);
							spwc_codec_data_tx_in_loopback_sig.txdata  <= tx_backdoor_fifo_read.q(7 downto 0);
							spwc_codec_data_tx_in_loopback_sig.txwrite <= '1';
							delay200tx_sig                             <= '1';
						end if;
					end if;
				end if;

			end if;

		end if;
	end process spwc_codec_loopback_clk200_proc;

	spwc_codec_link_command_in_sig.autostart <= spwc_codec_link_command_in.autostart;
	spwc_codec_link_command_in_sig.linkdis   <= spwc_codec_link_command_in.linkdis;
	spwc_codec_link_command_in_sig.linkstart <= spwc_codec_link_command_in.linkstart;

	spwc_codec_data_rx_in_sig <= (spwc_codec_data_rx_in) when ((external_loopback_sig = '0') and (backdoor_sig = '0')) else (spwc_codec_data_rx_in_loopback_sig);
	spwc_codec_data_rx_out    <= (spwc_codec_data_rx_out_sig) when ((external_loopback_sig = '0') and (backdoor_sig = '0')) else (spwc_codec_data_rx_out_loopback_sig);
	spwc_codec_data_tx_in_sig <= (spwc_codec_data_tx_in) when ((external_loopback_sig = '0') and (backdoor_sig = '0')) else (spwc_codec_data_tx_in_loopback_sig);
	spwc_codec_data_tx_out    <= (spwc_codec_data_tx_out_sig) when ((external_loopback_sig = '0') and (backdoor_sig = '0')) else (spwc_codec_data_tx_out_loopback_sig);

end architecture spwc_codec_loopback_arc;

