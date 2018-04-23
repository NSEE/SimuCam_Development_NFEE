library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sync_outmux_pkg.all;

entity sync_outmux_ent is
	generic(
		g_SYNC_POLARITY : std_logic := '1'
	);
	port(
		clk_i           : in  std_logic;
		reset_n_i       : in  std_logic;
		sync_signal_i   : in  std_logic_vector(1 downto 0);
		sync_control_i  : in  t_sync_outmux_control;
		sync_channels_o : out t_sync_outmux_output
	);
end entity sync_outmux_ent;

architecture RTL of sync_outmux_ent is

begin

	p_sync_outmux : process(clk_i, reset_n_i) is
	begin
		if (reset_n_i = '0') then
			sync_channels_o.channel_a_signal(1) <= '0';
			sync_channels_o.channel_a_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_b_signal(1) <= '0';
			sync_channels_o.channel_b_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_c_signal(1) <= '0';
			sync_channels_o.channel_c_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_d_signal(1) <= '0';
			sync_channels_o.channel_d_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_e_signal(1) <= '0';
			sync_channels_o.channel_e_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_f_signal(1) <= '0';
			sync_channels_o.channel_f_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_g_signal(1) <= '0';
			sync_channels_o.channel_g_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.channel_h_signal(1) <= '0';
			sync_channels_o.channel_h_signal(0) <= g_SYNC_POLARITY;
			sync_channels_o.sync_out_signal(1)  <= '0';
			sync_channels_o.sync_out_signal(0)  <= g_SYNC_POLARITY;
		elsif rising_edge(clk_i) then

			if (sync_control_i.channel_a_enable = '1') then
				sync_channels_o.channel_a_signal <= sync_signal_i;
			else
				sync_channels_o.channel_a_signal(1) <= '0';
				sync_channels_o.channel_a_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_b_enable = '1') then
				sync_channels_o.channel_b_signal <= sync_signal_i;
			else
				sync_channels_o.channel_b_signal(1) <= '0';
				sync_channels_o.channel_b_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_c_enable = '1') then
				sync_channels_o.channel_c_signal <= sync_signal_i;
			else
				sync_channels_o.channel_c_signal(1) <= '0';
				sync_channels_o.channel_c_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_d_enable = '1') then
				sync_channels_o.channel_d_signal <= sync_signal_i;
			else
				sync_channels_o.channel_d_signal(1) <= '0';
				sync_channels_o.channel_d_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_e_enable = '1') then
				sync_channels_o.channel_e_signal <= sync_signal_i;
			else
				sync_channels_o.channel_e_signal(1) <= '0';
				sync_channels_o.channel_e_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_f_enable = '1') then
				sync_channels_o.channel_f_signal <= sync_signal_i;
			else
				sync_channels_o.channel_f_signal(1) <= '0';
				sync_channels_o.channel_f_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_g_enable = '1') then
				sync_channels_o.channel_g_signal <= sync_signal_i;
			else
				sync_channels_o.channel_g_signal(1) <= '0';
				sync_channels_o.channel_g_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.channel_h_enable = '1') then
				sync_channels_o.channel_h_signal <= sync_signal_i;
			else
				sync_channels_o.channel_h_signal(1) <= '0';
				sync_channels_o.channel_h_signal(0) <= g_SYNC_POLARITY;
			end if;

			if (sync_control_i.sync_out_enable = '1') then
				sync_channels_o.sync_out_enable <= sync_signal_i;
			else
				sync_channels_o.sync_out_signal(1) <= '0';
				sync_channels_o.sync_out_signal(0) <= g_SYNC_POLARITY;
			end if;

		end if;
	end process p_sync_outmux;

end architecture RTL;
