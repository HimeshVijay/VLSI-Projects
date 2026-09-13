`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2026 02:49:42 PM
// Design Name: 
// Module Name: full_adder_using_half_adder
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


module full_adder_using_half_adder(input a_fa, b_fb, cin_fa, output sum_fa, carry_fa

    );
    
    wire w1, w2, w3;
    
    half_adder ha_1(.a(a_fa), .b(b_fb), .sum(w1), .carry(w2));
    half_adder ha_2(.a(w1), .b(cin_fa), .sum(sum_fa), .carry(w3));
    
    or(carry_fa, w2, w3);
    
endmodule
