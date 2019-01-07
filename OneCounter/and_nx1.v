// and n bits with 1 bit
module and_nx1(o_data, i_data, i_bit);
  parameter n=32;
  output[n-1:0] o_data;
  input[n-1:0] i_data;
  input i_bit;

  and a[n-1:0] (o_data[n-1:0], i_data[n-1:0], i_bit);
 	
endmodule