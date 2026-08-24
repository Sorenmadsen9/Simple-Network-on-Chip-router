module router(
  input logic clk,
  input logic n_rst,
  input logic[3:0] local_adr,

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

begin : routing_local_in
  if(local_in[36] == 1'b1 && local_in[35:32] < local_adr[3:2]) begin
    east_out <= local_in;
  end else if(local_in[36] == 1'b1 && local_in[35:32] > local_adr[3:2]) begin
    west_out <= local_in;
  end else if(local_in[36] == 1'b1 && local_in[35:32] == local_adr[3:2]) begin
    if(local_in[31:28] < local_adr[1:0]) begin
      north_out <= local_in;
    end else if(local_in[31:28] > local_adr[1:0]) begin
      south_out <= local_in;
    end else  if(local_in[31:28] == local_adr[1:0]) begin
      local_out <= local_in;
    end
  end
end


endmodule