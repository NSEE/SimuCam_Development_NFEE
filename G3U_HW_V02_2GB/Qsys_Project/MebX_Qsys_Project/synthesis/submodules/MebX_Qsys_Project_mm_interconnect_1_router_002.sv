// (C) 2001-2016 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/16.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2016/08/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module MebX_Qsys_Project_mm_interconnect_1_router_002_default_decode
  #(
     parameter DEFAULT_CHANNEL = 1,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 9 
   )
  (output [142 - 139 : 0] default_destination_id,
   output [11-1 : 0] default_wr_channel,
   output [11-1 : 0] default_rd_channel,
   output [11-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[142 - 139 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 11'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 11'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 11'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module MebX_Qsys_Project_mm_interconnect_1_router_002
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [156-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [156-1    : 0] src_data,
    output reg [11-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 105;
    localparam PKT_ADDR_L = 72;
    localparam PKT_DEST_ID_H = 142;
    localparam PKT_DEST_ID_L = 139;
    localparam PKT_PROTECTION_H = 146;
    localparam PKT_PROTECTION_L = 144;
    localparam ST_DATA_W = 156;
    localparam ST_CHANNEL_W = 11;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 108;
    localparam PKT_TRANS_READ  = 109;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h80000000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h100000000 - 64'h80000000); 
    localparam PAD2 = log2ceil(64'h140000000 - 64'h120000000); 
    localparam PAD3 = log2ceil(64'h160000000 - 64'h140000000); 
    localparam PAD4 = log2ceil(64'h180000000 - 64'h160000000); 
    localparam PAD5 = log2ceil(64'h1a0000000 - 64'h180000000); 
    localparam PAD6 = log2ceil(64'h1c0000000 - 64'h1a0000000); 
    localparam PAD7 = log2ceil(64'h1e0000000 - 64'h1c0000000); 
    localparam PAD8 = log2ceil(64'h200000000 - 64'h1e0000000); 
    localparam PAD9 = log2ceil(64'h220000000 - 64'h200000000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h220000000;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [11-1 : 0] default_src_channel;






    MebX_Qsys_Project_mm_interconnect_1_router_002_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x80000000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 34'h0   ) begin
            src_channel = 11'b0000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x80000000 .. 0x100000000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 34'h80000000   ) begin
            src_channel = 11'b0000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x120000000 .. 0x140000000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 34'h120000000   ) begin
            src_channel = 11'b1000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x140000000 .. 0x160000000 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 34'h140000000   ) begin
            src_channel = 11'b0100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x160000000 .. 0x180000000 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 34'h160000000   ) begin
            src_channel = 11'b0010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x180000000 .. 0x1a0000000 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 34'h180000000   ) begin
            src_channel = 11'b0001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x1a0000000 .. 0x1c0000000 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 34'h1a0000000   ) begin
            src_channel = 11'b0000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x1c0000000 .. 0x1e0000000 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 34'h1c0000000   ) begin
            src_channel = 11'b0000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x1e0000000 .. 0x200000000 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 34'h1e0000000   ) begin
            src_channel = 11'b0000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x200000000 .. 0x220000000 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 34'h200000000   ) begin
            src_channel = 11'b0000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


