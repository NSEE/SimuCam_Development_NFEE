// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
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


// $Id: //acds/rel/18.1std/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $

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

module MebX_Qsys_Project_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 40,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 9 
   )
  (output [110 - 105 : 0] default_destination_id,
   output [41-1 : 0] default_wr_channel,
   output [41-1 : 0] default_rd_channel,
   output [41-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[110 - 105 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 41'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 41'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 41'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module MebX_Qsys_Project_mm_interconnect_0_router
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
    input  [124-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [124-1    : 0] src_data,
    output reg [41-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 110;
    localparam PKT_DEST_ID_L = 105;
    localparam PKT_PROTECTION_H = 114;
    localparam PKT_PROTECTION_L = 112;
    localparam ST_DATA_W = 124;
    localparam ST_CHANNEL_W = 41;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h80000000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h80001000 - 64'h80000000); 
    localparam PAD2 = log2ceil(64'h81200000 - 64'h81100000); 
    localparam PAD3 = log2ceil(64'h81201000 - 64'h81200800); 
    localparam PAD4 = log2ceil(64'h81201400 - 64'h81201000); 
    localparam PAD5 = log2ceil(64'h81201800 - 64'h81201400); 
    localparam PAD6 = log2ceil(64'h81201c00 - 64'h81201800); 
    localparam PAD7 = log2ceil(64'h81202000 - 64'h81201c00); 
    localparam PAD8 = log2ceil(64'h81202400 - 64'h81202000); 
    localparam PAD9 = log2ceil(64'h81202800 - 64'h81202400); 
    localparam PAD10 = log2ceil(64'h81202c00 - 64'h81202800); 
    localparam PAD11 = log2ceil(64'h81202c20 - 64'h81202c00); 
    localparam PAD12 = log2ceil(64'h81202c40 - 64'h81202c20); 
    localparam PAD13 = log2ceil(64'h81202c60 - 64'h81202c40); 
    localparam PAD14 = log2ceil(64'h81202c80 - 64'h81202c60); 
    localparam PAD15 = log2ceil(64'h81202ca0 - 64'h81202c80); 
    localparam PAD16 = log2ceil(64'h81202cc0 - 64'h81202ca0); 
    localparam PAD17 = log2ceil(64'h81202ce0 - 64'h81202cc0); 
    localparam PAD18 = log2ceil(64'h81202d00 - 64'h81202ce0); 
    localparam PAD19 = log2ceil(64'h81202d20 - 64'h81202d00); 
    localparam PAD20 = log2ceil(64'h81202d40 - 64'h81202d20); 
    localparam PAD21 = log2ceil(64'h81202d60 - 64'h81202d40); 
    localparam PAD22 = log2ceil(64'h81202d80 - 64'h81202d60); 
    localparam PAD23 = log2ceil(64'h81202da0 - 64'h81202d80); 
    localparam PAD24 = log2ceil(64'h81202dc0 - 64'h81202da0); 
    localparam PAD25 = log2ceil(64'h81202de0 - 64'h81202dc0); 
    localparam PAD26 = log2ceil(64'h81202e00 - 64'h81202de0); 
    localparam PAD27 = log2ceil(64'h81202e20 - 64'h81202e00); 
    localparam PAD28 = log2ceil(64'h81202e40 - 64'h81202e20); 
    localparam PAD29 = log2ceil(64'h81202e60 - 64'h81202e40); 
    localparam PAD30 = log2ceil(64'h81202e80 - 64'h81202e60); 
    localparam PAD31 = log2ceil(64'h81202ea0 - 64'h81202e80); 
    localparam PAD32 = log2ceil(64'h81202ec0 - 64'h81202ea0); 
    localparam PAD33 = log2ceil(64'h81202ee0 - 64'h81202ec0); 
    localparam PAD34 = log2ceil(64'h81202f00 - 64'h81202ee0); 
    localparam PAD35 = log2ceil(64'h81202f20 - 64'h81202f00); 
    localparam PAD36 = log2ceil(64'h81202f40 - 64'h81202f20); 
    localparam PAD37 = log2ceil(64'h81202f48 - 64'h81202f40); 
    localparam PAD38 = log2ceil(64'h81202f50 - 64'h81202f48); 
    localparam PAD39 = log2ceil(64'h81202f58 - 64'h81202f50); 
    localparam PAD40 = log2ceil(64'h88000000 - 64'h84000000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h88000000;
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
    wire [41-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire write_transaction;
    assign write_transaction = sink_data[PKT_TRANS_WRITE];
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    MebX_Qsys_Project_mm_interconnect_0_router_default_decode the_default_decode(
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
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 32'h0   ) begin
            src_channel = 41'b10000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x80000000 .. 0x80001000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 32'h80000000   ) begin
            src_channel = 41'b00010000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x81100000 .. 0x81200000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 32'h81100000   ) begin
            src_channel = 41'b00100000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 39;
    end

    // ( 0x81200800 .. 0x81201000 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 32'h81200800   ) begin
            src_channel = 41'b00000000000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 38;
    end

    // ( 0x81201000 .. 0x81201400 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 32'h81201000   ) begin
            src_channel = 41'b00000000000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x81201400 .. 0x81201800 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 32'h81201400   ) begin
            src_channel = 41'b00000000000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x81201800 .. 0x81201c00 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 32'h81201800   ) begin
            src_channel = 41'b00000000000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x81201c00 .. 0x81202000 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 32'h81201c00   ) begin
            src_channel = 41'b00000000000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x81202000 .. 0x81202400 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 32'h81202000   ) begin
            src_channel = 41'b00000000000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x81202400 .. 0x81202800 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 32'h81202400   ) begin
            src_channel = 41'b00000000000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x81202800 .. 0x81202c00 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 32'h81202800   ) begin
            src_channel = 41'b00000000000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x81202c00 .. 0x81202c20 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 32'h81202c00  && write_transaction  ) begin
            src_channel = 41'b00001000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 35;
    end

    // ( 0x81202c20 .. 0x81202c40 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 32'h81202c20  && write_transaction  ) begin
            src_channel = 41'b00000100000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x81202c40 .. 0x81202c60 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 32'h81202c40  && write_transaction  ) begin
            src_channel = 41'b00000010000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x81202c60 .. 0x81202c80 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 32'h81202c60  && write_transaction  ) begin
            src_channel = 41'b00000001000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x81202c80 .. 0x81202ca0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 32'h81202c80  && write_transaction  ) begin
            src_channel = 41'b00000000100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x81202ca0 .. 0x81202cc0 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 32'h81202ca0  && write_transaction  ) begin
            src_channel = 41'b00000000010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x81202cc0 .. 0x81202ce0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 32'h81202cc0  && write_transaction  ) begin
            src_channel = 41'b00000000001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x81202ce0 .. 0x81202d00 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 32'h81202ce0  && write_transaction  ) begin
            src_channel = 41'b00000000000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x81202d00 .. 0x81202d20 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 32'h81202d00  && write_transaction  ) begin
            src_channel = 41'b00000000000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x81202d20 .. 0x81202d40 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 32'h81202d20  && write_transaction  ) begin
            src_channel = 41'b00000000000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x81202d40 .. 0x81202d60 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 32'h81202d40  && write_transaction  ) begin
            src_channel = 41'b00000000000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x81202d60 .. 0x81202d80 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 32'h81202d60  && write_transaction  ) begin
            src_channel = 41'b00000000000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x81202d80 .. 0x81202da0 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 32'h81202d80  && write_transaction  ) begin
            src_channel = 41'b00000000000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x81202da0 .. 0x81202dc0 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 32'h81202da0   ) begin
            src_channel = 41'b00000000000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
    end

    // ( 0x81202dc0 .. 0x81202de0 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 32'h81202dc0   ) begin
            src_channel = 41'b00000000000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x81202de0 .. 0x81202e00 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 32'h81202de0   ) begin
            src_channel = 41'b00000000000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x81202e00 .. 0x81202e20 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 32'h81202e00   ) begin
            src_channel = 41'b00000000000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0x81202e20 .. 0x81202e40 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 32'h81202e20   ) begin
            src_channel = 41'b00000000000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x81202e40 .. 0x81202e60 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 32'h81202e40   ) begin
            src_channel = 41'b00000000000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x81202e60 .. 0x81202e80 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 32'h81202e60   ) begin
            src_channel = 41'b00000000000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x81202e80 .. 0x81202ea0 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 32'h81202e80   ) begin
            src_channel = 41'b00000000000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x81202ea0 .. 0x81202ec0 )
    if ( {address[RG:PAD32],{PAD32{1'b0}}} == 32'h81202ea0   ) begin
            src_channel = 41'b00000000000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x81202ec0 .. 0x81202ee0 )
    if ( {address[RG:PAD33],{PAD33{1'b0}}} == 32'h81202ec0   ) begin
            src_channel = 41'b00000000000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x81202ee0 .. 0x81202f00 )
    if ( {address[RG:PAD34],{PAD34{1'b0}}} == 32'h81202ee0   ) begin
            src_channel = 41'b00000000000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x81202f00 .. 0x81202f20 )
    if ( {address[RG:PAD35],{PAD35{1'b0}}} == 32'h81202f00   ) begin
            src_channel = 41'b00000000000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x81202f20 .. 0x81202f40 )
    if ( {address[RG:PAD36],{PAD36{1'b0}}} == 32'h81202f20   ) begin
            src_channel = 41'b00000000000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x81202f40 .. 0x81202f48 )
    if ( {address[RG:PAD37],{PAD37{1'b0}}} == 32'h81202f40  && read_transaction  ) begin
            src_channel = 41'b00000000000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 40;
    end

    // ( 0x81202f48 .. 0x81202f50 )
    if ( {address[RG:PAD38],{PAD38{1'b0}}} == 32'h81202f48   ) begin
            src_channel = 41'b00000000000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x81202f50 .. 0x81202f58 )
    if ( {address[RG:PAD39],{PAD39{1'b0}}} == 32'h81202f50   ) begin
            src_channel = 41'b00000000000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 37;
    end

    // ( 0x84000000 .. 0x88000000 )
    if ( {address[RG:PAD40],{PAD40{1'b0}}} == 32'h84000000   ) begin
            src_channel = 41'b01000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 36;
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


