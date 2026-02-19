/*
  File Name     : mst_fifo_ctl.v 
  Department    : IC Design, FTDI SGP
  Author        : Do Ngoc Duong
  History       : 25 April 2016 - Initial Version 

  Description   : This module controls internal FIFOs read/write operation 
                  It is written for specific case of master FIFO loopback 
*/

module mst_fifo_ctl ( 
  input  clk,
  input  rst_n,
  input  mltcn, 
  //FIFO control 
  input  fiford,    
  input  [1:0] fifordid,  
  input  fifowr,
  input  [1:0] fifowrid,     
  //
  output reg [3:0] fifoafull, // high when fifo is almost full
  output wire [3:0] fifonempt, // high when fifo is not empty
  //
  input  [35:0] fifo_din,
  output wire [35:0] fifo_dout, 
 // Connect to memories
  output  wire mem_we,          // enable to write memories
  output  wire [13:0] mem_a,    // address of memories
  output  wire [35:0] mem_d,	// Data in 
  input   wire [35:0] mem_q	// Data out 
  );
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
wire mem_re;
reg [13:0] wrcnt0;
reg [11:0] wrcnt1;
reg [11:0] wrcnt2;
reg [11:0] wrcnt3;
reg [11:0] wrcnt;
// 
reg [13:0] rdcnt0;
reg [11:0] rdcnt1;
reg [11:0] rdcnt2;
reg [11:0] rdcnt3;
reg [11:0] rdcnt;
//
wire [13:0] mem_wa;
assign      mem_wa = mltcn ? {fifowrid,wrcnt} : wrcnt0;
wire [13:0] mem_ra;
assign      mem_ra = mltcn ? {fifordid,rdcnt} : rdcnt0;
//
always @ (*)  
  begin 
  case (fifowrid)
    2'b00: wrcnt = wrcnt0[11:0];
    2'b01: wrcnt = wrcnt1;
    2'b10: wrcnt = wrcnt2;
    2'b11: wrcnt = wrcnt3;
  endcase
  end  
//
always @ (*)  
  begin 
  case (fifordid)
    2'b00: rdcnt = rdcnt0[11:0];
    2'b01: rdcnt = rdcnt1;
    2'b10: rdcnt = rdcnt2;
    2'b11: rdcnt = rdcnt3;
  endcase
  end 
//  
assign mem_a = mem_we ? mem_wa : mem_ra;
assign mem_d = fifo_din;
assign fifo_dout = mem_q; 
//Write address counter
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    wrcnt0 <= {14{1'b0}};   
  else if (mem_we & (fifowrid == 2'b00)) 
    wrcnt0 <= wrcnt0 + 1'b1;
  end
// 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    wrcnt1 <= {12{1'b0}};   
  else if (mem_we & (fifowrid == 2'b01)) 
    wrcnt1 <= wrcnt1 + 1'b1;
  end
// 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    wrcnt2 <= {12{1'b0}};   
  else if (mem_we & (fifowrid == 2'b10)) 
    wrcnt2 <= wrcnt2 + 1'b1;
  end
// 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    wrcnt3 <= {12{1'b0}};   
  else if (mem_we & (fifowrid == 2'b11)) 
    wrcnt3 <= wrcnt3 + 1'b1;
  end
//Read address counter 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    rdcnt0 <= {14{1'b0}};   
  else if (mem_re & (fifordid == 2'b00)) 
    rdcnt0 <= rdcnt0 + 1'b1;
  end
// 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    rdcnt1 <= {12{1'b0}};   
  else if (mem_re & (fifordid == 2'b01)) 
    rdcnt1 <= rdcnt1 + 1'b1;
  end
// 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    rdcnt2 <= {12{1'b0}};   
  else if (mem_re & (fifordid == 2'b10)) 
    rdcnt2 <= rdcnt2 + 1'b1;
  end
// 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n)
    rdcnt3 <= {12{1'b0}};   
  else if (mem_re & (fifordid == 2'b11)) 
    rdcnt3 <= rdcnt3 + 1'b1;
  end
//FIFO full
wire [3:0] fifofull;
wire full;
assign full  =   fifofull[fifowrid];
// 
wire notempty;
assign notempty    =   fifonempt[fifordid];
//
assign mem_we      =   fifowr & (!full);
assign mem_re      =   fiford & (notempty);
//
reg [14:0] fifolen0;
reg [12:0] fifolen1;
reg [12:0] fifolen2;
reg [12:0] fifolen3;
//
//FIFO not empty
assign fifonempt[0] = |fifolen0;
assign fifonempt[1] = |fifolen1;
assign fifonempt[2] = |fifolen2;
assign fifonempt[3] = |fifolen3; 
// 
assign fifofull[0] = mltcn ? fifolen0[12] : fifolen0[14];
assign fifofull[1] = mltcn ? fifolen1[12] : 1'b0;
assign fifofull[2] = mltcn ? fifolen2[12] : 1'b0; 
assign fifofull[3] = mltcn ? fifolen3[12] : 1'b0; 
// FIFO length 
always @ (posedge clk or negedge rst_n)
  begin 
    if (!rst_n) 
      fifolen0 <= 15'h0000;
    else if (mem_we & (fifowrid == 2'b00))
      fifolen0 <= fifolen0 + 1'b1;
    else if (mem_re & (fifordid == 2'b00))
      fifolen0 <= fifolen0 - 1'b1;
  end 
//
always @ (posedge clk or negedge rst_n)
  begin 
    if (!rst_n) 
      fifolen1 <= 13'h0000;
    else if (mem_we & (fifowrid == 2'b01))
      fifolen1 <= fifolen1 + 1'b1;
    else if (mem_re & (fifordid == 2'b01))
      fifolen1 <= fifolen1 - 1'b1;
  end 
//
always @ (posedge clk or negedge rst_n)
  begin 
    if (!rst_n) 
      fifolen2 <= 13'h0000;
    else if (mem_we & (fifowrid == 2'b10))
      fifolen2 <= fifolen2 + 1'b1;
    else if (mem_re & (fifordid == 2'b10))
      fifolen2 <= fifolen2 - 1'b1;
  end 
//
always @ (posedge clk or negedge rst_n)
  begin 
    if (!rst_n) 
      fifolen3 <= 13'h0000;
    else if (mem_we & (fifowrid == 2'b11))
      fifolen3 <= fifolen3 + 1'b1;
    else if (mem_re & (fifordid == 2'b11))
      fifolen3 <= fifolen3 - 1'b1;
  end 
//FIFO Almost Full 
always @ (posedge clk or negedge rst_n)
  begin 
    if (!rst_n)
      fifoafull <= 4'h0;
    else if (mltcn) 
      begin
      fifoafull[0] <= (fifolen0 >= 15'h0FFB);
      fifoafull[1] <= (fifolen1 >= 13'h0FFB);
      fifoafull[2] <= (fifolen2 >= 13'h0FFB);
      fifoafull[3] <= (fifolen3 >= 13'h0FFB);
      end
    else  
      begin
      fifoafull[0] <= (fifolen0 >= 15'h3FFB);
      fifoafull[1] <= 1'b0;
      fifoafull[2] <= 1'b0; 
      fifoafull[3] <= 1'b0;
      end
  end 
//
endmodule
