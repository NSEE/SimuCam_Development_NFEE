library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_tx_data_ent is
	port(
		clk_avs_i          : in  std_logic;
		clk_spw_i          : in  std_logic;
		rst_i              : in  std_logic;
		data_command_avs_i : in  t_spwc_codec_data_tx_command;
		data_status_spw_i  : in  t_spwc_codec_data_tx_status;
		data_status_avs_o  : out t_spwc_codec_data_tx_status;
		data_command_spw_o : out t_spwc_codec_data_tx_command
	);
end entity spwc_clk_synchronization_tx_data_ent;

architecture RTL of spwc_clk_synchronization_tx_data_ent is

	signal s_spw_data_just_fetched : std_logic;

	signal s_data_dc_fifo_spw_rdreq       : std_logic;
	signal s_data_dc_fifo_spw_rddata_flag : std_logic;
	signal s_data_dc_fifo_spw_rddata_data : std_logic_vector(7 downto 0);
	signal s_data_dc_fifo_spw_rdempty     : std_logic;

	signal s_data_dc_fifo_avs_wrfull  : std_logic;
	signal s_data_dc_fifo_avs_wrusedw : std_logic_vector(3 downto 0);

begin

	-- data dc fifo instantiation
	spwc_data_dc_fifo_inst : entity work.spwc_data_dc_fifo
		port map(
			aclr             => rst_i,
			data(8)          => data_command_avs_i.txflag,
			data(7 downto 0) => data_command_avs_i.txdata,
			rdclk            => clk_spw_i,
			rdreq            => s_data_dc_fifo_spw_rdreq,
			wrclk            => clk_avs_i,
			wrreq            => data_command_avs_i.txwrite,
			q(8)             => s_data_dc_fifo_spw_rddata_flag,
			q(7 downto 0)    => s_data_dc_fifo_spw_rddata_data,
			rdempty          => s_data_dc_fifo_spw_rdempty,
			rdusedw          => open,
			wrfull           => s_data_dc_fifo_avs_wrfull,
			wrusedw          => s_data_dc_fifo_avs_wrusedw
		);

	p_clk_synchronization_tx_data_spw : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_data_just_fetched    <= '0';
			s_data_dc_fifo_spw_rdreq   <= '0';
			data_command_spw_o.txflag  <= '0';
			data_command_spw_o.txdata  <= (others => '0');
			data_command_spw_o.txwrite <= '0';

		elsif (rising_edge(clk_spw_i)) then

			s_data_dc_fifo_spw_rdreq   <= '0';
			data_command_spw_o.txwrite <= '0';

			if (s_spw_data_just_fetched = '0') then
				--				if ((s_data_dc_fifo_spw_rdempty = '0') and (data_status_spw_i.txrdy = '1')) then
				if ((s_data_dc_fifo_spw_rdempty = '0') and (data_status_spw_i.txhalff = '0')) then
					s_spw_data_just_fetched    <= '1';
					s_data_dc_fifo_spw_rdreq   <= '1';
					data_command_spw_o.txflag  <= s_data_dc_fifo_spw_rddata_flag;
					data_command_spw_o.txdata  <= s_data_dc_fifo_spw_rddata_data;
					data_command_spw_o.txwrite <= '1';
				end if;
			else
				s_spw_data_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_tx_data_spw;

	--	data_status_avs_o.txrdy   <= not (s_data_dc_fifo_avs_wrfull);
	data_status_avs_o.txrdy   <= not (s_data_dc_fifo_avs_wrusedw(3));
	data_status_avs_o.txhalff <= s_data_dc_fifo_avs_wrusedw(3);

end architecture RTL;
