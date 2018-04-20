//------------------------------------------------------------------------------
// Title        : fifo_mst_arb.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 12th Mar,2014
//------------------------------------------------------------------------------
// Description  : 
//                FT600 FIFO Master Arbitor 
//
//
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

module fifo_mst_arb (

  // inputs
  input                fifoRstn,
  input                fifoClk,
  input                idle_st,
  input [8:1]          slv_f_st_n,
  input [8:1]          mst_f_st_n, // {~full,~empty}
  input                mem_rdy,

  // outputs
  output reg           grant,
  output reg [2:0]     t_ep_num,
  output reg           m_rd_wr
);


  reg [8:1]            not_served_r;  // {...IN2,OUT2,IN1,OUT1} 
  reg [4:1]            oep_slv_st_r;
  reg [4:1]            iep_slv_st_r;
  reg [4:1]            oep_mst_st_r;
  reg [4:1]            iep_mst_st_r;
  reg [8:1]            deact_nxt;
  reg [2:0]            t_ep_num_nxt;
  reg                  m_rd_wr_nxt;

  wire                 req_hit;
  wire                 req_det;

  wire [4:1]           oep_slv_st;
  wire [4:1]           iep_slv_st;
  wire [4:1]           oep_mst_st;
  wire [4:1]           iep_mst_st;



///////////////////////////////////////////////////////////////////////////////
// assignments
  assign oep_slv_st = idle_st? ~slv_f_st_n[8:5] : 4'h0;
  assign iep_slv_st = idle_st? ~slv_f_st_n[4:1] : 4'h0;
  assign oep_mst_st = ~mst_f_st_n[8:5];
  assign iep_mst_st = ~mst_f_st_n[4:1];

  assign req_hit = |({oep_slv_st_r,iep_slv_st_r} &
                     {oep_mst_st_r,iep_mst_st_r} &
                     {not_served_r[7],not_served_r[5],
                      not_served_r[3],not_served_r[1],
                      not_served_r[8],not_served_r[6],
                      not_served_r[4],not_served_r[2]});


  assign req_det = |({oep_slv_st_r,iep_slv_st_r} &
                     {oep_mst_st_r,iep_mst_st_r});


///////////////////////////////////////////////////////////////////////////////
// Priority encoding 

  always @(*) begin

    if(not_served_r[1] & oep_slv_st_r[1] & oep_mst_st_r[1]) begin
      deact_nxt    = 8'b1111_1110;
      t_ep_num_nxt = 3'b001;
      m_rd_wr_nxt  = 1'b1;
    end
    else if(not_served_r[2] & iep_slv_st_r[1] & iep_mst_st_r[1]) begin
      deact_nxt    = 8'b1111_1100;
      t_ep_num_nxt = 3'b001;
      m_rd_wr_nxt  = 1'b0;
    end
    else if(not_served_r[3] & oep_slv_st_r[2] & oep_mst_st_r[2]) begin
      deact_nxt    = 8'b1111_1000;
      t_ep_num_nxt = 3'b010;
      m_rd_wr_nxt  = 1'b1;
    end
    else if(not_served_r[4] & iep_slv_st_r[2] & iep_mst_st_r[2]) begin
      deact_nxt    = 8'b1111_0000;
      t_ep_num_nxt = 3'b010;
      m_rd_wr_nxt  = 1'b0;
    end
    else if(not_served_r[5] & oep_slv_st_r[3] & oep_mst_st_r[3]) begin
      deact_nxt    = 8'b1110_0000;
      t_ep_num_nxt = 3'b011;
      m_rd_wr_nxt  = 1'b1;
    end
    else if(not_served_r[6] & iep_slv_st_r[3] & iep_mst_st_r[3]) begin
      deact_nxt    = 8'b1100_0000;
      t_ep_num_nxt = 3'b011;
      m_rd_wr_nxt  = 1'b0;
    end
    else if(not_served_r[7] & oep_slv_st_r[4] & oep_mst_st_r[4]) begin
      deact_nxt    = 8'b1000_0000;
      t_ep_num_nxt = 3'b100;
      m_rd_wr_nxt  = 1'b1;
    end
    else if(not_served_r[8] & iep_slv_st_r[4] & iep_mst_st_r[4]) begin
      deact_nxt    = 8'b0000_0000;
      t_ep_num_nxt = 3'b100;
      m_rd_wr_nxt  = 1'b0;
    end
    else begin
      deact_nxt    = not_served_r; 
      t_ep_num_nxt = 3'b000;
      m_rd_wr_nxt  = 1'b0;
    end

  end


  always @(posedge fifoClk or negedge fifoRstn)
    if (~fifoRstn) begin

      not_served_r  <= 8'hff;
      oep_slv_st_r  <= 4'h0;
      oep_mst_st_r  <= 4'h0;
      iep_slv_st_r  <= 4'h0;
      iep_mst_st_r  <= 4'h0;
      t_ep_num      <= 3'b000;
      m_rd_wr       <= 1'b0;
      grant         <= 1'b0;

    end
    else begin

      if ((idle_st & req_det & ~req_hit & ~grant) | (~|not_served_r))
        not_served_r <= 8'hff;
      else if (idle_st & ~grant)
        not_served_r <= deact_nxt;

      if (grant) begin
        oep_slv_st_r <= 4'h0;
        oep_mst_st_r <= 4'h0;
        iep_slv_st_r <= 4'h0;
        iep_mst_st_r <= 4'h0;
      end
      else if (idle_st & mem_rdy) begin
        oep_slv_st_r <= oep_slv_st;
        oep_mst_st_r <= oep_mst_st;
        iep_slv_st_r <= iep_slv_st;
        iep_mst_st_r <= iep_mst_st;
      end

      if (idle_st & req_hit & ~grant) begin
        t_ep_num <= t_ep_num_nxt;
        m_rd_wr  <= m_rd_wr_nxt;
      end

      if (idle_st & req_hit & ~grant)
        grant <= 1'b1;
      else
        grant <= 1'b0;

    end


endmodule
