/*
  File Name     : mst_fifo_top.v 
  Department    : IC Design, FTDI SGP
  Author        : Do Ngoc Duong
  History       : 25 April 2016 - Initial Version 

  Description   : This is the top module of Master FIFO bus  
*/

module mst_fifo_top (
  //GPIO Control Signals
  input wire HRST_N,
  input wire SRST_N,
  input wire MLTCN, // 1: Multi Channel Mode, 0: 245 Mode 
  input wire STREN, // 1: Streaming Test,     0: Loopback Test
  input wire ERDIS, // 1: Disable received data sequence check  
  input wire R_OOB,
  input wire W_OOB,  
  input wire WAKEUP_N, 
  // FIFO Slave interface 
  input wire CLK,
  inout wire [31:0] DATA,
  inout wire [3:0] BE,
  input wire RXF_N,    // ACK_N
  input wire TXE_N,
  output wire WR_N,    // REQ_N
  output wire SIWU_N,
  output wire RD_N,
  output wire OE_N,
  // Miscellaneous Interface 
  output wire [3:0] debug_sig,
  output wire [3:0] STRER
);

  assign debug_sig[0]   = WAKEUP_N; 
  assign debug_sig[3:1] = 3'b101;
  
  wire [31:0] tp_data;
  wire [3:0]  tp_be;
  wire tp_dt_oe_n;
  wire tp_be_oe_n;
  wire tp_siwu_n;
  wire tp_wr_n;     // tp_req_n
  wire tp_rd_n;
  wire tp_oe_n;
  // 
  wire [3:0] tp_debug_sig;
  wire [3:0] tp_seq_err;
  // To chip internal 
  wire [31:0] tc_data;
  wire [3:0]  tc_be;
  wire tc_rst_n;
  wire tc_clk;
  wire tc_txe_n;
  wire tc_rxf_n;
  //
  wire tc_mltcn;
  wire tc_stren;
  wire tc_bus16;
  wire tc_erdis;
  wire tc_r_oob;
  wire tc_w_oob;
  wire [3:0] tc_mst_rd_n;
  wire [3:0] tc_mst_wr_n; 
  // 
  mst_fifo_io i0_io (
    //GPIO Control Signals
  `ifdef ALTERA_FPGA 	 	 
    .HRST_N	(HRST_N),
    .SRST_N	(SRST_N),
  `else 
    .HRST_N	(HRST_N),
    .SRST_N	(!SRST_N),
  `endif 
    .MLTCN	(MLTCN), 
    .STREN	(STREN), 
    .ERDIS	(ERDIS), 
    .MST_RD_N	(4'h0),   
    .MST_WR_N	(4'h0), 
    .R_OOB	(R_OOB), 
    .W_OOB	(W_OOB), 
    // FIFO Slave interface 
    .CLK		(CLK),
    .DATA	(DATA),
    .BE		(BE),
    .RXF_N	(RXF_N),   
    .TXE_N	(TXE_N),
    .WR_N	(WR_N),
    .SIWU_N	(SIWU_N),
    .RD_N	(RD_N),
    .OE_N	(OE_N),
    // Miscellaneous Interface 
    .debug_sig	(), //(debug_sig),
    .seq_err	(STRER),
    // From chip internal 
    .tp_data	(tp_data),
    .tp_be	(tp_be),
    .tp_dt_oe_n	(tp_dt_oe_n),
    .tp_be_oe_n	(tp_be_oe_n),
    .tp_siwu_n	(tp_siwu_n),
    .tp_wr_n	(tp_wr_n),   
    .tp_rd_n	(tp_rd_n),
    .tp_oe_n	(tp_oe_n),
    // 
    .tp_debug_sig(tp_debug_sig),
    .tp_seq_err	(tp_seq_err),
    // To chip internal 
    .tc_data	(tc_data),
    .tc_be	(tc_be),
    .tc_rst_n	(tc_rst_n),
    .tc_clk	(tc_clk),
    .tc_txe_n	(tc_txe_n),
    .tc_rxf_n	(tc_rxf_n),
    //
    .tc_mltcn	(tc_mltcn),
    .tc_stren	(tc_stren),
    .tc_erdis	(tc_erdis),
    .tc_r_oob	(tc_r_oob),
    .tc_w_oob	(tc_w_oob),
    .tc_mst_rd_n(tc_mst_rd_n),
    .tc_mst_wr_n(tc_mst_wr_n) 
  );

  wire ch0_vld;
  wire ch1_vld;
  wire ch2_vld;
  wire ch3_vld;
  wire [31:0] chk_data;
  // 
  wire ch0_req;
  wire ch1_req;
  wire ch2_req;
  wire ch3_req;
  wire [31:0] ch0_dat;
  wire [31:0] ch1_dat;
  wire [31:0] ch2_dat;
  wire [31:0] ch3_dat;
  // 
  wire ififord;
  wire ififowr;
  wire [1:0] ififowrid;
  wire [3:0] ififoafull;
  wire [3:0] ififonempt;
  wire [35:0] ififo_wdat;
  wire [35:0] ififo_rdat;
  //
  wire prefena;
  wire prefreq;
  wire prefmod;
  wire[ 1:0]  prefchn;
  wire[ 3:0]  prefnempt;
  wire[35:0]  prefdout; 
 //
  mst_fifo_fsm i1_fsm (
    // IO interface 
    .rst_n	(tc_rst_n),
    .clk		(tc_clk),
    .txe_n	(tc_txe_n),
    .rxf_n	(tc_rxf_n),
    .idata	(tc_data),
    .ibe		(tc_be),
    //
    .mltcn	(tc_mltcn),
    .stren	(tc_stren),
    .r_oob	(tc_r_oob),
    .w_oob	(tc_w_oob),
    .mst_rd_n	(tc_mst_rd_n),
    .mst_wr_n	(tc_mst_wr_n), 
    // 
    .odata	(tp_data),
    .obe		(tp_be),
    .dt_oe_n(tp_dt_oe_n),
    .be_oe_n(tp_be_oe_n),
    .siwu_n	(tp_siwu_n),
    .wr_n	(tp_wr_n),
    .rd_n	(tp_rd_n),
    .oe_n	(tp_oe_n),
    // 
    .tp_debug_sig(tp_debug_sig),
    // Check Data interface 
    .ch0_vld	(ch0_vld),
    .ch1_vld	(ch1_vld),
    .ch2_vld	(ch2_vld),
    .ch3_vld	(ch3_vld),
    .chk_data	(chk_data),
    .chk_err	(tp_seq_err),
    // internal FIFO control interface 
    .ififoafull	(ififoafull),
    .ififonempt	(ififonempt),
    .ififowr	(ififowr),
    .ififowrid	(ififowrid),
    .ififo_wdat	(ififo_wdat),
    //
    .prefena   (prefena),
    .prefreq   (prefreq),
    .prefmod   (prefmod),
    .prefchn   (prefchn),
    .prefnempt (prefnempt),
    .prefdout  (prefdout)
  );
  //
   mst_pre_fet i2_pref (
    .clk      (tc_clk),
    .rst_n    (tc_rst_n),
     //Flow control interface
    .prefena  (prefena),    
    .prefreq  (prefreq),    
    .prefmod  (prefmod),
    .prefchn  (prefchn),       
    .prefnempt(prefnempt),     
    .prefdout (prefdout),     
     //Internal FIFO interface  
    .ififord  (ififord),
    .ifnempt  (ififonempt),    
    .ififodat (ififo_rdat),  
     //Streaming generate interface 
    .gen0req  (ch0_req),  
    .gen1req  (ch1_req), 
    .gen2req  (ch2_req),
    .gen3req  (ch3_req),
    .gen0dat  (ch0_dat),
    .gen1dat  (ch1_dat),
    .gen2dat  (ch2_dat),
    .gen3dat  (ch3_dat) 
     );
  // 
  wire chk_rst_n;
  assign chk_rst_n = (!tc_w_oob) & tc_rst_n;
  assign tc_bus16  = 1'b0;
  // 
  mst_data_chk i3_chk(
    .rst_n	(chk_rst_n),
    .clk	(tc_clk),
    .bus16	(tc_bus16),
    .erdis 	(tc_erdis), 
    .ch0_vld	(ch0_vld),
    .ch1_vld	(ch1_vld),
    .ch2_vld	(ch2_vld),
    .ch3_vld	(ch3_vld),
    .rdata	(chk_data),
    .seq_err	(tp_seq_err) 
  );
  //
  wire gen_rst_n;
  assign gen_rst_n = (!tc_r_oob) & tc_rst_n;
  // 
  mst_data_gen i4_gen(
    .rst_n	(gen_rst_n),
    .clk	(tc_clk),
    .bus16	(tc_bus16),
    .ch0_req	(ch0_req),
    .ch1_req	(ch1_req),
    .ch2_req	(ch2_req),
    .ch3_req	(ch3_req),
    .ch0_dat	(ch0_dat),
    .ch1_dat	(ch1_dat),
    .ch2_dat	(ch2_dat),
    .ch3_dat	(ch3_dat)
  ); 
  // 
  wire mem_w;       
  wire [13:0] mem_a;
  wire [35:0] mem_d;   
  wire [35:0] mem_q; 
  //  
  mst_fifo_ctl i5_ctl(
    .clk	(tc_clk),
    .rst_n	(tc_rst_n),
    .mltcn	(tc_mltcn),
    //FIFO control 
    .fiford	(ififord),
    .fifordid	(prefchn),
    .fifowr	(ififowr),
    .fifowrid	(ififowrid),
    .fifoafull	(ififoafull),
    .fifonempt	(ififonempt),
    .fifo_din	(ififo_wdat),
    .fifo_dout	(ififo_rdat), 
    // Connect to memories
    .mem_we	(mem_w),
    .mem_a	(mem_a),
    .mem_d	(mem_d),
    .mem_q	(mem_q) 
    );
    //
  `ifdef ALTERA_FPGA 	
  sp_sram_16k36 i6_ram (
    .address	(mem_a),
    .clock	(tc_clk),
    .data	(mem_d),
    .wren	(mem_w),
    .q		(mem_q) 
  );
 `else 
  sp_sram_16k36 i6_ram (
    .clka	(tc_clk),
    .wea	(mem_w),
    .addra	(mem_a),
    .dina	(mem_d),
    .douta	(mem_q) 
  );
 `endif
//
endmodule 
