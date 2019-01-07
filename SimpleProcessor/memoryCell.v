//structural memory cell
module memoryCell(o_bit, i_bit, i_rowSel, i_writeEn);
	output o_bit;
	input i_bit, i_rowSel, i_writeEn;

	wire w[1:0];
	and a0(w[0], i_rowSel, i_writeEn);
	dlatch_srt1 dl(
		.o_Q(w[1]),
		.i_D(i_bit),
		.i_en(w[0])
		);
	bufif1 b0(o_bit, w[1], i_rowSel);
endmodule
