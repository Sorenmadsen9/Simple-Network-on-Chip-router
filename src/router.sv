module router (
  input logic clk,
  input logic rst_n,

  input logic[36:0] local_in,
  input logic[36:0] north_in,
  input logic[36:0] south_in,
  input logic[36:0] east_in,
  input logic[36:0] west_in,

  output logic[36:0] local_out,
  output logic[36:0] north_out,
  output logic[36:0] south_out,
  output logic[36:0] east_out,
  output logic[36:0] west_out
);

  logic[1:0] selL;

  initial begin
    selL = 2'b01;
  end

  always_comb begin
    case (selL)
        2'b00: north_out = local_in;
        2'b01: north_out = east_in;
        2'b10: north_out = south_in;
        2'b11: north_out = west_in;
    endcase
  end

endmodule
