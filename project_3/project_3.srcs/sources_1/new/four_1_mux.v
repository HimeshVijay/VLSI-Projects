`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2026 09:52:54 PM
// Design Name: 
// Module Name: four_1_mux
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


module four_1_mux(
    input [1:0] w,
    input [3:0] mux_in,
    output mux_out
);

    wire w1, w2, w3, w4, w5, w6;

    not n1(w1, w[0]);
    not n2(w2, w[1]);

    and a1(w3, w1,    w2,    mux_in[0]);
    and a2(w4, w1,    w[1],  mux_in[1]);
    and a3(w5, w[0],  w2,    mux_in[2]);
    and a4(w6, w[0],  w[1],  mux_in[3]);

    or o1(mux_out, w3, w4, w5, w6);

endmodule
