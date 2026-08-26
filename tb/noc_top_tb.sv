`timescale 1ns/1ns

module noc_top_tb ;
logic clk, rst_n;
logic[36:0] local_in_a, local_in_b, local_in_c, local_in_d, local_in_e;
logic[36:0] local_in_f, local_in_g, local_in_h, local_in_i;
logic[36:0] local_out_a, local_out_b, local_out_c, local_out_d, local_out_e;
logic[36:0] local_out_f, local_out_g, local_out_h, local_out_i;

noc_top dut(
  .clk(clk),
  .rst_n(rst_n),
  .local_in_a(local_in_a),
  .local_in_b(local_in_b),
  .local_in_c(local_in_c),
  .local_in_d(local_in_d),
  .local_in_e(local_in_e),
  .local_in_f(local_in_f),
  .local_in_g(local_in_g),
  .local_in_h(local_in_h),
  .local_in_i(local_in_i),
  .local_out_a(local_out_a),
  .local_out_b(local_out_b),
  .local_out_c(local_out_c),
  .local_out_d(local_out_d),
  .local_out_e(local_out_e),
  .local_out_f(local_out_f),
  .local_out_g(local_out_g),
  .local_out_h(local_out_h),
  .local_out_i(local_out_i)
);

initial begin
  $dumpfile("noc_top_tb.vcd");
  $dumpvars(0, noc_top_tb);
end

initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

// Small task to just print all the input and output values
task automatic print_input_and_output();
  $display(" ");
  $display("IN: a=%b b=%b c=%b     | OUT: a=%b b=%b c=%b     Time=%0t",
              local_in_a[36:30], local_in_b[36:30], local_in_c[36:30],
              local_out_a[36:30], local_out_b[36:30], local_out_c[36:30], $time);
  $display("    d=%b e=%b f=%b     |      d=%b e=%b f=%b",
              local_in_d[36:30], local_in_e[36:30], local_in_f[36:30],
              local_out_d[36:30], local_out_e[36:30], local_out_f[36:30]);
  $display("    g=%b h=%b i=%b     |      g=%b h=%b i=%b",
              local_in_g[36:30], local_in_h[36:30], local_in_i[36:30],
              local_out_g[36:30], local_out_h[36:30], local_out_i[36:30]);

endtask


initial begin
  //Setting the initial value of all inputs
  local_in_a = '0;
  local_in_b = '0;
  local_in_c = '0;
  local_in_d = '0;
  local_in_e = '0;
  local_in_f = '0;
  local_in_g = '0;
  local_in_h = '0;
  local_in_i = '0;

  //restarting the module
  rst_n = 0;
  repeat (2) @(posedge clk);  // hold reset across at least one full edge
  rst_n = 1;
  @(posedge clk);
  #1;

  local_in_a = 37'b1111100000000000000000000000000000000;
  #10;
  print_input_and_output();
  @(posedge clk);
  local_in_a = 37'b0000000000000000000000000000000000000;
  #1;
  print_input_and_output();
  @(posedge clk);
  print_input_and_output();
  @(posedge clk);
  print_input_and_output();
  @(posedge clk);
  print_input_and_output();
  @(posedge clk);
  print_input_and_output();
  @(posedge clk);
  print_input_and_output();
  @(posedge clk);
  print_input_and_output();
  @(posedge clk);



  $finish;

end

endmodule
