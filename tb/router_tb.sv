`timescale 1ns/1ps

module router_tb ;

  logic[36:0] local_in;
  logic[36:0] south_in;
  logic[36:0] east_in;
  logic[36:0] west_in;

  logic[36:0] north_out;


    router dut(
        .local_in(local_in),
        .south_in(south_in),
        .east_in(east_in),
        .west_in(west_in),
        .north_out(north_out)
    );

    initial begin
        local_in = 36'd0;
        east_in = 36'd1;
        south_in = 36'd2;
        west_in = 36'd3;

        #10;
        $display("east_in=%b, north_out=%b", east_in, north_out);

        east_in = 36'd2;

        #10;
        $display("east_in=%b, north_out=%b", east_in, north_out);

        #10;
        $finish;
    end

    
endmodule