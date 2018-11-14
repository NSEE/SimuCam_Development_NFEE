//------------------------------------------------------------------------------
// Title        : fifo_mst_top.v 
// Project      : FT600
//------------------------------------------------------------------------------
// Author       : Wai Kwok 
// Date Created : 22th Mar,2014
//------------------------------------------------------------------------------
// Description  : 
//                FT600 FIFO Master TOP 
//
//
//------------------------------------------------------------------------------
// Known issues & omissions:
// 
// 
//------------------------------------------------------------------------------
// Copyright 2013 FTDI Ltd. All rights reserved.
//------------------------------------------------------------------------------

`ifndef FTDI_SIM
  `include "define_conf.v"
`endif

module fifo_mst_top (
  // TO/FROM pads
  // system control
  input                RESET_N,

  // FIFO interface 
  input                CLK,
  inout [31:0]         DATA,
  inout [3:0]          BE,
  input                RXF_N,   // ACK_N
  input                TXE_N,
  output               WR_N,    // REQ_N
  output               SIWU_N,
  output               RD_N,
  output               OE_N,

  // misc interface
  // outputs
  output wire [1:0]   sys_led

);
 

  localparam T_MSZ = 12;            // 16KB overall memory
  localparam EPm_MSZ = T_MSZ;       // highest endpoint size
  localparam EP1_BASE_ADR = 'h0;


  wire                 grant;
  wire                 idle_st;
  wire                 m_rd_wr;
  wire                 mem_rdy;
  wire [31:0]          tx_data;
  wire [31:0]          rx_data;
  wire [3:0]           rx_be;
  wire                 rx_rxf_n;
  wire                 rx_txe_n;
  wire                 mem_wren;
  wire                 mem_rden;
  wire                 mem_cs;
  wire [3:0]           m_wr_be_1;
  wire [T_MSZ-1:0]     ram_adr_1;
  wire                 fifo_empty_1;
  wire                 fifo_full_1;
  wire                 ld_2_empty_1;
  wire                 ld_2_full_1;
  wire [7:0]           slv_status;
  wire                 u_rd_ptr;
  wire [EPm_MSZ:0]     c_rd_ptr;
  wire [EPm_MSZ:0]     ep_rd_ptr;
  wire [EPm_MSZ:0]     ep_rd_ptr_1;

  wire                 fifoClk;
  wire                 dly_rstn;
  wire                 tm_rstn;
  wire                 tc_chipRstn;
  wire [31:0]          tc_data;
  wire [3:0]           tc_be;
  wire                 tc_rxf_n;
  wire                 tc_txe_n;
  wire [31:0]          tp_data;
  wire [3:0]           tp_be;
  wire                 tp_wr_n;
  wire                 tp_oe_n;
  wire                 tp_rd_n;
  wire                 tp_siwu_n;
  wire                 tp_be_oe_n;


///////////////////////////////////////////////////////////////////////////////
// system LEDs 
//
  assign sys_led[0] = fifo_empty_1 & tm_rstn; // indicate EP1 buffer is empty
  assign sys_led[1] = fifo_full_1 & tm_rstn;  // indicate EP1 buffer is full 

///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Debug signals
//
//

  assign i_mode = 1'b0;
///////////////////////////////////////////////////////////////////////////////


  assign tm_rstn  = tc_chipRstn & dly_rstn;

  assign ep_rd_ptr  = ep_rd_ptr_1;

  assign slv_status = {3'b111,rx_rxf_n,3'b111,rx_txe_n};


///////////////////////////////////////////////////////////////////////////////
// instantiations 

  fifo_mst_dpath i_fifo_mst_dpath (
    // inputs
    .fifoRstn(tm_rstn),
    .fifoClk(fifoClk),
    .tc_data(tc_data),
    .tc_be(tc_be),
    .tc_rxf_n(tc_rxf_n),
    .tc_txe_n(tc_txe_n),
    .snd_cmd(1'b0),     // NA
    .bus_cmd(4'h0),     // NA
    .tx_data(tx_data),
    .tx_be(m_wr_be_1),
    .ep_num(3'b000),    //NA
    // outputs 
    .tp_data(tp_data),
    .tp_be(tp_be),
    .rx_rxf_n(rx_rxf_n),
    .rx_txe_n(rx_txe_n),
    .rx_data(rx_data),
    .rx_be(rx_be)
  );


  fifo_mst_arb i_fifo_mst_arb (
    // inputs
    .fifoRstn(tm_rstn),
    .fifoClk(fifoClk),
    .idle_st(idle_st),
    .slv_f_st_n(slv_status),
    .mst_f_st_n({3'b111,fifo_full_1,3'b111,fifo_empty_1}),
    .mem_rdy(mem_rdy),
    // outputs
    .grant(grant),
    .t_ep_num(),
    .m_rd_wr(m_rd_wr)
  );


  fifo_mst_fsm #(
    .EPm_MSZ(EPm_MSZ)
    ) i_fifo_mst_fsm (
    // inputs
    .rstn(tm_rstn),
    .clk(fifoClk),
    .tc_txe_n(rx_txe_n),
    .tc_rxf_n(rx_rxf_n),
    .siwu_en(1'b0),  // connect this signal if you need to use it
    .grant(grant),
    .m_rd_wr(m_rd_wr),
    .fifo_full(fifo_full_1),
    .fifo_empty(fifo_empty_1),
    .ld_2_full(ld_2_full_1),
    .ld_2_empty(ld_2_empty_1),
    .ep_rd_ptr(ep_rd_ptr),
    // outputs 
    .idle_st(idle_st),
    .tp_wr_n(tp_wr_n),
    .tp_oe_n(tp_oe_n),
    .tp_rd_n(tp_rd_n),
    .tp_siwu_n(tp_siwu_n),
    .tp_be_oe_n(tp_be_oe_n),
    .u_rd_ptr(u_rd_ptr),
    .c_rd_ptr(c_rd_ptr),
    .mem_cs(mem_cs),
    .mem_wren(mem_wren),
    .mem_rden(mem_rden)
  );

  fifo_mst_ram #(
    .T_MSZ(T_MSZ)
    ) i_fifo_mst_ram (
    // inputs
    .rstn(tm_rstn),
    .clk(fifoClk),
    .wr_en({4{mem_wren}} & rx_be),
    .mem_en(mem_cs),
    .mem_addr(ram_adr_1),
    .mem_din(rx_data),
    // outputs
    .mem_rdy(mem_rdy),
    .mem_do(tx_data)
    );


  fifo_ep_mst #(
    .EP_NUM(3'b001),
    .EP_BASE_ADR(EP1_BASE_ADR),
    .T_MSZ(T_MSZ),
    .EPm_MSZ(EPm_MSZ),
    .EP_MSZ(EPm_MSZ)
    ) i_fifo_ep_mst_1 (
                // inputs
                .fifoRstn(tm_rstn),
                .fifoClk(fifoClk),
                .i_mode(i_mode),
                .m_wr_en(mem_rden),
                .m_rd_en(mem_wren),
                .m_rd_be(rx_be),
                .ep_num(3'b001),
                .m_wr_sel(~m_rd_wr),
                .u_rd_ptr(u_rd_ptr),
                .c_rd_ptr(c_rd_ptr),
                // outputs
                .m_wr_be(m_wr_be_1),
                .ram_adr(ram_adr_1),
                .ep_rd_ptr(ep_rd_ptr_1),
                .fifo_empty(fifo_empty_1),
                .fifo_full(fifo_full_1),
                .ld_2_empty(ld_2_empty_1),
                .ld_2_full(ld_2_full_1)
    );


  fifo_mst_io i_fifo_mst_io (
             // to/from PADS 
             .RESET_N(RESET_N),
             .CLK(CLK),
             .DATA(DATA),
             .BE(BE),
             .TXE_N(TXE_N),
             .RXF_N(RXF_N),
             .SIWU_N(SIWU_N),
             .WR_N(WR_N),
             .RD_N(RD_N),
             .OE_N(OE_N),

             // inputs
             .tp_dt_oe_n(tp_be_oe_n),
             .tp_be_oe_n(tp_be_oe_n),
             .tp_data(tp_data),
             .tp_be(tp_be),
             .tp_siwu_n(tp_siwu_n),
             .tp_wr_n(tp_wr_n),
             .tp_rd_n(tp_rd_n),
             .tp_oe_n(tp_oe_n),

             // outputs
             .tc_chipRstn(tc_chipRstn),
             .tc_clk(fifoClk),
             .tc_data(tc_data),
             .tc_be(tc_be),
             .tc_txe_n(tc_txe_n),
             .tc_rxf_n(tc_rxf_n)
            );

  timer_cntr #(.NUM_BIT(3),
               .INI_ST(3'b111)
              ) i_startup_timer (
  // inputs
    .rstn(tc_chipRstn),
    .clk(fifoClk),
    .enable(1'b1),
    .load(1'b0),
    .count(3'b000),
  // outputs
    .reach_zero(dly_rstn)

  );


endmodule
