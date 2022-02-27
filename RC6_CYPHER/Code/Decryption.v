`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 10:22:35 AM
// Design Name: 
// Module Name: Decryption
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


module RC6_Decryption
#(parameter w=4,r=4) //w is the word size in bits   r non negative number of rounds 

    (
        input [w-1:0] Decrypt_A,Decrypt_B,Decrypt_C,Decrypt_D, //Ciphertext stored in four w-bit input registers
        //input r,                //Number of rounds (r)
        input [2*r+3:0] S,         //w-bit round keys
        
        output wire Decrypt_A_out,Decrypt_B_out,Decrypt_C_out,Decrypt_D_out  //Plaintext stored in A,B,C,D
     );
     wire tmp_C,tmp_A;
     
     assign tmp_C = Decrypt_C - S;
     assign tmp_A = Decrypt_A - S;
     
     wire u,t;
     
     genvar i;
     generate
        for(i=4;i>0;i=i-1)// i should be equal to the number of rounds (r) however it is not a constant so setting i=r in the for loop is causing errors
            begin
                assign Decrypt_A = Decrypt_D;
                assign Decrypt_B = Decrypt_A;
                assign Decrypt_C = Decrypt_B;
                assign Decrypt_D = Decrypt_C;
                assign u = (Decrypt_D*(2*Decrypt_D+1)) <<< $clog2(w);
                assign t = (Decrypt_B*(2*Decrypt_B+1)) <<< $clog2(w);      //<<< arithmetic shift left
                assign tmp_C = ( ( Decrypt_C - S[2*i+1] ) >>> t ) ^ u;
                assign tmp_A = ( ( Decrypt_A - S[2*i]) >>> u ) ^ t;   //>>> arithmetic shift right
            end
            
            
     endgenerate
     assign Decrypt_C_out = tmp_C;
     assign Decrypt_A_out = tmp_A;
     assign Decrypt_D_out = Decrypt_D - S[1];
     assign Decrypt_B_out = Decrypt_B - S[0];
     
     
    
endmodule
