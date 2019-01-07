//n-bit shifter
module shifter_nb(o_data, i_bit, i_loadData, i_leftRight, i_loadEn_, i_clr_, i_clk);
  parameter n = 8;
  output[n-1:0] o_data;
  input [n-1:0] i_loadData;
  input i_bit, i_leftRight, i_loadEn_, i_clr_, i_clk; 
  //asynchronous clear and synchronous load
  reg [n-1:0] data;
  
  assign o_data = data;
  always @ (posedge i_clk or negedge i_clr_) begin
      if (~i_clr_)
  		    data <= 'b0;
      else if (~i_loadEn_)
  	     	data <= i_loadData;
      else if(!i_leftRight)
    	    data <= {data[n-2:0], i_bit};
  	   else	if(i_leftRight)
  	   	  data <= {i_bit, data[n-1:1]};
  end  
endmodule
//8-bit shifter 
module shifter_8b (o_data, i_bit, i_loadData, i_leftRight, i_loadEn_, i_clr_, i_clk);
output[7:0] o_data;
input [7:0] i_loadData;
input i_bit, i_leftRight, i_loadEn_, i_clr_, i_clk; 
//asynchronous clear and synchronous load
reg [7:0] data;

assign o_data = data;
always @ (posedge i_clk or negedge i_clr_) begin
    if (~i_clr_)
		data <= 0;
    else if (~i_loadEn_)
		data <= i_loadData;
    else if(!i_leftRight)
  	   	data <= {data[6:0], i_bit};
	  else	if(i_leftRight)
	   	  data <= {i_bit, data[7:1]};
end
endmodule

//n-bit behavior shifter, 1 bit per clock
module shifter_beh_1 (o_data, i_bit, i_loadData, i_leftRight, i_loadEn_, i_clr_, i_clk);
  parameter nobit = 32;
  output[nobit:0] o_data;
  input[nobit:0]  i_loadData;
  input i_bit, i_leftRight, i_loadEn_, i_clr_, i_clk;   //left:0, right:1
  
  //asynchronous clear and synchronous load
  reg [nobit-1:0] data;
  
  assign o_data = data;
  always @(posedge i_clk or negedge i_clr_) begin
      if (~i_clr_)
  		  data <= 'b0;
      else if (~i_loadEn_)
  		  data <= i_loadData;
      else if(!i_leftRight)
  	   	data <= {data[nobit -2:0], i_bit};
	   	else if(i_leftRight)
	   	  data <= {i_bit, data[nobit -1:1]};
  end
endmodule

//n-bit behavior shifter, 2 bit per clock
module shifter_beh_2 (o_data, i_bits, i_loadData, i_leftRight, i_loadEn_, i_clr_, i_clk);
  parameter nobit = 32;
  output[nobit:0] o_data;
  input[nobit:0]  i_loadData;
  input[1:0] i_bits;
  input i_leftRight, i_loadEn_, i_clr_, i_clk;   //left:0, right:1
  
  //asynchronous clear and synchronous load
  reg [nobit-1:0] data;
  
  assign o_data = data;
  always @(posedge i_clk or negedge i_clr_) begin
      if (~i_clr_)
  		  data <= 'b0;
      else if (~i_loadEn_)
  		  data <= i_loadData;
      else if(!i_leftRight)
  	   	data <= {data[nobit -3:0], i_bits};
	   	else if(i_leftRight)
	   	  data <= {i_bits, data[nobit -1:2]};
  end
endmodule

//n-bit behavior shifter, 2 bit per clock
module shifter_beh_3 (o_data, i_bits, i_loadData, i_leftRight);
  parameter nobit = 32;
  output[nobit:0] o_data;
  input[nobit:0]  i_loadData;
  input[1:0] i_bits;
  input i_leftRight;   //left:0, right:1
  
  //asynchronous clear and synchronous load
  reg [nobit-1:0] data;
  
  assign o_data = (i_leftRight)? {i_bits, i_loadData[nobit -1:2]}: {i_loadData[nobit -3:0], i_bits};  
endmodule