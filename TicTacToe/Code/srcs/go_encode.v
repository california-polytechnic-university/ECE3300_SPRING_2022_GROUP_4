`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 05:53:30 PM
// Design Name: 
// Module Name: go_encode
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

module go_encode(
    input [31:0] mem,
    output [9:0] gameover
    );
    //gameover: bool win, bool winner, bool line[8]
    wire [15:0] line;
    
    // P1 has won in one of eight ways: row 1-3, column 1-3, diagonal up left to bottom right, diagonal up right to bottom left
    assign line[0] = (mem[0] & mem[2] & mem[4]);
    assign line[1] = (mem[8] & mem[10] & mem[12]);
    assign line[2] = (mem[16] & mem[18] & mem[20]);
    assign line[3] = (mem[0] & mem[8] & mem[16]);
    assign line[4] = (mem[2] & mem[10] & mem[18]);
    assign line[5] = (mem[4] & mem[12] & mem[20]);
    assign line[6] = (mem[0] & mem[10] & mem[20]);
    assign line[7] = (mem[4] & mem[10] & mem[16]);
    
    // P2 has won (in the same ways/order as P1 above)
    assign line[8] = (mem[1] & mem[3] & mem[5]);
    assign line[9] = (mem[9] & mem[11] & mem[13]);
    assign line[10] = (mem[17] & mem[19] & mem[21]);
    assign line[11] = (mem[1] & mem[9] & mem[17]);
    assign line[12] = (mem[3] & mem[11] & mem[19]);
    assign line[13] = (mem[5] & mem[13] & mem[21]);
    assign line[14] = (mem[1] & mem[11] & mem[21]);
    assign line[15] = (mem[5] & mem[11] & mem[17]);
    

    assign gameover[0] = line[0] | line[8];
    assign gameover[1] = line[1] | line[9];
    assign gameover[2] = line[2] | line[10];
    assign gameover[3] = line[3] | line[11];
    assign gameover[4] = line[4] | line[12];
    assign gameover[5] = line[5] | line[13];
    assign gameover[6] = line[6] | line[14];
    assign gameover[7] = line[7] | line[15];
    
    assign gameover[8] = gameover[9] & |line[15:8]; // game is over and P2 has won
    
    
    assign gameover[9] = |gameover[7:0]; // game is over
    
    // [9:8] == 2'b10 implies that game is over and p1 has won
endmodule