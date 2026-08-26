`timescale 1ns/1ps

module clock_divider_tb;

    reg clk;
    reg reset;

    wire slow_clk;

    clock_divider uut (
        .clk(clk),
        .reset(reset),
        .slow_clk(slow_clk)
    );

    // Input clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        reset = 1;

        #10;

        reset = 0;

        #100;

        $stop;

    end

endmodule