`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2026 03:52:14 PM
// Design Name: 
// Module Name: ripple_carry_adder
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


module ripple_carry_adder(input [3:0] a_rca, [3:0] b_rca, input cin, output [3:0] sum_rca, carry

    );
    
    wire w1, w2, w3;
    
    full_adder fa1(a_rca[0], b_rca[0], cin, sum_rca[0], w1);
    full_adder fa2(a_rca[1], b_rca[1], w1, sum_rca[1], w2);
    full_adder fa3(a_rca[2], b_rca[2], w2, sum_rca[2], w3);
    full_adder fa4(a_rca[3], b_rca[3], w3, sum_rca[3], carry);
endmodule


module full_adder(input a, b,cin, output sum, carry

    );
    wire w1, w2, w3;
    xor xor1(sum, a, b, cin);
    and and1(w1, a, b);
    and and2(w2, b, cin);
    and and3(w3, a, cin);
    or or1(carry, w1, w2, w3);
endmodule