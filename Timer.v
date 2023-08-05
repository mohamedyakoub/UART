`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2023 01:20:46 PM
// Design Name: 
// Module Name: Timer
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


module Timer#(parameter Bits=10)(
    input clk,
    input reset,
    input [Bits-1:0] final_value,
    output tick
    );
 
 reg [Bits-1:0] counter;
    
 always@(posedge clk )begin
 if(reset)
   counter<=0;
 else
   counter<=  (counter==final_value)? 0:counter+1;
 end
 
 
 assign tick= (counter==final_value);
 
    
endmodule
