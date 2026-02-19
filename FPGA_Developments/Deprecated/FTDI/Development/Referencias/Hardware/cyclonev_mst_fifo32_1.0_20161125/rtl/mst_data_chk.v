/*
  File Name     : mst_data_chk.v 
  Department    : IC Design, FTDI SGP
  Author        : Do Ngoc Duong
  History       : 25 April 2016 - Initial Version 

  Description   : This module check the received streaming data 
*/
module mst_data_chk (
  input  rst_n, 
  input  clk,
  input  bus16,
  input  erdis, 
  input  ch0_vld,
  input  ch1_vld,
  input  ch2_vld,
  input  ch3_vld,
  input  [31:0] rdata,
  output wire [3:0] seq_err 
);
  // 
  reg [31:0] cmp0_dat;
  reg [31:0] cmp1_dat;
  reg [31:0] cmp2_dat;
  reg [31:0] cmp3_dat;
  reg cmp0_err;
  reg cmp1_err;
  reg cmp2_err;
  reg cmp3_err;
  //
  assign seq_err = {cmp3_err,cmp2_err,cmp1_err,cmp0_err} & {4{!erdis}};
  //245 Mode or Channel 0 of 600 Mode 
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      begin 
        cmp0_dat <= 32'h0000_0000;
        cmp0_err <= 1'b0;
      end 
    else if (ch0_vld & (!cmp0_err) & (!erdis))
      if (bus16) 
        if (rdata[15:0] == cmp0_dat[15:0])
          begin  
            cmp0_dat <= (&cmp0_dat[15:0]) ? 32'h0000_0000 : {16'h0000,cmp0_dat[15:0] + 1'b1};
            cmp0_err <= 1'b0;
          end 
        else
          begin 
            cmp0_dat <= cmp0_dat;
            cmp0_err <= 1'b1;
          end 
      else  
        if (rdata == cmp0_dat)
          begin  
            cmp0_dat <= (&cmp0_dat) ? 32'h0000_0000 : cmp0_dat + 1'b1;
            cmp0_err <= 1'b0;
          end 
        else
          begin 
            cmp0_dat <= cmp0_dat;
            cmp0_err <= 1'b1;
          end
  end 
  // Channel 1 of 600 Mode  
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      begin 
        cmp1_dat <= 32'h0000_0000;
        cmp1_err <= 1'b0;
      end 
    else if (ch1_vld & (!cmp1_err) & (!erdis)) 
      if (bus16) 
        if (rdata[15:0] == cmp1_dat[15:0])
          begin  
            cmp1_dat <= (&cmp1_dat[15:0]) ? 32'h0000_0000 : {16'h0000,cmp1_dat[15:0] + 1'b1};
            cmp1_err <= 1'b0;
          end 
        else
          begin 
            cmp1_dat <= cmp1_dat;
            cmp1_err <= 1'b1;
          end 
      else  
        if (rdata == cmp1_dat)
          begin  
            cmp1_dat <= (&cmp1_dat) ? 32'h0000_0000 : cmp1_dat + 1'b1;
            cmp1_err <= 1'b0;
          end 
        else
          begin 
            cmp1_dat <= cmp1_dat;
            cmp1_err <= 1'b1;
          end
  end 
  // Channel 2 of 600 Mode  
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      begin 
        cmp2_dat <= 32'h0000_0000;
        cmp2_err <= 1'b0;
      end 
    else if (ch2_vld & (!cmp2_err) & (!erdis)) 
      if (bus16) 
        if (rdata[15:0] == cmp2_dat[15:0])
          begin  
            cmp2_dat <= (&cmp2_dat[15:0]) ? 32'h0000_0000 : {16'h0000,cmp2_dat[15:0] + 1'b1};
            cmp2_err <= 1'b0;
          end 
        else
          begin 
            cmp2_dat <= cmp2_dat;
            cmp2_err <= 1'b1;
          end 
      else  
        if (rdata == cmp2_dat)
          begin  
            cmp2_dat <= (&cmp2_dat) ? 32'h0000_0000 : cmp2_dat + 1'b1;
            cmp2_err <= 1'b0;
          end 
        else
          begin 
            cmp2_dat <= cmp2_dat;
            cmp2_err <= 1'b1;
          end
  end 
  // Channel 3 of 600 Mode  
  always @ (posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      begin 
        cmp3_dat <= 32'h0000_0000;
        cmp3_err <= 1'b0;
      end 
    else if (ch3_vld & (!cmp3_err) & (!erdis)) 
      if (bus16) 
        if (rdata[15:0] == cmp3_dat[15:0])
          begin  
            cmp3_dat <= (&cmp3_dat[15:0]) ? 32'h0000_0000 : {16'h0000,cmp3_dat[15:0] + 1'b1};
            cmp3_err <= 1'b0;
          end 
        else
          begin 
            cmp3_dat <= cmp3_dat;
            cmp3_err <= 1'b1;
          end 
      else  
        if (rdata == cmp3_dat)
          begin  
            cmp3_dat <= (&cmp3_dat) ? 32'h0000_0000 : cmp3_dat + 1'b1;
            cmp3_err <= 1'b0;
          end 
        else
          begin 
            cmp3_dat <= cmp3_dat;
            cmp3_err <= 1'b1;
          end
  end 
// 
endmodule 
