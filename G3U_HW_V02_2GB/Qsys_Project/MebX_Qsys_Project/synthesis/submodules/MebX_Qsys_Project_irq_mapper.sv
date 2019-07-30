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


// $Id: //acds/rel/18.1std/ip/merlin/altera_irq_mapper/altera_irq_mapper.sv.terp#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $

// -------------------------------------------------------
// Altera IRQ Mapper
//
// Parameters
//   NUM_RCVRS        : 20
//   SENDER_IRW_WIDTH : 32
//   IRQ_MAP          : 0:0,1:1,2:2,3:3,4:17,5:19,6:4,7:5,8:6,9:7,10:8,11:9,12:10,13:11,14:12,15:13,16:14,17:15,18:16,19:18
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

    // -------------------
    // Command Source (Output)
    // -------------------
    output reg [31 : 0] sender_irq
);


    always @* begin
	sender_irq = 0;

        sender_irq[0] = receiver0_irq;
        sender_irq[1] = receiver1_irq;
        sender_irq[2] = receiver2_irq;
        sender_irq[3] = receiver3_irq;
        sender_irq[17] = receiver4_irq;
        sender_irq[19] = receiver5_irq;
        sender_irq[4] = receiver6_irq;
        sender_irq[5] = receiver7_irq;
        sender_irq[6] = receiver8_irq;
        sender_irq[7] = receiver9_irq;
        sender_irq[8] = receiver10_irq;
        sender_irq[9] = receiver11_irq;
        sender_irq[10] = receiver12_irq;
        sender_irq[11] = receiver13_irq;
        sender_irq[12] = receiver14_irq;
        sender_irq[13] = receiver15_irq;
        sender_irq[14] = receiver16_irq;
        sender_irq[15] = receiver17_irq;
        sender_irq[16] = receiver18_irq;
        sender_irq[18] = receiver19_irq;
    end

endmodule

