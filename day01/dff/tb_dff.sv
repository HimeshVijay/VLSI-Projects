module tb_dff;
    //signals
    logic D;
    logic clk;
    logic Q;
    //DUT
    dff dut(
        .D(D),
        .clk(clk),
        .Q(Q)
    );
    //clock generation
    initial begin
        clk = 0;    //this is to initialize a value to the clock so it doesnt take up X as initial
    end
    
    always #5 clk = ~clk;  //this is to generate a clock with time period of 10ns
    

    //stimulus
    initial begin
        D =0;

        #7 D = 1;
        #10 D = 0;
        #7 D = 1;
        #10 $finish;
    end

    initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0, tb_dff);
    end
endmodule