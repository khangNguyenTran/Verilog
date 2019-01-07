//3 modules   
//structural d-latch from 4 NANDs
module dlatch_srt1(o_Q, i_D, i_en);
  output o_Q;
  input i_D, i_en;
  
  wire w[1:0];
  wire d_, Q_;
  
  not  no0(d_,   i_D);
  nand na0(w[0], i_D,  i_en);
  nand na1(w[1], d_,   i_en);
  nand na2(o_Q,  w[0], Q_);
  nand na3(Q_, w[1], o_Q);  
endmodule

//RTL d-latch from 4 NANDs
module dlatch_rtl1(o_Q, i_D, i_en);// dlatch RTL 1
  output o_Q;
  input i_D, i_en;
  
  wire w0, w1, Q_;
  
  assign w0 = ~(i_D & i_en);
  assign w1 = ~(~i_D & i_en);
  assign o_Q  = ~(w0 & Q_);
  assign Q_ = ~(w1 & o_Q);
endmodule

module dlatch_s1(o_Q, i_D, i_en, i_cs); 
//special d-latch used for creating SRAM4x2
//Q, Qnot, D, enable, low level active chip select
		output o_Q;
		input i_D, i_en, i_cs;
		reg Q, o_Q;
		
		always@(i_cs or i_D or i_en)
		begin		
			if(i_en) 	
				if(i_cs) begin
				  o_Q <= 1'bz;	
					Q <= i_D;				
					end
				else
				  o_Q <= Q;
			else begin			
				o_Q <= 1'bz;
				end							
		end
endmodule
