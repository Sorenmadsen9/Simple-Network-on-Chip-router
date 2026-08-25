// top module for 3x3 torus-connected routers

module noc_top (
  input  logic clk,
  input  logic rst_n,

  // inputs
  input  logic [36:0] local_in_a,
  input  logic [36:0] local_in_b,
  input  logic [36:0] local_in_c,
  input  logic [36:0] local_in_d,
  input  logic [36:0] local_in_e,
  input  logic [36:0] local_in_f,
  input  logic [36:0] local_in_g,
  input  logic [36:0] local_in_h,
  input  logic [36:0] local_in_i,

  // outputs
  output logic [36:0] local_out_a,
  output logic [36:0] local_out_b,
  output logic [36:0] local_out_c,
  output logic [36:0] local_out_d,
  output logic [36:0] local_out_e,
  output logic [36:0] local_out_f,
  output logic [36:0] local_out_g,
  output logic [36:0] local_out_h,
  output logic [36:0] local_out_i
);

  // row rings
  logic [36:0] a_b_e, b_c_e, c_a_e;      // row y=01 east
  logic [36:0] b_a_w, c_b_w, a_c_w;      // row y=01 west
  logic [36:0] d_e_e, e_f_e, f_d_e;      // row y=10 east
  logic [36:0] e_d_w, f_e_w, d_f_w;      // row y=10 west
  logic [36:0] g_h_e, h_i_e, i_g_e;      // row y=11 east
  logic [36:0] h_g_w, i_h_w, g_i_w;      // row y=11 west

  // column rings
  logic [36:0] a_d_s, d_g_s, g_a_s;      // column x=01 south
  logic [36:0] d_a_n, g_d_n, a_g_n;      // column x=01 north
  logic [36:0] b_e_s, e_h_s, h_b_s;      // column x=10 south
  logic [36:0] e_b_n, h_e_n, b_h_n;      // column x=10 north
  logic [36:0] c_f_s, f_i_s, i_c_s;      // column x=11 south
  logic [36:0] f_c_n, i_f_n, c_i_n;      // column x=11 north

  // ***SETTING UP ALL THE ROUTERS***
  // A, location 0101. East B, west C, south D, north G
  router u_a (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b01_01),
    .east_in   (b_a_w),
    .west_in   (c_a_e),
    .north_in  (g_a_s),
    .south_in  (d_a_n),
    .local_in  (local_in_a),
    .east_out  (a_b_e),
    .west_out  (a_c_w),
    .north_out (a_g_n),
    .south_out (a_d_s),
    .local_out (local_out_a)
  );

  // B, location 0110. East C, west A, south E, north H
  router u_b (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b01_10),
    .east_in   (c_b_w),
    .west_in   (a_b_e),
    .north_in  (h_b_s),
    .south_in  (e_b_n),
    .local_in  (local_in_b),
    .east_out  (b_c_e),
    .west_out  (b_a_w),
    .north_out (b_h_n),
    .south_out (b_e_s),
    .local_out (local_out_b)
  );

  // C, location 0111. East A , west B, south F, north I
  router u_c (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b01_11),
    .east_in   (a_c_w),
    .west_in   (b_c_e),
    .north_in  (i_c_s),
    .south_in  (f_c_n),
    .local_in  (local_in_c),
    .east_out  (c_a_e),
    .west_out  (c_b_w),
    .north_out (c_i_n),
    .south_out (c_f_s),
    .local_out (local_out_c)
  );

  // D, location 1001. east E, west F , south G, north A
  router u_d (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b10_01),
    .east_in   (e_d_w),
    .west_in   (f_d_e),
    .north_in  (a_d_s),
    .south_in  (g_d_n),
    .local_in  (local_in_d),
    .east_out  (d_e_e),
    .west_out  (d_f_w),
    .north_out (d_a_n),
    .south_out (d_g_s),
    .local_out (local_out_d)
  );

  // E, centre, location 1010. east F, west D, south H, north B
  router u_e (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b10_10),
    .east_in   (f_e_w),
    .west_in   (d_e_e),
    .north_in  (b_e_s),
    .south_in  (h_e_n),
    .local_in  (local_in_e),
    .east_out  (e_f_e),
    .west_out  (e_d_w),
    .north_out (e_b_n),
    .south_out (e_h_s),
    .local_out (local_out_e)
  );

  //  F, location 1011. east D , west E, south I, north C
  router u_f (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b10_11),
    .east_in   (d_f_w),
    .west_in   (e_f_e),
    .north_in  (c_f_s),
    .south_in  (i_f_n),
    .local_in  (local_in_f),
    .east_out  (f_d_e),
    .west_out  (f_e_w),
    .north_out (f_c_n),
    .south_out (f_i_s),
    .local_out (local_out_f)
  );

  // G, location 1101. east H, west I , south A , north D
  router u_g (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b11_01),
    .east_in   (h_g_w),
    .west_in   (i_g_e),
    .north_in  (d_g_s),
    .south_in  (a_g_n),
    .local_in  (local_in_g),
    .east_out  (g_h_e),
    .west_out  (g_i_w),
    .north_out (g_d_n),
    .south_out (g_a_s),
    .local_out (local_out_g)
  );

  // H, location 1110. east I, west G, south B , north E
  router u_h (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b11_10),
    .east_in   (i_h_w),
    .west_in   (g_h_e),
    .north_in  (e_h_s),
    .south_in  (b_h_n),
    .local_in  (local_in_h),
    .east_out  (h_i_e),
    .west_out  (h_g_w),
    .north_out (h_e_n),
    .south_out (h_b_s),
    .local_out (local_out_h)
  );

  // I, location 1111. east G , west H, south C , north F
  router u_i (
    .clk       (clk),
    .rst_n     (rst_n),
    .location  (4'b11_11),
    .east_in   (g_i_w),
    .west_in   (h_i_e),
    .north_in  (f_i_s),
    .south_in  (c_i_n),
    .local_in  (local_in_i),
    .east_out  (i_g_e),
    .west_out  (i_h_w),
    .north_out (i_f_n),
    .south_out (i_c_s),
    .local_out (local_out_i)
  );

endmodule
