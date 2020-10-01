library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwc_errinj_pkg.all;
use work.spwc_codec_pkg.all;

entity spwc_clk_synchronization_commands_ent is
	port(
		clk_avs_i                 : in  std_logic;
		clk_spw_i                 : in  std_logic;
		rst_i                     : in  std_logic;
		link_command_avs_i        : in  t_spwc_codec_link_command;
		errinj_ctrl_control_avs_i : in  t_spwc_errinj_controller_control;
		link_command_spw_o        : out t_spwc_codec_link_command;
		errinj_ctrl_control_spw_o : out t_spwc_errinj_controller_control
	);
end entity spwc_clk_synchronization_commands_ent;

architecture RTL of spwc_clk_synchronization_commands_ent is

	signal s_avs_commands_waiting_write    : std_logic;
	signal s_avs_commands_vector           : std_logic_vector(16 downto 0);
	signal s_avs_commands_vector_dly       : std_logic_vector(16 downto 0);
	constant c_COMMANDS_VECTOR_NOT_CHANGED : std_logic_vector(16 downto 0) := (others => '0');

	signal s_spw_commands_just_fetched : std_logic;

	signal s_commands_dc_fifo_avs_wrreq              : std_logic;
	signal s_commands_dc_fifo_avs_wrdata_link_cmd    : t_spwc_codec_link_command;
	signal s_commands_dc_fifo_avs_wrdata_errinj_ctrl : t_spwc_errinj_controller_control;
	signal s_commands_dc_fifo_avs_wrfull             : std_logic;

	signal s_commands_dc_fifo_spw_rdreq              : std_logic;
	signal s_commands_dc_fifo_spw_rddata_link_cmd    : t_spwc_codec_link_command;
	signal s_commands_dc_fifo_spw_rddata_errinj_ctrl : t_spwc_errinj_controller_control;
	signal s_commands_dc_fifo_spw_rdempty            : std_logic;

begin

	-- commands dc fifo instantiation
	spwc_command_dc_fifo_inst : entity work.spwc_command_dc_fifo
		port map(
			aclr              => rst_i,
			data(16)          => s_commands_dc_fifo_avs_wrdata_link_cmd.autostart,
			data(15)          => s_commands_dc_fifo_avs_wrdata_link_cmd.linkstart,
			data(14)          => s_commands_dc_fifo_avs_wrdata_link_cmd.linkdis,
			data(13 downto 6) => s_commands_dc_fifo_avs_wrdata_link_cmd.txdivcnt,
			data(5)           => s_commands_dc_fifo_avs_wrdata_errinj_ctrl.start_errinj,
			data(4)           => s_commands_dc_fifo_avs_wrdata_errinj_ctrl.reset_errinj,
			data(3 downto 0)  => s_commands_dc_fifo_avs_wrdata_errinj_ctrl.errinj_code,
			rdclk             => clk_spw_i,
			rdreq             => s_commands_dc_fifo_spw_rdreq,
			wrclk             => clk_avs_i,
			wrreq             => s_commands_dc_fifo_avs_wrreq,
			q(16)             => s_commands_dc_fifo_spw_rddata_link_cmd.autostart,
			q(15)             => s_commands_dc_fifo_spw_rddata_link_cmd.linkstart,
			q(14)             => s_commands_dc_fifo_spw_rddata_link_cmd.linkdis,
			q(13 downto 6)    => s_commands_dc_fifo_spw_rddata_link_cmd.txdivcnt,
			q(5)              => s_commands_dc_fifo_spw_rddata_errinj_ctrl.start_errinj,
			q(4)              => s_commands_dc_fifo_spw_rddata_errinj_ctrl.reset_errinj,
			q(3 downto 0)     => s_commands_dc_fifo_spw_rddata_errinj_ctrl.errinj_code,
			rdempty           => s_commands_dc_fifo_spw_rdempty,
			rdusedw           => open,
			wrfull            => s_commands_dc_fifo_avs_wrfull,
			wrusedw           => open
		);

	p_clk_synchronization_commands_avs : process(clk_avs_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_avs_commands_waiting_write           <= '0';
			s_avs_commands_vector_dly(16)          <= '0';
			s_avs_commands_vector_dly(15)          <= '0';
			s_avs_commands_vector_dly(14)          <= '0';
			s_avs_commands_vector_dly(13 downto 6) <= x"01";
			s_avs_commands_vector_dly(5)           <= '0';
			s_avs_commands_vector_dly(4)           <= '0';
			s_avs_commands_vector_dly(3 downto 0)  <= c_SPWC_ERRINJ_CODE_NONE;

			s_commands_dc_fifo_avs_wrdata_link_cmd.autostart <= '0';
			s_commands_dc_fifo_avs_wrdata_link_cmd.linkstart <= '0';
			s_commands_dc_fifo_avs_wrdata_link_cmd.linkdis   <= '0';
			s_commands_dc_fifo_avs_wrdata_link_cmd.txdivcnt  <= x"01";
			s_commands_dc_fifo_avs_wrdata_errinj_ctrl        <= c_SPWC_ERRINJ_CONTROLLER_CONTROL_RST;
			s_commands_dc_fifo_avs_wrreq                     <= '0';

		elsif (rising_edge(clk_avs_i)) then

			s_commands_dc_fifo_avs_wrreq <= '0';

			if ((s_avs_commands_waiting_write = '1') and (s_commands_dc_fifo_avs_wrfull = '0')) then
				s_avs_commands_waiting_write <= '0';
				s_commands_dc_fifo_avs_wrreq <= '1';
			end if;

			if ((s_avs_commands_vector xor s_avs_commands_vector_dly) /= c_COMMANDS_VECTOR_NOT_CHANGED) then
				s_commands_dc_fifo_avs_wrdata_link_cmd    <= link_command_avs_i;
				s_commands_dc_fifo_avs_wrdata_errinj_ctrl <= errinj_ctrl_control_avs_i;
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

	s_avs_commands_vector(16)          <= link_command_avs_i.autostart;
	s_avs_commands_vector(15)          <= link_command_avs_i.linkstart;
	s_avs_commands_vector(14)          <= link_command_avs_i.linkdis;
	s_avs_commands_vector(13 downto 6) <= link_command_avs_i.txdivcnt;
	s_avs_commands_vector(5)           <= errinj_ctrl_control_avs_i.start_errinj;
	s_avs_commands_vector(4)           <= errinj_ctrl_control_avs_i.reset_errinj;
	s_avs_commands_vector(3 downto 0)  <= errinj_ctrl_control_avs_i.errinj_code;

	p_clk_synchronization_commands_spw : process(clk_spw_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_spw_commands_just_fetched  <= '0';
			s_commands_dc_fifo_spw_rdreq <= '0';

			link_command_spw_o.autostart <= '0';
			link_command_spw_o.linkstart <= '0';
			link_command_spw_o.linkdis   <= '0';
			link_command_spw_o.txdivcnt  <= x"01";
			errinj_ctrl_control_spw_o    <= c_SPWC_ERRINJ_CONTROLLER_CONTROL_RST;

		elsif (rising_edge(clk_spw_i)) then

			s_commands_dc_fifo_spw_rdreq <= '0';

			if (s_spw_commands_just_fetched = '0') then
				if (s_commands_dc_fifo_spw_rdempty = '0') then
					s_spw_commands_just_fetched  <= '1';
					s_commands_dc_fifo_spw_rdreq <= '1';
					link_command_spw_o           <= s_commands_dc_fifo_spw_rddata_link_cmd;
					errinj_ctrl_control_spw_o    <= s_commands_dc_fifo_spw_rddata_errinj_ctrl;
				end if;
			else
				s_spw_commands_just_fetched <= '0';
			end if;

		end if;
	end process p_clk_synchronization_commands_spw;

end architecture RTL;
