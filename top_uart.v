`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2023 06:48:12 PM
// Design Name: 
// Module Name: top_uart
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


module top_uart(
    input clk,
    input reset,
    input [7:0] data_in,
    input [9:0]final_value,
    input rd_en,
    input wr_en,
    output [7:0] data_out
    );
    wire data_line,rx_done,tx_done,tx_start; //between rx and tx 
    wire [7:0] fifo_rx,fifo_tx; //input and output of fifo
    wire tick;
    
    Tx tx(.clk(clk),.reset(reset),.tick(tick),.data_in(fifo_tx),.data_start(!tx_start),.tx(data_line),.done_tick(tx_done));
    Rx rx(.clk(clk),.rst(reset),.rx(data_line),.tick(tick),.data_(fifo_rx),.done(rx_done));
    Timer timer(.clk(clk),.reset(reset),.final_value(final_value),.tick(tick) );    
    fifo_generator_0 tx_fifo (.clk(clk),.srst(reset),.din(data_in),.wr_en(wr_en),.rd_en(tx_done),.dout(fifo_tx),.full(),.empty(tx_start)  );    
    fifo_generator_0 rx_fifo (.clk(clk),.srst(reset),.din(fifo_rx),.wr_en(rx_done),.rd_en(rd_en),.dout(data_out),.full(),.empty()  );    

    endmodule
