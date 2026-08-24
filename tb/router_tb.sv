module router_tb;


// signals
wire clk, n_rst;
wire[3:0] local_adr = 4'b1010;
wire[36:0] local_in, north_in, south_in, east_in, west_in;
wire[36:0] local_out, north_out, south_out, east_out, west_out;


router dut(
  .clk(clk),
  .n_rst(n_rst),
  .local_adr(local_adr),
  .local_in(local_in),
  .north_in(north_in),
  .south_in(south_in),
  .east_in(east_in),
  .west_in(west_in),
  .local_out(local_out),
  .north_out(north_out),
  .south_out(south_out),
  .east_out(east_out),
  .west_out(west_out)
);

initial begin
  local_in <= 37'b1_0000_0000_0000_0000_0000_1111_0000_0000; // Example input
  #10ns;
end

endmodule