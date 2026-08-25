`timescale 1ns/1ps

module router_tb ;
  logic clk;
  logic rst_n;
  logic[3:0] location;

  logic[36:0] east_in;
  logic[36:0] west_in;
  logic[36:0] north_in;
  logic[36:0] south_in;
  logic[36:0] local_in;

  logic[36:0] east_out;
  logic[36:0] west_out;
  logic[36:0] north_out;
  logic[36:0] south_out;
  logic[36:0] local_out;


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
        //restarting the module
        rst_n = 0;
        clk = 0;
        #10;
        rst_n = 1;

        //The location of the testing router
        location = 4'b1010;

        local_in = 37'b0000000000000000000000000000000000000;
        clk = 1;
        #1;
        clk = 0;
        $display("local_in=%b, east_out=%b", local_in[36:30], east_out[36:30]);

        #10;
        local_in = 37'b0001100000000000000000000000000000000;
        clk = 1;
        #1;
        clk = 0;
        $display("local_in=%b, east_out=%b", local_in[36:30], east_out[36:30]);

        #10;
        local_in = 37'b1001100000000000000000000000000000000;
        clk = 1;
        #1;
        clk = 0;
        $display("local_in=%b, east_out=%b", local_in[36:30], east_out[36:30]);

        #10
        local_in = 37'b1000100000000000000000000000000000000;
        clk = 1;
        #1;
        clk = 0;
        $display("local_in=%b, east_out=%b", local_in[36:30], east_out[36:30]);

        #10
        local_in = 37'b1111100000000000000000000000000000000;
        clk = 1;
        #1;
        clk = 0;
        $display("local_in=%b, east_out=%b", local_in[36:30], east_out[36:30]);


        $finish;
    end

endmodule
