//////////////////////////
// xKx32 memory model
/////////////////////////

module mem_xKx32_mdl #(
  parameter T_MSZ = 12
) (
input rstn,
input clk,
input ce,
input [3:0]   wen,
input [31:0]  din,
input [T_MSZ-1:0]  addr,
output reg [31:0] qout

);

localparam DEPTH = 1<<T_MSZ;

reg [31:0] ram_dat [0:DEPTH-1];


always @(posedge clk or negedge rstn)
  if (~rstn) begin
    qout <= 0;
    for (integer i=0;i<DEPTH;i=i+1)
      ram_dat[i] <= 0;
  end
  else begin
    if (ce) begin
  
      if (wen[0]) begin
        ram_dat[addr][7:0] <= din[7:0];
        qout[7:0] <= din[7:0];
      end
      else
        qout[7:0] <= ram_dat[addr][7:0];
  
      if (wen[1]) begin
        ram_dat[addr][15:8] <= din[15:8];
        qout[15:8] <= din[15:8];
      end
      else
        qout[15:8] <= ram_dat[addr][15:8];
  
      if (wen[2]) begin
        ram_dat[addr][23:16] <= din[23:16];
        qout[23:16] <= din[23:16];
      end
      else
        qout[23:16] <= ram_dat[addr][23:16];
  
      if (wen[3]) begin
        ram_dat[addr][31:24] <= din[31:24];
        qout[31:24] <= din[31:24];
      end
      else
        qout[31:24] <= ram_dat[addr][31:24];
  
    end
  end    

endmodule

