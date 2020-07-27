library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_tx_timecode_ent is
	port(
		clk_avs_i      : in  std_logic;
		clk_spw_i      : in  std_logic;
		rst_i          : in  std_logic;
		timecode_avs_i : in  t_spwc_codec_timecode_tx;
		timecode_spw_o : out t_spwc_codec_timecode_tx
	);
end entity spwc_clk_synchronization_tx_timecode_ent;

architecture RTL of spwc_clk_synchronization_tx_timecode_ent is

	signal s_spw_timecode_just_fetched : std_logic;

	signal s_timecode_dc_fifo_spw_rdreq       : std_logic;
	signal s_timecode_dc_fifo_spw_rddata_ctrl : std_logic_vector(1 downto 0);
	signal s_timecode_dc_fifo_spw_rddata_time : std_logic_vector(5 downto 0);
	signal s_timecode_dc_fifo_spw_rdempty     : std_logic;

begin

	-- timecode dc fifo instantiation
	spwc_timecode_dc_fifo_inst : entity work.spwc_timecode_dc_fifo
		port map(
			aclr             => rst_i,
			data(7 downto 6) => timecode_avs_i.ctrl_in,
			data(5 downto 0) => timecode_avs_i.time_in,
			rdclk            => clk_spw_i,
			rdreq            => s_timecode_dc_fifo_spw_rdreq,
			wrclk            => clk_avs_i,
			wrreq            => timecode_avs_i.tick_in,
			q(7 downto 6)    => s_timecode_dc_fifo_spw_rddata_ctrl,
			q(5 downto 0)    => s_timecode_dc_fifo_spw_rddata_time,
			rdempty          => s_timecode_dc_fifo_spw_rdempty,
			rdusedw          => open,
			wrfull           => open,
			wrusedw          => open
		);

	p_clk_synchronization_tx_timecode_spw : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_timecode_just_fetched  <= '0';
			s_timecode_dc_fifo_spw_rdreq <= '0';
			timecode_spw_o.ctrl_in       <= (others => '0');
			timecode_spw_o.time_in       <= (others => '0');
			timecode_spw_o.tick_in       <= '0';

		elsif (rising_edge(clk_spw_i)) then

			timecode_spw_o.tick_in       <= '0';
			s_timecode_dc_fifo_spw_rdreq <= '0';

			if (s_spw_timecode_just_fetched = '0') then
				if (s_timecode_dc_fifo_spw_rdempty = '0') then
					s_spw_timecode_just_fetched  <= '1';
					s_timecode_dc_fifo_spw_rdreq <= '1';
					timecode_spw_o.ctrl_in       <= s_timecode_dc_fifo_spw_rddata_ctrl;
					timecode_spw_o.time_in       <= s_timecode_dc_fifo_spw_rddata_time;
					timecode_spw_o.tick_in       <= '1';
				end if;
			else
				s_spw_timecode_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_tx_timecode_spw;

end architecture RTL;
