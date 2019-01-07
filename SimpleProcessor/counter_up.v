// 4-bit binary synchronous counter with D-ff

module  counter_4b_u1(Q,en,clk);
  output[3:0] Q;
  input en;
  input clk;
  
  reg[3:0] Q;
  wire[3:0] D;
  wire[2:0] tmp1;
  wire[3:0] tmp2;
  wire[3:0] tmp3;
  
  not (en_, en);
  //D0
  xor (D[0], Q[0], en);
  //D1
  xor (tmp1[0], Q[1], Q[0]);
  and (tmp1[1], tmp1[0], en);
  and (tmp1[2], Q[1], en_);
  or (D[1], tmp1[1], tmp1[2]);
  //D2
  and (tmp2[0], Q[1], Q[0]);
  xor (tmp2[1], Q[2], tmp2[0]);
  and (tmp2[2], tmp2[1], en);
  and (tmp2[3], Q[2], en_);
  or (D[2], tmp2[3], tmp2[2]);
  //D3
  and (tmp3[0] ,Q[0], Q[1], Q[2]);
  xor (tmp3[1], tmp3[0], Q[3]);
  and (tmp3[2], tmp3[1], en);
  and (tmp3[3], Q[3], en_);
  or (D[3], tmp3[2], tmp3[3]);
   
  always@(posedge clk) begin
    Q[0] <= D[0];
    Q[1] <= D[1];
    Q[2] <= D[2];
    Q[3] <= D[3];
  end
  initial Q = 4'b0000; 
endmodule

// 4-bit binary synchronous counter with JK-ff without input value
// module  counter_4b_u2a(o_count, i_en, i_clr_, i_clk);
//   output[3:0] o_count;
//   input i_en;
//   input i_clr_;
//   input i_clk;
  
//   reg[3:0] Q;
//   wire[3:0] J,K;
  
//   assign o_count = Q;
//   //JK0
//   assign J[0] = i_en;
//   assign K[0] = J[0];
//   //JK1
//   and (J[1], Q[0], i_en);
//   assign K[1] = J[1];
//   //JK2
//   and (J[2], Q[1], Q[0], i_en);
//   assign K[2] = J[2];
//   //JK3
//   and (J[3], Q[2], Q[1], Q[0], i_en);
//   assign K[3] = J[3];
  
//   always@(negedge i_clr_)
//     Q <= 4'b0;
  
//   always@(posedge i_clk) begin
//   case({J[0], K[0]})
//      2'b0_0: Q[0] <= Q[0];
//      2'b0_1: Q[0] <= 1'b0;
//      2'b1_0: Q[0] <= 1'b1;
//      2'b1_1: Q[0] <= ~Q[0];
//   endcase
//   case({J[1], K[1]})
//      2'b0_0: Q[1] <= Q[1];
//      2'b0_1: Q[1] <= 1'b0;
//      2'b1_0: Q[1] <= 1'b1;
//      2'b1_1: Q[1] <= ~Q[1];
//   endcase
//   case({J[2],  K[2]})
//      2'b0_0: Q[2] <= Q[2];
//      2'b0_1: Q[2] <= 1'b0;
//      2'b1_0: Q[2] <= 1'b1;
//      2'b1_1: Q[2] <= ~Q[2];
//   endcase
//   case({J[3], K[3]})
//      2'b0_0: Q[3] <= Q[3];
//      2'b0_1: Q[3] <= 1'b0;
//      2'b1_0: Q[3] <= 1'b1;
//      2'b1_1: Q[3] <= ~Q[3];
//   endcase
// end  
// endmodule

// 4-bit binary synchronous counter with JK-ff with input value
module  counter_4b_u2b(o_count, i_input, i_set_, i_en, i_clr_, i_clk);
  output[3:0] o_count;
  input[3:0] i_input;
  input i_set_;
  input i_en;
  input i_clr_;
  input i_clk;
  
  wire set;
  wire[3:0] pre, clr;
  wire[3:0] input_;
  wire[3:0] J, K;
  reg[3:0] Q;
   
  assign o_count = Q;
  not (set, i_set_); 
  //JK0
  assign J[0] = i_en;
  assign K[0] = J[0];
  //JK1
  and (J[1], Q[0], i_en);
  assign K[1] = J[1];
  //JK2
  and (J[2], Q[1], Q[0], i_en);
  assign K[2] = J[2];
  //JK3
  and (J[3], Q[2], Q[1], Q[0], i_en);
  assign K[3] = J[3];
  //pre
  nand (pre[0], i_input[0], set);
  nand (pre[1], i_input[1], set);
  nand (pre[2], i_input[2], set);
  nand (pre[3], i_input[3], set);
  //clr
  not (input_[0], i_input[0]);
  not (input_[1], i_input[1]);
  not (input_[2], i_input[2]);
  not (input_[3], i_input[3]);
  nand (clr[0], input_[0], set);
  nand (clr[1], input_[1], set);
  nand (clr[2], input_[2], set);
  nand (clr[3], input_[3], set);
  
  always@(negedge i_clr_)
    Q <= 4'b0;
  
  always@(posedge i_clk) begin
     if(pre[0] == 1'b0) Q[0] <= 1'b1;
     else if(clr[0] == 1'b0) Q[0] <= 1'b0;
     else case({J[0], K[0]})
        2'b0_0: Q[0] <= Q[0];
        2'b0_1: Q[0] <= 1'b0;
        2'b1_0: Q[0] <= 1'b1;
        2'b1_1: Q[0] <= ~Q[0];
     endcase
     
     if(pre[1] == 1'b0) Q[1] <= 1'b1;
     else if(clr[1] == 1'b0) Q[1] <= 1'b0;
     else case({J[1], K[1]})
        2'b0_0: Q[1] <= Q[1];
        2'b0_1: Q[1] <= 1'b0;
        2'b1_0: Q[1] <= 1'b1;
        2'b1_1: Q[1] <= ~Q[1];
     endcase
     
     if(pre[2] == 1'b0) Q[2] <= 1'b1;
     else if(clr[2] == 1'b0) Q[2] <= 1'b0;
     else case({J[2], K[2]})
        2'b0_0: Q[2] <= Q[2];
        2'b0_1: Q[2] <= 1'b0;
        2'b1_0: Q[2] <= 1'b1;
        2'b1_1: Q[2] <= ~Q[2];
     endcase
     
     if(pre[3] == 1'b0) Q[3] <= 1'b1;
     else if(clr[3] == 1'b0) Q[3] <= 1'b0;
     else case({J[3], K[3]})
        2'b0_0: Q[3] <= Q[3];
        2'b0_1: Q[3] <= 1'b0;
        2'b1_0: Q[3] <= 1'b1;
        2'b1_1: Q[3] <= ~Q[3];
   	 endcase
  end   
endmodule


