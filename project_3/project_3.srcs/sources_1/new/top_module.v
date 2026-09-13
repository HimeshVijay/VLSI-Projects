`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2026 10:40:14 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
 
    );
    wire [3:0] mux_in1;
    wire [3:0] mux_in2;
    wire [3:0] mux_in3;
    wire [1:0] w;
    wire w1,w2, mux_out3;
    
    assign mux_in1[0] = 0;
    assign mux_in1[1] = 1;
    assign mux_in1[2] = 1;
    assign mux_in1[3] = 0;
    
    assign mux_in2[0] = 0;
    assign mux_in2[1] = 1;
    assign mux_in2[2] = 0;
    assign mux_in2[3] = 0;
    
    assign mux_in3[0] = w1;
    assign mux_in3[1] = 1;
    assign mux_in3[2] = w2;
    assign mux_in3[3] = 0;
    
    four_1_mux mux1(w, mux_in1, w1);
    four_1_mux mux2(w, mux_in2, w2);
    
    four_1_mux mux3(w, mux_in3, mux_out3);
    
    
    
endmodule
