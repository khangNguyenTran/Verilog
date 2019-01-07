//32-bit input, 32-bit output byte counter
//automatically add 0,1,2,3 respecfully to the output of PC to get 4 byte of a PC address
module byteCounter1(o_res, o_count, i_pc, i_rst_, i_clk); 
	parameter n = 32;
	output[n-1:0] o_res;
	output[1:0] o_count;
	input [n-1:0] i_pc;
	input i_rst_;
	input i_clk;
	
	wire[1:0] w0, w1;
	wire[n-1:0] w2;

	assign o_count = w1; // output of Adder

	fa_2b fa0( 
	.o_sum(w0), 
	.i_dataA(w1), 
	.i_dataB(2'b01), 
	.i_cin(1'b0)
	);

	dff_rtl2 d[1:0](
	.o_Q(w1),
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

module byteCounter2(o_res, o_count, i_pc, i_rst_, i_clk); 
	parameter n = 32;
	output[n-1:0] o_res;
	output[1:0] o_count;
	input [n-1:0] i_pc;
	input i_rst_;
	input i_clk;
	
	wire[1:0] w0;

	counter_4b_u2b counter0(
	.o_count(w0), 
	.i_input(4'b0), 
	.i_set_(i_rst_),
	.i_en(1'b1), 
	.i_clr_(i_rst_), 
	.i_clk(i_clk)
	);
	assign o_count = w0;
	assign o_res = i_pc + w0;
endmodule 

// not-repeating byte counter
module byteCounter3(o_res, o_count, i_pc, i_rst_, i_clk); 
	parameter n = 32;
	output[n-1:0] o_res;
	output[1:0] o_count;
	input [n-1:0] i_pc;
	input i_rst_;
	input i_clk;
	
	wire[1:0] w0, w1, ocount;
	wire[n-1:0] w2, ores;
	wire cout;

	assign ocount = w1; // output of Adder

	fa_2b fa0( 
	.o_sum(w0),
	.o_cout(cout), 
	.i_dataA(w1), 
	.i_dataB(2'b01), 
	.i_cin(1'b0)
	);

	dff_rtl2 d[1:0](
	.o_Q(w1),
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
	.o_sum(ores), 
	.i_dataA(i_pc), 
	.i_dataB(w2), 
	.i_cin(1'b0)
	);

	bufif0 b0[n-1:0](o_res, ores, cout);
	bufif0 b1[1:0](o_count, ocount, cout);
endmodule 


module byteCounter1_(o_res, o_count, i_pc, i_rst_, i_clk); 
	parameter n = 32;
	output[n-1:0] o_res;
	output[1:0] o_count;
	input [n-1:0] i_pc;
	input i_rst_;
	input i_clk;
	
	wire[3:0] w0;
	wire w1, w2;

	counter_4b_u2b counter0(
	.o_count(w0), 
	.i_input(4'b0), 
	.i_set_(i_rst_),
	.i_en(w2), 
	.i_clr_(i_rst_), 
	.i_clk(i_clk)
	);
	dff_rtl2 d0(
	.o_Q(w2),
	.i_D(w1),
	.i_pre_(1'b1), 
	.i_clr_(i_rst_),
	.i_clk(i_clk)
	);
	assign w1 = ~(~w0[3] & ~w0[2] & w0[1] & w0[0]);
	assign o_count = w0[1:0];
	fa_32b fa0( 
	.o_sum(o_res), 
	.i_dataA(i_pc), 
	.i_dataB({30'b0, w0[1:0]}), 
	.i_cin(1'b0)
	);
endmodule 
