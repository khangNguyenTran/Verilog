
//2-4 decoder
module decoder_2to4(o_bit0, o_bit1, o_bit2, o_bit3, i_sel);
	output o_bit0, o_bit1, o_bit2, o_bit3;
	input[1:0] i_sel;
	
	assign o_bit0 = !i_sel[1] & !i_sel[0];
	assign o_bit1 = !i_sel[1] &  i_sel[0];
	assign o_bit2 =  i_sel[1] & !i_sel[0];
	assign o_bit3 =  i_sel[1] &  i_sel[0];
endmodule

//5-32 decoder
module decoder_5to32(
  o_bit0, o_bit1, o_bit2, o_bit3, o_bit4, o_bit5, o_bit6, o_bit7, 
  o_bit8, o_bit9, o_bit10, o_bit11, o_bit12, o_bit13, o_bit14, o_bit15, 
  o_bit16, o_bit17, o_bit18, o_bit19, o_bit20, o_bit21, o_bit22, o_bit23, 
  o_bit24, o_bit25, o_bit26, o_bit27, o_bit28, o_bit29, o_bit30, o_bit31, 
  i_sel
  );

	output o_bit0, o_bit1, o_bit2, o_bit3, o_bit4, o_bit5, o_bit6, o_bit7, 
  o_bit8, o_bit9, o_bit10, o_bit11, o_bit12, o_bit13, o_bit14, o_bit15, 
  o_bit16, o_bit17, o_bit18, o_bit19, o_bit20, o_bit21, o_bit22, o_bit23, 
  o_bit24, o_bit25, o_bit26, o_bit27, o_bit28, o_bit29, o_bit30, o_bit31; 
  
	input[4:0] i_sel;
	
	assign o_bit0  = !i_sel[4] & !i_sel[3] & !i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit1  = !i_sel[4] & !i_sel[3] & !i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit2  = !i_sel[4] & !i_sel[3] & !i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit3  = !i_sel[4] & !i_sel[3] & !i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit4  = !i_sel[4] & !i_sel[3] &  i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit5  = !i_sel[4] & !i_sel[3] &  i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit6  = !i_sel[4] & !i_sel[3] &  i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit7  = !i_sel[4] & !i_sel[3] &  i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit8  = !i_sel[4] &  i_sel[3] & !i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit9  = !i_sel[4] &  i_sel[3] & !i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit10 = !i_sel[4] &  i_sel[3] & !i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit11 = !i_sel[4] &  i_sel[3] & !i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit12 = !i_sel[4] &  i_sel[3] &  i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit13 = !i_sel[4] &  i_sel[3] &  i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit14 = !i_sel[4] &  i_sel[3] &  i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit15 = !i_sel[4] &  i_sel[3] &  i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit16 =  i_sel[4] & !i_sel[3] & !i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit17 =  i_sel[4] & !i_sel[3] & !i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit18 =  i_sel[4] & !i_sel[3] & !i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit19 =  i_sel[4] & !i_sel[3] & !i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit20 =  i_sel[4] & !i_sel[3] &  i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit21 =  i_sel[4] & !i_sel[3] &  i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit22 =  i_sel[4] & !i_sel[3] &  i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit23 =  i_sel[4] & !i_sel[3] &  i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit24 =  i_sel[4] &  i_sel[3] & !i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit25 =  i_sel[4] &  i_sel[3] & !i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit26 =  i_sel[4] &  i_sel[3] & !i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit27 =  i_sel[4] &  i_sel[3] & !i_sel[2] &  i_sel[1] &  i_sel[0];
	assign o_bit28 =  i_sel[4] &  i_sel[3] &  i_sel[2] & !i_sel[1] & !i_sel[0];
	assign o_bit29 =  i_sel[4] &  i_sel[3] &  i_sel[2] & !i_sel[1] &  i_sel[0];
	assign o_bit30 =  i_sel[4] &  i_sel[3] &  i_sel[2] &  i_sel[1] & !i_sel[0];
	assign o_bit31 =  i_sel[4] &  i_sel[3] &  i_sel[2] &  i_sel[1] &  i_sel[0];

endmodule

