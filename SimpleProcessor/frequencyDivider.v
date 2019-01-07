//frequency divider
//o_freq = i_freq % 2^n 
module frequencyDivider_beh(o_freq, i_freq, i_clr_);
  parameter n=2; // o_clk = i_clk % 2^n 
  output o_freq;
  input  i_freq, i_clr_;
  
  reg [n-1:0] delay;
  assign o_freq = delay[n-1];
  always@(posedge i_freq or negedge i_clr_)begin
    if(!i_clr_)
      delay = 'b0;
    else
      delay <= delay+1;
  end
  
endmodule


