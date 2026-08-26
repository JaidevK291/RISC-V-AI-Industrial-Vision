`timescale 1ns/1ps

module control_unit_tb;

    reg clk;
    reg reset;
    reg start;

    wire load;
    wire process;
    wire done;

    control_unit uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .load(load),
        .process(process),
        .done(done)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        reset = 1;
        start = 0;

        // Reset
        #10;

        reset = 0;

        // Start operation
        start = 1;
        #10;

        // Remove start
        start = 0;

        // Allow controller to finish
        #40;

        $stop;

    end

endmodule