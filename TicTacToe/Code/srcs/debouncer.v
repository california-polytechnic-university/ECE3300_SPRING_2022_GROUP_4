`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2022 08:38:00 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer
#(parameter N=16'hffff)
    (
    input clk,
    input rst,
    input I,
    output Y
    );
       // as clock input is undivided from the 100MHz base, N=2^16-1 -> maximum noise period = 655us or 0.6ms
    reg [15:0] C;           // "time" since last input flip
    reg [1:0] ps;           // state machine's present state, 
    // 00 is low, no recent input flip, 01 
    
    always@(posedge clk or posedge rst)begin
        if (rst == 1'b1)
                C <= 'b0;
        else if (ps == 2'b01 || ps == 2'b10)
            C <= C + 1'b1; // count only while in a transition state
        else
            C <= 'b0; // reset counter while in stable state, to prepare for transition
    end
    always@(posedge clk or posedge rst) begin // set state machine registers, depending on current state, input, count, and max count
        if (rst == 1'b1)
                ps <= 'b0;
        else begin case (ps)
            2'b00: ps <= (I) ? 2'b01 : 2'b00;                       // OFF - no recent input flip
            2'b01: ps <= (I) ? (C == N) ? 2'b11 : 2'b01 : 2'b00;    // OFF - counting time, if no second input flip in maximum noise period, transition to ON
            2'b11: ps <= (I) ? 2'b11 : 2'b10;                       // ON - no recent input flip
            2'b10: ps <= (I) ? 2'b11 : (C == N) ? 2'b00 : 2'b10;    // ON - counting time, if no second input flip in maximum noise period, transition to OFF
        endcase
        end
    end
    assign Y = ps[1]; // set the output
endmodule
