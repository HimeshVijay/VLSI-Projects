`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2026 07:38:18 PM
// Design Name: 
// Module Name: half_adder
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


`timescale 1ns / 1ps

// ============================================================
// MEGA SOC - Large Verilog-2001 Demonstration Design
// ============================================================

module mega_soc (
    input         clk,
    input         rst,

    input  [31:0] ext_data,
    input         ext_valid,

    output [31:0] result,
    output        irq
);

    // --------------------------------------------------------
    // Global buses
    // --------------------------------------------------------

    wire [31:0] cpu_addr;
    wire [31:0] cpu_wdata;
    wire [31:0] cpu_rdata;
    wire        cpu_we;
    wire        cpu_re;

    wire [31:0] bus_rdata;

    wire [15:0] irq_sources;

    // --------------------------------------------------------
    // CPU
    // --------------------------------------------------------

    mega_cpu u_cpu (
        .clk       (clk),
        .rst       (rst),
        .ext_data  (ext_data),
        .ext_valid (ext_valid),

        .addr      (cpu_addr),
        .wdata     (cpu_wdata),
        .rdata     (cpu_rdata),
        .we        (cpu_we),
        .re        (cpu_re),

        .result    (result)
    );

    // --------------------------------------------------------
    // Main interconnect
    // --------------------------------------------------------

    mega_bus u_bus (
        .clk        (clk),
        .rst        (rst),

        .addr       (cpu_addr),
        .wdata      (cpu_wdata),
        .rdata      (bus_rdata),
        .we         (cpu_we),
        .re         (cpu_re),

        .ram_rdata  (ram_rdata),
        .gpio_rdata (gpio_rdata),
        .uart_rdata (uart_rdata),
        .timer_rdata(timer_rdata),
        .alu_rdata  (alu_rdata)
    );

    assign cpu_rdata = bus_rdata;

    // --------------------------------------------------------
    // RAM
    // --------------------------------------------------------

    wire [31:0] ram_rdata;

    mega_ram u_ram (
        .clk   (clk),
        .rst   (rst),
        .addr  (cpu_addr[9:2]),
        .wdata (cpu_wdata),
        .we    (cpu_we),
        .rdata (ram_rdata)
    );

    // --------------------------------------------------------
    // GPIO
    // --------------------------------------------------------

    wire [31:0] gpio_rdata;

    mega_gpio u_gpio (
        .clk   (clk),
        .rst   (rst),
        .addr  (cpu_addr),
        .wdata (cpu_wdata),
        .we    (cpu_we),
        .rdata (gpio_rdata)
    );

    // --------------------------------------------------------
    // UART cluster
    // --------------------------------------------------------

    wire [31:0] uart_rdata;

    mega_uart_cluster u_uart_cluster (
        .clk   (clk),
        .rst   (rst),
        .addr  (cpu_addr),
        .wdata (cpu_wdata),
        .we    (cpu_we),
        .rdata (uart_rdata),
        .irq   (irq_sources[3:0])
    );

    // --------------------------------------------------------
    // Timer cluster
    // --------------------------------------------------------

    wire [31:0] timer_rdata;

    mega_timer_cluster u_timer_cluster (
        .clk   (clk),
        .rst   (rst),
        .addr  (cpu_addr),
        .wdata (cpu_wdata),
        .we    (cpu_we),
        .rdata (timer_rdata),
        .irq   (irq_sources[7:4])
    );

    // --------------------------------------------------------
    // ALU processing cluster
    // --------------------------------------------------------

    wire [31:0] alu_rdata;

    mega_compute_cluster u_compute (
        .clk   (clk),
        .rst   (rst),
        .addr  (cpu_addr),
        .wdata (cpu_wdata),
        .we    (cpu_we),
        .rdata (alu_rdata)
    );

    // --------------------------------------------------------
    // Interrupt controller
    // --------------------------------------------------------

    mega_interrupt_controller u_intc (
        .clk       (clk),
        .rst       (rst),
        .irq_in    (irq_sources),
        .irq_out   (irq)
    );

endmodule


// ============================================================
// CPU
// ============================================================

module mega_cpu (
    input         clk,
    input         rst,
    input  [31:0] ext_data,
    input         ext_valid,

    output reg [31:0] addr,
    output reg [31:0] wdata,
    input      [31:0] rdata,

    output reg        we,
    output reg        re,

    output reg [31:0] result
);

    reg [31:0] pc;
    reg [31:0] r [0:31];

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            pc     <= 32'd0;
            result <= 32'd0;
            addr   <= 32'd0;
            wdata  <= 32'd0;
            we     <= 1'b0;
            re     <= 1'b0;

            for (i = 0; i < 32; i = i + 1)
                r[i] <= 32'd0;
        end
        else begin
            pc <= pc + 4;

            addr  <= pc;
            wdata <= ext_data;

            we <= ext_valid;
            re <= ~ext_valid;

            if (ext_valid)
                r[1] <= ext_data;

            result <= rdata;
        end
    end

endmodule


// ============================================================
// BUS
// ============================================================

module mega_bus (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    output reg [31:0] rdata,

    input         we,
    input         re,

    input  [31:0] ram_rdata,
    input  [31:0] gpio_rdata,
    input  [31:0] uart_rdata,
    input  [31:0] timer_rdata,
    input  [31:0] alu_rdata
);

    always @(*) begin

        rdata = 32'd0;

        case (addr[15:12])

            4'h0:
                rdata = ram_rdata;

            4'h1:
                rdata = gpio_rdata;

            4'h2:
                rdata = uart_rdata;

            4'h3:
                rdata = timer_rdata;

            4'h4:
                rdata = alu_rdata;

            default:
                rdata = 32'hDEAD_BEEF;

        endcase

    end

endmodule


// ============================================================
// RAM
// ============================================================

module mega_ram (
    input         clk,
    input         rst,

    input  [7:0]  addr,
    input  [31:0] wdata,
    input         we,

    output reg [31:0] rdata
);

    reg [31:0] mem [0:255];

    integer i;

    always @(posedge clk) begin

        if (rst) begin

            for (i = 0; i < 256; i = i + 1)
                mem[i] <= 32'd0;

            rdata <= 32'd0;
        end

        else begin

            if (we)
                mem[addr] <= wdata;

            rdata <= mem[addr];
        end

    end

endmodule


// ============================================================
// GPIO
// ============================================================

module mega_gpio (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    input         we,

    output reg [31:0] rdata
);

    reg [31:0] gpio_reg [0:7];

    integer i;

    always @(posedge clk) begin

        if (rst) begin

            for (i = 0; i < 8; i = i + 1)
                gpio_reg[i] <= 32'd0;

            rdata <= 32'd0;
        end

        else begin

            if (we)
                gpio_reg[addr[4:2]] <= wdata;

            rdata <= gpio_reg[addr[4:2]];
        end

    end

endmodule


// ============================================================
// UART CLUSTER
// ============================================================

module mega_uart_cluster (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    input         we,

    output [31:0] rdata,
    output [3:0]  irq
);

    wire [31:0] uart_rdata [0:3];

    genvar i;

    generate

        for (i = 0; i < 4; i = i + 1) begin : UARTS

            mega_uart u_uart (
                .clk   (clk),
                .rst   (rst),
                .addr  (addr),
                .wdata (wdata),
                .we    (we),
                .rdata (uart_rdata[i]),
                .irq   (irq[i])
            );

        end

    endgenerate

    assign rdata =
        uart_rdata[0] |
        uart_rdata[1] |
        uart_rdata[2] |
        uart_rdata[3];

endmodule


// ============================================================
// UART
// ============================================================

module mega_uart (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    input         we,

    output reg [31:0] rdata,
    output reg        irq
);

    reg [7:0] tx_data;
    reg [7:0] rx_data;

    reg [15:0] baud_counter;

    always @(posedge clk) begin

        if (rst) begin

            tx_data     <= 8'd0;
            rx_data     <= 8'd0;
            baud_counter<= 16'd0;
            irq         <= 1'b0;
            rdata       <= 32'd0;

        end

        else begin

            baud_counter <= baud_counter + 1;

            irq <= 1'b0;

            if (we) begin
                tx_data <= wdata[7:0];
                irq <= 1'b1;
            end

            rx_data <= tx_data;

            case (addr[3:2])

                2'd0: rdata <= {24'd0, tx_data};
                2'd1: rdata <= {24'd0, rx_data};
                2'd2: rdata <= {16'd0, baud_counter};
                default: rdata <= 32'd0;

            endcase

        end

    end

endmodule


// ============================================================
// TIMER CLUSTER
// ============================================================

module mega_timer_cluster (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    input         we,

    output [31:0] rdata,
    output [3:0]  irq
);

    wire [31:0] timer_rdata [0:3];

    genvar i;

    generate

        for (i = 0; i < 4; i = i + 1) begin : TIMERS

            mega_timer u_timer (
                .clk   (clk),
                .rst   (rst),
                .addr  (addr),
                .wdata (wdata),
                .we    (we),
                .rdata (timer_rdata[i]),
                .irq   (irq[i])
            );

        end

    endgenerate

    assign rdata =
        timer_rdata[0] |
        timer_rdata[1] |
        timer_rdata[2] |
        timer_rdata[3];

endmodule


// ============================================================
// TIMER
// ============================================================

module mega_timer (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    input         we,

    output reg [31:0] rdata,
    output reg        irq
);

    reg [31:0] counter;
    reg [31:0] compare;

    always @(posedge clk) begin

        if (rst) begin

            counter <= 32'd0;
            compare <= 32'h0000FFFF;
            irq     <= 1'b0;
            rdata   <= 32'd0;

        end

        else begin

            counter <= counter + 1;

            irq <= 1'b0;

            if (counter == compare) begin
                counter <= 32'd0;
                irq <= 1'b1;
            end

            if (we)
                compare <= wdata;

            case (addr[3:2])

                2'd0: rdata <= counter;
                2'd1: rdata <= compare;

                default:
                    rdata <= 32'd0;

            endcase

        end

    end

endmodule


// ============================================================
// COMPUTE CLUSTER
// ============================================================

module mega_compute_cluster (
    input         clk,
    input         rst,

    input  [31:0] addr,
    input  [31:0] wdata,
    input         we,

    output [31:0] rdata
);

    wire [31:0] alu_out [0:15];

    genvar i;

    generate

        for (i = 0; i < 16; i = i + 1) begin : ALUS

            mega_alu #(
                .ID(i)
            )
            u_alu (
                .clk   (clk),
                .rst   (rst),
                .a     (wdata),
                .b     (addr),
                .we    (we),
                .result(alu_out[i])
            );

        end

    endgenerate

    assign rdata =
        alu_out[0]  ^
        alu_out[1]  ^
        alu_out[2]  ^
        alu_out[3]  ^
        alu_out[4]  ^
        alu_out[5]  ^
        alu_out[6]  ^
        alu_out[7]  ^
        alu_out[8]  ^
        alu_out[9]  ^
        alu_out[10] ^
        alu_out[11] ^
        alu_out[12] ^
        alu_out[13] ^
        alu_out[14] ^
        alu_out[15];

endmodule


// ============================================================
// ALU
// ============================================================

module mega_alu #(
    parameter ID = 0
)(
    input         clk,
    input         rst,

    input  [31:0] a,
    input  [31:0] b,
    input         we,

    output reg [31:0] result
);

    always @(posedge clk) begin

        if (rst) begin

            result <= 32'd0;

        end

        else if (we) begin

            case (ID % 8)

                0: result <= a + b;
                1: result <= a - b;
                2: result <= a & b;
                3: result <= a | b;
                4: result <= a ^ b;
                5: result <= a << 2;
                6: result <= a >> 2;
                7: result <= a * b;

            endcase

        end

    end

endmodule


// ============================================================
// INTERRUPT CONTROLLER
// ============================================================

module mega_interrupt_controller (
    input        clk,
    input        rst,

    input  [15:0] irq_in,
    output reg    irq_out
);

    reg [15:0] pending;

    always @(posedge clk) begin

        if (rst) begin
            pending <= 16'd0;
            irq_out <= 1'b0;
        end

        else begin

            pending <= irq_in;

            if (|pending)
                irq_out <= 1'b1;
            else
                irq_out <= 1'b0;

        end

    end

endmodule