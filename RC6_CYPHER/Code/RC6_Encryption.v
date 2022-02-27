`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 10:58:59 AM
// Design Name: 
// Module Name: RC6_Encryption
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


module RC6_Encryption
#(parameter w=4,r=4) //w is the word size in bits   r non negative number of rounds 

    (
        input [w-1:0] Encrypt_A, Encrypt_B, Encrypt_C, Encrypt_D, //Plaintext stored in four w-bit input registers
        //input r,                //Number of rounds (r)
        input [2*r+3:0] S,         //w-bit round keys
        
        output wire Encrypt_A_out,Encrypt_B_out,Encrypt_C_out,Encrypt_D_out  //Ciphertext stored in A,B,C,D
     );
     wire tmp_A, tmp_B, tmp_C, tmp_D;
     
     assign tmp_B = Encrypt_B - S[0];
     assign tmp_D = Encrypt_D - S[1];
     
     wire u,t;
     
     genvar i;
     generate
        for(i=1; i<=r; i=i+1)
            begin
                assign t = (Encrypt_B*(2*Encrypt_B+1)) <<< $clog2(w);      //<<< arithmetic shift left
                assign u = (Encrypt_D*(2*Encrypt_D+1)) <<< $clog2(w);
                assign tmp_A = ( ( Encrypt_A ^ t ) <<< u ) + S[2*i];   //>>> arithmetic shift right
                assign tmp_C = ( ( Encrypt_C ^ u ) <<< t ) + S[2*i+1];
                assign Encrypt_A = Encrypt_B;
                assign Encrypt_B = Encrypt_C;
                assign Encrypt_C = Encrypt_D;
                assign Encrypt_D = Encrypt_A;
            end
            
            
     endgenerate
     assign Encrypt_A_out = tmp_A + S[2*r + 2];
     assign Encrypt_C_out = tmp_C + S[2*r + 3];
     
endmodule
