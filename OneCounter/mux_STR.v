//n-bit input, n-bit output mux2-1
module mux2to1_str(o_res, i_sel, i_data0, i_data1);
  parameter n = 32; // number of bit 
  output[n-1:0] o_res;
  input i_sel;
  input[n-1:0]  i_data0, i_data1;
  
  wire[n-1:0] tmp[1:0];
  wire sel_;

  not n0(sel_, i_sel);
  and_nx1 #(n) a0(.o_data(tmp[0]), .i_data(i_data0), .i_bit(sel_));
  and_nx1 #(n) a1(.o_data(tmp[1]), .i_data(i_data1), .i_bit(i_sel));
  or o0[n-1:0](o_res, tmp[0], tmp[1]);
endmodule

//n-bit input, n-bit output mux4-1
module mux4to1_str(o_res, i_sel, i_data0, i_data1, i_data2, i_data3);
  parameter n = 32; // number of bit 
  output[n-1:0] o_res;
  input[1:0] i_sel;
  input[n-1:0]  i_data0, i_data1, i_data2, i_data3;
  
  wire[n-1:0] w0[3:0], w1[3:0];
  wire[1:0] sel_;

  not n0[1:0](sel_, i_sel);  
  and a0(w0[0],  sel_[1],  sel_[0]);
  and a1(w0[1],  sel_[1], i_sel[0]);
  and a2(w0[2], i_sel[1],  sel_[0]);
  and a3(w0[3], i_sel[1], i_sel[0]);
  
  and_nx1 #(n) and_nx10(.o_data(w1[0]), .i_data(i_data0), .i_bit(w0[0]));
  and_nx1 #(n) and_nx11(.o_data(w1[1]), .i_data(i_data1), .i_bit(w0[1]));
  and_nx1 #(n) and_nx12(.o_data(w1[2]), .i_data(i_data2), .i_bit(w0[2]));
  and_nx1 #(n) and_nx13(.o_data(w1[3]), .i_data(i_data3), .i_bit(w0[3]));
  or o0[n-1:0](o_res, w1[0], w1[1], w1[2], w1[3]);
endmodule

// 1-bit inputs, 1-bit output mux2-1
module mux2to1_str_1b(o_res, i_sel, i_data0, i_data1);
  output o_res;
  input i_sel;
  input i_data0, i_data1;
  
  wire tmp[1:0];
  wire sel_;
  
  not n0(sel_, i_sel);
  and a0(tmp[0], sel_,   i_data0);
  and a1(tmp[1], i_sel,  i_data1);
  or  o0(o_res,  tmp[0], tmp[1]);
endmodule

// 1-bit inputs, 1-bit output mux4-1
module mux4to1_str_1b(o_res, i_sel, i_data0, i_data1, i_data2, i_data3);
  output o_res;
  input[1:0] i_sel;
  input i_data0, i_data1, i_data2, i_data3;
  
  wire tmp[3:0];
  wire[1:0] sel_;
  
  not n0[1:0](sel_, i_sel);  
  and a0(tmp[0], sel_[1], sel_[0], i_data0);
  and a1(tmp[1], sel_[1], i_sel[0],i_data1);
  and a2(tmp[2], i_sel[1],sel_[0], i_data2);
  and a3(tmp[3], i_sel[1],i_sel[0],i_data3);
  and a4(o_res,  tmp[0],  tmp[1],  tmp[2], tmp[3]);
endmodule
