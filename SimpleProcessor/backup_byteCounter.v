//32-bit input, 32-bit output byte counter
//automatically add 0,1,2,3 respecfully to the output of PC to get 4 byte of a PC address
module byteCounter(o_res, o_count, i_pc, i_rst_, i_clk);
	parameter n = 32;
	output[n-1:0] o_res;
	output[1:0] o_count;
	input [n-1:0] i_pc;
	input i_rst_;
	input i_clk;
	
	wire[1:0] w0, w1;//, wTmp;
	//wire wCountEn, wCountEnTmp[1:0], wRstCountEn, rstCountEn_;
	wire[n-1:0] w2;

	assign o_count = w1; // output of Adder

	fa_2b fa0( 
	.o_sum(w0), 
	.i_dataA(w1), 
	.i_dataB(2'b01), 
	.i_cin(1'b0)
	);

	// mux2to1_rtl #(2) m0(
	// .o_res(wTmp),
	// .i_sel(wCountEn),
	// .i_data0(w1),
	// .i_data1(w0)
	// );

//2 Clocks per instruction: 0->1 ->0->...
	// dff_rtl2 d_countEn(
	// .o_Q(wCountEn),
	// .i_D(!wCountEn),
	// .i_pre_(1'b1),
	// .i_clr_(i_rst_),
	// .i_clk(i_clk)
	// );

//3 Clocks per instruction: 00->01->11->10 ->00->...
	// dff_rtl2 d_countEn1(
	// .o_Q(wCountEnTmp[0]),
	// .i_D(!wCountEnTmp[1]),
	// .i_pre_(1'b1),
	// .i_clr_(rstCountEn_),
	// .i_clk(i_clk)
	// );	
	// dff_rtl2 d_countEn0(
	// .o_Q(wCountEnTmp[1]),
	// .i_D(wCountEnTmp[0]),
	// .i_pre_(1'b1),
	// .i_clr_(rstCountEn_),
	// .i_clk(i_clk)
	// );
	// assign wCountEn = wCountEnTmp[1] & wCountEnTmp[0];
	// assign wRstCountEn = wCountEnTmp[1] & ~wCountEnTmp[0];
	// assign rstCountEn_ = (wRstCountEn)? 1'b0: i_rst_;

	dff_rtl2 d[1:0](
	.o_Q(w1),
	//.i_D(wTmp),
	.i_D(w0),
	.i_pre_(1'b1), 
	.i_clr_(i_rst_),
	.i_clk(i_clk)
	);

	signExtender_rtl_NtoM #(3,n) s0(
	.o_data(w2), 
	.i_data({1'b0, w1})
	);	

	fa_32b fa1( 
	.o_sum(o_res), 
	.i_dataA(i_pc), 
	.i_dataB(w2), 
	.i_cin(1'b0)
	);
endmodule 

