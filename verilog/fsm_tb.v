`timescale 1ns/1ps

module fsm_tb;

    reg clk;
    reg reset;
    reg start;

    wire active;

    // Instantiate FSM
    fsm uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .active(active)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        reset = 1;
        start = 0;

        // Hold reset
        #10;

        // Release reset
        reset = 0;

        // IDLE → ACTIVE
        start = 1;
        #20;

        // ACTIVE → IDLE
        start = 0;
        #20;

        // IDLE → ACTIVE again
        start = 1;
        #20;

        // ACTIVE → IDLE again
        start = 0;
        #20;

        $stop;

    end

endmodule