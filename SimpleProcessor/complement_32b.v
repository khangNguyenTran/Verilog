// 32-bit 2's Complement circuit
module complement_32b(o_data, i_data);
  output[31:0] o_data;
  input[31:0]  i_data;
  
  wire[31:0]  tmp;
  
  assign tmp = ~i_data;
  fa_32b fa0(
    .o_sum(o_data),
    .i_dataA(tmp),
    .i_dataB(32'b01),
    .i_cin(1'b0)
    );
    
endmodule
