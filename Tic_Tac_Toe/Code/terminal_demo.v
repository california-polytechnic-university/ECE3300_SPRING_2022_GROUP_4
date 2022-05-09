`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2022 04:24:33 PM
// Design Name: 
// Module Name: terminal_demo
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


module terminal_demo(
    input clk, reset_n,
    
    // Receiver port
    input rd_uart,      // left push button
    output rx_empty,    // LED0
    input rx,           
    
    // Transmitter port
    input [7:0] w_data, // SW0 -> SW7
    input wr_uart,      // right push button
    output tx_full,     // LED1
    output tx,
    
    // Sseg signals
    output [6:0] sseg,
    output [0:7] AN,
    output DP,
    
    input play_enable,Pc_enable,
   
    output wire [1:0] position1,
    output wire [1:0] position2,
    output wire [1:0] position3,
    output wire [1:0] position4,
    output wire [1:0] position5,
    output wire [1:0] position6,
    output wire [1:0] position7
    );
    wire [1:0] position8;
    wire [1:0] position9;
    
    wire rd_uart_pedge;
    wire wr_uart_pedge;
    // Push buttons debouncers/synchronizers
    button read_uart(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(rd_uart),
        .debounced(),
        .p_edge(rd_uart_pedge),
        .n_edge(),
        ._edge()
    );
    
    button write_uart(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(wr_uart),
        .debounced(),
        .p_edge(wr_uart_pedge),
        .n_edge(),
        ._edge()
    );
        
    // UART Driver
    
    
    wire [7:0] r_data;
    
    uart #(.DBIT(8), .SB_TICK(16)) uart_driver(
        .clk(clk),
        .reset_n(reset_n),
        .r_data(r_data),
        .rd_uart(rd_uart_pedge),
        .rx_empty(rx_empty),
        .rx(rx),
        .w_data(w_data[3:0]),
        .wr_uart(wr_uart_pedge),
        .tx_full(tx_full),
        .tx(tx),
        .TIMER_FINAL_VALUE(11'd650) // baud rate = 9600 bps
    );
    reg [3:0] r_data_convert;
    
    always@(r_data)
        case(r_data)
           6'h30: r_data_convert = 3'd0;     
           6'h31: r_data_convert = 3'd1;
           6'h32: r_data_convert = 3'd2;
           6'h33: r_data_convert = 3'd3;
           6'h34: r_data_convert = 3'd4;
           6'h35: r_data_convert = 3'd5;
           6'h36: r_data_convert = 3'd6;
           6'h37: r_data_convert = 3'd7;
           6'h38: r_data_convert = 4'd8;
           6'h39: r_data_convert = 4'd9;
        endcase   
        
    wire [1:0] winner;
    tic_tac_toe Game(
         .clock(clk), // clock of the game 
         .reset(reset_n), // reset button to reset the game 
         .play(play_enable), // play button to enable player to play 
         .pc(Pc_enable), // pc button to enable computer to play 
         
         .computer_position(w_data), //input [3:0] 
         .player_position(r_data_convert),   //input [3:0] 
         // positions to play 
         .pos1(position1),
         .pos2(position2),
         .pos3(position3),    //output wire [1:0]
         .pos4(position4),
         .pos5(position5),
         .pos6(position6),
         .pos7(position7),
         .pos8(position8),
         .pos9(position9),
         // LED display for positions 
         // 01: Player 
         // 10: Computer 
         .who(winner) // who the winner is  output wire[1:0]
         );
   
   
    // Seven-Segment Driver
    sseg_driver(
        .clk(clk),
        .reset_n(reset_n),
        .I0({1'b1, w_data[3: 0], 1'b0}),
        //.I1({1'b1, w_data[7: 4], 1'b0}),  //
        .I2({2'b11, winner, 2'b00}),
        .I3(position8),
        .I4(position9),
        .I5(r_data_convert[3: 0]),
        .I6(r_data[3: 0]),
        .I7(r_data[7: 4]),  //
        .AN(AN),
        .sseg(sseg),
        .DP(DP)
    );
    
endmodule
