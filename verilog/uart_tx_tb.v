`timescale 1ns/1ps

module uart_tx_tb;

    reg       clk;
    reg       reset;
    reg       start;
    reg [7:0] data_in;

    wire tx;
    wire busy;

    // Instantiate UART transmitter
    uart_tx #(
        .CLKS_PER_BIT(4)
    ) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        clk     = 0;
        reset   = 1;
        start   = 0;
        data_in = 8'b0;

        // Reset
        #20;
        reset = 0;

        // Send 10101010
        #10;
        data_in = 8'b10101010;
        start   = 1;

        #10;
        start = 0;

        // Wait for transmission
        #400;

        $stop;

    end

endmodule