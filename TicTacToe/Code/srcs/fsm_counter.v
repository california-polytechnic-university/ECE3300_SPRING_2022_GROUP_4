`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2022 01:39:58 PM
// Design Name: 
// Module Name: fsm_counter
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


module fsm_counter
#(parameter VC = 2'b11)    
    (
    input clk, reset_n,
    input [9:8] x,
    output [3:0] num
    );
    
    reg [3:0] state_reg, state_next;
    localparam  s0 = 0, s1 = 1, s2 = 2, s3 = 3,
                s4 = 4, s5 = 5, s6 = 6, s7 = 7,
                s8 = 8, s9 = 9;   
    
    // State register
    always @(posedge clk or negedge reset_n)
    begin
        if (reset_n)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end
    
    // Next state logic
    always @(posedge x[9])
    begin
        if(x[9:8] == VC)
            case(state_reg)
                s0: state_next = s1;                            
                s1: state_next = s2;                                
                s2: state_next = s3;                
                s3: state_next = s4;                 
                s4: state_next = s5;                
                s5: state_next = s6;                 
                s6: state_next = s7;         
                s7: state_next = s8;
                s8: state_next = s9;
                s9: state_next = s0;                                                                                                           
                default: state_next = state_reg;            
            endcase
        else
            state_next = state_reg;        
    end
    
    // Output logic
    assign num = reset_n ? 0 : state_reg;
endmodule
