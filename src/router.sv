// router.sv
//
// XY-routing router node for a mesh NoC.
// NOTE: this fixes compile-blocking / latch-inference issues found in the
// original module (see chat notes). Behavior for local_in is unchanged;
// north_in/south_in/east_in/west_in are still not routed (out of scope
// of the original code, flagged separately).

module router(
  input  logic        clk,
  input  logic        n_rst,
  input  logic [3:0]  local_adr,

  input  logic [36:0] local_in,
  input  logic [36:0] north_in,
  input  logic [36:0] south_in,
  input  logic [36:0] east_in,
  input  logic [36:0] west_in,

  output logic [36:0] local_out,
  output logic [36:0] north_out,
  output logic [36:0] south_out,
  output logic [36:0] east_out,
  output logic [36:0] west_out
);

  // Pull part-selects out into their own signals first. Icarus Verilog
  // can't do fine-grained sensitivity analysis for constant part-selects
  // used directly inside an always_comb/always_* process ("sorry:
  // constant selects in always_* processes are not fully supported"),
  // so we compute these with continuous assigns instead.
  logic        pkt_valid;
  logic [3:0]  pkt_dest_x, pkt_dest_y;
  logic [3:0]  adr_x, adr_y;

  assign pkt_valid  = local_in[36];
  assign pkt_dest_x = local_in[35:32];
  assign pkt_dest_y = local_in[31:28];
  assign adr_x      = {2'b00, local_adr[3:2]};
  assign adr_y      = {2'b00, local_adr[1:0]};

  always_comb begin
    // Defaults avoid latch inference; also means "no valid packet this
    // cycle" -> all outputs deasserted (valid bit, [36], will be 0).
    local_out = '0;
    north_out = '0;
    south_out = '0;
    east_out  = '0;
    west_out  = '0;

    if (pkt_valid == 1'b1) begin
      if (pkt_dest_x < adr_x) begin
        east_out = local_in;
      end else if (pkt_dest_x > adr_x) begin
        west_out = local_in;
      end else begin // X (dest col) matches this router's column
        if (pkt_dest_y < adr_y) begin
          north_out = local_in;
        end else if (pkt_dest_y > adr_y) begin
          south_out = local_in;
        end else begin // Y (dest row) also matches -> this is the destination
          local_out = local_in;
        end
      end
    end
  end

endmodule
