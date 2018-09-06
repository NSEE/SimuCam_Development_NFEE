//------------------------------------------------------------------------------
// Title        : fifo_mst_io.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 1st Dec,2013
//------------------------------------------------------------------------------
// Description  : 
//                FPGA IO pads 
//
//             
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

`ifndef FTDI_SIM
  `include "../../IP_GEN/C5_CLKCTRL/AL_MC600_CLKCTRL/synthesis/CLKCTRL.v"
`endif

module fifo_mst_io (

  // system control
  input             RESET_N,

  // FIFO interface 
  input             CLK,
  inout [31:0]      DATA,
  inout [3:0]       BE,
  input             TXE_N,
  input             RXF_N,      // ACK_N
  output            SIWU_N,
  output            WR_N,       // REQ_N
  output            RD_N,
  output            OE_N,

  // from chip internal
  input [31:0]     tp_data,
  input            tp_dt_oe_n,
  input [3:0]      tp_be,
  input            tp_be_oe_n,
  input            tp_siwu_n,
  input            tp_wr_n,     // tp_req_n
  input            tp_rd_n,
  input            tp_oe_n,

  // to chip internal
  // outputs
  output wire         tc_chipRstn,
  output wire         tc_clk,
  output wire  [31:0] tc_data,
  output wire  [3:0]  tc_be,
  output wire         tc_txe_n,
  output wire         tc_rxf_n
  );


  // sysem reset
  assign tc_chipRstn = RESET_N;


`ifndef FTDI_SIM 

//  assign tc_clk = CLK;

  CLKCTRL i_CLKCTRL (.inclk (CLK), .outclk (tc_clk));

  assign tc_data[7:0]  = DATA[7:0];
  assign DATA[7:0] = ~tp_be_oe_n ? tp_data[7:0] : 8'bzzzzzzzz;
 
  assign tc_data[15:8] = DATA[15:8];
  assign DATA[15:8] = ~tp_dt_oe_n ? tp_data[15:8] : 8'bzzzzzzzz;

  assign tc_data[31:16] = DATA[31:16];
  assign DATA[31:16] = ~tp_be_oe_n ? tp_data[31:16] : 16'hzzzz;

  // FIFO BE 
  assign tc_be  = BE;
  assign BE = ~tp_be_oe_n ? tp_be : 4'bzzzz;

  // FIFO TXE
  assign tc_txe_n = TXE_N;

  // FIFO RXF
  assign tc_rxf_n = RXF_N;

  // FIFO SIWU
  assign SIWU_N  = tp_siwu_n;

  // FIFO WR 
  assign WR_N = tp_wr_n;

  // FIFO RD
  assign RD_N = tp_rd_n;

  // FIFO OE 
  assign OE_N = tp_oe_n;

`else

  localparam IN_DLY  = 2ns;
  localparam OUT_DLY = 2.5ns;
  localparam CTS     = 2ns; 

  assign #(IN_DLY + CTS) tc_clk = CLK;


///////////////////////////////////////////////////////////////////////////////
// build IOs 

  // FIFO data
  assign #IN_DLY tc_data[7:0]  = DATA[7:0];
  assign #OUT_DLY DATA[7:0] = ~tp_be_oe_n ? tp_data[7:0] : 8'bzzzzzzzz;
 
  assign #IN_DLY tc_data[15:8] = DATA[15:8];
  assign #OUT_DLY DATA[15:8] = ~tp_dt_oe_n ? tp_data[15:8] : 8'bzzzzzzzz;

  assign #IN_DLY tc_data[31:16] = DATA[31:16];
  assign #OUT_DLY DATA[31:16] = ~tp_be_oe_n ? tp_data[31:16] : 16'hzzzz;

  // FIFO BE 
  assign #IN_DLY tc_be  = BE;
  assign #OUT_DLY BE = ~tp_be_oe_n ? tp_be : 4'bzzzz;

  // FIFO TXE
  assign #IN_DLY tc_txe_n = TXE_N;

  // FIFO RXF
  assign #IN_DLY tc_rxf_n = RXF_N;

  // FIFO SIWU
  assign #OUT_DLY SIWU_N  = tp_siwu_n;

  // FIFO WR 
  assign #OUT_DLY WR_N = tp_wr_n;

  // FIFO RD 
  assign #OUT_DLY RD_N    = tp_rd_n;

  // FIFO OE 
  assign #OUT_DLY OE_N    = tp_oe_n;

`endif


endmodule
