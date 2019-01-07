//n-bit input, n-bit output mux2-1
module mux2to1_rtl(o_res, i_sel, i_data0, i_data1);
  parameter n = 32; // number of bit 
  output[n-1:0] o_res;
  input i_sel;
  input[n-1:0]  i_data0, i_data1;
  
  wire[n-1:0] tmp[1:0];
  wire sel_;

  assign sel_ = ~i_sel;
  and_nx1 #(n) a0(.o_data(tmp[0]), .i_data(i_data0), .i_bit(sel_));
  and_nx1 #(n) a1(.o_data(tmp[1]), .i_data(i_data1), .i_bit(i_sel));
  assign o_res = tmp[0] | tmp[1];
endmodule

//n-bit input, n-bit output mux4-1
module mux4to1_rtl(o_res, i_sel, i_data0, i_data1, i_data2, i_data3);
  parameter n = 32; // number of bit 
  output[n-1:0] o_res;
  input[1:0] i_sel;
  input[n-1:0]  i_data0, i_data1, i_data2, i_data3;
  
  wire[n-1:0] w0[3:0], w1[3:0];
  wire[1:0] sel_;

  assign sel_ = ~i_sel;  
  assign w0[0] =  sel_[1] &  sel_[0];
  assign w0[1] =  sel_[1] & i_sel[0];
  assign w0[2] = i_sel[1] &  sel_[0];
  assign w0[3] = i_sel[1] & i_sel[0];
  
  and_nx1 #(n) and_nx10(.o_data(w1[0]), .i_data(i_data0), .i_bit(w0[0]));
  and_nx1 #(n) and_nx11(.o_data(w1[1]), .i_data(i_data1), .i_bit(w0[1]));
  and_nx1 #(n) and_nx12(.o_data(w1[2]), .i_data(i_data2), .i_bit(w0[2]));
  and_nx1 #(n) and_nx13(.o_data(w1[3]), .i_data(i_data3), .i_bit(w0[3]));
  assign o_res = w1[0] | w1[1] | w1[2] | w1[3];
endmodule

// 1-bit inputs, 1-bit output mux2-1
module mux2to1_rtl_1b(o_res, i_sel, i_bit0, i_bit1);
  output o_res;
  input i_sel;
  input i_bit0, i_bit1;
  
  wire tmp[1:0];
  
  assign tmp[0] = ~i_sel  & i_bit0;
  assign tmp[1] = i_sel & i_bit1;
  assign o_res  = tmp[0] | tmp[1];
endmodule

// 1-bit inputs, 1-bit output mux4-1
module mux4to1_rtl_1b(o_res, i_sel, i_bit0, i_bit1, i_bit2, i_bit3);
  output o_res;
  input[1:0] i_sel;
  input i_bit0, i_bit1, i_bit2, i_bit3;
  
  wire tmp[3:0];
  
  assign tmp[0] = ~i_sel[1] & ~i_sel[0] & i_bit0;
  assign tmp[1] = ~i_sel[1] & i_sel[0]  & i_bit1;
  assign tmp[2] = i_sel[1]  & ~i_sel[0] & i_bit2;
  assign tmp[3] = i_sel[1]  & i_sel[0]  & i_bit3;
  assign o_res  = tmp[0] | tmp[1] | tmp[2] | tmp[3];
endmodule

// 32-bit inputs, 32-bit output mux2-1
module mux2to1_rtl_32b(o_res, i_sel, i_data0, i_data1);
  output[31:0] o_res;
  input i_sel;
  input[31:0] i_data0, i_data1;
  
  wire[1:0] tmp;
  wire[31:0] res[1:0];
  assign tmp[0] = !i_sel;
  assign tmp[1] =  i_sel;
  
  and_32x1 a0(.o_data(res[0]), .i_bit(tmp[0]), .i_data(i_data0));
  and_32x1 a1(.o_data(res[1]), .i_bit(tmp[1]), .i_data(i_data1));
  
  assign o_res = res[0] | res[1];
endmodule

// 32-bit inputs, 32-bit output mux4-1
module mux4to1_rtl_32b(o_res, i_sel, i_data0, i_data1, i_data2, i_data3);
  output[31:0] o_res;
  input[1:0] i_sel;
  input[31:0] i_data0, i_data1, i_data2, i_data3;
  
  wire[3:0] tmp;
  wire[31:0] res[3:0];
  assign tmp[0] = (!i_sel[1]  & !i_sel[0]);
  assign tmp[1] = (!i_sel[1]  &  i_sel[0]);
  assign tmp[2] = ( i_sel[1]  & !i_sel[0]);
  assign tmp[3] = ( i_sel[1]  &  i_sel[0]);
  
  and_32x1 a0(.o_data(res[0]), .i_bit(tmp[0]), .i_data(i_data0));
  and_32x1 a1(.o_data(res[1]), .i_bit(tmp[1]), .i_data(i_data1));
  and_32x1 a2(.o_data(res[2]), .i_bit(tmp[2]), .i_data(i_data2));
  and_32x1 a3(.o_data(res[3]), .i_bit(tmp[3]), .i_data(i_data3));
  
  assign o_res  = res[0] | res[1] | res[2] | res[3];
endmodule


// 32-bit inputs, 32-bit output mux8-1
module mux8to1_rtl_32b(o_res, i_sel, i_data0, i_data1, i_data2, i_data3, i_data4, i_data5, i_data6, i_data7);
  output[31:0] o_res;
  input[2:0] i_sel;
  input[31:0] i_data0, i_data1, i_data2, i_data3, i_data4, i_data5, i_data6, i_data7;
  
  wire[7:0] tmp;
  wire[31:0] res[7:0];
  assign tmp[0] = (!i_sel[2] & !i_sel[1]  & !i_sel[0]);
  assign tmp[1] = (!i_sel[2] & !i_sel[1]  &  i_sel[0]);
  assign tmp[2] = (!i_sel[2] &  i_sel[1]  & !i_sel[0]);
  assign tmp[3] = (!i_sel[2] &  i_sel[1]  &  i_sel[0]);
  assign tmp[4] = (i_sel[2]  & !i_sel[1]  & !i_sel[0]);
  assign tmp[5] = (i_sel[2]  & !i_sel[1]  &  i_sel[0]);
  assign tmp[6] = (i_sel[2]  &  i_sel[1]  & !i_sel[0]);
  assign tmp[7] = (i_sel[2]  &  i_sel[1]  &  i_sel[0]);
  
  and_32x1 a0(.o_data(res[0]), .i_bit(tmp[0]), .i_data(i_data0));
  and_32x1 a1(.o_data(res[1]), .i_bit(tmp[1]), .i_data(i_data1));
  and_32x1 a2(.o_data(res[2]), .i_bit(tmp[2]), .i_data(i_data2));
  and_32x1 a3(.o_data(res[3]), .i_bit(tmp[3]), .i_data(i_data3));
  and_32x1 a4(.o_data(res[4]), .i_bit(tmp[4]), .i_data(i_data4));
  and_32x1 a5(.o_data(res[5]), .i_bit(tmp[5]), .i_data(i_data5));
  and_32x1 a6(.o_data(res[6]), .i_bit(tmp[6]), .i_data(i_data6));
  and_32x1 a7(.o_data(res[7]), .i_bit(tmp[7]), .i_data(i_data7));
  
  assign o_res  = res[0] | res[1] | res[2] | res[3] | res[4] | res[5] | res[6] | res[7];
endmodule




