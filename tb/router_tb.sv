// router_tb.sv
//
// Self-checking testbench for router.sv
//
// Packet format (37 bits), matches router.sv's field slicing:
//   [36]    valid
//   [35:32] dest X (column) -- only low 2 bits meaningful, compared
//                              against local_adr[3:2]
//   [31:28] dest Y (row)    -- only low 2 bits meaningful, compared
//                              against local_adr[1:0]
//   [27:0]  payload
//
// local_adr[3:2] = this router's X (column)
// local_adr[1:0] = this router's Y (row)

`timescale 1ns/1ps

module router_tb;

  logic        clk;
  logic        n_rst;
  logic [3:0]  local_adr;

  logic [36:0] local_in, north_in, south_in, east_in, west_in;
  logic [36:0] local_out, north_out, south_out, east_out, west_out;

  int errors = 0;
  int checks = 0;

  router dut (
    .clk       (clk),
    .n_rst     (n_rst),
    .local_adr (local_adr),
    .local_in  (local_in),
    .north_in  (north_in),
    .south_in  (south_in),
    .east_in   (east_in),
    .west_in   (west_in),
    .local_out (local_out),
    .north_out (north_out),
    .south_out (south_out),
    .east_out  (east_out),
    .west_out  (west_out)
  );

  // 100 MHz clock (unused by the combinational DUT itself, but used here
  // to pace stimulus / sampling, and in case a sequential version is
  // swapped in later)
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // Build a packet: valid | destX(4b) | destY(4b) | payload(28b)
  function automatic logic [36:0] make_pkt(
    input logic       valid,
    input logic [3:0] dest_x,
    input logic [3:0] dest_y,
    input logic [27:0] payload
  );
    return {valid, dest_x, dest_y, payload};
  endfunction

  // Drive local_in with one packet, wait for combinational settle, then
  // check that exactly the expected output port fired with the packet
  // unchanged, and every other output is all-zero.
  task automatic check_route(
    input string      name,
    input logic [3:0] dest_x,
    input logic [3:0] dest_y,
    input logic        exp_local,
    input logic        exp_north,
    input logic        exp_south,
    input logic        exp_east,
    input logic        exp_west
  );
    logic [36:0] pkt;
    begin
      pkt = make_pkt(1'b1, dest_x, dest_y, 28'hABCDE12);
      local_in = pkt;
      #1; // settle combinational logic

      checks++;
      if (exp_local) begin
        if (local_out !== pkt) begin
          $error("[%s] expected local_out == pkt, got local_out=%h pkt=%h", name, local_out, pkt);
          errors++;
        end
      end else if (local_out !== '0) begin
        $error("[%s] expected local_out == 0, got %h", name, local_out);
        errors++;
      end

      if (exp_north) begin
        if (north_out !== pkt) begin
          $error("[%s] expected north_out == pkt, got north_out=%h pkt=%h", name, north_out, pkt);
          errors++;
        end
      end else if (north_out !== '0) begin
        $error("[%s] expected north_out == 0, got %h", name, north_out);
        errors++;
      end

      if (exp_south) begin
        if (south_out !== pkt) begin
          $error("[%s] expected south_out == pkt, got south_out=%h pkt=%h", name, south_out, pkt);
          errors++;
        end
      end else if (south_out !== '0) begin
        $error("[%s] expected south_out == 0, got %h", name, south_out);
        errors++;
      end

      if (exp_east) begin
        if (east_out !== pkt) begin
          $error("[%s] expected east_out == pkt, got east_out=%h pkt=%h", name, east_out, pkt);
          errors++;
        end
      end else if (east_out !== '0) begin
        $error("[%s] expected east_out == 0, got %h", name, east_out);
        errors++;
      end

      if (exp_west) begin
        if (west_out !== pkt) begin
          $error("[%s] expected west_out == pkt, got west_out=%h pkt=%h", name, west_out, pkt);
          errors++;
        end
      end else if (west_out !== '0) begin
        $error("[%s] expected west_out == 0, got %h", name, west_out);
        errors++;
      end

      if (!errors) $display("[PASS] %s (destX=%0d destY=%0d)", name, dest_x, dest_y);
    end
  endtask

  initial begin
    // Static inputs to unused ports for this DUT (not routed, but keep
    // them defined so nothing is X in waveforms)
    north_in = '0;
    south_in = '0;
    east_in  = '0;
    west_in  = '0;
    local_in = '0;
    n_rst    = 1'b0;

    // This router sits at column(X)=1, row(Y)=2
    local_adr = {2'b01, 2'b10};

    @(posedge clk);
    n_rst = 1'b1;
    @(posedge clk);

    // dest X < local X (0 < 1) -> route east
    check_route("dest_x_less_than_local",  4'd0, 4'd2, 0,0,0,1,0);

    // dest X > local X (2 > 1) -> route west
    check_route("dest_x_greater_than_local", 4'd2, 4'd2, 0,0,0,0,1);

    // dest X == local X, dest Y < local Y (0 < 2) -> route north
    check_route("dest_y_less_than_local",  4'd1, 4'd0, 0,1,0,0,0);

    // dest X == local X, dest Y > local Y (3 > 2) -> route south
    check_route("dest_y_greater_than_local", 4'd1, 4'd3, 0,0,1,0,0);

    // dest X == local X, dest Y == local Y -> route local (this is destination)
    check_route("dest_matches_local",      4'd1, 4'd2, 1,0,0,0,0);

    // valid bit low -> nothing should be routed anywhere
    local_in = make_pkt(1'b0, 4'd1, 4'd2, 28'hDEAD001);
    #1;
    checks++;
    if (local_out !== '0 || north_out !== '0 || south_out !== '0 ||
        east_out !== '0 || west_out !== '0) begin
      $error("[invalid_packet_not_routed] expected all outputs 0, got local=%h north=%h south=%h east=%h west=%h",
             local_out, north_out, south_out, east_out, west_out);
      errors++;
    end else begin
      $display("[PASS] invalid_packet_not_routed");
    end

    $display("--------------------------------------------------");
    if (errors == 0)
      $display("ALL %0d CHECKS PASSED", checks);
    else
      $display("%0d/%0d CHECKS FAILED", errors, checks);
    $display("--------------------------------------------------");

    $finish;
  end

endmodule
