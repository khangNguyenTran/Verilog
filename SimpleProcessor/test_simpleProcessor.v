`timescale 100ps/10ps
module test_simpleProcessor();
  reg[31:0] ins;
  reg rstCounter_;  
  reg clk;
  wire zf, of;

  parameter halfClock1 = 1;  // T1 =  200 ps
  parameter halfClock2 = 32; // T2 = 6400 ps

  simpleProcessor1 s0(
  .o_zf(zf),
  .o_of(of),
  .i_rstCounter_(rstCounter_),
  .i_clk(clk)
  );
  
  initial begin
    	clk = 1;
        //initialize value 
        //for Data Memory
         $readmemb("data/DataMemory.data", s0.d0.ram0.memoryCell);
        //for Register File
        $readmemb("data/RegisterFile.data", s0.d0.re0.rfc);
        //for Instruction Memory        
        $readmemb("data/InstructionMemory.data", s0.d0.insMem0.r0.memoryCell);		
        rstCounter_ = 1'b0; #(halfClock1*2) rstCounter_ = 1'b1;
        //for Progran Counter
    	force s0.d0.pc0.memoryCell = 32'b0;

	    //add $1, $2, $3;
    	#(halfClock2*2 - (halfClock1*2));
		release s0.d0.pc0.memoryCell;

	    //sw $1, 4($3);
        rstCounter_ = 1'b0; #(halfClock1*2) rstCounter_ = 1'b1;
	    #(halfClock2*2 - (halfClock1*2));

	    //lw $2, 4($3);
        rstCounter_ = 1'b0; #(halfClock1*2) rstCounter_ = 1'b1;
	    #(halfClock2*2 - (halfClock1*2));
        $stop;
  end
  
  always #halfClock1 clk = ~ clk;
endmodule

