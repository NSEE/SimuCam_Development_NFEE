library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_rx_data_ent is
	port(
		clk_avs_i          : in  std_logic;
		clk_spw_i          : in  std_logic;
		rst_i              : in  std_logic;
		data_command_avs_i : in  t_spwc_codec_data_rx_command;
		data_status_spw_i  : in  t_spwc_codec_data_rx_status;
		data_status_avs_o  : out t_spwc_codec_data_rx_status;
		data_command_spw_o : out t_spwc_codec_data_rx_command
	);
end entity spwc_clk_synchronization_rx_data_ent;

architecture RTL of spwc_clk_synchronization_rx_data_ent is

	signal s_spw_data_just_fetched : std_logic;

	signal s_data_dc_fifo_spw_wrreq       : std_logic;
	signal s_data_dc_fifo_spw_wrdata_flag : std_logic;
	signal s_data_dc_fifo_spw_wrdata_data : std_logic_vector(7 downto 0);
	signal s_data_dc_fifo_avs_wrfull      : std_logic;

	signal s_data_dc_fifo_avs_rdempty : std_logic;
	signal s_data_dc_fifo_avs_rdusedw : std_logic_vector(3 downto 0);

begin

	-- data dc fifo instantiation
	spwc_data_dc_fifo_inst : entity work.spwc_data_dc_fifo
		port map(
			aclr             => rst_i,
			data(8)          => s_data_dc_fifo_spw_wrdata_flag,
			data(7 downto 0) => s_data_dc_fifo_spw_wrdata_data,
			rdclk            => clk_avs_i,
			rdreq            => data_command_avs_i.rxread,
			wrclk            => clk_spw_i,
			wrreq            => s_data_dc_fifo_spw_wrreq,
			q(8)             => data_status_avs_o.rxflag,
			q(7 downto 0)    => data_status_avs_o.rxdata,
			rdempty          => s_data_dc_fifo_avs_rdempty,
			rdusedw          => s_data_dc_fifo_avs_rdusedw,
			wrfull           => s_data_dc_fifo_avs_wrfull,
			wrusedw          => open
		);

	p_clk_synchronization_rx_data_spw : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_data_just_fetched   <= '0';
			s_data_dc_fifo_spw_wrreq  <= '0';
			data_command_spw_o.rxread <= '0';

		elsif (rising_edge(clk_spw_i)) then

			s_data_dc_fifo_spw_wrreq  <= '0';
			data_command_spw_o.rxread <= '0';

			if (s_spw_data_just_fetched = '0') then
				if ((data_status_spw_i.rxvalid = '1') and (s_data_dc_fifo_avs_wrfull = '0')) then
					s_spw_data_just_fetched        <= '1';
					s_data_dc_fifo_spw_wrreq       <= '1';
					s_data_dc_fifo_spw_wrdata_flag <= data_status_spw_i.rxflag;
					s_data_dc_fifo_spw_wrdata_data <= data_status_spw_i.rxdata;
					data_command_spw_o.rxread      <= '1';
				end if;
			else
				s_spw_data_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_rx_data_spw;

	data_status_avs_o.rxvalid <= not (s_data_dc_fifo_avs_rdempty);
	data_status_avs_o.rxhalff <= s_data_dc_fifo_avs_rdusedw(3);

end architecture RTL;
