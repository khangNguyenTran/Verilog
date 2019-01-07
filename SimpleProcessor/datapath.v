//Simple datapath with 3 command line
//add $1, $2, $3
//lw $1, 0($2)
//sw $1, 0($2)
module datapath1(o_isZero, o_isOverflow, 
      i_inst, i_regDst, i_regWrite, i_ALUSrc, i_ALUcontrol, 
      i_memWrite, i_memRead, i_memToReg,
      i_clk
      );
      
  output o_isZero, o_isOverflow;
  input[31:0] i_inst;
  input i_regDst, i_regWrite;
  input i_ALUSrc; 
  input[3:0] i_ALUcontrol;
  input i_memWrite, i_memRead, i_memToReg;
  input i_clk;
  
  //tempoary variables
  wire[5:0] opcode;
  wire[4:0] rs, rt, rd;
  wire[4:0] shamt;
  wire[5:0] funct;
  wire[4:0] wr;
  wire[31:0] wd, rd1, rd2, operand2, ALUresult, readData;
  wire[15:0] immediate;
  wire[31:0] signExtendRes;
  
  assign opcode = i_inst[31:26];
  assign rs = i_inst[25:21];
  assign rt = i_inst[20:16];
  assign rd = i_inst[15:11];
  assign immediate = i_inst[15:0];
  assign shamt = i_inst[10:6];
  assign funct = i_inst[5:0];
  
  mux2to1_rtl #(5) m0(
    .o_res(wr), 
    .i_sel(i_regDst), 
    .i_data0(rt), 
    .i_data1(rd)
    );
  mux2to1_rtl #(32) m1(
    .o_res(operand2), 
    .i_sel(i_ALUSrc), 
    .i_data0(rd2), 
    .i_data1(signExtendRes)
    );
  mux2to1_rtl #(32) m2(
    .o_res(wd), 
    .i_sel(i_memToReg), 
    .i_data0(ALUresult), 
    .i_data1(readData)
    );
  nor n0 (o_isZero, 
    ALUresult[0],  ALUresult[1],  ALUresult[2],  ALUresult[3],  ALUresult[4],  ALUresult[5],  ALUresult[6],  ALUresult[7], 
    ALUresult[8],  ALUresult[9],  ALUresult[10], ALUresult[11], ALUresult[12], ALUresult[13], ALUresult[14], ALUresult[15],
    ALUresult[16], ALUresult[17], ALUresult[18], ALUresult[19], ALUresult[20], ALUresult[21], ALUresult[22], ALUresult[23], 
    ALUresult[24], ALUresult[25], ALUresult[26], ALUresult[27], ALUresult[28], ALUresult[29], ALUresult[30], ALUresult[31]
    );
  ALU_32b_2 alu0( //RTL 32-bit ALU
    .o_data(ALUresult), 
    .o_addSubOverflow(o_isOverflow), 
    .i_dataA(rd1), 
    .i_dataB(operand2), 
    .i_m(i_ALUcontrol[2]), 
    .i_sel(i_ALUcontrol[1:0])
    );
  signExtender_rtl_NtoM #(16,32) s0(
    .i_data(immediate),
    .o_data(signExtendRes)
    );
  registerFile_beh_32x32_3 re0(
    .o_readData1(rd1), .o_readData2(rd2), 
    .i_readAdd1(rs), .i_readAdd2(rt), 
    .i_writeAdd(wr), .i_writeData(wd), .i_writeEn(i_regWrite),
    .i_clk(i_clk)
   );
  dataMem_beh ram0(
    .o_data(readData), 
    .i_data(rd2),
    .i_add(ALUresult),
    .i_writeEn(i_memWrite), 
    .i_readEn(i_memRead), 
    .i_en(1'b1) // always being enabled
    );
endmodule


module datapath2(
      o_isZero, o_isOverflow, 
      o_opcode,
      i_PCSrc,
      i_regDst, i_regWrite, i_ALUSrc, i_ALUcontrol, 
      i_memWrite, i_memRead, i_memToReg,
      i_rstCounter_,
      i_clk
      );
      
  output o_isZero, o_isOverflow;
  output[5:0] o_opcode;
  input i_PCSrc;
  input i_regDst, i_regWrite;
  input i_ALUSrc; 
  input[3:0] i_ALUcontrol;
  input i_memWrite, i_memRead, i_memToReg;
  input i_rstCounter_;
  input i_clk;
  
  //temporary variables
  wire rstPC_;
  wire[5:0] opcode;
  wire[4:0] rs, rt, rd;
  wire[4:0] shamt;
  wire[5:0] funct;
  wire[4:0] wr;
  wire[31:0] inst, wd, rd1, rd2, operand2, ALUresult, readData, signExtendRes;
  wire[31:0] iPC, oPC, addRes0, addRes1, shiftRes; 
  wire[15:0] immediate;
  wire sysClk, sysClk_;

  assign opcode = inst[31:26];
  assign rs = inst[25:21];
  assign rt = inst[20:16];
  assign rd = inst[15:11];
  assign immediate = inst[15:0];
  assign shamt = inst[10:6];
  assign funct = inst[5:0];
  
  assign o_opcode = opcode;
  assign rstPC_ = i_rstCounter_;

  assign sysClk = ~sysClk_;

   frequencyDivider_beh #(5) freqDiv0(
     .o_freq(sysClk_),
     .i_freq(i_clk), 
     .i_clr_(rstPC_)
     );

  pc_beh1 pc0(
    .o_data(oPC), 
    .i_data(iPC), 
    //.i_rst_(rstPC_), 
    .i_clk(sysClk),
    .i_writeEn(1'b1), 
    .i_readEn(1'b1)
    );

  instructionMemory2 insMem0(
    .o_ins(inst), 
    .i_add(oPC), 
    .i_rstCounter_(i_rstCounter_), // <---- 
    .i_clk(i_clk), 
    .i_en(1'b1)
    );

  fa_32b adder0( 
    .o_sum(addRes0),
    .i_dataA(oPC), 
    .i_dataB(32'b0100), 
    .i_cin(1'b0)
    );
  fa_32b adder1( 
    .o_sum(addRes1), 
    .i_dataA(addRes0), 
    .i_dataB(shiftRes), 
    .i_cin(1'b0)
    );

  shifter_beh_3 shifter0(
    .o_data(shiftRes), 
    .i_bits(2'b00), 
    .i_loadData(signExtendRes), 
    .i_leftRight(1'b0)
    );

  mux2to1_rtl #(5) m0(
    .o_res(wr), 
    .i_sel(i_regDst), 
    .i_data0(rt), 
    .i_data1(rd)
    );
  mux2to1_rtl #(32) m1(
    .o_res(operand2), 
    .i_sel(i_ALUSrc), 
    .i_data0(rd2), 
    .i_data1(signExtendRes)
    );
  mux2to1_rtl #(32) m2(
    .o_res(wd), 
    .i_sel(i_memToReg), 
    .i_data0(ALUresult), 
    .i_data1(readData)
    );
  mux2to1_rtl #(32) m3(
    .o_res(iPC), 
    .i_sel(i_PCSrc), 
    .i_data0(addRes0), 
    .i_data1(addRes1)
    );

  nor n0 (o_isZero, 
    ALUresult[0],  ALUresult[1],  ALUresult[2],  ALUresult[3],  ALUresult[4],  ALUresult[5],  ALUresult[6],  ALUresult[7], 
    ALUresult[8],  ALUresult[9],  ALUresult[10], ALUresult[11], ALUresult[12], ALUresult[13], ALUresult[14], ALUresult[15],
    ALUresult[16], ALUresult[17], ALUresult[18], ALUresult[19], ALUresult[20], ALUresult[21], ALUresult[22], ALUresult[23], 
    ALUresult[24], ALUresult[25], ALUresult[26], ALUresult[27], ALUresult[28], ALUresult[29], ALUresult[30], ALUresult[31]
    );
  ALU_32b_2 alu0( //RTL 32-bit ALU
    .o_data(ALUresult), 
    .o_addSubOverflow(o_isOverflow), 
    .i_dataA(rd1), 
    .i_dataB(operand2), 
    .i_m(i_ALUcontrol[2]), 
    .i_sel(i_ALUcontrol[1:0])
    );
  signExtender_rtl_NtoM #(16,32) s0(
    .i_data(immediate),
    .o_data(signExtendRes)
    );
  registerFile_beh_32x32_3 re0(
    .o_readData1(rd1), .o_readData2(rd2), 
    .i_readAdd1(rs), .i_readAdd2(rt), 
    .i_writeAdd(wr), .i_writeData(wd), .i_writeEn(i_regWrite),
    .i_clk(i_clk)
   );
  dataMem_beh ram0(
    .o_data(readData), 
    .i_data(rd2),
    .i_add(ALUresult),
    .i_writeEn(i_memWrite), 
    .i_readEn(i_memRead), 
    .i_en(1'b1) // always being enabled
    );    
endmodule
