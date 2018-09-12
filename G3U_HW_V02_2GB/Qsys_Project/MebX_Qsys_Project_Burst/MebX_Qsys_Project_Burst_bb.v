
module MebX_Qsys_Project_Burst (
	clk50_clk,
	comm_a_conduit_end_spw_si_signal,
	comm_a_conduit_end_spw_di_signal,
	comm_a_conduit_end_spw_do_signal,
	comm_a_conduit_end_spw_so_signal,
	rst_reset_n,
	timer_1ms_external_port_export,
	timer_1us_external_port_export,
	clk100_clk,
	clk200_clk);	

	input		clk50_clk;
	input		comm_a_conduit_end_spw_si_signal;
	input		comm_a_conduit_end_spw_di_signal;
	output		comm_a_conduit_end_spw_do_signal;
	output		comm_a_conduit_end_spw_so_signal;
	input		rst_reset_n;
	output		timer_1ms_external_port_export;
	output		timer_1us_external_port_export;
	input		clk100_clk;
	input		clk200_clk;
endmodule
