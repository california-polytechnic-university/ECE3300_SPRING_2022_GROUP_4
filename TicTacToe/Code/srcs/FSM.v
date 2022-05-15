`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2022 01:06:26 AM
// Design Name: 
// Module Name: FSM
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

//LAST DONE AT 12:15PM FRIDAY NIGHT, FSM NOT COUNTING PROPERLY, IT SEEMS TO BE COUNTING FOR ONE PLAYER AT A TIME TAKING TURNS TO LET THEM IN, IF X WINS THEN O HAS TO WIN FOR IT TO COUNT, NEITHER CAN WIN IN A ROW AND COUNT UPWARD, MAYBE TRY MAKING IT BLOCKING
//OR USE EDDIN'S FSM COUNTER IF HIS DOESNT WORK THEN IT HAS TO BE SOMETHING RELATED TO THE MEMORY
//WD IS CODE FOR ACTIVE PLAYER, MAYBE THAT IS WORTH INVESTIGATING MORE IN btn_flsm module
//MAYBE BRING IN THE SYSTEM CLOCK AND USE THAT FOR THE STATE AT THE VERY BOTTOM AND MAKE THE FSM NONBLOCKING WITH X[9] AND STATE AS THE SENSITIVITY 
module FSM
#(parameter VC = 2'b10)
(
 input [9:8] x,
 input rst,
 output reg [3:0] Z1
 );
 //removed state from initial block, Nextstate is in rst block

 reg [3:0] State, Nextstate;
 
    initial
    begin
        Z1=0;
        //Nextstate = 0;
        //State = 0;
    end
    
    always@(x[9] or State or rst)
    begin
        if(rst)
        begin
            Z1 = 0;
            Nextstate = 0;
        end
        else begin 
        case(State)
            0: begin
                if (x[9:8]==VC) 
                   begin
                       Z1= 1;
                       Nextstate = 1;
                   end
                else      
                       Nextstate = 0;
                end
            1: begin
                if (x[9:8]==VC) 
                   begin
                      Z1 = 2;
                      Nextstate = 2;
                   end
                else
                      Nextstate = 1;
            end
            2: begin
                if (x[9:8]==VC) 
                   begin
                      Z1= 3;
                      Nextstate = 3;
                   end    
                else
                      Nextstate = 2;
           end
            3: begin
                if (x[9:8]==VC) 
                   begin
                      Z1 = 4;
                      Nextstate = 4;
                   end
                    else
                      Nextstate = 3;
                end
           4: begin
                if(x[9:8]==VC) 
                  begin
                      Z1= 5;
                      Nextstate = 5;
                  end
                    else
                      Nextstate = 4;      
                end
           5: begin
                if (x[9:8]==VC) 
                   begin
                      Z1= 6;
                      Nextstate = 6;
                   end
                    else
                      Nextstate = 5;
               end
           6: begin
                if (x[9:8]==VC) 
                   begin
                      Z1= 7;
                      Nextstate = 7;
                   end
                    else
                      Nextstate = 6;
           end
           7: begin
               if (x[9:8]==VC) 
                  begin
                      Z1= 8;
                      Nextstate = 8;
                  end    
                    else
                      Nextstate = 7;
                end
           8: begin
               if (x[9:8]==VC) 
                  begin
                      Z1= 9;
                      Nextstate = 9;
                  end
                    else
                      Nextstate = 8;
               end
           9: begin
               if(x[9:8]==VC) 
                 begin
                     Z1= 0;
                     Nextstate = 0;
                 end
                    else
                     Nextstate = 9;      
               end  
                 
            endcase
            end 
   end     
             
            always@(posedge x[9])begin
                State <= Nextstate;
                end

endmodule

//removed state from initial block, Nextstate is in rst block
 /*Now its switching back and forth correctly but the first win causes the counter to jump to 2
 reg [3:0] State, Nextstate;
 
    initial
    begin
        Z1 = 0;
        Nextstate = 0;
    end
    
    always@(x[9] or State or rst)
    begin
        if(rst)
        begin
            Z1 = 0;
            Nextstate = 0;
        end
        else begin 
        case(State)
            0: begin
                if (x[9:8]==VC) 
                   begin
                       Z1= 1;
                       Nextstate = 1;
                   end
                else      
                       Nextstate = 0;
                end
            1: begin
                if (x[9:8]==VC) 
                   begin
                      Z1 = 2;
                      Nextstate = 2;
                   end
                else
                      Nextstate = 1;
            end
            2: begin
                if (x[9:8]==VC) 
                   begin
                      Z1= 3;
                      Nextstate = 3;
                   end    
                else
                      Nextstate = 2;
           end
            3: begin
                if (x[9:8]==VC) 
                   begin
                      Z1 = 4;
                      Nextstate = 4;
                   end
                    else
                      Nextstate = 3;
                end
           4: begin
                if(x[9:8]==VC) 
                  begin
                      Z1= 5;
                      Nextstate = 5;
                  end
                    else
                      Nextstate = 4;      
                end
           5: begin
                if (x[9:8]==VC) 
                   begin
                      Z1= 6;
                      Nextstate = 6;
                   end
                    else
                      Nextstate = 5;
               end
           6: begin
                if (x[9:8]==VC) 
                   begin
                      Z1= 7;
                      Nextstate = 7;
                   end
                    else
                      Nextstate = 6;
           end
           7: begin
               if (x[9:8]==VC) 
                  begin
                      Z1= 8;
                      Nextstate = 8;
                  end    
                    else
                      Nextstate = 7;
                end
           8: begin
               if (x[9:8]==VC) 
                  begin
                      Z1= 9;
                      Nextstate = 9;
                  end
                    else
                      Nextstate = 8;
               end
           9: begin
               if(x[9:8]==VC) 
                 begin
                     Z1= 0;
                     Nextstate = 0;
                 end
                    else
                     Nextstate = 9;      
               end  
                 
            endcase
            end 
   end     
             
            always@(posedge x[9])begin
                State <= Nextstate;
                end
*/
