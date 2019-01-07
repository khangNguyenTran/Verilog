
`timescale 100ps/10ps
module test_oneCounter_v1_fsm(); //16-bit output
    reg[15:0] inputData;
    reg rst, clk;
    wire[15:0] outputData;
    wire done;
    parameter delay = 40;
    integer i;
    
    oneCounter_v1_fsm z0(
      .o_done(done), 
      .o_data(outputData), 
      .i_data(inputData), 
      .i_rst(rst), 
      .i_clk(clk)
      );
    
    initial begin
      clk = 1'b1;
      i = 0;
        
      while(1) begin
        if(done === 1'b1)
          #4; // 2 cycle
          rst = 1'b1;
          case(i) 
          0: inputData = 16'b0000_0000_0000_1111; 
          1: inputData = 16'b1111_0000_1111_0000; 
          2: inputData = 16'b1111_1111_1111_1111; 
          3: inputData = 16'b0000_0000_0000_0000;
          4: $stop;
          endcase
          i = i+1;
          #2 rst = 1'b0;
          #delay;  
      end
    end
    
    always #1 clk =~clk;
endmodule

module test_oneCounter_v2_fsm(); //32-bit output
    reg[31:0] inputData;
    reg start, rst, clk;
    wire[31:0] outputData;
    wire done;
    
    oneCounter_v2_fsm z1(
      .o_data(outputData), 
      .o_done(done), 
      .i_data(inputData), 
      .i_start(start),
      .i_rst(rst),
      .i_clk(clk)
      );
    
    initial begin
      clk = 1'b1;

      start = 1'b1;

      rst = 1'b1;
      //inputData = 32'b0000_0000_0000_1111; 
      //inputData = 32'b1111_0000_1111_0001; 
      inputData = 32'b1111_1111_1111_1111;
      #4 rst = 1'b0;
    end

    always wait (done === 1'b1)
      #4 $stop;

    always #1 clk =~clk;
endmodule
