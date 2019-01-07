module simpleProcessor1(
  o_zf,
  o_of,
  i_rstCounter_,
  i_clk
  );
  output o_zf, o_of;
  input i_rstCounter_;
  input i_clk;
  
  wire regDst, branch, regWrite, ALUSrc;
  wire[1:0] ALUop;
  wire[3:0] ALUcontrol;
  wire memWrite, memRead, memToReg;
  wire[5:0] opcode;  
  
  controlUnit c0(  
  .o_regDst(regDst), 
  .o_branch(branch), 
  .o_regWrite(regWrite), 
  .o_ALUSrc(ALUSrc), 
  .o_ALUop(ALUop), 
  .o_memWrite(memWrite), 
  .o_memRead(memRead), 
  .o_memToReg(memToReg), 
  .i_opcode(opcode)
  );
  
  ALUcontrol a0(
  .o_ALUcontrol(ALUcontrol), 
  .i_ALUop(ALUop)
  );

  PCsrcSignal pcsrc0(
  .o_PCsrc(PCSrc), 
  .i_branch(branch), 
  .i_isZero(o_zf)
  );
  
  datapath2 d0(
  .o_isZero(o_zf), 
  .o_isOverflow(o_of), 
  .o_opcode(opcode),
  .i_rstCounter_(i_rstCounter_),
  .i_PCSrc(PCSrc),
  .i_regDst(regDst),  
  .i_regWrite(regWrite),     
  .i_ALUSrc(ALUSrc),      
  .i_ALUcontrol(ALUcontrol), 
  .i_memWrite(memWrite), 
  .i_memRead(memRead), 
  .i_memToReg(memToReg),
  .i_clk(i_clk)
  );
endmodule

