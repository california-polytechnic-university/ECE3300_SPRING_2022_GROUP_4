`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State Polytechnic University, Pomona
// Engineer: Joseph Popoviciu
// 
// Create Date: 05/13/2022 04:12:26 PM
// Design Name: 
// Module Name: btn_cntrl
// Project Name: TicTacToe
// Target Devices: Nexys Artix-7
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






module btn_cntrl(
    input En,
    input clk,
    input [7:0] keyboard_data,
    output reg btnC, btnR, btnL, btnU, btnD
    );
    //posedge clk originally with all nonblocking
    always@(posedge clk)begin
        if(~En)
            begin
            btnC <= 0;
            btnR <= 0;
            btnL <= 0;
            btnU <= 0;
            btnD <= 0;
            end
        else begin    
        if(keyboard_data == 8'b0101_1010)
            begin
                btnC <= 1;
                btnR <= 0;
                btnL <= 0;
                btnU <= 0;
                btnD <= 0;
            end
        else if(keyboard_data == 8'b0111_0100)
            begin
                btnC <= 0;
                btnR <= 1;
                btnL <= 0;
                btnU <= 0;
                btnD <= 0;
            end
        else if(keyboard_data == 8'b0110_1011)
            begin
                btnC <= 0;
                btnR <= 0;
                btnL <= 1;
                btnU <= 0;
                btnD <= 0;
            end
        else if(keyboard_data == 8'b0111_0101)
            begin
                btnC <= 0;
                btnR <= 0;
                btnL <= 0;
                btnU <= 1;
                btnD <= 0;
            end
        else if(keyboard_data == 8'b0111_0010)
            begin
                btnC <= 0;
                btnR <= 0;
                btnL <= 0;
                btnU <= 0;
                btnD <= 1;
            end
        end
    end
    
endmodule
