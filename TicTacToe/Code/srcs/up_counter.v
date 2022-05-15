`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 06:47:05 PM
// Design Name: 
// Module Name: up_counter
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


module up_counter(
    input clk, 
    input rst,
    input En,
    output wire [3:0] cnt
    );
    reg [3:0] tmp;
    
    
    always@(posedge clk or posedge En)
            begin
                if(rst)
                        tmp <= 0;
                else 
                   begin
                       if(En)
                           begin
                               if(tmp < 4'd9)
                                    tmp <= tmp + 1;
                               else if(tmp == 4'd9)
                                        tmp <= 0;
                           end
                       else
                            tmp <= tmp;
                   end
             end

assign cnt = tmp;           
          
endmodule

