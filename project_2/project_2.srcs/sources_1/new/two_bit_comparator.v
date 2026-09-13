`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2026 03:12:59 PM
// Design Name: 
// Module Name: two_bit_comparator
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

module two_bit_comparator(input [1:0] a, b, output gt, eq, ls

    );
    wire a1bar, anotbar, b1bar, bnotbar, w5, w6, w7, w8, w9, w10, w11, w12;
    not n1(a1bar, a[1]);
    not n2(anotbar, a[0]);
    not n3(b1bar, b[1]);
    not n4(bnotbar, b[0]);
    
    and a1(w5, a[0], b1bar, bnotbar);
    and a2(w6, a[1],b1bar);
    and a3(w7, a[1], a[0], bnotbar);
    
    or o1(gt, w5, w6,w7);
    
    xnor ex1(w8, a[0], b[0]);
    xnor ex2(w9, a[1], b[1]);
    
    and a7(eq, w8, w9);
    
    and a4(w10, a1bar, anotbar, b[0]);
    and a5(w11, a1bar, b[1]);
    and a6(w12, anotbar, b[1], b[0]);
    
    or o3(ls, w10, w11, w12);
    
    
endmodule
