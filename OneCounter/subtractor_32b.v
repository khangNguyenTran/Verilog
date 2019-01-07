// 32-bit subtractor from 32-bit fulladder
module subtractor_32b(o_cout, o_res, i_dataA, i_dataB, i_cin);
  output o_cout;
  output[31:0] o_res;
  input[31:0]  i_dataA, i_dataB;
  input i_cin;
  
  wire[31:0] tmp;
  wire cout_;
  assign o_cout = ~cout_;
  complement_32b c0 (
    .o_data(tmp),
    .i_data(i_dataB)
    );
    
  fa_32b fa0(
    .o_cout(cout_),
    .o_sum(o_res),
    .i_dataA(i_dataA),
    .i_dataB(tmp),
    .i_cin(i_cin)
    );
    
endmodule

