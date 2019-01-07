// program counter
// 32b
module pc_str(o_data, i_data, i_writeEn, i_readEn);
  parameter m = 32; // m: number of bits
  output[m-1:0] o_data;
  input [m-1:0] i_data;
  input i_writeEn, i_readEn;

  wire [m-1:0] i_data, o_data, outData;
  memoryCell memoryCell[m-1:0](
    .o_bit(outData[m-1:0]),
    .i_bit(i_data[m-1:0]),
    .i_rowSel(1'b1),
    .i_writeEn(i_writeEn)
    );
  bufif1 b[m-1:0](o_data[m-1:0], outData[m-1:0], i_readEn);
endmodule

// Behavior Program counter 
module pc_beh1(o_data, i_data, i_clk, i_writeEn, i_readEn);
	parameter n = 32; // number of bits
	output[n-1:0] o_data;
	input i_readEn, i_writeEn, i_clk;
	input [n-1:0] i_data;

	reg[n-1:0] memoryCell;
	assign o_data = (i_readEn)? memoryCell: 'bz;
	always@(posedge i_clk)begin		
		memoryCell = (i_writeEn)? i_data: memoryCell;
	end
endmodule

// With byteCounter and writeControlSignal
module pc_beh2(o_data, i_data, i_rst_, i_readEn, i_clk);
	parameter n = 32; // number of bits
	output[n-1:0] o_data;
	input i_readEn, i_rst_, i_clk;
	input [n-1:0] i_data;

	reg[n-1:0] memoryCell;
  wire[1:0] w0, w1;//, wTmp;
	//wire wCountEn, wCountEnTmp[1:0], wRstCountEn, rstCountEn_;

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

// 3 clocks per instruction: 00->01->11->10 ->00->...
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
  
  //assign writeEn = ~(w1[1] | w1[0] | ~wCountEnTmp[1] | wCountEnTmp[0]);
	assign writeEn = ~w1[1] & w1[0] & w0[1] & ~w0[0];
  assign o_data = (i_readEn)? memoryCell: 'bz;
	always@(posedge i_clk)begin		
		memoryCell = (writeEn)? i_data: memoryCell;
	end
endmodule