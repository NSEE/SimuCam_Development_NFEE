//------------------------------------------------------------------------------
// Title        : fifo_mst_fsm.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 8th Mar, 2014
//------------------------------------------------------------------------------
// Description  : 
//               FIFO 245 Master FSM 
//  
//             
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

module fifo_mst_fsm #(
  parameter EPm_MSZ = 11
  ) (

  // inputs
  input                    rstn,
  input                    clk,
  input                    tc_txe_n,
  input                    tc_rxf_n,      // this is s2mack_n in M600 mode
  input                    siwu_en,
  input                    grant,
  input                    m_rd_wr,       // 1: master read, 0: master write
  input                    fifo_full,
  input                    fifo_empty,
  input                    ld_2_full,
  input                    ld_2_empty,
  input [EPm_MSZ:0]        ep_rd_ptr,

  // outputs
  output wire              idle_st,
  output reg               tp_wr_n,       // this is m2sreq_n in M600 mode
  output reg               tp_oe_n,
  output reg               tp_rd_n,
  output reg               tp_siwu_n,
  output reg               tp_be_oe_n,
  output wire              u_rd_ptr,
  output reg [EPm_MSZ:0]   c_rd_ptr,
  output wire              mem_cs,
  output wire              mem_wren,
  output wire              mem_rden

);


  reg  [6:0]   cur_st;
  reg  [6:0]   nxt_st;
 
  wire         adv_c_rptr;
  wire         load_crptr;
  wire         set_siwu_en;



  assign adv_c_rptr = ~tc_txe_n & cur_st[0] & ~m_rd_wr;

  assign load_crptr = grant & ~m_rd_wr;

  assign mem_wren   = cur_st[4] & ~tc_rxf_n;

  assign mem_cs     = m_rd_wr ? (cur_st[2] & ~fifo_full) :
                                ((cur_st[2] & ~fifo_empty) | grant);

  assign mem_rden   = cur_st[3] | (grant & ~m_rd_wr);

  assign u_rd_ptr   = cur_st[6];

  assign set_siwu_en = siwu_en & cur_st[0];

//////////////////////////////////////////////////////////////
// FSM

  localparam   MODE_SL = 7'b000_0000;  // h00
  localparam   M245_00 = 7'b000_0010;  // h02
  localparam   M245_10 = 7'b010_0000;  // h20 
  localparam   M245_11 = 7'b011_0100;  // h74 MT READ
  localparam   M245_20 = 7'b000_1110;  // h0e 
  localparam   M245_21 = 7'b000_1111;  // h0f MT WRITE
  localparam   M245_22 = 7'b100_0010;  // h82


  assign idle_st    = (cur_st == M245_00);



  always @(*) begin

    nxt_st      = cur_st;

    case(cur_st)

      MODE_SL: begin

        nxt_st = M245_00;

      end
      M245_00: begin


        if (grant) begin

          if (m_rd_wr)
            nxt_st = M245_10;
          else
            nxt_st = M245_20;

        end

      end
      M245_10: begin       // master read cycle start, OE_N is asserted

        nxt_st = M245_11;

      end
      M245_11: begin       // OE_N and RD_N are asserted

        if (ld_2_full | tc_rxf_n)
          nxt_st = MODE_SL;  // OE_N and RD_N are de-asserted
        
      end
      M245_20: begin       // first data is ready at Memory out

        nxt_st = M245_21;

      end
      M245_21: begin        // master write cycle start, WR_N is asserted

        if (ld_2_empty | tc_txe_n)
          nxt_st = M245_22;

      end
      M245_22: begin

        nxt_st = M245_00;

      end

     default: begin

        nxt_st = MODE_SL;

     end

    endcase

  end


  always @(posedge clk or negedge rstn)
    if (~rstn) begin
      cur_st       <= MODE_SL;
      c_rd_ptr     <= 0;
      tp_wr_n      <= 1;
      tp_oe_n      <= 1;
      tp_rd_n      <= 1;
      tp_siwu_n    <= 1;
      tp_be_oe_n   <= 1;
    end
    else begin

      cur_st       <= nxt_st;

      if (load_crptr)
        c_rd_ptr   <= ep_rd_ptr;
      else if (adv_c_rptr)
        c_rd_ptr   <= c_rd_ptr + 1'b1;

      if (nxt_st[0])
        tp_wr_n  <= 0;
      else
        tp_wr_n  <= 1;

      if (nxt_st[5])
        tp_oe_n  <= 0;
      else
        tp_oe_n  <= 1;

      if (nxt_st[4])
        tp_rd_n  <= 0;
      else
        tp_rd_n  <= 1;

      if (set_siwu_en)
        tp_siwu_n  <= 0;
      else
        tp_siwu_n  <= 1;

      if (nxt_st[1])
        tp_be_oe_n  <= 0;
      else
        tp_be_oe_n  <= 1;

    end


endmodule
