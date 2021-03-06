
`timescale 100ps/10ps
module test_instructionMemory();
    wire[31:0] ins;
    reg[31:0] pc;
    reg rstCounter_, clk;
    parameter cycleT = 1;
    instructionMemory2 im0(
        .o_ins(ins), 
        .i_add(pc), 
        .i_rstCounter_(rstCounter_), 
        .i_clk(clk), 
        .i_en(1'b1)
        );

    initial begin
      clk = 1'b1;
      im0.r0.memoryCell[3]  = 8'b000001_00;
      im0.r0.memoryCell[2]  = 8'b010_00011;
      im0.r0.memoryCell[1]  = 8'b00001_000;
      im0.r0.memoryCell[0]  = 8'b00_000000; //add $1, $2, $3;

      im0.r0.memoryCell[7]  = 8'b000010_00;
      im0.r0.memoryCell[6]  = 8'b011_00001;
      im0.r0.memoryCell[5]  = 8'b00000000;
      im0.r0.memoryCell[4]  = 8'b00000100;   //sw $1, 4($3);

      im0.r0.memoryCell[11] = 8'b000100_00;
      im0.r0.memoryCell[10] = 8'b011_00010;
      im0.r0.memoryCell[9]  = 8'b00000000;
      im0.r0.memoryCell[8]  = 8'b00000100;   //lw $2, 4($3);

      im0.r0.memoryCell[15]  = 8'b000010_00;
      im0.r0.memoryCell[14]  = 8'b011_00001;
      im0.r0.memoryCell[13]  = 8'b00000000;
      im0.r0.memoryCell[12]  = 8'b00000000;  //sw $1, 0($3);

      pc = 32'h0;
      rstCounter_ = 1'b0; #(cycleT*2) rstCounter_ = 1'b1;
      
      #(cycleT*7*2)
      //pc = 32'd4;
      //#(cycleT*8*2)
      //pc = 32'd8;
      //#(cycleT*8*2)
      //pc = 32'd12;
      //#(cycleT*8*2)
      $stop;
      
    end

    always #(cycleT) clk = ~clk;
endmodule
