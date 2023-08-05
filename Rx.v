`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2023 02:20:19 PM
// Design Name: 
// Module Name: Rx
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


module Rx(
    input clk,rst,
    input rx,
    input tick,
    output  [7:0] data_,
    output reg done
    );
    reg [7:0] data_rx,data_rx_final;
    reg [1:0] curr_state,next_state;
    reg [4:0]num_ticks,num_ticks_next;
    reg [2:0] data_bits,data_bits_next;
    parameter           idle=2'b00,
                        start=2'b01,
                        data=2'b10,
                        stop=2'b11;
                        
    always@(posedge clk,posedge rst)begin
    if(rst) begin
      curr_state<=idle;
      num_ticks_next<=0;
      data_bits_next<=0;
      data_rx<=0;
      end
    else begin
          curr_state<=next_state;
          num_ticks_next<=num_ticks;
          data_bits_next<=data_bits;
          data_rx_final<=data_rx;
    end
    end
    always@(*)begin
    done=0;  
    data_bits=data_bits_next;
    num_ticks=num_ticks_next;
    data_rx=data_rx_final;
    case(curr_state)
    idle:begin
    if(rx==0)begin
     next_state=start;
    end
    else
     next_state=curr_state;
    end
    start:begin
        if(tick)
          if(num_ticks==7)begin
           next_state=data;
           num_ticks=0;
          end
          else begin
           num_ticks=num_ticks_next+1;
           next_state=curr_state;    
          end
        else
         next_state=curr_state;
    end
    data:begin
        if(tick)    
            if(num_ticks_next==15)begin
                num_ticks=0;
                data_rx={rx,data_rx_final[7:1]};
                if(data_bits_next==7)begin
                    next_state=stop;
                    data_bits=0;
                end
                else begin
                   next_state=curr_state;
                   data_bits=data_bits_next+1;
                end 
            end   
            else begin
               num_ticks=num_ticks_next+1;
               next_state=curr_state;
            end
        else
         next_state=curr_state;
    end
    stop:begin
     if(tick)    
            if(num_ticks_next==15) begin
              next_state=idle;
              num_ticks=0;
              done=1;  
            
            end
            else begin
              num_ticks=num_ticks_next+1;
              next_state=curr_state;
              done=0;  
            end
     else
       next_state=curr_state;
            
    end
    default: begin
    next_state=curr_state;
    num_ticks=num_ticks_next;
    data_bits=data_bits_next;
    done=0; 
    data_rx=data_rx_final; 

    

    end
    endcase
    end
    
    assign data_=data_rx_final;
    
endmodule
