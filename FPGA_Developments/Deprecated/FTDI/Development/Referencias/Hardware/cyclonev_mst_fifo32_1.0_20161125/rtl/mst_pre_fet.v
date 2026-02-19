/*
  File Name     : mst_pre_fet.v  
  Department    : IC Design, FTDI SGP
  Author        : Do Ngoc Duong
  History       : 30 June 2016 - Initial Version 

  Description   : This module contains pre-fetch data 
*/

module mst_pre_fet 
    (
     clk,
     rst_n,
     //Flow control interface
     prefena,       // pre-fetch enable 
     prefreq,       // pre-fetch data request signal
     prefmod,	    // pre-fetch mode: 1 streamming 0 loop-back 
     prefchn,	    // pre-fetch channel 
     prefnempt,     // pre-fetch data not empty 
     prefdout,      // pre-fetch data out
     //Internal FIFO interface  
     ififord,       // internal FIFO read request 
     ifnempt,       // internam FIFO not empty 
     ififodat,      // internal FIFO data 
     //Streaming generate interface 
     gen0req,        // Generate request channel 0
     gen1req,        // Generate request channel 1
     gen2req,        // Generate request channel 2  
     gen3req,        // Generate request channel 3
     gen0dat,        // Generate data channel 0
     gen1dat,        // Generate data channel 1  
     gen2dat,        // Generate data channel 2
     gen3dat         // Generate data channel 3 
     );
//**********************************************
parameter ADDRBIT = 2;
parameter LENGTH  = 4;
parameter WIDTH   = 36;
//**********************************************
input clk;
input rst_n;
//
input prefena;      
input prefreq;      
input prefmod;	    
input [1:0]  prefchn;
output[3:0]  prefnempt;      
output[WIDTH -1:0]  prefdout;      
//Internal FIFO interface  
output ififord;
input [3:0] ifnempt;
input [WIDTH -1:0] ififodat; 
//Streaming generate interface 
output gen0req;
output gen1req;
output gen2req;
output gen3req;
input[WIDTH-5:0]  gen0dat; 
input[WIDTH-5:0]  gen1dat; 
input[WIDTH-5:0]  gen2dat; 
input[WIDTH-5:0]  gen3dat; 
//*********************************************
reg     [WIDTH-1:0]     pref_dat0 [LENGTH-1:0];
reg     [WIDTH-1:0]     pref_dat1 [LENGTH-1:0];
reg     [WIDTH-1:0]     pref_dat2 [LENGTH-1:0];
reg     [WIDTH-1:0]     pref_dat3 [LENGTH-1:0];
reg     [ADDRBIT:0]     pref_len0;
reg     [ADDRBIT:0]     pref_len1;
reg     [ADDRBIT:0]     pref_len2;
reg     [ADDRBIT:0]     pref_len3;
reg     [ADDRBIT-1:0]   wrcnt0;
reg     [ADDRBIT-1:0]   wrcnt1;
reg     [ADDRBIT-1:0]   wrcnt2;
reg     [ADDRBIT-1:0]   wrcnt3;
//
wire    [3:0] prefnempt; 
assign  prefnempt[0]    =   (pref_len0!={1'b0,{ADDRBIT{1'b0}}});
assign  prefnempt[1]    =   (pref_len1!={1'b0,{ADDRBIT{1'b0}}});
assign  prefnempt[2]    =   (pref_len2!={1'b0,{ADDRBIT{1'b0}}});
assign  prefnempt[3]    =   (pref_len3!={1'b0,{ADDRBIT{1'b0}}});
// 
wire    [3:0] preffull;
assign  preffull[0]    =   (pref_len0[ADDRBIT]);
assign  preffull[1]    =   (pref_len1[ADDRBIT]);
assign  preffull[2]    =   (pref_len2[ADDRBIT]);
assign  preffull[3]    =   (pref_len3[ADDRBIT]);
//
wire    prefwr; 
wire    write;
assign  write       =   (prefwr & !preffull[prefchn]);
// 
wire    read;
assign  read        =   (prefreq & prefnempt[prefchn]);
// 
wire    [ADDRBIT-1:0]   rdcnt0;
wire    [ADDRBIT-1:0]   rdcnt1;
wire    [ADDRBIT-1:0]   rdcnt2;
wire    [ADDRBIT-1:0]   rdcnt3;
assign  rdcnt0       =   wrcnt0 - pref_len0[ADDRBIT-1:0];
assign  rdcnt1       =   wrcnt1 - pref_len1[ADDRBIT-1:0];
assign  rdcnt2       =   wrcnt2 - pref_len2[ADDRBIT-1:0];
assign  rdcnt3       =   wrcnt3 - pref_len3[ADDRBIT-1:0];
// 
integer     i;
reg [WIDTH-1:0] prefdat0 [LENGTH-1:0];
reg [WIDTH-1:0] prefdat1 [LENGTH-1:0];
reg [WIDTH-1:0] prefdat2 [LENGTH-1:0];
reg [WIDTH-1:0] prefdat3 [LENGTH-1:0];
reg [WIDTH-1:0] prefdin; 
//
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) 
    for(i=0; i<LENGTH; i=i+1)
    begin 
      prefdat0[i]      <= {WIDTH{1'b0}};
      prefdat1[i]      <= {WIDTH{1'b0}};
      prefdat2[i]      <= {WIDTH{1'b0}};
      prefdat3[i]      <= {WIDTH{1'b0}};
    end 
  else if(write)
    case (prefchn) 
      2'b00 :  prefdat0[wrcnt0] <= prefdin;
      2'b01 :  prefdat1[wrcnt1] <= prefdin;
      2'b10 :  prefdat2[wrcnt2] <= prefdin;
      2'b11 :  prefdat3[wrcnt3] <= prefdin;
    endcase 
end
// 
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) 
  begin
    wrcnt0 <= {ADDRBIT{1'b0}};
    wrcnt1 <= {ADDRBIT{1'b0}};
    wrcnt2 <= {ADDRBIT{1'b0}};
    wrcnt3 <= {ADDRBIT{1'b0}};
  end 
  else if(write)
    case (prefchn)
      2'b00:  wrcnt0 <= wrcnt0 + 1'b1;
      2'b01:  wrcnt1 <= wrcnt1 + 1'b1;
      2'b10:  wrcnt2 <= wrcnt2 + 1'b1;
      2'b11:  wrcnt3 <= wrcnt3 + 1'b1;
    endcase
end  
// 
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) pref_len0  <= {1'b0,{ADDRBIT{1'b0}}};
  else if (prefchn == 2'b00)
    case({read,write})
      2'b01:   pref_len0 <= pref_len0 + 1'b1;
      2'b10:   pref_len0 <= pref_len0 - 1'b1;
      default: pref_len0 <= pref_len0;
    endcase
end
// 
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) pref_len1  <= {1'b0,{ADDRBIT{1'b0}}};
  else if (prefchn == 2'b01)
    case({read,write})
      2'b01:   pref_len1 <= pref_len1 + 1'b1;
      2'b10:   pref_len1 <= pref_len1 - 1'b1;
      default: pref_len1 <= pref_len1;
    endcase
end
// 
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) pref_len2  <= {1'b0,{ADDRBIT{1'b0}}};
  else if (prefchn == 2'b10)
    case({read,write})
      2'b01:   pref_len2 <= pref_len2 + 1'b1;
      2'b10:   pref_len2 <= pref_len2 - 1'b1;
      default: pref_len2 <= pref_len2;
    endcase
end
// 
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) pref_len3  <= {1'b0,{ADDRBIT{1'b0}}};
  else if (prefchn == 2'b11)
    case({read,write})
      2'b01:   pref_len3 <= pref_len3 + 1'b1;
      2'b10:   pref_len3 <= pref_len3 - 1'b1;
      default: pref_len3 <= pref_len3;
    endcase
end
wire [WIDTH-1:0] pref_dout[3:0];
assign pref_dout[0] = prefdat0[rdcnt0]; 
assign pref_dout[1] = prefdat1[rdcnt1]; 
assign pref_dout[2] = prefdat2[rdcnt2]; 
assign pref_dout[3] = prefdat3[rdcnt3];
//
wire [WIDTH-1:0] prefdout;  
assign prefdout = pref_dout[prefchn];
//Internal FIFO control
wire[3:0] prenotful; 
assign prenotful[0] = (pref_len0 < 3);
assign prenotful[1] = (pref_len1 < 3);
assign prenotful[2] = (pref_len2 < 3);
assign prenotful[3] = (pref_len3 < 3);
//read data from FIFO
wire datareq;
wire ififord;  
assign datareq = prefena && prenotful[prefchn] && (ifnempt[prefchn] | prefmod) ;
assign ififord = datareq && (!prefmod);  
// 
reg datareq_p1;
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) 
    datareq_p1 <= 1'b0;
  else
    datareq_p1 <= datareq; 
end
//
assign prefwr = datareq_p1;
// 
always @(*)  
begin 
  if (!prefmod)
    prefdin = ififodat; 
  else 
    case (prefchn)
      2'b00: prefdin = {4'hf,gen0dat};
      2'b01: prefdin = {4'hf,gen1dat}; 
      2'b10: prefdin = {4'hf,gen2dat}; 
      2'b11: prefdin = {4'hf,gen3dat}; 
    endcase 
end 
//Generate Data Request 
wire gen0req;
wire gen1req;
wire gen2req;
wire gen3req;
//
assign gen0req = datareq & (prefchn == 2'b00) & prefmod; 
assign gen1req = datareq & (prefchn == 2'b01) & prefmod; 
assign gen2req = datareq & (prefchn == 2'b10) & prefmod; 
assign gen3req = datareq & (prefchn == 2'b11) & prefmod;
// 
endmodule 
