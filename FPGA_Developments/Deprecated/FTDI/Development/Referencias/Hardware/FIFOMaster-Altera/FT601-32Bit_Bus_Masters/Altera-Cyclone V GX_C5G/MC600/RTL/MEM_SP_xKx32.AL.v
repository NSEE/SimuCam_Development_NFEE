`ifndef FTDI_SIM
  `include "define_conf.v"
`endif

`include "../RTL/memory/C5_SP_4Kx32.v"

module  MEM_SP_xKx32 #(
  parameter T_MSZ = 12
) (
  input  wire        rstn,
  output wire [31:0] Q,
  input  wire [31:0] D,
  input  wire [T_MSZ-1:0] A,
  input  wire        CE,
  input  wire [3:0]  WE,
  input  wire        CLK
  );


`ifdef FTDI_SIM

  mem_xKx32_mdl #(
  .T_MSZ(T_MSZ)
  ) i_mem_xKx32_mdl (
    .rstn(rstn),
    .clk(CLK),
    .ce(CE),
    .wen(WE),
    .din(D), 
    .addr(A), 
    .qout(Q) 
  );  

`else

  C5_SP_4Kx32 i_C5_SP_4Kx32 (
  .data(D),
  .address(A),
  .byteena(WE),
  .rden(CE),
  .wren(((|WE) & CE)),
  .clock(CLK),
  .q(Q)
  );

`endif


endmodule

