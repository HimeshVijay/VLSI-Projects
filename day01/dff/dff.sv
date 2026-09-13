module dff(
    input D,
    input clk,
    output logic Q
);
    always_ff @(posedge clk)
    Q <= D;

endmodule;