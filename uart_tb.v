`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2023 10:34:22 PM
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tb(

    );
    reg clk,reset,rd_en,wr_en;
    reg [7:0] data_in;
    wire [7:0]data_out;
    reg [9:0] final;
    top_uart uart(.clk(clk),.reset(reset),.data_in(data_in),.final_value(final),.rd_en(rd_en),.wr_en(wr_en),. data_out(data_out));
    
    
    parameter T=10;

   
    always begin
    clk='b0;
    #(T/2);
    clk='b1;
    #(T/2);
    end
    
    initial begin
     reset=1;
     final=650;
     #T;
     reset=0;
     #(10*T);
          wr_en=1;
          rd_en=1;
     data_in=8'b11100111;
     #T;
     data_in=8'b10000110;
     #T;
     data_in=8'b11110110;
     #T;
     data_in=8'b11111111;
     #T;
     data_in=8'b10000000;
     #T;
     data_in=8'b11100100;
     #T;
     data_in=8'b11100110;
     #T;
     wr_en=0;
  
    end
endmodule
 
 