//1-bit full adder
module fa_1b(cout,sum,a,b,cin);
output sum, cout;
input a, b, cin;
wire t0, t1, t2;

xor (t0,  a,  b);
xor (sum, t0, cin);

and (t1,  a,   b);
and (t2,  cin, t0);
or (cout, t1,  t2);
endmodule

// 2-bit full adder
module fa_2b( o_cout, o_sum, i_dataA, i_dataB, i_cin);
  output[1:0] o_sum;
  output o_cout;
  input[1:0] i_dataA, i_dataB;
  input i_cin;
  
  wire t0;  
  fa_1b a0 (.cout(t0),     .sum(o_sum[0]),  .a(i_dataA[0]), .b(i_dataB[0]), .cin(i_cin));
  fa_1b a1 (.cout(o_cout), .sum(o_sum[1]),  .a(i_dataA[1]), .b(i_dataB[1]), .cin(t0));
endmodule

// 4-bit full adder
module fa_4b( o_cout, o_sum, i_dataA, i_dataB, i_cin);
  output[3:0] o_sum;
  output o_cout;
  input[3:0] i_dataA, i_dataB;
  input i_cin;
  
  wire t0, t1, t2;  
  fa_1b a0 (.cout(t0),     .sum(o_sum[0]),  .a(i_dataA[0]), .b(i_dataB[0]), .cin(i_cin));
  fa_1b a1 (.cout(t1),     .sum(o_sum[1]),  .a(i_dataA[1]), .b(i_dataB[1]), .cin(t0));
  fa_1b a2 (.cout(t2),     .sum(o_sum[2]),  .a(i_dataA[2]), .b(i_dataB[2]), .cin(t1));
  fa_1b a3 (.cout(o_cout), .sum(o_sum[3]),  .a(i_dataA[3]), .b(i_dataB[3]), .cin(t2));
endmodule

// 8-bit full adder
module fa_8b( o_cout, o_sum, i_dataA, i_dataB, i_cin);
  output[7:0] o_sum;
  output o_cout;
  input[7:0] i_dataA, i_dataB;
  input i_cin;
  
  wire[6:0] t;  
  fa_1b a0 (.cout(t[0]),   .sum(o_sum[0]),  .a(i_dataA[0]), .b(i_dataB[0]), .cin(i_cin));
  fa_1b a1 (.cout(t[1]),   .sum(o_sum[1]),  .a(i_dataA[1]), .b(i_dataB[1]), .cin(t[0]));
  fa_1b a2 (.cout(t[2]),   .sum(o_sum[2]),  .a(i_dataA[2]), .b(i_dataB[2]), .cin(t[1]));
  fa_1b a3 (.cout(t[3]),   .sum(o_sum[3]),  .a(i_dataA[3]), .b(i_dataB[3]), .cin(t[2]));
  fa_1b a4 (.cout(t[4]),   .sum(o_sum[4]),  .a(i_dataA[4]), .b(i_dataB[4]), .cin(t[3]));
  fa_1b a5 (.cout(t[5]),   .sum(o_sum[5]),  .a(i_dataA[5]), .b(i_dataB[5]), .cin(t[4]));
  fa_1b a6 (.cout(t[6]),   .sum(o_sum[6]),  .a(i_dataA[6]), .b(i_dataB[6]), .cin(t[5]));
  fa_1b a7 (.cout(o_cout), .sum(o_sum[7]),  .a(i_dataA[7]), .b(i_dataB[7]), .cin(t[6]));
endmodule


// 16-bit full adder
module fa_16b( o_cout, o_sum, i_dataA, i_dataB, i_cin);
  output[15:0] o_sum;
  output o_cout;
  input[15:0] i_dataA, i_dataB;
  input i_cin;
  
  wire tmp;  
  fa_8b a0 (.o_cout(tmp),    .o_sum(o_sum[7:0]),  .i_dataA(i_dataA[7:0]),  .i_dataB(i_dataB[7:0]),  .i_cin(i_cin));
  fa_8b a1 (.o_cout(o_cout), .o_sum(o_sum[15:8]), .i_dataA(i_dataA[15:8]), .i_dataB(i_dataB[15:8]), .i_cin(tmp));
endmodule

// 32-bit full adder
module fa_32b( o_cout, o_sum, i_dataA, i_dataB, i_cin);
  output[31:0] o_sum;
  output o_cout;
  input[31:0] i_dataA, i_dataB;
  input i_cin;
  
  wire tmp;  
  fa_16b a0 (.o_cout(tmp),    .o_sum(o_sum[15:0]),  .i_dataA(i_dataA[15:0]),  .i_dataB(i_dataB[15:0]),  .i_cin(i_cin));
  fa_16b a1 (.o_cout(o_cout), .o_sum(o_sum[31:16]), .i_dataA(i_dataA[31:16]), .i_dataB(i_dataB[31:16]), .i_cin(tmp));
endmodule









