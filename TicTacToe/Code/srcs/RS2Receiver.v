`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2022 07:56:03 AM
// Design Name: 
// Module Name: RS2Receiver
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


module PS2Receiver(
    input clk,
    input kclk,
    input kdata,
    output reg [7:0] keycodeout
    );
    
    
    wire kclkf, kdataf;
    reg [7:0]datacur;
    reg [7:0]dataprev;
    reg [3:0]cnt;
    reg [7:0]keycode;
    reg flag;
    reg [7:0] store1,store2;
    initial begin
        keycode[7:0] <= 8'h00000000;
        cnt <= 4'b0000;
        flag <= 1'b0;
    end
    
debouncer_keyboard debounce(
    .clk(clk),
    .I0(kclk),
    .I1(kdata),
    .O0(kclkf),
    .O1(kdataf)
);
    
always@(negedge(kclkf))begin
    case(cnt)
    0:;//Start bit
    1:datacur[0]<=kdataf;
    2:datacur[1]<=kdataf;
    3:datacur[2]<=kdataf;
    4:datacur[3]<=kdataf;
    5:datacur[4]<=kdataf;
    6:datacur[5]<=kdataf;
    7:datacur[6]<=kdataf;
    8:datacur[7]<=kdataf;
    9:flag<=1'b1;
    10:flag<=1'b0;
    
    endcase
        if(cnt<=9) 
            cnt<=cnt+1;
        else if(cnt==10) 
            cnt<=0;
        
end

always@(posedge flag)begin
    dataprev <= datacur;
    store1 <= datacur;
    store2 <= dataprev;
end



always@(posedge flag)begin
    if (datacur == 'hF0)
        keycodeout <= dataprev;
    else
        keycodeout <= datacur;
end

endmodule
