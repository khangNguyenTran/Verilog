
module instructionMemory1(o_ins, i_add, i_en);
  // default: 32 addresses, 32 bits per address
  parameter n = 32, m = 32;
  // n: number of rows (addresses)
  // m: number of comlumns (bits for each address)
  output[m-1:0] o_ins;
  input [n-1:0] i_add;
  input i_en;

  dataMem_beh #(n, m) r0(
    .o_data(o_ins),
    .i_add(i_add),
    //.i_data(i_data),
    //.i_writeEn(i_writeEn),
    .i_readEn(1'b1),
    .i_en(i_en)
    );
endmodule

  //32 addresses, 32 bits per address
module instructionMemory2(o_ins, i_add, i_rstCounter_, i_clk, i_en);
  output[31:0] o_ins;
  input [31:0] i_add;
  input i_rstCounter_, i_clk, i_en;

  wire[1:0] wSel;
  wire readInsEn;
  wire[31:0] wCounterRes, wInsPart, wIns;

  byteCounter1_ #(32) bc0(
    .o_res(wCounterRes), 
    .o_count(wSel), 
    .i_pc(i_add), 
    .i_rst_(i_rstCounter_), 
    .i_clk(i_clk)
    );

  dataMem_beh #(128, 8) r0(
    .o_data(wInsPart),
    .i_add(wCounterRes),
    //.i_data(i_data),
    //.i_writeEn(i_writeEn),
    .i_readEn(1'b1),
    .i_en(i_en)
    );

  wordBuffer wb0( //32-bit word
    .o_data(wIns), 
    .i_data(wInsPart), 
    .i_address(wSel), 
    .i_clk(i_clk)
    );
  assign o_ins = wIns;
  //assign readInsEn = ~wSel[1] & ~wSel[0];

  //bufif1 b[31:0](o_ins, wIns, readInsEn);
endmodule