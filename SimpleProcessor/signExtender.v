// 16-bit to 32-bit sign extender
module signExtender_rtl_16to32(o_data, i_data);
  output[31:0] o_data;
  input[15:0]  i_data;
  
  assign o_data[15:0] = i_data;
  mux2to1_rtl #(1) m[31:16](
    .o_res(o_data[31:16]), 
    .i_sel(i_data[15]), 
    .i_data0(1'b0), 
    .i_data1(1'b1)
    );    
endmodule

// n-bit to m-bit sign extender
module signExtender_rtl_NtoM(o_data, i_data);
  parameter n = 16;
  parameter m = 32;
  output[m-1:0] o_data;
  input[n-1:0]  i_data;
  
  assign o_data[n-1:0] = i_data;
  mux2to1_rtl #(1) mu0[m-1:n](
    .o_res(o_data[m-1:n]), 
    .i_sel(i_data[n-1]), 
    .i_data0(1'b0), 
    .i_data1(1'b1)
    );    
endmodule

