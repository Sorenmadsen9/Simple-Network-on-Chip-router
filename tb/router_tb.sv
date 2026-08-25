`timescale 1ns/1ps

module router_tb ;
logic clk, rst_n;
logic[3:0] location;
logic[36:0] east_in, west_in, north_in, south_in, local_in;
logic[36:0] east_out, west_out, north_out, south_out, local_out;

router dut(
  .clk(clk),
  .rst_n(rst_n),
  .location(location),
  .east_in(east_in),
  .west_in(west_in),
  .north_in(north_in),
  .south_in(south_in),
  .local_in(local_in),
  .east_out(east_out),
  .west_out(west_out),
  .north_out(north_out),
  .south_out(south_out),
  .local_out(local_out)
);

initial begin
  $dumpfile("router_tb.vcd");
  $dumpvars(0, router_tb);
end

initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

// port enum for helper task
typedef enum { EAST, WEST, NORTH, SOUTH, LOCAL } port_e;

// Helper task: drive local_in, wait one clock for the register to update,
// then print the result
task automatic drive_and_print(input port_e port, input logic[36:0] val);

  // reset all inputs to 0 first so only the selected port carries traffic
  east_in  = '0;
  west_in  = '0;
  north_in = '0;
  south_in = '0;
  local_in = '0;

  case(port)
    EAST:  east_in  = val;
    WEST:  west_in  = val;
    NORTH: north_in = val;
    SOUTH: south_in = val;
    LOCAL: local_in = val;
    default: local_in = val;  // should never happen
  endcase

  @(posedge clk);
  #1;
  $display("port=%s, in=%b | east_out=%b west_out=%b north_out=%b south_out=%b local_out=%b",
            port.name(), val[36:30],
            east_out[36:30], west_out[36:30], north_out[36:30],
            south_out[36:30], local_out[36:30]);
endtask

initial begin
  // Drive every input to a known value up front
  east_in  = '0;
  west_in  = '0;
  north_in = '0;
  south_in = '0;
  local_in = '0;

  //The location of the testing router
  location = 4'b1010;

  //restarting the module
  rst_n = 0;
  repeat (2) @(posedge clk);  // hold reset across at least one full edge
  rst_n = 1;
  @(posedge clk);
  #1;

  $display(" ");
  $display("Router location=%b", location);
  $display(" ");

  $display("Send emptly packages to all inputs at once");
  drive_and_print(EAST, 37'b0000000000000000000000000000000000000);
  drive_and_print(WEST, 37'b0000000000000000000000000000000000000);
  drive_and_print(NORTH, 37'b0000000000000000000000000000000000000);
  drive_and_print(SOUTH, 37'b0000000000000000000000000000000000000);
  drive_and_print(LOCAL, 37'b0000000000000000000000000000000000000);
  $display(" ");

  $display("Send emptly packages to all inputs one by one");
  drive_and_print(EAST, 37'b0000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b0000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b0000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b0000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b0000000000000000000000000000000000000);
  $display(" ");

  $display("Testing all 16 possible headers one by one from east");
  drive_and_print(EAST, 37'b1000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1000100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1001000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1001100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1010000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1010100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1011000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1011100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1100000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1100100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1101000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1101100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1110000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1110100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1111000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(EAST, 37'b1111100000000000000000000000000000000);
  @(posedge clk);
  $display(" ");

  $display("Testing all 16 possible headers one by one from west");
  drive_and_print(WEST, 37'b1000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1000100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1001000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1001100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1010000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1010100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1011000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1011100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1100000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1100100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1101000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1101100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1110000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1110100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1111000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(WEST, 37'b1111100000000000000000000000000000000);
  @(posedge clk);
  $display(" ");

  $display("Testing all 16 possible headers one by one from north");
  drive_and_print(NORTH, 37'b1000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1000100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1001000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1001100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1010000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1010100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1011000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1011100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1100000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1100100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1101000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1101100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1110000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1110100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1111000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(NORTH, 37'b1111100000000000000000000000000000000);
  @(posedge clk);
  $display(" ");

  $display("Testing all 16 possible headers one by one from south");
  drive_and_print(SOUTH, 37'b1000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1000100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1001000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1001100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1010000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1010100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1011000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1011100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1100000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1100100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1101000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1101100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1110000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1110100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1111000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(SOUTH, 37'b1111100000000000000000000000000000000);
  @(posedge clk);
  $display(" ");

  $display("Testing all 16 possible headers one by one from local");
  drive_and_print(LOCAL, 37'b1000000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1000100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1001000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1001100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1010000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1010100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1011000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1011100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1100000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1100100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1101000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1101100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1110000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1110100000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1111000000000000000000000000000000000);
  @(posedge clk);
  drive_and_print(LOCAL, 37'b1111100000000000000000000000000000000);
  @(posedge clk);
  $display(" ");


  $finish;
end

endmodule
