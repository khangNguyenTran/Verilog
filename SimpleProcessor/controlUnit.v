// Control unit
module controlUnit(
  o_regDst, 
  o_branch,
  o_regWrite, 
  o_ALUSrc, 
  o_ALUop, 
  o_memWrite, 
  o_memRead, 
  o_memToReg, 
  i_opcode 
  );
  
  output o_regDst, o_branch, o_regWrite;
  output o_ALUSrc, o_memWrite, o_memRead, o_memToReg;
  output[1:0] o_ALUop;
  input[5:0]  i_opcode;
  
  reg o_regDst, o_branch, o_regWrite;
  reg o_ALUSrc, o_memWrite, o_memRead, o_memToReg;
  reg[1:0] o_ALUop;
  
  parameter runAddIns = 6'b000_001;
  parameter runSwIns  = 6'b000_010;
  parameter runLwIns  = 6'b000_100;
  
  always@(i_opcode) begin
    case(i_opcode) 
runAddIns: begin
      o_regDst    = 1'b1;
      o_branch    = 1'b0;
      o_regWrite  = 1'b1;
      o_ALUSrc    = 1'b0;
      o_ALUop     = 2'b10;
      o_memWrite  = 1'b0;
      o_memRead   = 1'b0;
      o_memToReg  = 1'b0;
      end
runLwIns: begin
      o_regDst    = 1'b0;
      o_branch    = 1'b0;
      o_regWrite  = 1'b1;
      o_ALUSrc    = 1'b1;
      o_ALUop     = 2'b00;
      o_memWrite  = 1'b0;
      o_memRead   = 1'b1;
      o_memToReg  = 1'b1;
      end
runSwIns: begin  
      o_regDst    = 1'b0;
      o_branch    = 1'b0;
      o_regWrite  = 1'b0;
      o_ALUSrc    = 1'b1;
      o_ALUop     = 2'b00;
      o_memWrite  = 1'b1;
      o_memRead   = 1'b0;
      o_memToReg  = 1'b1;
      end
      // default??            
    endcase
  end
endmodule

// ALU control unit
module ALUcontrol(o_ALUcontrol, i_ALUop);
  output[3:0] o_ALUcontrol;
  input[1:0]  i_ALUop;
  
  reg[3:0] o_ALUcontrol;
  always@(i_ALUop)  // ALU only uses ADD operation 
  case(i_ALUop)
    2'b00: o_ALUcontrol = 4'b0101;
    2'b01: o_ALUcontrol = 4'b0101;
    2'b10: o_ALUcontrol = 4'b0101;
    2'b11: o_ALUcontrol = 4'b0101;
  endcase
endmodule

  // Branch Mux unit
module PCsrcSignal(o_PCsrc, i_branch, i_isZero);
  output o_PCsrc;
  input i_branch, i_isZero;

  assign o_PCsrc = i_branch & i_isZero;
endmodule