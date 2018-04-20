//------------------------------------------------------------------------------
// Title        : fifo_ep_mst.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 10th Mar,2014
//------------------------------------------------------------------------------
// Description  : 
//                FT600 FIFO Master Endpoint module 
//
//
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

module fifo_ep_mst #(
  parameter T_MSZ = 13,   // 16Kx32bit
  parameter EPm_MSZ = 11,
  parameter EP_MSZ = 11,  // 4Kx32bit, no roll-over bit
  parameter [2:0]  EP_NUM = 0,
  parameter [T_MSZ-1:0] EP_BASE_ADR = 0
  ) (
  // inputs
  input                          fifoRstn,
  input                          fifoClk,
  input                          i_mode,
  input                          m_wr_en,
  input                          m_rd_en,
  input [3:0]                    m_rd_be,
  input [2:0]                    ep_num,
  input                          m_wr_sel,
  input                          u_rd_ptr,
  input [EPm_MSZ:0]              c_rd_ptr,

  // outputs
  output wire [3:0]              m_wr_be,
  output wire [T_MSZ-1:0]        ram_adr,
  output reg [EPm_MSZ:0]         ep_rd_ptr,
  output wire                    fifo_empty,
  output wire                    fifo_full,
  output wire                    ld_2_empty,
  output wire                    ld_2_full
);

  reg [EP_MSZ:0]             wr_ptr;   // added roll-over bit
  reg [EP_MSZ:0]             rd_ptr;   // added roll-over bit
  reg [3:0]                  last_be;

  wire [EP_MSZ:0]            wlah_ptr;
  wire [EP_MSZ:0]            lah_cptr;
  wire [T_MSZ-1:0]           mm_wr_adr;
  wire [T_MSZ-1:0]           mm_rd_adr;
  wire [T_MSZ-1:0]           ep_ram_adr;
  wire                       ep_match;
  wire                       lb_ptr_eq;
  wire                       la_wptr_eq;
  wire                       lah_cptr_eq;
  wire                       mm_wr_en;
  wire                       mm_rd_en;
  wire                       ld_rd_ptr;


  localparam EP_DIFF = EPm_MSZ - EP_MSZ;
  localparam EP_MSZ_P = EP_MSZ + 1;



  always @(*) begin

    if (EPm_MSZ<=EP_MSZ)
      ep_rd_ptr = {{EP_MSZ_P{ep_match}} & rd_ptr};
    else
      ep_rd_ptr = {{EP_DIFF{1'b0}},{{EP_MSZ_P{ep_match}} & rd_ptr}};

  end


  assign ld_rd_ptr   = ep_match & u_rd_ptr;

  assign mm_wr_en    = m_rd_en & ep_match;

  assign mm_rd_en    = m_wr_en & ep_match;

  assign ram_adr     = {T_MSZ{ep_match}} & ep_ram_adr;

  assign ep_ram_adr  = m_wr_sel ? mm_rd_adr : mm_wr_adr;

  assign mm_wr_adr   = EP_BASE_ADR + wr_ptr[EP_MSZ-1:0];

  assign mm_rd_adr   = EP_BASE_ADR + rd_ptr[EP_MSZ-1:0];

  assign la_wptr_eq  = (~|(wlah_ptr[EP_MSZ-1:0] ^ rd_ptr[EP_MSZ-1:0]));

  assign wlah_ptr    = wr_ptr + 1'b1;

  assign ld_2_full = (wlah_ptr[EP_MSZ] ^ rd_ptr[EP_MSZ]) &
                     la_wptr_eq & ep_match & ~i_mode;

  assign m_wr_be     = {4{ep_match}} & (fifo_empty? last_be : 4'b1111);

  assign ep_match    = (ep_num == EP_NUM);


///////////////////////////////////////////////////////////////////////////////
// external FIFO full/empty

  assign lah_cptr     = c_rd_ptr[EP_MSZ:0] + 1'b1;

  assign lah_cptr_eq  = (~|(wr_ptr ^ lah_cptr));

  assign ld_2_empty = lah_cptr_eq & ep_match & ~i_mode;


///////////////////////////////////////////////////////////////////////////////
// internal FIFO full/empty

  assign lb_ptr_eq   = (~|(wr_ptr[EP_MSZ-1:0] ^ rd_ptr[EP_MSZ-1:0]));

  assign fifo_full   = (wr_ptr[EP_MSZ] ^ rd_ptr[EP_MSZ]) &
                       lb_ptr_eq & ~i_mode;

  assign fifo_empty  = (wr_ptr[EP_MSZ] ~^ rd_ptr[EP_MSZ]) &
                       lb_ptr_eq & ~i_mode;


///////////////////////////////////////////////////////////////////////////////
// EP data count calculation

  always @(posedge fifoClk or negedge fifoRstn)
    if (~fifoRstn) begin

      wr_ptr         <= 0;
      rd_ptr         <= 0;
      last_be        <= 0;

    end
    else begin

      if (mm_wr_en & ~fifo_full)
        wr_ptr       <=  wr_ptr + 1'b1;

      if (ld_rd_ptr)
        rd_ptr       <=  c_rd_ptr[EP_MSZ:0];
      else if (mm_rd_en & ~fifo_empty)
        rd_ptr       <=  rd_ptr + 1'b1;

      if (mm_wr_en)
        last_be      <=  m_rd_be;

    end


endmodule
