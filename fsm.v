`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:19:16 07/05/2023 
// Design Name: 
// Module Name:    fsm 
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
module fsm(
    input RX,
    input rst,
    input sys_clk,
    output reg [7:0] data_out,
	 output reg error
    );

parameter [1:0] start = 2'b00,
					 data = 2'b01,
					 stop = 2'b10,
					 idle = 2'b11;

reg [1:0] curr_state,next_state;
reg [3:0] counter=1;
reg [2:0] cntr=0;
reg pb=0,flag=0;


always @(posedge sys_clk) begin
	if(rst)
		curr_state = idle;
	else
		curr_state = next_state;
	if(curr_state != idle)
		counter = counter + 1;
		
	if(curr_state == idle)
		counter = 0;
end

	always @(*) begin
		case(curr_state)
			idle: begin
				if(RX == 0) begin
					next_state = start;
					error = 0;
				end
				else
					next_state = curr_state;
			end
			
			start: begin
				if(counter == 7)
					next_state = data;
				flag = 0;
			end
			
			data: begin
				if(counter == 7) begin
					data_out[7-cntr] = RX;
					next_state = curr_state;
					if(cntr == 7) begin
						next_state = stop;
					end
					cntr = cntr + 1;
				end
			end

			stop: begin
				if(counter == 7) begin
					pb = ^data_out;
					if(pb != RX)
						error = 1;
					flag = 1;
				end
				if(flag == 1 && counter == 1)
					next_state = idle;
			end
			
		endcase
	end
endmodule
