//8-bit shift register with parallel input, serial ouput, parallel output
//Using structural models
module shiftRegister_8b_1(o_data, o_bit, i_data, i_bit, i_sel, i_clk, i_clr_);
    output[7:0] o_data;
    output o_bit;
    input[7:0] i_data;
    input[1:0] i_sel;
    //0: no change (no load)
    //1: shift left 1bit
    //2: shift right 1bit
    //3: load data
    input i_bit, i_clr_, i_clk;
    
    wire[7:0] d;  
    // if i_sel = 2'b00 and 2'b11 this                                                                           
    mux2to1_rtl #(1) m0(
      .o_res(o_bit),
      .i_sel(i_sel[1]),
      .i_data0(d[7]),
      .i_data1(d[0])
      );

   	mux4to1_rtl_1b m1[7:0] (
   		.o_res(d[7:0]), 
   		.i_sel(i_sel), 
   		.i_data0(o_data[7:0]), 
   		.i_data1({o_data[6:0], i_bit}), 
   		.i_data2({i_bit, o_data[7:1]}), 
   		.i_data3(i_data[7:0])
   		);    

	//using dffs that have both clr and pre
    dff_rtl2 dff[7:0] (
    	.o_Q(o_data[7:0]), 
    	.i_D(d[7:0]), 
    	.i_clk(i_clk), 
    	.i_pre_(1'b1), .i_clr_(i_clr_)
    	);
    
endmodule
//Using continuous assignment
module shiftRegister_8b_2(o_data, i_data, i_bit, i_sel, i_clk, i_clr_);
    output[7:0] o_data;
    input[7:0] i_data;
    input[1:0] i_sel;
    //0: no change (no load)
    //1: shift left 1bit
    //2: shift right 1bit
    //3: load data
    input i_bit, i_clr_, i_clk;
    wire[7:0] d;
    wire[3:0] tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
    wire[5:0] w0, w1, w2, w3, w4, w5, w6, w7;
     
    // mux4-1 for d-ff0 
    assign tmp0[0] = ~i_sel[1] & ~i_sel[0] & o_data[0];
    assign tmp0[1] = ~i_sel[1] & i_sel[0]  & i_bit;
    assign tmp0[2] = i_sel[1]  & ~i_sel[0] & o_data[1];
    assign tmp0[3] = i_sel[1]  & i_sel[0]  & i_data[0];
    assign d[0]  = tmp0[0] | tmp0[1] | tmp0[2] | tmp0[3];
    
    // mux4-1 for d-ff1    
    assign tmp1[0] = ~i_sel[1] & ~i_sel[0] & o_data[1];
    assign tmp1[1] = ~i_sel[1] & i_sel[0]  & o_data[0];
    assign tmp1[2] = i_sel[1]  & ~i_sel[0] & o_data[2];
    assign tmp1[3] = i_sel[1]  & i_sel[0]  & i_data[1];
    assign d[1]  = tmp1[0] | tmp1[1] | tmp1[2] | tmp1[3];
    
    // mux4-1 for d-ff2
    assign tmp2[0] = ~i_sel[1] & ~i_sel[0] & o_data[2];
    assign tmp2[1] = ~i_sel[1] & i_sel[0]  & o_data[1];
    assign tmp2[2] = i_sel[1]  & ~i_sel[0] & o_data[3];
    assign tmp2[3] = i_sel[1]  & i_sel[0]  & i_data[2];
    assign d[2]  = tmp2[0] | tmp2[1] | tmp2[2] | tmp2[3];
    
    // mux4-1 for d-ff3
    assign tmp3[0] = ~i_sel[1] & ~i_sel[0] & o_data[3];
    assign tmp3[1] = ~i_sel[1] & i_sel[0]  & o_data[2];
    assign tmp3[2] = i_sel[1]  & ~i_sel[0] & o_data[4];
    assign tmp3[3] = i_sel[1]  & i_sel[0]  & i_data[3];
    assign d[3]  = tmp3[0] | tmp3[1] | tmp3[2] | tmp3[3];
    
    // mux4-1 for d-ff4
    assign tmp4[0] = ~i_sel[1] & ~i_sel[0] & o_data[4];
    assign tmp4[1] = ~i_sel[1] & i_sel[0]  & o_data[3];
    assign tmp4[2] = i_sel[1]  & ~i_sel[0] & o_data[5];
    assign tmp4[3] = i_sel[1]  & i_sel[0]  & i_data[4];
    assign d[4]  = tmp4[0] | tmp4[1] | tmp4[2] | tmp4[3];
    
    // mux4-1 for d-ff5
    assign tmp5[0] = ~i_sel[1] & ~i_sel[0] & o_data[5];
    assign tmp5[1] = ~i_sel[1] & i_sel[0]  & o_data[4];
    assign tmp5[2] = i_sel[1]  & ~i_sel[0] & o_data[6];
    assign tmp5[3] = i_sel[1]  & i_sel[0]  & i_data[5];
    assign d[5]  = tmp5[0] | tmp5[1] | tmp5[2] | tmp5[3];
    
    // mux4-1 for d-ff6
    assign tmp6[0] = ~i_sel[1] & ~i_sel[0] & o_data[6];
    assign tmp6[1] = ~i_sel[1] & i_sel[0]  & o_data[5];
    assign tmp6[2] = i_sel[1]  & ~i_sel[0] & o_data[7];
    assign tmp6[3] = i_sel[1]  & i_sel[0]  & i_data[6];
    assign d[6]  = tmp6[0] | tmp6[1] | tmp6[2] | tmp6[3];
    
    // mux4-1 for d-ff7
    assign tmp7[0] = ~i_sel[1] & ~i_sel[0] & o_data[7];
    assign tmp7[1] = ~i_sel[1] & i_sel[0]  & o_data[6];
    assign tmp7[2] = i_sel[1]  & ~i_sel[0] & i_bit;
    assign tmp7[3] = i_sel[1]  & i_sel[0]  & i_data[7];
    assign d[7]  = tmp7[0] | tmp7[1] | tmp7[2] | tmp7[3];
    
    // d-ff0
    assign w0[0] = ~(w0[3] & w0[1]);// & i_set_);
    assign w0[1] = ~(w0[0] & i_clk);
    assign w0[2] = ~(w0[1] & i_clk  & w0[3]);
    assign w0[3] = ~(d[0]  & w0[2] & i_clr_);//  & i_pre_);
    assign w0[4] = ~(w0[1] & w0[5]);// & i_set_);
    assign w0[5] = ~(w0[2] & w0[4] & i_clr_);//  & i_pre_);
    assign o_data[0]  = w0[4];
    
     // d-ff1
    assign w1[0] = ~(w1[3] & w1[1]);// & i_set_);
    assign w1[1] = ~(w1[0] & i_clk);
    assign w1[2] = ~(w1[1] & i_clk & w1[3]);
    assign w1[3] = ~(d[1]  & w1[2] & i_clr_);//  & i_pre_);
    assign w1[4] = ~(w1[1] & w1[5]);// & i_set_);
    assign w1[5] = ~(w1[2] & w1[4] & i_clr_);//  & i_pre_);
    assign o_data[1]  = w1[4];
    
    // d-ff2
    assign w2[0] = ~(w2[3] & w2[1]);// & i_set_);
    assign w2[1] = ~(w2[0] & i_clk);
    assign w2[2] = ~(w2[1] & i_clk & w2[3]);
    assign w2[3] = ~(d[2]  & w2[2] & i_clr_);//  & i_pre_);
    assign w2[4] = ~(w2[1] & w2[5]);// & i_set_);
    assign w2[5] = ~(w2[2] & w2[4] & i_clr_);//  & i_pre_);
    assign o_data[2]  = w2[4];
    
    // d-ff3
    assign w3[0] = ~(w3[3] & w3[1]);// & i_set_);
    assign w3[1] = ~(w3[0] & i_clk);
    assign w3[2] = ~(w3[1] & i_clk & w3[3]);
    assign w3[3] = ~(d[3]  & w3[2] & i_clr_);//  & i_pre_);
    assign w3[4] = ~(w3[1] & w3[5]); // & i_set_);
    assign w3[5] = ~(w3[2] & w3[4] & i_clr_);//  & i_pre_);
    assign o_data[3]  = w3[4];
    
    // d-ff4
    assign w4[0] = ~(w4[3] & w4[1]);// & i_set_);
    assign w4[1] = ~(w4[0] & i_clk);
    assign w4[2] = ~(w4[1] & i_clk & w4[3]);
    assign w4[3] = ~(d[4]  & w4[2] & i_clr_);//  & i_pre_);
    assign w4[4] = ~(w4[1] & w4[5]);// & i_set_);
    assign w4[5] = ~(w4[2] & w4[4] & i_clr_);//  & i_pre_);
    assign o_data[4]  = w4[4];
    
    // d-ff5
    assign w5[0] = ~(w5[3] & w5[1]);// & i_set_);
    assign w5[1] = ~(w5[0] & i_clk);
    assign w5[2] = ~(w5[1] & i_clk & w5[3]);
    assign w5[3] = ~(d[5]  & w5[2] & i_clr_);//  & i_pre_);
    assign w5[4] = ~(w5[1] & w5[5]);// & i_set_);
    assign w5[5] = ~(w5[2] & w5[4] & i_clr_);//  & i_pre_);
    assign o_data[5]  = w5[4];
    
    // d-ff6
    assign w6[0] = ~(w6[3] & w6[1]);// & i_set_);
    assign w6[1] = ~(w6[0] & i_clk);
    assign w6[2] = ~(w6[1] & i_clk & w6[3]);
    assign w6[3] = ~(d[6]  & w6[2] & i_clr_);//  & i_pre_);
    assign w6[4] = ~(w6[1] & w6[5]);// & i_set_);
    assign w6[5] = ~(w6[2] & w6[4] & i_clr_);//  & i_pre_);
    assign o_data[6]  = w6[4];
    
    // d-ff7
    assign w7[0] = ~(w7[3] & w7[1]);// & i_set_);
    assign w7[1] = ~(w7[0] & i_clk);
    assign w7[2] = ~(w7[1] & i_clk & w7[3]);
    assign w7[3] = ~(d[7]  & w7[2] & i_clr_);//  & i_pre_);
    assign w7[4] = ~(w7[1] & w7[5]);// & i_set_);
    assign w7[5] = ~(w7[2] & w7[4] & i_clr_);//  & i_pre_);
    assign o_data[7]  = w7[4];
    
endmodule
//Using procedure blocks
module shiftRegister_8b_3(o_data, o_bit, i_data, i_bit, i_clk, i_leftRight, i_loadEn_, i_clr_);
    output[7:0] o_data;
    output o_bit;
    input[7:0] i_data;
    input i_leftRight; //left:0 right:1
    input i_bit, i_clk;
    input i_loadEn_, i_clr_; 
    
    reg[7:0] q;
    reg o_bit;
    assign o_data = q;
    //assign o_bit = i_leftRight? o_data[0]: o_data[7];
    always @ (posedge i_clk or negedge i_clr_) begin
      if (!i_clr_)begin
  	   	o_bit <= 1'bz;
  		   q <= 8'b0 ;
		   end
      else if (!i_loadEn_)begin
  	   	o_bit <= 1'bz;
  	   	q <= i_data;
  	   	end
      else if(!i_leftRight)begin
 	     o_bit <=  q[7];
 	     q <= {q[6:0], i_bit};
 	     end
	    else if(i_leftRight)begin
	     o_bit <= q[0];
	     q <= {i_bit, q[7:1]};
	     end
    end
endmodule

module shiftRegister_32b_1(o_data, i_data, i_bit, i_sel, i_clk, i_clr_);
    output[31:0] o_data;
    input[31:0] i_data;
    input[1:0] i_sel;
    //0: no change (no load)
    //1: shift left 1bit
    //2: shift right 1bit
    //3: load data
    input i_bit, i_clr_, i_clk;
    
    wire [31:0] d;  

   	mux4to1_rtl_1b m1[31:0] (
   		.o_res(d[31:0]), 
   		.i_sel(i_sel), 
   		.i_data0(o_data[31:0]), 
   		.i_data1({o_data[30:0], i_bit}), 
   		.i_data2({i_bit, o_data[31:1]}), 
   		.i_data3(i_data[31:0])
   		);    

	//using dffs that have both clr and pre
    dff_rtl2 dff[31:0] (
    	.o_Q(o_data[31:0]), 
    	.i_D(d[31:0]), 
    	.i_clk(i_clk), 
    	.i_pre_(1'b1), 
        .i_clr_(i_clr_)
    	);
endmodule

module shiftRegister_32b_2(o_data, i_data, i_bit, i_sel, i_clk, i_clr_);
    output[31:0] o_data;
    input[31:0] i_data;
    input[1:0] i_sel;
    //0: pass
    //1: shift left 1bit
    //2: shift right 1bit
    //3: load data
    input i_bit, i_clr_, i_clk;
    
    wire [31:0] d;  

   	mux4to1_rtl_1b m1[31:0] (
   		.o_res(d[31:0]), 
   		.i_sel(i_sel), 
   		.i_data0(o_data[31:0]), 
   		.i_data1({o_data[30:0], i_bit}), 
   		.i_data2({i_bit, o_data[31:1]}), 
   		.i_data3(i_data[31:0])
   		);    

	//using dffs that have both clr and pre
    dff_rtl2 dff[31:0] (
    	.o_Q(o_data[31:0]), 
    	.i_D(d[31:0]), 
    	.i_clk(i_clk), 
    	.i_pre_(1'b1), 
        .i_clr_(i_clr_)
    	);
endmodule
