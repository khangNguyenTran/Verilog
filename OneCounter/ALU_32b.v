// 2 modules
// 32-bit ALU
/* 
M | S1 | S0 | ALU operation
0 |  0 | 0  | complement A
0 |  0 | 1  | and
0 |  1 | 0  | exor
0 |  1 | 1  | or
1 |  0 | 0  | decrement A
1 |  0 | 1  | add
1 |  1 | 0  | subtract
1 |  1 | 1  | increment A
*/
module ALU_32b_1(o_data, o_addSubOverflow, i_dataA, i_dataB, i_m, i_sel, i_clk);
  output[31:0] o_data;
  output o_addSubOverflow;
  input[31:0] i_dataA, i_dataB;
  input i_m;
  input[1:0] i_sel;
  input i_clk;
  
  reg[31:0] o_data;
  reg o_addSubOverflow;
  
  always@(posedge i_clk)
    case({i_m, i_sel})
      3'b000: begin
        o_data = ~i_dataA + 1;
        o_addSubOverflow = 1'b0;
      end
      3'b001: begin
        o_data = i_dataA & i_dataB;
        o_addSubOverflow = 1'b0;
      end
      3'b010: begin
        o_data = i_dataA ^ i_dataB;
        o_addSubOverflow = 1'b0;
      end
      3'b011: begin
        o_data = i_dataA | i_dataB;
        o_addSubOverflow = 1'b0;
      end
      3'b100: begin
        o_data = i_dataA - 1;
        o_addSubOverflow = 1'b0;
      end
      3'b101: begin
        {o_addSubOverflow, o_data} = i_dataA + i_dataB;
      end
      3'b110: begin
        {o_addSubOverflow, o_data} = i_dataA - i_dataB;
      end
      3'b111: begin
        o_data = i_dataA + 1;
        o_addSubOverflow = 1'b0;
      end
    endcase
endmodule

//RTL 32-bit ALU
module ALU_32b_2(o_data, o_addSubOverflow, i_dataA, i_dataB, i_m, i_sel);
  output[31:0] o_data;
  output o_addSubOverflow;
  input[31:0] i_dataA, i_dataB;
  input i_m;
  input[1:0] i_sel;
  
  wire[31:0] o_data;
  wire o_addSubOverflow;  
  wire[31:0] res[7:0];
  
  wire of_adder, of_subtractor;
  assign o_addSubOverflow = ((i_m & ~i_sel[1] & i_sel[0]) & of_adder) 
										| ((i_m & i_sel[1] & ~i_sel[0]) & of_subtractor);
  //complement A
  complement_32b c0(
    .o_data(res[0]),
    .i_data(i_dataA)
    );
  //AND  
   assign res[1] = i_dataA & i_dataB;
  //XOR
   assign res[2] = i_dataA ^ i_dataB;
  //OR
   assign res[3] = i_dataA | i_dataB;
  //Decrement A
  subtractor_32b s0(
    .o_res(res[4]), 
    .i_dataA(i_dataA), 
    .i_dataB(32'b1), //decrease 1
    .i_cin(1'b0)
    );
  //Add A and B
  fa_32b fa0(
    .o_cout(of_adder), 
    .o_sum(res[5]), 
    .i_dataA(i_dataA), 
    .i_dataB(i_dataB), 
    .i_cin(1'b0)
    );
  //Subtract A to B
  subtractor_32b s1(
    .o_cout(of_subtractor), 
    .o_res(res[6]), 
    .i_dataA(i_dataA), 
    .i_dataB(i_dataB), 
    .i_cin(1'b0)
    );
  //Increment A
  fa_32b fa1(
    .o_sum(res[7]), 
    .i_dataA(i_dataA), 
    .i_dataB(32'b1), //add 1
    .i_cin(1'b0)
    );
  //mux8-1 for output selection
  mux8to1_rtl_32b m0(
    .o_res(o_data), 
    .i_sel({i_m, i_sel}), 
    .i_data0(res[0]), 
    .i_data1(res[1]),
    .i_data2(res[2]), 
    .i_data3(res[3]), 
    .i_data4(res[4]), 
    .i_data5(res[5]), 
    .i_data6(res[6]), 
    .i_data7(res[7])
    );
endmodule