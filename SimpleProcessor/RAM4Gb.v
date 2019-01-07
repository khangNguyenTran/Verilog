
module dataMem_beh(o_data, i_data, i_add, i_writeEn, i_readEn, i_en);
  parameter n = 32, m = 32;
  //n: number of addresses
  //m: number of bits for each address 
  output[n-1:0] o_data;
  input [n-1:0] i_data;
  input [m-1:0] i_add;
  input i_writeEn, i_readEn, i_en;
  
  reg[n-1:0] o_data;
  reg[m-1:0] memoryCell [n-1:0];
  
  always@(i_data or i_add or i_writeEn or i_readEn or i_en)begin
    if(i_en)begin
      if(i_readEn)
          o_data <= memoryCell[i_add];
      else if(i_writeEn)
          memoryCell[i_add] <= i_data;
      memoryCell['b0] <= 'b0; 
    end else
      o_data <= 'bz;
  end
endmodule