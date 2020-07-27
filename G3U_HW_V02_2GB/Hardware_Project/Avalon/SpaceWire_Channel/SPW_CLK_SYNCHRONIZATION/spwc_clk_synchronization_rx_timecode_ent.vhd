library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_rx_timecode_ent is
	port(
		clk_avs_i      : in  std_logic;
		clk_spw_i      : in  std_logic;
		rst_i          : in  std_logic;
		timecode_spw_i : in  t_spwc_codec_timecode_rx;
		timecode_avs_o : out t_spwc_codec_timecode_rx
	);
end entity spwc_clk_synchronization_rx_timecode_ent;

architecture RTL of spwc_clk_synchronization_rx_timecode_ent is

	signal s_avs_timecode_just_fetched : std_logic;

	signal s_timecode_dc_fifo_avs_rdreq       : std_logic;
	signal s_timecode_dc_fifo_avs_rddata_ctrl : std_logic_vector(1 downto 0);
	signal s_timecode_dc_fifo_avs_rddata_time : std_logic_vector(5 downto 0);
	signal s_timecode_dc_fifo_avs_rdempty     : std_logic;

begin

	-- timecode dc fifo instantiation
	spwc_timecode_dc_fifo_inst : entity work.spwc_timecode_dc_fifo
		port map(
			aclr             => rst_i,
			data(7 downto 6) => timecode_spw_i.ctrl_out,
			data(5 downto 0) => timecode_spw_i.time_out,
			rdclk            => clk_avs_i,
			rdreq            => s_timecode_dc_fifo_avs_rdreq,
			wrclk            => clk_spw_i,
			wrreq            => timecode_spw_i.tick_out,
			q(7 downto 6)    => s_timecode_dc_fifo_avs_rddata_ctrl,
			q(5 downto 0)    => s_timecode_dc_fifo_avs_rddata_time,
			rdempty          => s_timecode_dc_fifo_avs_rdempty,
			rdusedw          => open,
			wrfull           => open,
			wrusedw          => open
		);

	p_clk_synchronization_tx_timecode_avs : process(clk_avs_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_avs_timecode_just_fetched  <= '0';
			s_timecode_dc_fifo_avs_rdreq <= '0';
			timecode_avs_o.ctrl_out      <= (others => '0');
			timecode_avs_o.time_out      <= (others => '0');
			timecode_avs_o.tick_out      <= '0';

		elsif (rising_edge(clk_avs_i)) then

			s_timecode_dc_fifo_avs_rdreq <= '0';
			timecode_avs_o.tick_out      <= '0';

			if (s_avs_timecode_just_fetched = '0') then
				if (s_timecode_dc_fifo_avs_rdempty = '0') then
					s_avs_timecode_just_fetched  <= '1';
					s_timecode_dc_fifo_avs_rdreq <= '1';
					timecode_avs_o.ctrl_out      <= s_timecode_dc_fifo_avs_rddata_ctrl;
					timecode_avs_o.time_out      <= s_timecode_dc_fifo_avs_rddata_time;
					timecode_avs_o.tick_out      <= '1';
				end if;
			else
				s_avs_timecode_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_tx_timecode_avs;

end architecture RTL;
