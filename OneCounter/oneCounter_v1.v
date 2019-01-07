// One counter
// 16-bit output
module oneCounter_v1_fsm(
  o_done, o_data, 
  i_data, i_rst, i_clk);
  
  output o_done;
  output[15:0] o_data;   
  input[15:0]  i_data;
  input i_rst, i_clk;

  wire loadShiftDataEn_, rst_c2d, oneFlat;
  oneCounter_v1_datapath datapath0(
    .o_data(o_data), 
    .o_oneFlat(oneFlat),
    .i_data(i_data), 
    .i_loadShiftEn_(loadShiftDataEn_),
    .i_done(o_done),
    .i_rst_(rst_c2d), 
    .i_clk(i_clk)
    );
  
  oneCounter_v1_ctrlUnit ctrlUnit0(
    .o_done(o_done), 
    .o_loadShiftDataEn_(loadShiftDataEn_), 
    .o_rst_(rst_c2d), 
    .i_oneFlat(oneFlat), 
    .i_rst(i_rst), 
    .i_clk(i_clk)
    );  
endmodule
// Datapath
module oneCounter_v1_datapath(
  o_data, o_oneFlat,
  i_data, i_loadShiftEn_, i_done,
  i_rst_, i_clk);
  
  output[15:0] o_data;
  output o_oneFlat;
  input[15:0] i_data;
  input i_loadShiftEn_, i_done, i_rst_, i_clk;
  
  wire[15:0] outData;
  wire[15:0] rstShiftData, shiftLoadData, shiftRes, addRes, add1Or0;
  wire rstShift_, isBitOne;
  
   mux2to1_rtl #(16) m0(
    .o_res(rstShiftData),
    .i_sel(i_rst_), 
    .i_data0(16'b0),
    .i_data1(i_data)
    );
    
  mux2to1_rtl #(16) m1(
    .o_res(shiftLoadData),
    .i_sel(i_loadShiftEn_), 
    .i_data0(rstShiftData),
    .i_data1(shiftRes)
    );
  
  shifter_nb #(16) s0(
    .o_data(shiftRes),
    .i_bit(1'b0), //<= key of success
    .i_loadData(shiftLoadData),
    .i_leftRight(1'b1),// always shift right
    .i_loadEn_(i_loadShiftEn_), 
    .i_clr_(1'b1),
    .i_clk(i_clk)
    );
    
  assign o_oneFlat = 
    i_loadShiftEn_ & i_rst_ &
    ~shiftRes[15] & ~shiftRes[14] & ~shiftRes[13] & ~shiftRes[12] &
    ~shiftRes[11] & ~shiftRes[10] & ~shiftRes[9]  & ~shiftRes[8] &
    ~shiftRes[7]  & ~shiftRes[6]  & ~shiftRes[5]  & ~shiftRes[4] &
    ~shiftRes[3]  & ~shiftRes[2]  & ~shiftRes[1]  & ~shiftRes[0]
    ;
  
  assign isBitOne  = ~(shiftRes[0] ^ 1'b1);
  
	mux2to1_rtl #(16) m2(
    .o_res(add1Or0), 
    .i_sel(isBitOne), 
    .i_data0(16'b0),// disable counting 
    .i_data1(16'b1) // enable counting   
    );
    
	fa_16b f0(
    .o_sum(addRes), 
    .i_cin(1'b0),
    .i_dataA(outData),     
    .i_dataB(add1Or0) 
    );
  
  dff_rtl2 d[15:0](
    .o_Q(outData[15:0]), 
    .i_D(addRes[15:0]), 
    .i_pre_(1'b1),
    .i_clr_(i_rst_),
    .i_clk(i_clk)
    );

  bufif1 b[15:0](o_data, outData, i_done);

endmodule
// Control Unit
module oneCounter_v1_ctrlUnit(
  o_done, o_loadShiftDataEn_, o_rst_, 
  i_oneFlat, i_rst, i_clk);
  
  output o_done; 
  output o_loadShiftDataEn_, o_rst_;
  input i_oneFlat;
  input i_rst, i_clk;
  
  reg[1:0] state, nextState;
  reg o_done, o_loadShiftDataEn_, o_rst_;
  
  parameter reset     = 2'b00;
  parameter ready     = 2'b01; // load input data into shifter
  parameter counting  = 2'b10;
  parameter done      = 2'b11;
  
  // next state logic
  always@(state or i_rst or i_oneFlat) begin
    case(state)
reset:begin
      nextState <= i_rst? reset: ready; 
      end
ready:begin
      nextState <= counting;
      end    
counting:begin
      nextState <= i_rst? reset: (i_oneFlat? done: counting);
      end
done:begin
      nextState <= i_rst? reset: done;
      end
    endcase      
  end
  // state transition
  always @(posedge i_clk or posedge i_rst) begin
    if(i_rst)
      state <= reset;
     else
      state <= nextState;
  end
  // output logic
  always@(state or i_rst or i_oneFlat) begin
    case(state)
reset:begin
      o_done = 0;
      o_loadShiftDataEn_ = 0;
      o_rst_ = 0;
      end
ready:begin
    	 o_done = 0;
      o_loadShiftDataEn_ = 0;
      o_rst_ = 1;
      end          
counting:begin
      o_done = 0;
      o_loadShiftDataEn_ = 1;
      o_rst_ = 1;
      end
done:begin
      o_done = 1;
      o_loadShiftDataEn_ = 1;
      o_rst_ = 1;
      end 
      endcase            
  end
endmodule