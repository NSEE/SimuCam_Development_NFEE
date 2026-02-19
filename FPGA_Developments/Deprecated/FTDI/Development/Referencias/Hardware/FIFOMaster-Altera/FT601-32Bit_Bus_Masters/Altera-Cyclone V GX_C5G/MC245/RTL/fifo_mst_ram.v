//------------------------------------------------------------------------------
// Title        : fifo_mst_ram.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 8th Mar, 2014
//------------------------------------------------------------------------------
// Description  : 
//               FIFO FT600 Master RAM module 
//  
//             
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

module fifo_mst_ram #(
  parameter T_MSZ =12
  ) (
  // inputs
  input               rstn,
  input               clk,
  input [3:0]         wr_en,
  input               mem_en,
  input [T_MSZ-1:0]   mem_addr,
  input [31:0]        mem_din,

  // outputs
  output wire         mem_rdy,
  output wire [31:0]  mem_do

);

  assign mem_rdy = 1'b1;


  MEM_SP_xKx32 #(
    .T_MSZ(T_MSZ)
  ) i_MEM_SP_xKx32 (
  // inputs
    .rstn(rstn),
    .CLK(clk),
    .CE(mem_en),
    .WE(wr_en),
    .A(mem_addr),
    .D(mem_din),
  // outputs
    .Q(mem_do)
  );

endmodule
