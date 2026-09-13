`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2026 10:56:21 PM
// Design Name: 
// Module Name: sr_flip_flop
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


module sr_flip_flop(
    input s, r, clk,
    output q, qn

    );
    
    wire w1, w2;
    
    nand a1(w1, s, clk);
    nand a2(w2, r, clk);
    
    nand a3(q, w1, qn);
    nand a4(qn, w2, q);
endmodule
