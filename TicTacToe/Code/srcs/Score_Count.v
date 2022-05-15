`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 10:11:39 PM
// Design Name: 
// Module Name: Score_Count
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


module Score_Count(
    input clk_slow,
    input rst,
    input [9:8] gameover,
    output [3:0] player1_score,
    output [3:0] player2_score
    );

    wire Player1score_En;
    wire Player2score_En;
    assign Player1score_En = (gameover[9:8] == 2'b10) ? 1'b1 : 1'b0;
    assign Player2score_En = (gameover[9:8] == 2'b11) ? 1'b1 : 1'b0;
                    
    up_counter Player1Score(
        .clk(clk_slow), 
        .rst(rst),
        .En(Player1score_En),
        .cnt(player1_score)
        );
    
    up_counter Player2Score(
        .clk(clk_slow), 
        .rst(rst),
        .En(Player2score_En),
        .cnt(player2_score)
        );
                   
                        
endmodule
