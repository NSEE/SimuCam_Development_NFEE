library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_commands_ent is
	port(
		clk_avs_i          : in  std_logic;
		clk_spw_i          : in  std_logic;
		rst_i              : in  std_logic;
		link_command_avs_i : in  t_spwc_codec_link_command;
		link_command_spw_o : out t_spwc_codec_link_command
	);
end entity spwc_clk_synchronization_commands_ent;

architecture RTL of spwc_clk_synchronization_commands_ent is

	signal s_avs_commands_waiting_write    : std_logic;
	signal s_avs_commands_vector           : std_logic_vector(10 downto 0);
	signal s_avs_commands_vector_dly       : std_logic_vector(10 downto 0);
	constant c_COMMANDS_VECTOR_NOT_CHANGED : std_logic_vector(10 downto 0) := (others => '0');

	signal s_spw_commands_just_fetched : std_logic;

	signal s_commands_dc_fifo_avs_wrreq  : std_logic;
	signal s_commands_dc_fifo_avs_wrdata : t_spwc_codec_link_command;
	signal s_commands_dc_fifo_avs_wrfull : std_logic;

	signal s_commands_dc_fifo_spw_rdreq   : std_logic;
	signal s_commands_dc_fifo_spw_rddata  : t_spwc_codec_link_command;
	signal s_commands_dc_fifo_spw_rdempty : std_logic;

begin

	-- commands dc fifo instantiation
	spwc_command_dc_fifo_inst : entity work.spwc_command_dc_fifo
		port map(
			aclr             => rst_i,
			data(10)         => s_commands_dc_fifo_avs_wrdata.autostart,
			data(9)          => s_commands_dc_fifo_avs_wrdata.linkstart,
			data(8)          => s_commands_dc_fifo_avs_wrdata.linkdis,
			data(7 downto 0) => s_commands_dc_fifo_avs_wrdata.txdivcnt,
			rdclk            => clk_spw_i,
			rdreq            => s_commands_dc_fifo_spw_rdreq,
			wrclk            => clk_avs_i,
			wrreq            => s_commands_dc_fifo_avs_wrreq,
			q(10)            => s_commands_dc_fifo_spw_rddata.autostart,
			q(9)             => s_commands_dc_fifo_spw_rddata.linkstart,
			q(8)             => s_commands_dc_fifo_spw_rddata.linkdis,
			q(7 downto 0)    => s_commands_dc_fifo_spw_rddata.txdivcnt,
			rdempty          => s_commands_dc_fifo_spw_rdempty,
			rdusedw          => open,
			wrfull           => s_commands_dc_fifo_avs_wrfull,
			wrusedw          => open
		);

	p_clk_synchronization_commands_avs : process(clk_avs_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_avs_commands_waiting_write          <= '0';
			s_avs_commands_vector_dly(10)         <= '0';
			s_avs_commands_vector_dly(9)          <= '0';
			s_avs_commands_vector_dly(8)          <= '0';
			s_avs_commands_vector_dly(7 downto 0) <= x"01";

			s_commands_dc_fifo_avs_wrdata.autostart <= '0';
			s_commands_dc_fifo_avs_wrdata.linkstart <= '0';
			s_commands_dc_fifo_avs_wrdata.linkdis   <= '0';
			s_commands_dc_fifo_avs_wrdata.txdivcnt  <= x"01";
			s_commands_dc_fifo_avs_wrreq            <= '0';

		elsif (rising_edge(clk_avs_i)) then

			s_commands_dc_fifo_avs_wrreq <= '0';

			if ((s_avs_commands_waiting_write = '1') and (s_commands_dc_fifo_avs_wrfull = '0')) then
				s_avs_commands_waiting_write <= '0';
				s_commands_dc_fifo_avs_wrreq <= '1';
			end if;

			if ((s_avs_commands_vector xor s_avs_commands_vector_dly) /= c_COMMANDS_VECTOR_NOT_CHANGED) then
				s_commands_dc_fifo_avs_wrdata <= link_command_avs_i;
				if (s_commands_dc_fifo_avs_wrfull = '0') then
					s_avs_commands_waiting_write <= '0';
					s_commands_dc_fifo_avs_wrreq <= '1';
				else
					s_avs_commands_waiting_write <= '1';
					s_commands_dc_fifo_avs_wrreq <= '0';
				end if;
			end if;

			s_avs_commands_vector_dly <= s_avs_commands_vector;

		end if;
	end process p_clk_synchronization_commands_avs;

	s_avs_commands_vector(10)         <= link_command_avs_i.autostart;
	s_avs_commands_vector(9)          <= link_command_avs_i.linkstart;
	s_avs_commands_vector(8)          <= link_command_avs_i.linkdis;
	s_avs_commands_vector(7 downto 0) <= link_command_avs_i.txdivcnt;

	p_clk_synchronization_commands_spw : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_commands_just_fetched  <= '0';
			s_commands_dc_fifo_spw_rdreq <= '0';

			link_command_spw_o.autostart <= '0';
			link_command_spw_o.linkstart <= '0';
			link_command_spw_o.linkdis   <= '0';
			link_command_spw_o.txdivcnt  <= x"01";

		elsif (rising_edge(clk_spw_i)) then

			s_commands_dc_fifo_spw_rdreq <= '0';

			if (s_spw_commands_just_fetched = '0') then
				if (s_commands_dc_fifo_spw_rdempty = '0') then
					s_spw_commands_just_fetched  <= '1';
					s_commands_dc_fifo_spw_rdreq <= '1';
					link_command_spw_o           <= s_commands_dc_fifo_spw_rddata;
				end if;
			else
				s_spw_commands_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_commands_spw;

end architecture RTL;
