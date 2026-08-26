`timescale 1ns/1ps

module uart_rx_tb;

    reg clk;
    reg reset;
    reg rx;

    wire [7:0] data_out;
    wire data_valid;

    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(4)
    ) uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        reset = 1;
        rx    = 1;

        // Reset
        #20;
        reset = 0;

        // UART START BIT
        #10;
        rx = 0;
        #40;

        // Send 10101010 (LSB first)
        rx = 0;
        #40;

        rx = 1;
        #40;

        rx = 0;
        #40;

        rx = 1;
        #40;

        rx = 0;
        #40;

        rx = 1;
        #40;

        rx = 0;
        #40;

        rx = 1;
        #40;

        // STOP BIT
        rx = 1;
        #40;

        #20;

        $stop;

    end

endmodule