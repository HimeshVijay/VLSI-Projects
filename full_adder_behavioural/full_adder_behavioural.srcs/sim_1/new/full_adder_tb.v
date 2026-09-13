`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2026 03:36:07 PM
// Design Name: 
// Module Name: full_adder_tb
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


module full_adder_tb(

    );
    
    reg a_tb, b_tb, cin_tb;
    wire sum_tb, carry_tb;
    
    //step 2 connecting design
    
    full_adder dut(a_tb, b_tb, cin_tb, sum_tb, carry_tb);
    
    //step 3:
    
    initial 
        begin
            {a_tb, b_tb, cin_tb} = 0;
        end
        
    initial 
        begin
        
        $monitor("the value of a_tb is %b and b_tb is %b and cin_tb is %b and sum_tb is %b and carry_tb is %b", a_tb, b_tb, cin_tb,sum_tb, carry_tb);
            a_tb = 1'b1;
            b_tb = 1'b1;
            cin_tb = 1'b1;
            
            #1;
            
            a_tb = 1'b0;
            b_tb = 1'b0;
            cin_tb = 1'b1;
            
            #1;
            
            a_tb = 1'b0;
            b_tb = 1'b1;
            cin_tb = 1'b0;
            
            #1;
            
            a_tb = 1'b1;
            b_tb = 1'b1;
            cin_tb = 1'b0;
            
            
            #1;
            
            a_tb = #1 1'b0;
            b_tb = 1'b1;
            cin_tb = 1'b1;
            end
            
            
        
endmodule
