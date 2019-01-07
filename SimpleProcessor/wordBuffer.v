// 32-bit output, 8-bit input, 4 addresses;
// 32 bits per word
//`timescale 10ps/10ps
module wordBuffer(o_data, i_data, i_address, i_clk);
    output[31:0] o_data;
    input [7:0] i_data;
    input [1:0] i_address;
    input i_clk;

    reg[7:0] buff[3:0];

    assign o_data = {buff[3], buff[2], buff[1], buff[0]};
    always@(i_data or i_clk) begin
      //if(!i_clk)
         buff[i_address] <= i_data;
     //else
        //buff[i_address] <=  buff[i_address];
    end
endmodule
