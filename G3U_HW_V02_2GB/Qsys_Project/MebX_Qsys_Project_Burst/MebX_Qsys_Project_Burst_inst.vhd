	component MebX_Qsys_Project_Burst is
		port (
			clk50_clk                        : in  std_logic := 'X'; -- clk
			comm_a_conduit_end_spw_si_signal : in  std_logic := 'X'; -- spw_si_signal
			comm_a_conduit_end_spw_di_signal : in  std_logic := 'X'; -- spw_di_signal
			comm_a_conduit_end_spw_do_signal : out std_logic;        -- spw_do_signal
			comm_a_conduit_end_spw_so_signal : out std_logic;        -- spw_so_signal
			rst_reset_n                      : in  std_logic := 'X'; -- reset_n
			timer_1ms_external_port_export   : out std_logic;        -- export
			timer_1us_external_port_export   : out std_logic;        -- export
			clk100_clk                       : in  std_logic := 'X'; -- clk
			clk200_clk                       : in  std_logic := 'X'  -- clk
		);
	end component MebX_Qsys_Project_Burst;

	u0 : component MebX_Qsys_Project_Burst
		port map (
			clk50_clk                        => CONNECTED_TO_clk50_clk,                        --                   clk50.clk
			comm_a_conduit_end_spw_si_signal => CONNECTED_TO_comm_a_conduit_end_spw_si_signal, --      comm_a_conduit_end.spw_si_signal
			comm_a_conduit_end_spw_di_signal => CONNECTED_TO_comm_a_conduit_end_spw_di_signal, --                        .spw_di_signal
			comm_a_conduit_end_spw_do_signal => CONNECTED_TO_comm_a_conduit_end_spw_do_signal, --                        .spw_do_signal
			comm_a_conduit_end_spw_so_signal => CONNECTED_TO_comm_a_conduit_end_spw_so_signal, --                        .spw_so_signal
			rst_reset_n                      => CONNECTED_TO_rst_reset_n,                      --                     rst.reset_n
			timer_1ms_external_port_export   => CONNECTED_TO_timer_1ms_external_port_export,   -- timer_1ms_external_port.export
			timer_1us_external_port_export   => CONNECTED_TO_timer_1us_external_port_export,   -- timer_1us_external_port.export
			clk100_clk                       => CONNECTED_TO_clk100_clk,                       --                  clk100.clk
			clk200_clk                       => CONNECTED_TO_clk200_clk                        --                  clk200.clk
		);

