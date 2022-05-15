`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 05:53:30 PM
// Design Name: 
// Module Name: Top
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


module Top(
//EXTERNAL EVENT TRIGGERS FOR FPGA REGISTERS
            input clk,
            input btnCpuReset,
            input [4:0] SW,
            input En,
        //USER INPUT
            input PS2_DATA,
            input PS2_CLK, 
            input btnC,
            input btnR,
            input btnL,
            input btnU,
            input btnD,
        //USER OUTPUT
        //  VGA PINS
            output HS,
            output VS,
            output [3:0] vgaR,
            output [3:0] vgaG,
            output [3:0] vgaB,
        //  RGB LED PINS
            output RGB1_Red,
            output RGB1_Green,
            output RGB1_Blue,
        //  SSegDisplay
            output [6:0] sseg,
            output [7:0] AN,
            output dp,
            output [15:0] LED
        );
    //internal buses
            
            wire [9:0] gameover;
            wire [9:0] gameover_vga;
            wire [3:0] uaddr;
            wire [3:0] vgaaddr;
            wire [1:0] wd;
            wire [1:0] rd;
            wire [1:0] ud;
            wire wen, rst, save;
            wire clk_slow;
    
            wire btnC_connector;
            wire btnR_connector;
            wire btnL_connector;
            wire btnU_connector;
            wire btnD_connector;
            
            
            
    assign rst = ~btnCpuReset; // Nexys4 cpu reset button is ACTIVE LOW, meaning when the button is held down, the signal goes low. I prefer posedge rst for coding style, so inverted the signal
    
    
                //slows the system clock based on 5 input switches
                clk_manager(
                        clk,
                        rst,
                        SW,
                        clk_slow //output
                        );
                        
                assign LED[13] = ~En;        
                assign LED[14] = En;
                assign LED[4:0] = SW[4:0];
                assign LED[15] = clk_slow;
                
                
                //UART FOR KEYBOARD
                wire [7:0]keyboard_data_out;
                Keyboard KeyBoard_PS2(
                    .clk(clk),
                    .PS2_CLK(PS2_CLK),
                    .PS2_DATA(PS2_DATA),
                    .keycode(keyboard_data_out)
                    );

                //Converts the signals from the keyboard UART to the up/down/left/right arrow keys and enter button
                btn_cntrl ButtonControler(
                        .En(En),
                        .clk(clk),
                        .keyboard_data(keyboard_data_out),
                        .btnC(btnC_connector), 
                        .btnR(btnR_connector),
                        .btnL(btnL_connector),
                        .btnU(btnU_connector),
                        .btnD(btnD_connector)
                        );
    
                //handles user inputs, edit if needed
                btn_flsm m0 (
                        .clk(clk),
                        .rst(rst),
                        .btnC(btnC_connector||btnC),       //try using xor operator ^
                        .btnR(btnR_connector||btnR),       //try using xor operator ^
                        .btnL(btnL_connector||btnL),       //try using xor operator ^
                        .btnU(btnU_connector||btnU),       //try using xor operator ^
                        .btnD(btnD_connector||btnD),       //try using xor operator ^ 
                        .ud(ud),             
                        .gameover(gameover),
                        .addr(uaddr),
                        .wd(wd),
                        .wen(wen)
                );
                
                
                // stores game state, do not remove
                reg_array m1 (
                        clk,
                        rst,
                        wen, 
                        wd,
                        uaddr,
                        vgaaddr,
                        save,
                        rd,
                        ud,
                        gameover,
                        gameover_vga
                );
                
                
                // controls the vga output of the board (main way of viewing game state, remove only with extreme caution)
                VGA_AB m2 (
                        clk,
                        rst,
                        rd,
                        uaddr,
                        gameover_vga,
                        HS,
                        VS,
                        {vgaR, vgaG, vgaB},
                        vgaaddr,
                        save
                );
                
                
                
               //sends the corrent color to the RGB_PWM module based on which player won
               reg [2:0] color;
                always@(gameover)                       
                begin
                    if (~gameover[9])
                            color = 3'b010;
                    else            
                       if(gameover[9:8] == 2'b10)
                           color = 3'b100;
                       else if(gameover[9:8] == 2'b11)
                           color = 3'b001;
                       else
                           color = 3'b010;    
                end

                
                reg [3:0] roundsremaining=4'd9; 
                
                wire [31:0] To_display;
                wire [3:0] player1_score;
                wire [3:0] player2_score;
                //FSM that counts the score of each player
                fsm_counter
                #(.VC(2'b10))    
                Score1(
                    .clk(clk), 
                    .reset_n(rst||roundsremaining==0),
                    .x(gameover[9:8]),
                    .num(player1_score)
                    );
                    
                fsm_counter
                #(.VC(2'b11))     
                Score2(
                    .clk(clk), 
                    .reset_n(rst||roundsremaining==0),
                    .x(gameover[9:8]),
                    .num(player2_score)
                    );    

                
                assign To_display[31:28] = clk_slow;
                assign To_display[3:0] = player1_score;     
                assign To_display[11:8] = player2_score;    
                
                       
                
                //downcounter to display games remaining
                always@(posedge gameover[9] or posedge rst)
                    begin
                        if(rst)
                            roundsremaining<=0;
                        else if(roundsremaining==0) 
                            roundsremaining <= 9;
                        else if(~gameover[9])    
                            roundsremaining <= roundsremaining;
                        else
                            roundsremaining <= roundsremaining - 1;    
                    end 
                    
                    
                 assign To_display[19:16] = roundsremaining;
                          
                seg7_driver DISPLAY(
                    .clk(clk),
                    .rst(rst),
                    .Cnode(sseg),
                    .SW(To_display),
                    .dp(dp), 
                    .AN(AN) 
                    );
                
                // remove this module to port to a board without RGB leds
                // color the RGB led red if P2 has won, blue if P1 has won
                // Pulse width modulation (PWM) is used to reduce the brightness of the led
                rgb_pwm #(.Duty(4))
                m3 (
                    clk_slow,
                    rst,
                    color,
                    {RGB1_Red, RGB1_Green, RGB1_Blue}
                );
    
endmodule
