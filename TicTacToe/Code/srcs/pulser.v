`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 05:53:30 PM
// Design Name: 
// Module Name: pulser
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

module pulser
#(parameter PE = 1)(
    input       clk,
    input       rst,
    input       I,
    output wire Y
    );

    reg [1:0] ps; // state machine present state register
    always@(posedge clk or posedge rst)begin
        if (rst == 1'b1)
            ps <= 2'b0;
        else begin case (ps) // no explicit next state register, implied here
            2'b00: ps <= (I) ? 2'b01 : 2'b00;   // wait until input is high, do nothing
            2'b01: ps <= 2'b11;                 // go to wait high state, output POSEDGE pulse
            2'b10: ps <= 2'b00;                 // go to wait low state, output NEGEDGE pulse
            2'b11: ps <= (I) ? 2'b11 : 2'b10;   // wait until input is low, do nothing
        endcase
        end
    end
        // note: removed input ternary on transition states, so that, for instance, a negedge pulse will be generated when the input pulses high for one clock cycle
    
    assign Y = (ps == (PE ? 2'b01 : 2'b10)) ? 1'b1 : 1'b0;
    // output is high on low to high transition state (2'b01) if PE == 1
    // output is high on high to low transition state (2'b10) if PE == 0
endmodule