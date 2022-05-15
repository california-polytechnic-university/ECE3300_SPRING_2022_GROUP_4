`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 05:53:30 PM
// Design Name: 
// Module Name: counter
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

module counter
#(parameter   N=1,        // count width
  parameter   M=2**N-1)   // count maximum, normally allow every possible combination of bits

(
    input clk,
    input rst,
    input E,                // enable
    output reg [N-1:0] C,   // count
    output T                // count at terminal count, next increment will roll the counter over
);
    
    always@(posedge clk or posedge rst)
    begin
        if (rst == 1'b1) // asynchronous reset
           C <= 'b0;
        else if (E == 1'b1)
        begin
            if (T == 1'b1)
                C <= 'b0; // count at terminal value, roll over
            else
                C <= C + 1'b1; // count not at terminal value, increment by one
        end
        else
            C <= C; // not enabled, hold value
    end
    assign T = (C == M) ? 1'b1 : 1'b0; // count at terminal value?
endmodule