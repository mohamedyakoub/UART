`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2023 02:12:39 PM
// Design Name: 
// Module Name: Tx
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


module Tx(
    input clk,reset,
    input tick,
    input [7:0] data_in,
    input data_start,
    output tx,done_tick
    );
    reg[3:0] num_ticks,num_ticks_next;
    reg[2:0] data_bits,data_bits_next;
    reg[1:0] curr_state,next_state;
    reg data_out,done;
    parameter         idle=2'b00,
                      start=2'b01,
                      data=2'b10,
                      stop=2'b11;
                      
    always@(posedge clk,posedge reset)begin
        if(reset)begin
        curr_state<=idle;
        num_ticks<=0;
        data_bits<=0;
        end
        else begin
        curr_state<=next_state;
        num_ticks<=num_ticks_next;
        data_bits<=data_bits_next;
        end
    end
    
    
    
    always@(*)begin
    next_state=curr_state;
    num_ticks_next=num_ticks;
    data_bits_next=data_bits;
    done=0;
    case(curr_state)
        idle:begin
            data_out=1;
            if(data_start)begin
                num_ticks_next=0;
                next_state=start;
            end
        end
        
        start:begin
            data_out=0;
            if(tick)
                if(num_ticks==15)begin                                  
                    num_ticks_next=0;
                    next_state=data;
                    data_bits_next=0;
                end
                else begin
                    num_ticks_next=num_ticks+1;
                    next_state=curr_state;
                end
        end
        
        data:begin
           data_out=data_in[data_bits];
           if(tick)
                if(num_ticks==15)begin                                  
                    num_ticks_next=0;
                    if(data_bits==7)
                      next_state=stop;
                    else begin
                      next_state=curr_state; 
                      data_bits_next=data_bits+1;
                    end
                      
                end
                else begin
                    num_ticks_next=num_ticks+1;
                    next_state=curr_state;
                end
        end
        
        stop:begin
            data_out=1;
            if(tick)
                if(num_ticks==15)begin
                    next_state=idle;
                    done=1;
                end
                else
                    num_ticks_next=num_ticks+1;
        end
        
        default:begin
            next_state=idle;
            num_ticks_next=num_ticks;
            data_bits_next=data_bits;
            done=0;      
        end
        
        
    endcase
    end
    assign tx=data_out;
    assign done_tick=done;
endmodule
