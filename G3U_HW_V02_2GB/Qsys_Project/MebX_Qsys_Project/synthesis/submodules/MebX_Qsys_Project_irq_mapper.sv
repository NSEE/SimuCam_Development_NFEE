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


// $Id: //acds/rel/16.1/ip/merlin/altera_irq_mapper/altera_irq_mapper.sv.terp#1 $
// $Revision: #1 $
// $Date: 2016/08/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Altera IRQ Mapper
//
// Parameters
//   NUM_RCVRS        : 24
//   SENDER_IRW_WIDTH : 32
//   IRQ_MAP          : 0:2,1:5,2:6,3:8,4:16,5:18,6:20,7:22,8:0,9:1,10:10,11:11,12:12,13:13,14:14,15:15,16:3,17:4,18:7,19:9,20:17,21:19,22:21,23:23
//
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module MebX_Qsys_Project_irq_mapper
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // IRQ Receivers
    // -------------------
    input                receiver0_irq,
    input                receiver1_irq,
    input                receiver2_irq,
    input                receiver3_irq,
    input                receiver4_irq,
    input                receiver5_irq,
    input                receiver6_irq,
    input                receiver7_irq,
    input                receiver8_irq,
    input                receiver9_irq,
    input                receiver10_irq,
    input                receiver11_irq,
    input                receiver12_irq,
    input                receiver13_irq,
    input                receiver14_irq,
    input                receiver15_irq,
    input                receiver16_irq,
    input                receiver17_irq,
    input                receiver18_irq,
    input                receiver19_irq,
    input                receiver20_irq,
    input                receiver21_irq,
    input                receiver22_irq,
    input                receiver23_irq,

    // -------------------
    // Command Source (Output)
    // -------------------
    output reg [31 : 0] sender_irq
);


    always @* begin
	sender_irq = 0;

        sender_irq[2] = receiver0_irq;
        sender_irq[5] = receiver1_irq;
        sender_irq[6] = receiver2_irq;
        sender_irq[8] = receiver3_irq;
        sender_irq[16] = receiver4_irq;
        sender_irq[18] = receiver5_irq;
        sender_irq[20] = receiver6_irq;
        sender_irq[22] = receiver7_irq;
        sender_irq[0] = receiver8_irq;
        sender_irq[1] = receiver9_irq;
        sender_irq[10] = receiver10_irq;
        sender_irq[11] = receiver11_irq;
        sender_irq[12] = receiver12_irq;
        sender_irq[13] = receiver13_irq;
        sender_irq[14] = receiver14_irq;
        sender_irq[15] = receiver15_irq;
        sender_irq[3] = receiver16_irq;
        sender_irq[4] = receiver17_irq;
        sender_irq[7] = receiver18_irq;
        sender_irq[9] = receiver19_irq;
        sender_irq[17] = receiver20_irq;
        sender_irq[19] = receiver21_irq;
        sender_irq[21] = receiver22_irq;
        sender_irq[23] = receiver23_irq;
    end

endmodule

