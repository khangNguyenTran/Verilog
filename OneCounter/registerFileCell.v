//structural register file cell
module RFC(o_bit1, o_bit2, i_bit, i_readEn1, i_readEn2, i_writeEn, i_clk);
	output o_bit1, o_bit2;
	input i_bit, i_readEn1, i_readEn2, i_writeEn, i_clk;
	
	wire w[2:0];
	wire qout, writeEn_;
  not n0(writeEn_, i_writeEn);
  and a0(w[0], i_writeEn, i_bit);
	and a1(w[1], qout, writeEn_);
	or  o0(w[2], w[1], w[0]);
	dff_rtl1 d0(
	 .o_Q(qout), 
	 .i_D(w[2]), 
	 .i_clk(i_clk)
	 );
	
	bufif1 b0(o_bit1, qout, i_readEn1);
	bufif1 b1(o_bit2, qout, i_readEn2);
endmodule

