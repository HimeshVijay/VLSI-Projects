`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2026 03:52:45 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(input a, b,cin, output sum, carry

    );
    wire w1, w2, w3;
    xor xor1(sum, a, b, cin);
    and and1(w1, a, b);
    and and2(w2, b, cin);
    and and3(w3, a, cin);
    or or1(carry, w1, w2, w3);
endmodule
