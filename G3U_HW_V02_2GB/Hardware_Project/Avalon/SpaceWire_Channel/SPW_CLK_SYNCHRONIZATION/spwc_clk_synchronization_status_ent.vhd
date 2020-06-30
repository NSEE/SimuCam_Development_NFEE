library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_status_ent is
	port(
		clk_avs_i         : in  std_logic;
		clk_spw_i         : in  std_logic;
		rst_i             : in  std_logic;
		link_status_spw_i : in  t_spwc_codec_link_status;
		link_error_spw_i  : in  t_spwc_codec_link_error;
		link_status_avs_o : out t_spwc_codec_link_status;
		link_error_avs_o  : out t_spwc_codec_link_error
	);
end entity spwc_clk_synchronization_status_ent;

architecture RTL of spwc_clk_synchronization_status_ent is

	signal s_spw_status_waiting_write    : std_logic;
	signal s_spw_status_vector           : std_logic_vector(6 downto 0);
	signal s_spw_status_vector_dly       : std_logic_vector(6 downto 0);
	constant c_STATUS_VECTOR_NOT_CHANGED : std_logic_vector(6 downto 0) := (others => '0');

	signal s_avs_status_just_fetched : std_logic;

	signal s_status_dc_fifo_spw_wrreq         : std_logic;
	signal s_status_dc_fifo_spw_wrdata_status : t_spwc_codec_link_status;
	signal s_status_dc_fifo_spw_wrdata_error  : t_spwc_codec_link_error;
	signal s_status_dc_fifo_spw_wrfull        : std_logic;

	signal s_status_dc_fifo_avs_rdreq         : std_logic;
	signal s_status_dc_fifo_avs_rddata_status : t_spwc_codec_link_status;
	signal s_status_dc_fifo_avs_rddata_error  : t_spwc_codec_link_error;
	signal s_status_dc_fifo_avs_rdempty       : std_logic;

begin

	-- status dc fifo instantiation
	spwc_status_dc_fifo_inst : entity work.spwc_status_dc_fifo
		port map(
			aclr    => rst_i,
			data(6) => s_status_dc_fifo_spw_wrdata_status.started,
			data(5) => s_status_dc_fifo_spw_wrdata_status.connecting,
			data(4) => s_status_dc_fifo_spw_wrdata_status.running,
			data(3) => s_status_dc_fifo_spw_wrdata_error.errcred,
			data(2) => s_status_dc_fifo_spw_wrdata_error.errdisc,
			data(1) => s_status_dc_fifo_spw_wrdata_error.erresc,
			data(0) => s_status_dc_fifo_spw_wrdata_error.errpar,
			rdclk   => clk_avs_i,
			rdreq   => s_status_dc_fifo_avs_rdreq,
			wrclk   => clk_spw_i,
			wrreq   => s_status_dc_fifo_spw_wrreq,
			q(6)    => s_status_dc_fifo_avs_rddata_status.started,
			q(5)    => s_status_dc_fifo_avs_rddata_status.connecting,
			q(4)    => s_status_dc_fifo_avs_rddata_status.running,
			q(3)    => s_status_dc_fifo_avs_rddata_error.errcred,
			q(2)    => s_status_dc_fifo_avs_rddata_error.errdisc,
			q(1)    => s_status_dc_fifo_avs_rddata_error.erresc,
			q(0)    => s_status_dc_fifo_avs_rddata_error.errpar,
			rdempty => s_status_dc_fifo_avs_rdempty,
			rdusedw => open,
			wrfull  => s_status_dc_fifo_spw_wrfull,
			wrusedw => open
		);

	p_clk_synchronization_status_spw : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_status_waiting_write <= '0';
			s_spw_status_vector_dly(6) <= '0';
			s_spw_status_vector_dly(5) <= '0';
			s_spw_status_vector_dly(4) <= '0';
			s_spw_status_vector_dly(3) <= '0';
			s_spw_status_vector_dly(2) <= '0';
			s_spw_status_vector_dly(1) <= '0';
			s_spw_status_vector_dly(0) <= '0';

			s_status_dc_fifo_spw_wrdata_status.started    <= '0';
			s_status_dc_fifo_spw_wrdata_status.connecting <= '0';
			s_status_dc_fifo_spw_wrdata_status.running    <= '0';
			s_status_dc_fifo_spw_wrdata_error.errcred     <= '0';
			s_status_dc_fifo_spw_wrdata_error.errdisc     <= '0';
			s_status_dc_fifo_spw_wrdata_error.erresc      <= '0';
			s_status_dc_fifo_spw_wrdata_error.errpar      <= '0';
			s_status_dc_fifo_spw_wrreq                    <= '0';

		elsif (rising_edge(clk_spw_i)) then

			s_status_dc_fifo_spw_wrreq <= '0';

			if ((s_spw_status_waiting_write = '1') and (s_status_dc_fifo_spw_wrfull = '0')) then
				s_spw_status_waiting_write <= '0';
				s_status_dc_fifo_spw_wrreq <= '1';
			end if;

			if ((s_spw_status_vector xor s_spw_status_vector_dly) /= c_STATUS_VECTOR_NOT_CHANGED) then
				s_status_dc_fifo_spw_wrdata_status <= link_status_spw_i;
				s_status_dc_fifo_spw_wrdata_error  <= link_error_spw_i;
				if (s_status_dc_fifo_spw_wrfull = '0') then
					s_spw_status_waiting_write <= '0';
					s_status_dc_fifo_spw_wrreq <= '1';
				else
					s_spw_status_waiting_write <= '1';
					s_status_dc_fifo_spw_wrreq <= '0';
				end if;
			end if;

			s_spw_status_vector_dly <= s_spw_status_vector;

		end if;
	end process p_clk_synchronization_status_spw;

	s_spw_status_vector(6) <= link_status_spw_i.started;
	s_spw_status_vector(5) <= link_status_spw_i.connecting;
	s_spw_status_vector(4) <= link_status_spw_i.running;
	s_spw_status_vector(3) <= link_error_spw_i.errcred;
	s_spw_status_vector(2) <= link_error_spw_i.errdisc;
	s_spw_status_vector(1) <= link_error_spw_i.erresc;
	s_spw_status_vector(0) <= link_error_spw_i.errpar;

	p_clk_synchronization_status_avs : process(clk_avs_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_avs_status_just_fetched  <= '0';
			s_status_dc_fifo_avs_rdreq <= '0';

			link_status_avs_o.started    <= '0';
			link_status_avs_o.connecting <= '0';
			link_status_avs_o.running    <= '0';
			link_error_avs_o.errcred     <= '0';
			link_error_avs_o.errdisc     <= '0';
			link_error_avs_o.erresc      <= '0';
			link_error_avs_o.errpar      <= '0';

		elsif (rising_edge(clk_avs_i)) then

			s_status_dc_fifo_avs_rdreq <= '0';

			if (s_avs_status_just_fetched = '0') then
				if (s_status_dc_fifo_avs_rdempty = '0') then
					s_avs_status_just_fetched  <= '1';
					s_status_dc_fifo_avs_rdreq <= '1';
					link_status_avs_o          <= s_status_dc_fifo_avs_rddata_status;
					link_error_avs_o           <= s_status_dc_fifo_avs_rddata_error;
				end if;
			else
				s_avs_status_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_status_avs;

end architecture RTL;
