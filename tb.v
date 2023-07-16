`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:57 07/07/2023 
// Design Name: 
// Module Name:    tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tb;
	parameter clk_period = 10;
	reg clk = 0;
	always #(clk_period/2) clk = ~ clk;
	reg RX_tb,rst_tb;
	wire [7:0] data_out_tb;
	wire error_tb;
	
	top dut (
    .RX(RX_tb), 
    .rst(rst_tb), 
    .clk(clk), 
    .data_out(data_out_tb), 
    .error(error_tb)
    );
	 
	 parameter arr = 27'b111101110010111001001101011;
	 reg [4:0] i;
	 initial begin
		rst_tb = 1;
		#(clk_period);
		rst_tb = 0;
		#(clk_period);
		for(i=0;i<27;i=i+1) begin
			RX_tb = arr[26-i];
			$display("%b",RX_tb);
			#(16*clk_period);
		end
		#(16*clk_period);

		$finish();
		
	 end


endmodule
