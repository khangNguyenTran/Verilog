
`timescale 100ps/10ps
module test_byteCounter();
    reg[31:0] pc;
    reg rst_, clk;
    wire[31:0] res;
    byteCounter bc0(
    .o_res(res), 
    .i_pc(pc), 
    .i_rst_(rst_), 
    .i_clk(clk)
    );
    initial begin
        clk =1'b1;
        pc = 32'b0;
        rst_ = 1'b0; #2 rst_ = 1'b1;
        #16
        $stop;
    end

    always clk = #1 ~clk;
endmodule
