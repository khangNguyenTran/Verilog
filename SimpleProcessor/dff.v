//2 modules
//D flipflop          

//structural d-ff
module dff_str1(o_Q, i_D, i_clk);
  output o_Q;
  input i_D, i_clk;
  
  wire w0, w1;
  not (w1, i_clk);
  //posedge clock
  dlatch_srt1 masterDlatch(
    .o_Q(w0),
    .i_D(i_D),
    .i_en(w1)
    );
  dlatch_srt1 slaveDlatch(
    .o_Q(o_Q),
    .i_D(w0),
    .i_en(i_clk)
    );
endmodule

//structural d-ff with pre and clr, both are active low
module dff_str2(o_Q, i_D, i_pre_, i_clr_, i_clk);//dff_STR_2
  output o_Q;
  input i_D, i_clk, i_pre_, i_clr_;
  
  wire w[3:0], Q_;

  nand na0(w[0], w[3], w[1],  i_pre_);
  nand na1(w[1], w[0], i_clk);
  nand na2(w[2], w[1], i_clk, w[3]);
  nand na3(w[3], i_D,  w[2],  i_clr_);
  nand na4(o_Q,  w[1], Q_,  i_pre_);
  nand na5(Q_, w[2], o_Q,   i_clr_);
endmodule            

//RTL d-ff
module dff_rtl1(o_Q, i_D, i_clk);
  output o_Q;
  input i_D, i_clk;
  
  wire w0, w1;
  assign w1 = ~i_clk;
  //posedge clock
  dlatch_rtl1 masterDlatch(
    .o_Q(w0),
    .i_D(i_D),
    .i_en(w1)
    );
  dlatch_rtl1 slaveDlatch(
    .o_Q(o_Q),
    .i_D(w0),
    .i_en(i_clk)
    );
endmodule

//RTL d-ff with pre and clr, both are active low
module dff_rtl2(o_Q, i_D, i_pre_, i_clr_, i_clk);//dff_RTL_2
  output o_Q;
  input i_D, i_clk, i_pre_, i_clr_;
  
  wire[5:0] w;

  assign w[0] = ~(w[3] & w[1]  & i_pre_);
  assign w[1] = ~(w[0] & i_clk);
  assign w[2] = ~(w[1] & i_clk & w[3]);
  assign w[3] = ~(i_D  & w[2]  & i_clr_);
  assign w[4] = ~(w[1] & w[5]  & i_pre_);
  assign w[5] = ~(w[2] & w[4]  & i_clr_);
  assign o_Q  = w[4];
endmodule

//Behavior d-ff
module dff_beh1(o_Q, i_D, i_clk);
  output o_Q;
  input i_D, i_clk;
  
  reg o_Q;  
  always@(posedge i_clk ) 
      o_Q <= i_D;      
endmodule

//Behavior d-ff with pre and clrpre
module dff_beh2(o_Q, i_D, i_pre_, i_clr_, i_clk);
  output o_Q;
  input i_D, i_pre_, i_clr_, i_clk;
  
  reg o_Q;  
  always@(posedge i_clk)
    if(i_pre_) 
      o_Q <= 1'b1;
    else if(i_clr_)
      o_Q <= 1'b0;
    else
      o_Q <= i_D;      
endmodule

