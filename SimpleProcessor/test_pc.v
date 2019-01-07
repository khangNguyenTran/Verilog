
`timescale 100ps/10ps
module test_pc();
	reg clk, readEn, writeEn;
	reg[31:0] idata;
	wire[31:0] odata0, odata1;
	integer i;
	PC_1 pc0(
		.o_data(odata0), 
		.i_data(idata), 
		.i_readEn(readEn), 
		.i_writeEn(writeEn), 
		.i_clk(clk)
		);

	PC_2 pc1(
		.o_data(odata1), 
		.i_data(idata), 
		.i_readEn(readEn), 
		.i_writeEn(writeEn), 
		.i_clk(clk)
		);
		
	initial begin
		clk = 1'b1;
		idata = 32'b1; 

		readEn = 1'b0;
		writeEn = 1'b1;
		for(i=0; i<32; i= i+1)begin
			#2 idata = i; 		  
		end
		#2
		readEn = 1'b1;
		writeEn = 1'b0;
		for(i=0; i<32; i= i+1)begin
			#2 idata = i; 		  
		end
		#2
		readEn = 1'b1;
		writeEn = 1'b1;
		for(i=32; i<64; i= i+1)begin
			#2 idata = i; 		  
		end
		#2 $stop;
	end

	always clk = #1 ~clk;
endmodule