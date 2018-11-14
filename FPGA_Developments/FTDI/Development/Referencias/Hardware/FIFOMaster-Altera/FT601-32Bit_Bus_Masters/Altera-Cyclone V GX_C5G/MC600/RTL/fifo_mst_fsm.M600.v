//------------------------------------------------------------------------------
// Title        : fifo_mst_fsm.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 8th Mar, 2014
//------------------------------------------------------------------------------
// Description  : 
//               FIFO FT600 Master FSM 
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
  input                    tc_rxf_n,      // this is s2mack_n in PP mode
  input                    grant,
  input                    m_rd_wr,       // 1: master read, 0: master write
  input                    fifo_full,
  input                    fifo_empty,
  input                    ld_2_full,
  input                    ld_2_empty,
  input [EPm_MSZ:0]        ep_rd_ptr,

  // outputs
  output wire              idle_st,
  output wire [3:0]        cmd_out,
  output reg               tp_wr_n,       // this is m2sreq_n in M600 mode
  output reg               snd_cmd,
  output reg               tp_dt_oe_n,    // data BE[1]
  output reg               tp_be_oe_n,
  output reg               u_rd_ptr,
  output reg [EPm_MSZ:0]   c_rd_ptr,
  output wire              mem_cs,
  output wire              mem_wren,
  output wire              mem_rden

);


  reg  [7:0]   cur_st;
  reg  [7:0]   nxt_st;
 
  wire         adv_c_rptr;
  wire         load_crptr;
  wire         s2mack_n;




  assign adv_c_rptr = ~s2mack_n & cur_st[0] & ~m_rd_wr;

  assign load_crptr = grant & ~m_rd_wr;

  assign s2mack_n   = tc_rxf_n;

  assign mem_wren   = cur_st[5] & ~s2mack_n;

  assign mem_cs     = m_rd_wr ? (cur_st[3] & ~fifo_full) :
                                (cur_st[3] & ~fifo_empty);

  assign mem_rden   = cur_st[4];

  assign cmd_out    = m_rd_wr ? 4'h0 : 4'h1;



///////////////////////////////////////////////////////////////////////////////
// FSM
//


  localparam   MODE_SL = 8'b0000_0000;  // h00
  localparam   F888M00 = 8'b0000_0010;  // h02
  localparam   F888M10 = 8'b0000_1011;  // h0b
  localparam   F888M11 = 8'b0000_0001;  // h01 MT READ turnaround
  localparam   F888M12 = 8'b0100_0001;  // h41 MT Wait
  localparam   F888M13 = 8'b0010_1001;  // h29 MT READ
  localparam   F888M14 = 8'b0100_0000;  // h40
  localparam   F888M20 = 8'b0001_1011;  // h1b
  localparam   F888M21 = 8'b0101_1111;  // h5f MT WRITE turnaround
  localparam   F888M22 = 8'b0001_1111;  // h1f MT WRITE
  localparam   F888M23 = 8'b0100_0010;  // h42
  localparam   F888M24 = 8'b1000_0010;  // h82



  assign idle_st    = cur_st == F888M00;


  always @(*) begin

    nxt_st      = cur_st;
    snd_cmd     = 0;
    u_rd_ptr    = 0;

    case(cur_st)

      MODE_SL: begin

        nxt_st = F888M00;

      end
      F888M00: begin

        if (grant) begin

          snd_cmd = 1;
          
          if (m_rd_wr)
            nxt_st = F888M10;   // master read cycle 
          else
            nxt_st = F888M20;   // master write cycle

        end

      end
      F888M10: begin            // master read cmd on bus 

        nxt_st = F888M11;

      end
      F888M20: begin            // master write cmd on bus 

        nxt_st = F888M21;

      end
      F888M11: begin            // MASTER READ turn around  

        nxt_st = F888M12;

      end
      F888M12: begin            // MASTER READ wait 

        nxt_st = F888M13;

      end
      F888M13: begin            // MASTER READ DATA

        if (s2mack_n)
          nxt_st = F888M00;
        else if (ld_2_full)
          nxt_st = F888M14;

      end
      F888M14: begin           // waiting for s2mack_n de-assertion

        if (s2mack_n)
         nxt_st = F888M00;

      end
      F888M21: begin          // MASTER WRITE turn around

        nxt_st = F888M22;

      end
      F888M22: begin          // MASTER WRITE DATA
 
        if (ld_2_empty)
          nxt_st = F888M24;
        else if (s2mack_n)
          nxt_st = F888M23;

      end
      F888M23: begin          // de-assert m2sreq_n & turn around 
    
         nxt_st = F888M00;
         u_rd_ptr = 1;

      end
      F888M24: begin          // de-assert m2sreq_n & turn around

        if (s2mack_n)   
          nxt_st = F888M00;

        u_rd_ptr = 1;

      end

     default: begin

        nxt_st = F888M00;

     end

    endcase

  end


  always @(posedge clk or negedge rstn)
    if (~rstn) begin
      cur_st       <= MODE_SL;
      c_rd_ptr     <= 0;
      tp_wr_n      <= 1;
      tp_be_oe_n   <= 1;
      tp_dt_oe_n   <= 1;
    end
    else begin

      cur_st       <= nxt_st;

      if (nxt_st[2])
        tp_dt_oe_n <= 0;
      else
        tp_dt_oe_n <= 1;

      if (nxt_st[1])
        tp_be_oe_n   <= 0;
      else
        tp_be_oe_n   <= 1;

      if (nxt_st[0])
        tp_wr_n    <= 0;
      else
        tp_wr_n    <= 1;
        
      if (load_crptr)
        c_rd_ptr   <= ep_rd_ptr;
      else if (adv_c_rptr)
        c_rd_ptr   <= c_rd_ptr + 1'b1;

    end


endmodule
