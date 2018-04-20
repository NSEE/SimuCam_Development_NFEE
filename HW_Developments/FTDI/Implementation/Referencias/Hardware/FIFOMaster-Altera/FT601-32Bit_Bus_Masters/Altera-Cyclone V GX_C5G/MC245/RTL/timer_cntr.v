//------------------------------------------------------------------------------
// Title        : timer_cntr.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 10th Sept, 2013
//------------------------------------------------------------------------------
// Description  : 
//               programmable timer counter with preload 
//  
//             
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

module timer_cntr #(
  parameter NUM_BIT = 13, 
  parameter [NUM_BIT-1:0] INI_ST  = 0
  ) (

// inputs
  input               rstn,
  input               clk,
  input               enable,
  input               load,
  input [NUM_BIT-1:0] count, 

// outputs
  output wire         reach_zero 
        
       );


  reg [NUM_BIT-1:0]  cntr;

  assign reach_zero = ~|cntr;

  always @(posedge clk or negedge rstn)
    if (~rstn)
      cntr <= INI_ST;
    else if (load) 
      cntr <= count;
    else if (~reach_zero & enable)
      cntr <= cntr - 1'b1;


endmodule
