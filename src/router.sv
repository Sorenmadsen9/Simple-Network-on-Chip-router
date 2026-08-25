module router (
  input logic clk,
  input logic rst_n,

  //The location of the router
  input logic[3:0] location,

  input logic[36:0] east_in,
  input logic[36:0] west_in,
  input logic[36:0] north_in,
  input logic[36:0] south_in,
  input logic[36:0] local_in,

  output logic[36:0] east_out,
  output logic[36:0] west_out,
  output logic[36:0] north_out,
  output logic[36:0] south_out,
  output logic[36:0] local_out
);

  //selects which input are assigned to an output
  //0XX -> the output should be 37'd0 
  //1YY -> output is the input if address YY
  logic[2:0] selE;
  logic[2:0] selW;
  logic[2:0] selN;
  logic[2:0] selS;
  logic[2:0] selL;

  //Creating all registers and wiring them to their outputs
  logic[36:0] east_reg;
  logic[36:0] west_reg;
  logic[36:0] north_reg;
  logic[36:0] south_reg;
  logic[36:0] local_reg;
  assign east_out = east_reg;
  assign west_out = west_reg;
  assign north_out = north_reg;
  assign south_out = south_reg;
  assign local_out = local_reg;

  always_ff @(posedge clk) begin
    if(!rst_n) begin
      // Default
      east_reg <= 37'd0;
      west_reg <= 37'd0;
      north_reg <= 37'd0;
      south_reg <= 37'd0;
      local_reg <= 37'd0;

    end else begin
      // Default
      east_reg <= 37'd0;
      west_reg <= 37'd0;
      north_reg <= 37'd0;
      south_reg <= 37'd0;
      local_reg <= 37'd0;

      //  ***DETERMINING WHICH PACKAGE MOVES EAST***
      // Looking at the package from east
      if(west_in[36] == 1'b1) begin
        if(west_in[33:32] > location[1:0]) begin
          east_reg <= west_in;
        end
      end else if(north_in[36] == 1'b1) begin
        if(north_in[33:32] > location[1:0]) begin
          east_reg <= north_in;
        end
      end else if(south_in[36] == 1'b1) begin
        if(south_in[33:32] > location[1:0]) begin
          east_reg <= south_in;
        end
      end else if(local_in[36] == 1'b1) begin
        if(local_in[33:32] > location[1:0]) begin
          east_reg <= local_in;
        end
      end
    end
  end


endmodule
