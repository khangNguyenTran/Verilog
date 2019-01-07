// 32x32 register file: 5-bit Add with 1-bit enable 
// 2 read ports: 32 bits per ports
// 1 write port: 32 bits 

// RTL level register file
module registerFile_rtl_32x32_1(
   	o_readData1, o_readData2, 
  	i_readAdd1, i_readAdd2, 
  	i_writeAdd, i_writeData,
  	i_clk
  	);
  	
 	output[31:0] o_readData1, o_readData2; 
  	input[4:0] i_readAdd1, i_readAdd2, i_writeAdd;
   	input[31:0] i_writeData;
   	input i_clk;
  	
  	wire writeSel[31:0], read1Sel[31:0], read2Sel[31:0];
  	
	decoder_5to32 d0( // write decoder
	    .o_bit0(writeSel[0]),   .o_bit1(writeSel[1]),   .o_bit2(writeSel[2]),   .o_bit3(writeSel[3]),   .o_bit4(writeSel[4]),   .o_bit5(writeSel[5]),   .o_bit6(writeSel[6]),   .o_bit7(writeSel[7]),
	    .o_bit8(writeSel[8]),   .o_bit9(writeSel[9]),   .o_bit10(writeSel[10]), .o_bit11(writeSel[11]), .o_bit12(writeSel[12]), .o_bit13(writeSel[13]), .o_bit14(writeSel[14]), .o_bit15(writeSel[15]),
	    .o_bit16(writeSel[16]), .o_bit17(writeSel[17]), .o_bit18(writeSel[18]), .o_bit19(writeSel[19]), .o_bit20(writeSel[20]), .o_bit21(writeSel[21]), .o_bit22(writeSel[22]), .o_bit23(writeSel[23]), 
	    .o_bit24(writeSel[24]), .o_bit25(writeSel[25]), .o_bit26(writeSel[26]), .o_bit27(writeSel[27]), .o_bit28(writeSel[28]), .o_bit29(writeSel[29]), .o_bit30(writeSel[30]), .o_bit31(writeSel[31]),
	    .i_sel(i_writeAdd)
	   	);	
	decoder_5to32 d1( // read 1 decoder
	    .o_bit0(read1Sel[0]),   .o_bit1(read1Sel[1]),   .o_bit2(read1Sel[2]),   .o_bit3(read1Sel[3]),   .o_bit4(read1Sel[4]),   .o_bit5(read1Sel[5]),   .o_bit6(read1Sel[6]),   .o_bit7(read1Sel[7]),
	    .o_bit8(read1Sel[8]),   .o_bit9(read1Sel[9]),   .o_bit10(read1Sel[10]), .o_bit11(read1Sel[11]), .o_bit12(read1Sel[12]), .o_bit13(read1Sel[13]), .o_bit14(read1Sel[14]), .o_bit15(read1Sel[15]),
	    .o_bit16(read1Sel[16]), .o_bit17(read1Sel[17]), .o_bit18(read1Sel[18]), .o_bit19(read1Sel[19]), .o_bit20(read1Sel[20]), .o_bit21(read1Sel[21]), .o_bit22(read1Sel[22]), .o_bit23(read1Sel[23]), 
	    .o_bit24(read1Sel[24]), .o_bit25(read1Sel[25]), .o_bit26(read1Sel[26]), .o_bit27(read1Sel[27]), .o_bit28(read1Sel[28]), .o_bit29(read1Sel[29]), .o_bit30(read1Sel[30]), .o_bit31(read1Sel[31]),
	    .i_sel(i_readAdd1)
	   	);
	decoder_5to32 d2( // read 2 decoder
	    .o_bit0(read2Sel[0]),   .o_bit1(read2Sel[1]),   .o_bit2(read2Sel[2]),   .o_bit3(read2Sel[3]),   .o_bit4(read2Sel[4]),   .o_bit5(read2Sel[5]),   .o_bit6(read2Sel[6]),   .o_bit7(read2Sel[7]),
	    .o_bit8(read2Sel[8]),   .o_bit9(read2Sel[9]),   .o_bit10(read2Sel[10]), .o_bit11(read2Sel[11]), .o_bit12(read2Sel[12]), .o_bit13(read2Sel[13]), .o_bit14(read2Sel[14]), .o_bit15(read2Sel[15]),
	    .o_bit16(read2Sel[16]), .o_bit17(read2Sel[17]), .o_bit18(read2Sel[18]), .o_bit19(read2Sel[19]), .o_bit20(read2Sel[20]), .o_bit21(read2Sel[21]), .o_bit22(read2Sel[22]), .o_bit23(read2Sel[23]), 
	    .o_bit24(read2Sel[24]), .o_bit25(read2Sel[25]), .o_bit26(read2Sel[26]), .o_bit27(read2Sel[27]), .o_bit28(read2Sel[28]), .o_bit29(read2Sel[29]), .o_bit30(read2Sel[30]), .o_bit31(read2Sel[31]),
	    .i_sel(i_readAdd2)
	   	); 	
  	RFC rfc0[31:0]( // first register is always zero
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(32'b0), 
  	 .i_readEn1(read1Sel[0]), 
  	 .i_readEn2(read2Sel[0]), 
  	 .i_writeEn(1'b1), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc1[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[1]), 
  	 .i_readEn2(read2Sel[1]), 
  	 .i_writeEn(writeSel[1]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc2[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[2]), 
  	 .i_readEn2(read2Sel[2]), 
  	 .i_writeEn(writeSel[2]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc3[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[3]), 
  	 .i_readEn2(read2Sel[3]), 
  	 .i_writeEn(writeSel[3]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc4[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[4]), 
  	 .i_readEn2(read2Sel[4]), 
  	 .i_writeEn(writeSel[4]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc5[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[5]), 
  	 .i_readEn2(read2Sel[5]), 
  	 .i_writeEn(writeSel[5]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc6[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[6]), 
  	 .i_readEn2(read2Sel[6]), 
  	 .i_writeEn(writeSel[6]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc7[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[7]), 
  	 .i_readEn2(read2Sel[7]), 
  	 .i_writeEn(writeSel[7]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc8[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[8]), 
  	 .i_readEn2(read2Sel[8]), 
  	 .i_writeEn(writeSel[8]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc9[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[9]), 
  	 .i_readEn2(read2Sel[9]), 
  	 .i_writeEn(writeSel[9]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc10[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[10]), 
  	 .i_readEn2(read2Sel[10]), 
  	 .i_writeEn(writeSel[10]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc11[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[11]), 
  	 .i_readEn2(read2Sel[11]), 
  	 .i_writeEn(writeSel[11]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc12[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[12]), 
  	 .i_readEn2(read2Sel[12]), 
  	 .i_writeEn(writeSel[12]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc13[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[13]), 
  	 .i_readEn2(read2Sel[13]), 
  	 .i_writeEn(writeSel[13]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc14[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[14]), 
  	 .i_readEn2(read2Sel[14]), 
  	 .i_writeEn(writeSel[14]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc15[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[15]), 
  	 .i_readEn2(read2Sel[15]), 
  	 .i_writeEn(writeSel[15]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc16[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[16]), 
  	 .i_readEn2(read2Sel[16]), 
  	 .i_writeEn(writeSel[16]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc17[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[17]), 
  	 .i_readEn2(read2Sel[17]), 
  	 .i_writeEn(writeSel[17]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc18[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[18]), 
  	 .i_readEn2(read2Sel[18]), 
  	 .i_writeEn(writeSel[18]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc19[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[19]), 
  	 .i_readEn2(read2Sel[19]), 
  	 .i_writeEn(writeSel[19]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc20[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[20]), 
  	 .i_readEn2(read2Sel[20]), 
  	 .i_writeEn(writeSel[20]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc21[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[21]), 
  	 .i_readEn2(read2Sel[21]), 
  	 .i_writeEn(writeSel[21]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc22[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[22]), 
  	 .i_readEn2(read2Sel[22]), 
  	 .i_writeEn(writeSel[22]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc23[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[23]), 
  	 .i_readEn2(read2Sel[23]), 
  	 .i_writeEn(writeSel[23]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc24[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[24]), 
  	 .i_readEn2(read2Sel[24]), 
  	 .i_writeEn(writeSel[24]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc25[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[25]), 
  	 .i_readEn2(read2Sel[25]), 
  	 .i_writeEn(writeSel[25]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc26[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[26]), 
  	 .i_readEn2(read2Sel[26]), 
  	 .i_writeEn(writeSel[26]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc27[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[27]), 
  	 .i_readEn2(read2Sel[27]), 
  	 .i_writeEn(writeSel[27]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc28[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[28]), 
  	 .i_readEn2(read2Sel[28]), 
  	 .i_writeEn(writeSel[28]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc29[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[29]), 
  	 .i_readEn2(read2Sel[29]), 
  	 .i_writeEn(writeSel[29]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc30[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[30]), 
  	 .i_readEn2(read2Sel[30]), 
  	 .i_writeEn(writeSel[30]), 
  	 .i_clk(i_clk)
  	 );
	 RFC rfc31[31:0](
  	 .o_bit1(o_readData1[31:0]), 
  	 .o_bit2(o_readData2[31:0]), 
  	 .i_bit(i_writeData[31:0]), 
  	 .i_readEn1(read1Sel[31]), 
  	 .i_readEn2(read2Sel[31]), 
  	 .i_writeEn(writeSel[31]), 
  	 .i_clk(i_clk)
  	 );
endmodule

// behavior level register file
module registerFile_beh_32x32_1(
  	o_readData1, 
	o_readData2, 
  	i_readAdd1, 
	i_readAdd2, 
	i_readEn1, 
	i_readEn2,
  	i_writeAdd, 
	i_writeEn, 
	i_writeData,
  	i_clk
  	);
  	//parameter noDataBits = 32;
  	
   output[31:0] o_readData1, o_readData2; 
   input[4:0] i_readAdd1, i_readAdd2, i_writeAdd;
   input i_readEn1, i_readEn2, i_writeEn;
   input[31:0]	i_writeData;
   input i_clk;
  
   reg[31:0] o_readData1, o_readData2;    
   reg[31:0] rfc[31:0];

   always@(posedge i_clk) begin
    if(i_readEn1) 
      o_readData1 <= (i_readAdd1 !== 'b0)? rfc[i_readAdd1]: 'b0;
	else 
	  o_readData1 <= 'bx;

    if(i_readEn2)
      o_readData2 <= (i_readAdd2 !== 'b0)? rfc[i_readAdd2]: 'b0;
	else 
	  o_readData2 <= 'bx;

    if(i_writeEn)  
      rfc[i_writeAdd] <= (i_writeAdd !== 'b0)? i_writeData: 'b0;    
	  
	  rfc['b0] <= 'b0;
   end
   
endmodule

// 32x32 behavior level register file 
module registerFile_beh_32x32_2(  
  o_readData1, 
  o_readData2, 
  i_readAdd1, 
  i_readAdd2, 
  i_readWriteEn,
  i_writeAdd, 
  i_writeData,
  i_clk
  );

  output[31:0] o_readData1, o_readData2;  
  input[4:0] i_readAdd1, i_readAdd2, i_writeAdd;
  input[31:0] i_writeData;
  input i_clk;
  input i_readWriteEn; 

  reg[31:0] rfc[31:0];
  reg[31:0] o_readData1, o_readData2;
  always@(posedge i_clk) begin
    if(i_readWriteEn == 1'b0) begin  //read
      o_readData1 <= rfc[i_readAdd1];
      o_readData2 <= rfc[i_readAdd2];
     end 
    else begin //write  
      rfc[i_writeAdd] <= i_writeData;
    end
	  rfc['b0] <= 'b0;
  end  
endmodule

// 32x32 behavior level register file readWriteEn
module registerFile_beh_32x32_3( 
  o_readData1, 
  o_readData2,  
  i_readAdd1, 
  i_readAdd2, 
  i_writeAdd, 
  i_writeData,
  i_writeEn,
  i_clk
  );

  output[31:0] o_readData1, o_readData2;  
  input[4:0] i_readAdd1, i_readAdd2, i_writeAdd;
  input[31:0] i_writeData;
  input i_writeEn, i_clk;

  reg[31:0] rfc[31:0];
  reg[31:0] o_readData1, o_readData2;
  always@(edge i_clk) begin
      o_readData1  		<= rfc[i_readAdd1];
      o_readData2  		<= rfc[i_readAdd2];
      rfc[i_writeAdd]	<= (i_writeEn)? i_writeData: rfc[i_writeAdd];
	  rfc['b0]			<= 'b0;
  end
endmodule