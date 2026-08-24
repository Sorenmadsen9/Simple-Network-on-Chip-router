module router (
  input logic clk,
  input logic rst_n,

  input logic[35:0] local_in,
  input logic[35:0] north_in,
  input logic[35:0] south_in,
  input logic[35:0] east_in,
  input logic[35:0] west_in,

  output logic[35:0] local_out,
  output logic[35:0] north_out,
  output logic[35:0] south_out,
  output logic[35:0] east_out,
  output logic[35:0] west_out
);

// state type def
typedef enum logic[4:0] {idle, comp_x, comp_y} state_t;
state_t state, next_state;

// state reg
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state <= idle;
  end else begin
    state <= next_state;
  end
end

// state and output logic
always_comb begin
  // defaults
  next_state = state;

  case(state)
    idle: begin
      
    end

    comp_x: begin
      
    end

    comp_y: begin
      
    end

end
  
