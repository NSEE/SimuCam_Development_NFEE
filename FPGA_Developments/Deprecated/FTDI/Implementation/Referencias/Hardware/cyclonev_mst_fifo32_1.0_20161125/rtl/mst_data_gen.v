/*
  File Name     : mst_data_gen.v 
  Department    : IC Design, FTDI SGP
  Author        : Do Ngoc Duong
  History       : 25 April 2016 - Initial Version 

  Description   : This module generates the streaming data 
*/

module mst_data_gen (
  input rst_n, 
  input clk,
  input bus16,
  input ch0_req,
  input ch1_req,
  input ch2_req,
  input ch3_req,
  output reg [31:0] ch0_dat,
  output reg [31:0] ch1_dat,
  output reg [31:0] ch2_dat,
  output reg [31:0] ch3_dat 
);
  //245 Mode or Channel 0 of 600 Mode 
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
        ch0_dat <= 32'hFFFF_FFFF;
    else if (ch0_req)  
      if (bus16) 
            ch0_dat <= (&ch0_dat[15:0]) ? 32'h0000_0000 : {16'h0000,ch0_dat[15:0] + 1'b1};
      else  
            ch0_dat <= (&ch0_dat) ? 32'h0000_0000 : ch0_dat + 1'b1;
  end 
  //Channel 1 of 600 Mode 
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
        ch1_dat <= 32'hFFFF_FFFF;
    else if (ch1_req)  
      if (bus16) 
            ch1_dat <= (&ch1_dat[15:0]) ? 32'h0000_0000 : {16'h0000,ch1_dat[15:0] + 1'b1};
      else  
            ch1_dat <= (&ch1_dat) ? 32'h0000_0000 : ch1_dat + 1'b1;
  end 
  //Channel 2 of 600 Mode 
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
        ch2_dat <= 32'hFFFF_FFFF;
    else if (ch2_req)  
      if (bus16) 
            ch2_dat <= (&ch2_dat[15:0]) ? 32'h0000_0000 : {16'h0000,ch2_dat[15:0] + 1'b1};
      else  
            ch2_dat <= (&ch2_dat) ? 32'h0000_0000 : ch2_dat + 1'b1;
  end 
  //Channel 3 of 600 Mode 
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
        ch3_dat <= 32'hFFFF_FFFF;
    else if (ch3_req)  
      if (bus16) 
            ch3_dat <= (&ch3_dat[15:0]) ? 32'h0000_0000 : {16'h0000,ch3_dat[15:0] + 1'b1};
      else  
            ch3_dat <= (&ch3_dat) ? 32'h0000_0000 : ch3_dat + 1'b1;
  end
  //  
endmodule 
