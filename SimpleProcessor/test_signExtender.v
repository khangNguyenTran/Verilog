// test sign extender 2-32
`timescale 100ps/10ps
module test_signExtender();
    reg[1:0] idata;
    wire[31:0] odata;
    signExtender_rtl_NtoM #(3, 32) s0(
	.o_data(odata), 
	.i_data({1'b0, idata})
	);	
    initial begin
      idata = 2'b01;
      #2
      idata = 2'b11;
      #2
      $stop;
    end
endmodule
