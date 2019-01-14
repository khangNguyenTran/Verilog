// bit 1 counter, 32-bit input, 32-bit result
module oneCounter_v2_fsm(o_data, o_done, i_data, i_start, i_rst, i_clk);
    output[31:0] o_data;
    output o_done;
    input [31:0] i_data;
    input i_start;
    input i_rst;
    input i_clk;

    wire ie, oe, we, rea, reb, s2, s1, s0, sh1, sh0, allBitsAreZero, sysClk;
    wire[31:0] wa, raa, rab; 

    oneCounter_v2_datapath datapath0(
    .o_data(o_data), 
    .o_allBitsAreZero(allBitsAreZero),
    .i_data(i_data),
    .i_ie(ie),
    .i_oe(oe),
    .i_wa(wa), .i_raa(raa), .i_rab(rab),
    .i_we(we), .i_rea(rea), .i_reb(reb),
    .i_s2(s2), .i_s1(s1),   .i_s0(s0),
    .i_sh1(sh1), .i_sh0(sh0),
    .i_sysClk(sysClk), .i_clk(i_clk)
    );

    oneCounter_v2_controlUnit controlUnit0(
    .o_done(o_done), 
    .o_sysClk(sysClk),
    .o_ie(ie),
    .o_oe(oe),
    .o_wa(wa), .o_raa(raa), .o_rab(rab),
    .o_we(we), .o_rea(rea), .o_reb(reb),
    .o_s2(s2), .o_s1(s1),   .o_s0(s0),
    .o_sh1(sh1), .o_sh0(sh0),
    .i_start(i_start), .i_rst(i_rst), .i_allBitsAreZero(allBitsAreZero), .i_clk(i_clk)
    );
endmodule

module oneCounter_v2_datapath(
    o_data, 
    o_allBitsAreZero,
    i_data,
    i_ie,
    i_oe,
    i_wa, i_raa, i_rab,
    i_we, i_rea, i_reb,
    i_s2, i_s1, i_s0,
    i_sh1, i_sh0,
    i_sysClk, i_clk
    );

    output[31:0] o_data;
    output o_allBitsAreZero;
    input [31:0] i_data;
    input i_ie, i_oe;
    input [2:0] i_wa, i_raa, i_rab; //8 registers
    input i_we, i_rea, i_reb;
    input i_s2, i_s1, i_s0;
    input i_sh1, i_sh0;
    input i_sysClk;
    input i_clk;
    
    wire[31:0] muxRes, aluRes, outData;
    wire[31:0] Adata, Bdata;
    wire oe;

    mux2to1_rtl #(32) m0(
        .o_res(muxRes), 
        .i_sel(i_ie), 
        .i_data0(outData), 
        .i_data1(i_data)
    );

    registerFile_beh_32x32_1 regis0(  
        .o_readData1(Adata), 
        .o_readData2(Bdata), 
        .i_readEn1(i_rea),
        .i_readAdd1({2'b00, i_raa}), 
        .i_readEn2(i_reb), 
        .i_readAdd2({2'b00, i_rab}),
        .i_writeEn(i_we),
        .i_writeAdd({2'b00, i_wa}), 
        .i_writeData(muxRes),
        .i_clk(~i_clk)
    );

    ALU_32b_1 alu0(
        .o_data(aluRes),         
        .i_dataA(Adata), 
        .i_dataB(Bdata), 
        .i_m(i_s2), 
        .i_sel({i_s1, i_s0}), 
        .i_clk(i_clk)
    );

    assign o_allBitsAreZero = i_sh1 & i_sh0 & ~(|outData);
     

    shifter_beh_4 #(32) shifter0(
        .o_data(outData), 
        .i_bit(1'b0), 
        .i_loadData(aluRes), 
        .i_sel({i_sh1, i_sh0})
    );

    assign oe = ~i_sysClk & i_oe;
    bufif1 b0[31:0](o_data, outData, oe);

endmodule

module oneCounter_v2_controlUnit(
    o_done, 
    o_sysClk,
    o_ie,
    o_oe,
    o_wa, o_raa, o_rab,
    o_we, o_rea, o_reb,
    o_s2, o_s1, o_s0,
    o_sh1, o_sh0,
    i_start, i_rst, i_allBitsAreZero, i_clk
    );
  
  output o_done; 
  output o_sysClk;
  output o_ie;
  output o_oe;
  output[2:0] o_wa, o_raa, o_rab;
  output o_we, o_rea, o_reb;
  output o_s2, o_s1, o_s0;
  output o_sh1, o_sh0;

  input i_start;
  input i_rst;
  input i_allBitsAreZero;
  input i_clk;
  
  reg[2:0] state, nextState;
  reg o_done; 
  reg o_ie;
  reg o_oe;
  reg[2:0] o_wa, o_raa, o_rab;
  reg o_we, o_rea, o_reb;
  reg o_s2, o_s1, o_s0;
  reg o_sh1, o_sh0;
  reg sysClk;

  parameter s0  = 3'b000;
  parameter s1  = 3'b001;
  parameter s2  = 3'b010;
  parameter s3  = 3'b011;
  parameter s4  = 3'b100;
  parameter s5  = 3'b101;
  parameter s6  = 3'b110;
  parameter s7  = 3'b111;

    assign o_sysClk = sysClk;
    always@(posedge i_clk)begin
    @(posedge i_clk)
    sysClk <= (i_rst)? 1'b0: ~sysClk;
    end

  // next state logic
  always@(state or i_rst) begin
    case(state)
s0:begin
      nextState = (i_start)? s1: s0;
      end
s1:begin
      nextState = s2;
      end    
s2:begin
      nextState = s3;
      end
s3:begin
      nextState = s4;
      end
s4:begin
      nextState = s5;
      end
s5:begin
      nextState = s6;
      end
s6:begin // shift right 1 bit
      nextState = (i_allBitsAreZero)? s7: s4;
      end
s7:begin
      nextState = s0;
      end
    endcase      
  end
  // state transition
  always @(posedge sysClk or posedge i_rst) begin
    if(i_rst)
      state <= s0;
     else
      state <= nextState;
  end
  // output logic
  always@(state or i_rst) begin
    case(state)
s0:begin//////////////////////
    o_done  = 1'b0;
    o_ie    = 1'b0;
    o_oe    = 1'b0;
    o_wa    = 3'b000;
    o_raa   = 3'b000;
    o_rab   = 3'b000;
    o_we    = 1'b0;
    o_rea   = 1'b0;
    o_reb   = 1'b0;
    {o_s2, o_s1, o_s0} = 3'b000;
    {o_sh1, o_sh0} = 2'b00;
    end
s1:begin
    o_done  = 1'b0;
    o_ie    = 1'b1;
    o_oe    = 1'b0;
    o_wa    = 3'b001;
    o_raa   = 3'bxxx;
    o_rab   = 3'bxxx;
    o_we    = 1'b1;
    o_rea   = 1'b0;
    o_reb   = 1'b0;
    {o_s2, o_s1, o_s0} = 3'bxxx;
    {o_sh1, o_sh0} = 2'bxx;
    end    
s2:begin
    o_done  = 1'b0;
    o_ie    = 1'b0;
    o_oe    = 1'b0;
    o_wa    = 3'b011;
    o_raa   = 3'b000;
    o_rab   = 3'b000;
    o_we    = 1'b1;
    o_rea   = 1'b1;
    o_reb   = 1'b1;
    {o_s2, o_s1, o_s0} = 3'b101; 
    {o_sh1, o_sh0} = 2'b00;
    end
s3:begin
    o_done  = 1'b0;
    o_ie    = 1'b0;
    o_oe    = 1'b0;
    o_wa    = 3'b010;
    o_raa   = 3'b000;
    o_rab   = 3'bxxx;
    o_we    = 1'b1;
    o_rea   = 1'b1;
    o_reb   = 1'b0;
    {o_s2, o_s1, o_s0} = 3'b111;
    {o_sh1, o_sh0} = 2'b00;
    end
s4:begin
    o_done  = 1'b0;
    o_ie    = 1'b0;
    o_oe    = 1'b0;
    o_wa    = 3'b100;
    o_raa   = 3'b001;
    o_rab   = 3'b010;
    o_we    = 1'b1;
    o_rea   = 1'b1;
    o_reb   = 1'b1;
    {o_s2, o_s1, o_s0} = 3'b001; //AND
    {o_sh1, o_sh0} = 2'b00;
    end
s5:begin
    o_done  = 1'b0;
    o_ie    = 1'b0;
    o_oe    = 1'b0;
    o_wa    = 3'b011;
    o_raa   = 3'b011;
    o_rab   = 3'b100;
    o_we    = 1'b1;
    o_rea   = 1'b1;
    o_reb   = 1'b1;
    {o_s2, o_s1, o_s0} = 3'b101; 
    {o_sh1, o_sh0} = 2'b00;
    end
s6:begin
    o_done  = 1'b0;
    o_ie    = 1'b0;
    o_oe    = 1'b0;
    o_wa    = 3'b001;
    o_raa   = 3'b001;
    o_rab   = 3'b000;
    o_we    = 1'b1;
    o_rea   = 1'b1;
    o_reb   = 1'b1;
    {o_s2, o_s1, o_s0} = 3'b101; 
    {o_sh1, o_sh0} = 2'b11; //shift right 1 bit
    end
s7:begin
    o_done  = 1'b1;
    o_ie    = 1'b0;
    o_oe    = 1'b1;
    o_wa    = 3'bxxx;
    o_raa   = 3'b011;
    o_rab   = 3'b000;
    o_we    = 1'b0;
    o_rea   = 1'b1;
    o_reb   = 1'b1;
    {o_s2, o_s1, o_s0} = 3'b101; 
    {o_sh1, o_sh0} = 2'b00;
    end
    endcase
  end
endmodule