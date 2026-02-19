/*
  File Name     : mst_fifo_io.v 
  Department    : IC Design, FTDI SGP
  Author        : Do Ngoc Duong
  History       : 25 April 2016 - Modify from fifo_mst_io.v of Kwok Wai  

  Description   : This module control the input, output delay of FPGA  
*/
module mst_fifo_io (
  //GPIO Control Signals
  input wire HRST_N,
  input wire SRST_N,
  input wire MLTCN, // 1: Multi Channel Mode, 0: 245 Mode 
  input wire STREN, // 1: Streaming Test,     0: Loopback Test
  input wire ERDIS, // 1: Disable received data sequence check 
  input wire [3:0] MST_RD_N,	//In 245 Mode, only MST_RD_N[0] is valid 
  input wire [3:0] MST_WR_N,   //In 245 Mode, only MST_WR_N[0] is valid 
  input wire R_OOB,
  input wire W_OOB, 
  // FIFO Slave interface 
  input wire CLK,
  inout wire [31:0] DATA,
  inout wire [3:0] BE,
  input wire RXF_N,   	// ACK_N
  input wire TXE_N,
  output wire WR_N,    // REQ_N
  output wire SIWU_N,
  output wire RD_N,
  output wire OE_N,
  // Miscellaneous Interface 
  output wire [3:0] debug_sig,
  output wire [3:0] seq_err, 
  // From chip internal 
  input wire [31:0] tp_data,
  input wire [3:0]  tp_be,
  input wire tp_dt_oe_n,
  input wire tp_be_oe_n,
  input wire tp_siwu_n,
  input wire tp_wr_n,     // tp_req_n
  input wire tp_rd_n,
  input wire tp_oe_n,
  // 
  input wire [3:0] tp_debug_sig,  
  input wire [3:0] tp_seq_err, 
  // To chip internal 
  output wire [31:0] tc_data,
  output wire [3:0]  tc_be,
  output wire tc_rst_n,
  output wire tc_clk,
  output wire tc_txe_n,
  output wire tc_rxf_n,
  //
  output wire tc_mltcn,
  output wire tc_stren,
  output wire tc_erdis,  
  output wire tc_r_oob,
  output wire tc_w_oob,  
  output wire [3:0] tc_mst_rd_n,
  output wire [3:0] tc_mst_wr_n
);
  // 
  `ifdef FTDI_SIM 
  localparam INP_DLY  = 2ns;
  localparam OUT_DLY  = 2.5ns;
  localparam CLK_DLY  = 4ns;
  `else 
  localparam INP_DLY  = 0;
  localparam OUT_DLY  = 0;
  localparam CLK_DLY  = 0;
  `endif 
  // Clock 
  assign #CLK_DLY tc_clk 	= CLK; 
  // data
  assign #INP_DLY tc_data[7:0]  = DATA[7:0];
  assign #INP_DLY tc_data[15:8] = DATA[15:8];
  assign #INP_DLY tc_data[31:16]= DATA[31:16];
  assign #INP_DLY tc_be  	= BE;
  // 
  assign #OUT_DLY DATA[7:0] 	= ~tp_be_oe_n ? tp_data[7:0] 	: 8'bzzzzzzzz;
  assign #OUT_DLY DATA[15:8] 	= ~tp_dt_oe_n ? tp_data[15:8] 	: 8'bzzzzzzzz;
  assign #OUT_DLY DATA[31:16] 	= ~tp_be_oe_n ? tp_data[31:16] 	: 16'hzzzz;
  assign #OUT_DLY BE 		= ~tp_be_oe_n ? tp_be 		: 4'bzzzz;
  // control  
  assign #INP_DLY tc_txe_n 	= TXE_N;
  assign #INP_DLY tc_rxf_n 	= RXF_N;
  // 
  assign #OUT_DLY SIWU_N  	= tp_siwu_n;
  assign #OUT_DLY WR_N 		= tp_wr_n;
  assign #OUT_DLY RD_N    	= tp_rd_n;
  assign #OUT_DLY OE_N    	= tp_oe_n;
  //GPIO Control  
  assign tc_rst_n 		= SRST_N & HRST_N; 
  assign tc_mltcn		= MLTCN;
  assign tc_stren		= STREN;
  assign tc_erdis		= ERDIS;  
  assign tc_r_oob		= R_OOB; 
  assign tc_w_oob		= W_OOB; 
  assign tc_mst_rd_n		= MST_RD_N;
  assign tc_mst_wr_n		= MST_WR_N;
  assign debug_sig		= tp_debug_sig;	
  assign seq_err		= tp_seq_err;
  //
endmodule 
