library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spw_codec_pkg.all;

entity spw_clk_synchronization_ent is
	port(
		clk_100_i                          : in  std_logic;
		clk_200_i                          : in  std_logic;
		rst_i                              : in  std_logic;
		spw_codec_link_command_clk100_i    : in  t_spw_codec_link_command;
		spw_codec_timecode_tx_clk100_i     : in  t_spw_codec_timecode_tx;
		spw_codec_data_rx_command_clk100_i : in  t_spw_codec_data_rx_command;
		spw_codec_data_tx_command_clk100_i : in  t_spw_codec_data_tx_command;
		spw_codec_link_status_clk200_i     : in  t_spw_codec_link_status;
		spw_codec_link_error_clk200_i      : in  t_spw_codec_link_error;
		spw_codec_timecode_rx_clk200_i     : in  t_spw_codec_timecode_rx;
		spw_codec_data_rx_status_clk200_i  : in  t_spw_codec_data_rx_status;
		spw_codec_data_tx_status_clk200_i  : in  t_spw_codec_data_tx_status;
		spw_codec_link_status_clk100_o     : out t_spw_codec_link_status;
		spw_codec_link_error_clk100_o      : out t_spw_codec_link_error;
		spw_codec_timecode_rx_clk100_o     : out t_spw_codec_timecode_rx;
		spw_codec_data_rx_status_clk100_o  : out t_spw_codec_data_rx_status;
		spw_codec_data_tx_status_clk100_o  : out t_spw_codec_data_tx_status;
		spw_codec_link_command_clk200_o    : out t_spw_codec_link_command;
		spw_codec_timecode_tx_clk200_o     : out t_spw_codec_timecode_tx;
		spw_codec_data_rx_command_clk200_o : out t_spw_codec_data_rx_command;
		spw_codec_data_tx_command_clk200_o : out t_spw_codec_data_tx_command
	);
end entity spw_clk_synchronization_ent;

architecture RTL of spw_clk_synchronization_ent is

	-- clk100 commands to clk200 signals
	signal s_link_command_stage_0 : t_spw_codec_link_command;
	signal s_link_command_stage_1 : t_spw_codec_link_command;
	signal s_link_command_stage_2 : t_spw_codec_link_command;

	-- clk100 tx_data to clk200 signals
	signal s_clk100_tx_data_txflag    : std_logic;
	signal s_clk100_tx_data_txdata    : std_logic_vector(7 downto 0);
	signal s_clk200_tx_data_rdreq     : std_logic;
	signal s_clk100_tx_data_wrreq     : std_logic;
	signal s_clk200_tx_data_txflag    : std_logic;
	signal s_clk200_tx_data_txdata    : std_logic_vector(7 downto 0);
	signal s_clk200_tx_data_rdempty   : std_logic;
	signal s_clk100_tx_data_wrfull    : std_logic;
	signal s_clk100_tx_data_wrusedw   : std_logic_vector(3 downto 0);
	signal s_clk200_tx_data_available : std_logic;

	-- clk100 tx_timecode to clk200 signals
	signal s_clk100_tx_timecode_ctrl_in   : std_logic_vector(1 downto 0);
	signal s_clk100_tx_timecode_time_in   : std_logic_vector(5 downto 0);
	signal s_clk200_tx_timecode_rdreq     : std_logic;
	signal s_clk100_tx_timecode_wrreq     : std_logic;
	signal s_clk200_tx_timecode_ctrl_in   : std_logic_vector(1 downto 0);
	signal s_clk200_tx_timecode_time_in   : std_logic_vector(5 downto 0);
	signal s_clk200_tx_timecode_rdempty   : std_logic;
	signal s_clk100_tx_timecode_wrfull    : std_logic;
	signal s_clk200_tx_timecode_available : std_logic;

	-- clk200 status to clk100 signals
	signal s_stretching_over : std_logic;
	signal s_link_status     : t_spw_codec_link_status;
	signal s_link_error      : t_spw_codec_link_error;

	-- clk200 rx_data to clk100 signals
	signal s_clk200_rx_data_rxflag    : std_logic;
	signal s_clk200_rx_data_rxdata    : std_logic_vector(7 downto 0);
	signal s_clk100_rx_data_rdreq     : std_logic;
	signal s_clk200_rx_data_wrreq     : std_logic;
	signal s_clk100_rx_data_rxflag    : std_logic;
	signal s_clk100_rx_data_rxdata    : std_logic_vector(7 downto 0);
	signal s_clk100_rx_data_rdempty   : std_logic;
	signal s_clk200_rx_data_wrfull    : std_logic;
	signal s_clk100_rx_data_available : std_logic;
	signal s_clk100_rx_data_valid     : std_logic;

	-- clk200 rx_timecode to clk100 signals
	signal s_clk200_rx_timecode_ctrl_out  : std_logic_vector(1 downto 0);
	signal s_clk200_rx_timecode_time_out  : std_logic_vector(5 downto 0);
	signal s_clk100_rx_timecode_rdreq     : std_logic;
	signal s_clk200_rx_timecode_wrreq     : std_logic;
	signal s_clk100_rx_timecode_ctrl_out  : std_logic_vector(1 downto 0);
	signal s_clk100_rx_timecode_time_out  : std_logic_vector(5 downto 0);
	signal s_clk100_rx_timecode_rdempty   : std_logic;
	signal s_clk200_rx_timecode_wrfull    : std_logic;
	signal s_clk100_rx_timecode_available : std_logic;

begin

	-- clk100 commands to clk200 --
	-- flip-flop synchronization
	p_clk200_clk100_commands_to_clk200 : process(clk_200_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_link_command_stage_1.autostart          <= '0';
			s_link_command_stage_1.linkstart          <= '0';
			s_link_command_stage_1.linkdis            <= '0';
			s_link_command_stage_1.txdivcnt           <= x"01";
			s_link_command_stage_2.autostart          <= '0';
			s_link_command_stage_2.linkstart          <= '0';
			s_link_command_stage_2.linkdis            <= '0';
			s_link_command_stage_2.txdivcnt           <= x"01";
			spw_codec_link_command_clk200_o.autostart <= '0';
			spw_codec_link_command_clk200_o.linkstart <= '0';
			spw_codec_link_command_clk200_o.linkdis   <= '0';
			spw_codec_link_command_clk200_o.txdivcnt  <= x"01";
		elsif rising_edge(clk_200_i) then
			s_link_command_stage_1          <= s_link_command_stage_0;
			s_link_command_stage_2          <= s_link_command_stage_1;
			spw_codec_link_command_clk200_o <= s_link_command_stage_2;
		end if;
	end process p_clk200_clk100_commands_to_clk200;
	p_clk100_clk100_commands_to_clk200 : process(clk_100_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_link_command_stage_0.autostart <= '0';
			s_link_command_stage_0.linkstart <= '0';
			s_link_command_stage_0.linkdis   <= '0';
			s_link_command_stage_0.txdivcnt  <= x"01";
		elsif rising_edge(clk_100_i) then
			s_link_command_stage_0 <= spw_codec_link_command_clk100_i;
		end if;
	end process p_clk100_clk100_commands_to_clk200;

	-- clk100 tx_data to clk200 --
	-- dc fifo
	clk100_to_clk200_spw_data_dc_fifo_inst : entity work.spw_data_dc_fifo
		port map(
			aclr             => rst_i,
			data(8)          => s_clk100_tx_data_txflag,
			data(7 downto 0) => s_clk100_tx_data_txdata,
			rdclk            => clk_200_i,
			rdreq            => s_clk200_tx_data_rdreq,
			wrclk            => clk_100_i,
			wrreq            => s_clk100_tx_data_wrreq,
			q(8)             => s_clk200_tx_data_txflag,
			q(7 downto 0)    => s_clk200_tx_data_txdata,
			rdempty          => s_clk200_tx_data_rdempty,
			rdusedw          => open,
			wrfull           => s_clk100_tx_data_wrfull,
			wrusedw          => s_clk100_tx_data_wrusedw
		);
	p_clk200_clk100_tx_data_to_clk200 : process(clk_200_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk200_tx_data_rdreq                     <= '0';
			s_clk200_tx_data_available                 <= '0';
			spw_codec_data_tx_command_clk200_o.txflag  <= '0';
			spw_codec_data_tx_command_clk200_o.txdata  <= (others => '0');
			spw_codec_data_tx_command_clk200_o.txwrite <= '0';
		elsif rising_edge(clk_200_i) then
			-- read fifo
			s_clk200_tx_data_rdreq                     <= '0';
			spw_codec_data_tx_command_clk200_o.txwrite <= '0';
			if ((s_clk200_tx_data_rdempty = '0') and (s_clk200_tx_data_available <= '0') and (s_clk200_tx_data_rdreq = '0')) then
				s_clk200_tx_data_rdreq     <= '1';
				s_clk200_tx_data_available <= '0';
			end if;
			if (s_clk200_tx_data_rdreq = '1') then
				s_clk200_tx_data_rdreq     <= '0';
				s_clk200_tx_data_available <= '1';
			end if;
			if ((s_clk200_tx_data_available = '1') and (spw_codec_data_tx_status_clk200_i.txrdy = '1') and (spw_codec_data_tx_status_clk200_i.txhalff = '0')) then
				spw_codec_data_tx_command_clk200_o.txwrite <= '1';
				spw_codec_data_tx_command_clk200_o.txflag  <= s_clk200_tx_data_txflag;
				spw_codec_data_tx_command_clk200_o.txdata  <= s_clk200_tx_data_txdata;
				s_clk200_tx_data_available                 <= '0';
			end if;
		end if;
	end process p_clk200_clk100_tx_data_to_clk200;
	p_clk100_clk100_tx_data_to_clk200 : process(clk_100_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk100_tx_data_txflag <= '0';
			s_clk100_tx_data_txdata <= (others => '0');
			s_clk100_tx_data_wrreq  <= '0';
		elsif rising_edge(clk_100_i) then
			-- write fifo
			s_clk100_tx_data_wrreq <= '0';
			if (spw_codec_data_tx_command_clk100_i.txwrite = '1') then
				s_clk100_tx_data_wrreq  <= '1';
				s_clk100_tx_data_txflag <= spw_codec_data_tx_command_clk100_i.txflag;
				s_clk100_tx_data_txdata <= spw_codec_data_tx_command_clk100_i.txdata;
			end if;
		end if;
	end process p_clk100_clk100_tx_data_to_clk200;
	spw_codec_data_tx_status_clk100_o.txhalff <= '0';
	spw_codec_data_tx_status_clk100_o.txrdy   <= ('1') when ((s_clk100_tx_data_wrusedw < "1111") and (spw_codec_data_tx_status_clk200_i.txhalff = '0')) else ('0');

	-- clk100 tx_timecode to clk200 --
	-- dc fifo
	clk100_to_clk200_spw_timecode_dc_fifo_inst : entity work.spw_timecode_dc_fifo
		port map(
			aclr             => rst_i,
			data(7 downto 6) => s_clk100_tx_timecode_ctrl_in,
			data(5 downto 0) => s_clk100_tx_timecode_time_in,
			rdclk            => clk_200_i,
			rdreq            => s_clk200_tx_timecode_rdreq,
			wrclk            => clk_100_i,
			wrreq            => s_clk100_tx_timecode_wrreq,
			q(7 downto 6)    => s_clk200_tx_timecode_ctrl_in,
			q(5 downto 0)    => s_clk200_tx_timecode_time_in,
			rdempty          => s_clk200_tx_timecode_rdempty,
			rdusedw          => open,
			wrfull           => s_clk100_tx_timecode_wrfull,
			wrusedw          => open
		);
	p_clk200_clk100_tx_timecode_to_clk200 : process(clk_200_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk200_tx_timecode_rdreq             <= '0';
			s_clk200_tx_timecode_available         <= '0';
			spw_codec_timecode_tx_clk200_o.ctrl_in <= (others => '0');
			spw_codec_timecode_tx_clk200_o.time_in <= (others => '0');
			spw_codec_timecode_tx_clk200_o.tick_in <= '0';
		elsif rising_edge(clk_200_i) then
			-- read fifo
			s_clk200_tx_timecode_rdreq             <= '0';
			spw_codec_timecode_tx_clk200_o.tick_in <= '0';
			if ((s_clk200_tx_timecode_rdempty = '0') and (s_clk200_tx_timecode_available <= '0') and (s_clk200_tx_timecode_rdreq = '0')) then
				s_clk200_tx_timecode_rdreq     <= '1';
				s_clk200_tx_timecode_available <= '0';
			end if;
			if (s_clk200_tx_timecode_rdreq = '1') then
				s_clk200_tx_timecode_rdreq     <= '0';
				s_clk200_tx_timecode_available <= '1';
			end if;
			if (s_clk200_tx_timecode_available = '1') then
				spw_codec_timecode_tx_clk200_o.tick_in <= '1';
				spw_codec_timecode_tx_clk200_o.ctrl_in <= s_clk200_tx_timecode_ctrl_in;
				spw_codec_timecode_tx_clk200_o.time_in <= s_clk200_tx_timecode_time_in;
				s_clk200_tx_timecode_available         <= '0';
			end if;
		end if;
	end process p_clk200_clk100_tx_timecode_to_clk200;
	p_clk100_clk100_tx_timecode_to_clk200 : process(clk_100_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk100_tx_timecode_ctrl_in <= (others => '0');
			s_clk100_tx_timecode_time_in <= (others => '0');
			s_clk100_tx_timecode_wrreq   <= '0';
		elsif rising_edge(clk_100_i) then
			-- write fifo
			s_clk100_tx_timecode_wrreq <= '0';
			if ((s_clk100_tx_timecode_wrfull = '0') and (spw_codec_timecode_tx_clk100_i.tick_in = '1')) then
				s_clk100_tx_timecode_wrreq   <= '1';
				s_clk100_tx_timecode_ctrl_in <= spw_codec_timecode_tx_clk100_i.ctrl_in;
				s_clk100_tx_timecode_time_in <= spw_codec_timecode_tx_clk100_i.time_in;
			end if;
		end if;
	end process p_clk100_clk100_tx_timecode_to_clk200;

	-- clk200 status to clk100 --
	-- clock stretching
	p_clk200_clk200_status_to_clk100 : process(clk_200_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_stretching_over        <= '0';
			s_link_status.started    <= '0';
			s_link_status.connecting <= '0';
			s_link_status.running    <= '0';
			s_link_error.errcred     <= '0';
			s_link_error.errdisc     <= '0';
			s_link_error.erresc      <= '0';
			s_link_error.errpar      <= '0';
		elsif rising_edge(clk_200_i) then
			if (s_stretching_over = '1') then
				s_stretching_over <= '0';
				s_link_status     <= spw_codec_link_status_clk200_i;
				s_link_error      <= spw_codec_link_error_clk200_i;
			else
				s_stretching_over <= '1';
				s_link_status     <= s_link_status;
				s_link_error      <= s_link_error;
			end if;
		end if;
	end process p_clk200_clk200_status_to_clk100;
	p_clk100_clk200_status_to_clk100 : process(clk_100_i, rst_i) is
	begin
		if (rst_i = '1') then
			spw_codec_link_status_clk100_o.started    <= '0';
			spw_codec_link_status_clk100_o.connecting <= '0';
			spw_codec_link_status_clk100_o.connecting <= '0';
			spw_codec_link_error_clk100_o.errcred     <= '0';
			spw_codec_link_error_clk100_o.errdisc     <= '0';
			spw_codec_link_error_clk100_o.erresc      <= '0';
			spw_codec_link_error_clk100_o.errpar      <= '0';
		elsif rising_edge(clk_100_i) then
			spw_codec_link_status_clk100_o <= s_link_status;
			spw_codec_link_error_clk100_o  <= s_link_error;
		end if;
	end process p_clk100_clk200_status_to_clk100;

	-- clk200 rx_data to clk100 --
	-- dc fifo
	clk200_to_clk100_spw_data_dc_fifo_inst : entity work.spw_data_dc_fifo
		port map(
			aclr             => rst_i,
			data(8)          => s_clk200_rx_data_rxflag,
			data(7 downto 0) => s_clk200_rx_data_rxdata,
			rdclk            => clk_100_i,
			rdreq            => s_clk100_rx_data_rdreq,
			wrclk            => clk_200_i,
			wrreq            => s_clk200_rx_data_wrreq,
			q(8)             => s_clk100_rx_data_rxflag,
			q(7 downto 0)    => s_clk100_rx_data_rxdata,
			rdempty          => s_clk100_rx_data_rdempty,
			rdusedw          => open,
			wrfull           => s_clk200_rx_data_wrfull,
			wrusedw          => open
		);
	p_clk200_clk200_rx_data_to_clk100 : process(clk_200_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk200_rx_data_rxflag                   <= '0';
			s_clk200_rx_data_rxdata                   <= (others => '0');
			s_clk200_rx_data_wrreq                    <= '0';
			spw_codec_data_rx_command_clk200_o.rxread <= '0';
		elsif rising_edge(clk_200_i) then
			-- write fifo
			s_clk200_rx_data_wrreq                    <= '0';
			spw_codec_data_rx_command_clk200_o.rxread <= '0';
			if ((s_clk200_rx_data_wrfull = '0') and (spw_codec_data_rx_status_clk200_i.rxvalid = '1') and (s_clk200_rx_data_wrreq = '0')) then
				s_clk200_rx_data_wrreq                    <= '1';
				s_clk200_rx_data_rxflag                   <= spw_codec_data_rx_status_clk200_i.rxflag;
				s_clk200_rx_data_rxdata                   <= spw_codec_data_rx_status_clk200_i.rxdata;
				spw_codec_data_rx_command_clk200_o.rxread <= '1';
			end if;
		end if;
	end process p_clk200_clk200_rx_data_to_clk100;
	p_clk100_clk200_rx_data_to_clk100 : process(clk_100_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk100_rx_data_rdreq                   <= '0';
			s_clk100_rx_data_available               <= '0';
			s_clk100_rx_data_valid                   <= '0';
			spw_codec_data_rx_status_clk100_o.rxflag <= '0';
			spw_codec_data_rx_status_clk100_o.rxdata <= (others => '0');
		elsif rising_edge(clk_100_i) then
			-- read fifo
			s_clk100_rx_data_rdreq <= '0';
			if ((s_clk100_rx_data_rdempty = '0') and (s_clk100_rx_data_available = '0') and (s_clk100_rx_data_rdreq = '0')) then
				s_clk100_rx_data_rdreq     <= '1';
				s_clk100_rx_data_available <= '0';
				s_clk100_rx_data_valid     <= '0';
			end if;
			if (s_clk100_rx_data_rdreq = '1') then
				s_clk100_rx_data_rdreq     <= '0';
				s_clk100_rx_data_available <= '1';
				s_clk100_rx_data_valid     <= '0';
			end if;
			if (s_clk100_rx_data_available = '1') then
				s_clk100_rx_data_rdreq                   <= '0';
				spw_codec_data_rx_status_clk100_o.rxflag <= s_clk100_rx_data_rxflag;
				spw_codec_data_rx_status_clk100_o.rxdata <= s_clk100_rx_data_rxdata;
				s_clk100_rx_data_available               <= '1';
				s_clk100_rx_data_valid                   <= '1';
			end if;
			if (spw_codec_data_rx_command_clk100_i.rxread = '1') then
				s_clk100_rx_data_available <= '0';
				s_clk100_rx_data_valid     <= '0';
			end if;
		end if;
	end process p_clk100_clk200_rx_data_to_clk100;
	spw_codec_data_rx_status_clk100_o.rxhalff <= '0';
	spw_codec_data_rx_status_clk100_o.rxvalid <= ('1') when ((s_clk100_rx_data_valid = '1') and (spw_codec_data_rx_command_clk100_i.rxread = '0')) else ('0');

	-- clk200 rx_timecode to clk100 --
	-- dc fifo
	clk200_to_clk100_spw_timecode_dc_fifo_inst : entity work.spw_timecode_dc_fifo
		port map(
			aclr             => rst_i,
			data(7 downto 6) => s_clk200_rx_timecode_ctrl_out,
			data(5 downto 0) => s_clk200_rx_timecode_time_out,
			rdclk            => clk_100_i,
			rdreq            => s_clk100_rx_timecode_rdreq,
			wrclk            => clk_200_i,
			wrreq            => s_clk200_rx_timecode_wrreq,
			q(7 downto 6)    => s_clk100_rx_timecode_ctrl_out,
			q(5 downto 0)    => s_clk100_rx_timecode_time_out,
			rdempty          => s_clk100_rx_timecode_rdempty,
			rdusedw          => open,
			wrfull           => s_clk200_rx_timecode_wrfull,
			wrusedw          => open
		);
	p_clk200_clk200_rx_timecode_to_clk100 : process(clk_200_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk200_rx_timecode_ctrl_out <= (others => '0');
			s_clk200_rx_timecode_time_out <= (others => '0');
			s_clk200_rx_timecode_wrreq    <= '0';
		elsif rising_edge(clk_200_i) then
			-- write fifo
			s_clk200_rx_timecode_wrreq <= '0';
			if ((s_clk200_rx_timecode_wrfull = '0') and (spw_codec_timecode_rx_clk200_i.tick_out = '1')) then
				s_clk200_rx_timecode_wrreq    <= '1';
				s_clk200_rx_timecode_ctrl_out <= spw_codec_timecode_rx_clk200_i.ctrl_out;
				s_clk200_rx_timecode_time_out <= spw_codec_timecode_rx_clk200_i.time_out;
			end if;
		end if;
	end process p_clk200_clk200_rx_timecode_to_clk100;
	p_clk100_clk200_rx_timecode_to_clk100 : process(clk_100_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_clk100_rx_timecode_rdreq              <= '0';
			s_clk100_rx_timecode_available          <= '0';
			spw_codec_timecode_rx_clk100_o.ctrl_out <= (others => '0');
			spw_codec_timecode_rx_clk100_o.time_out <= (others => '0');
			spw_codec_timecode_rx_clk100_o.tick_out <= '0';
		elsif rising_edge(clk_100_i) then
			-- read fifo
			s_clk100_rx_timecode_rdreq              <= '0';
			spw_codec_timecode_rx_clk100_o.tick_out <= '0';
			if ((s_clk100_rx_timecode_rdempty = '0') and (s_clk100_rx_timecode_available <= '0') and (s_clk100_rx_timecode_rdreq = '0')) then
				s_clk100_rx_timecode_rdreq     <= '1';
				s_clk100_rx_timecode_available <= '0';
			end if;
			if (s_clk100_rx_timecode_rdreq = '1') then
				s_clk100_rx_timecode_rdreq     <= '0';
				s_clk100_rx_timecode_available <= '1';
			end if;
			if (s_clk100_rx_timecode_available = '1') then
				spw_codec_timecode_rx_clk100_o.tick_out <= '1';
				spw_codec_timecode_rx_clk100_o.ctrl_out <= s_clk100_rx_timecode_ctrl_out;
				spw_codec_timecode_rx_clk100_o.time_out <= s_clk100_rx_timecode_time_out;
				s_clk100_rx_timecode_available          <= '0';
			end if;
		end if;
	end process p_clk100_clk200_rx_timecode_to_clk100;

end architecture RTL;
