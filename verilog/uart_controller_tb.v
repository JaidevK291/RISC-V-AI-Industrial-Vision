`timescale 1ns/1ps

module uart_controller_tb;

    reg clk;
    reg reset;

    reg       tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    wire [7:0] rx_data;
    wire rx_valid;

    // Connect TX output directly to RX input
    uart_controller #(
        .CLKS_PER_BIT(4)
    ) uut (

        .clk(clk),
        .reset(reset),

        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),

        .rx(tx),

        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );


    // 10 ns clock
    always #5 clk = ~clk;


    initial begin

        clk      = 0;
        reset    = 1;
        tx_start = 0;
        tx_data  = 8'b0;

        // Reset
        #20;
        reset = 0;

        // Send data
        #20;

        tx_data  = 8'b10101010;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait for complete transmission
        #500;

        $stop;

    end

endmodule