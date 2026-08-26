`timescale 1ns/1ps

module shift_register_tb;

    reg clk;
    reg reset;
    reg serial_in;
    wire [3:0] q;

    shift_register uut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        serial_in = 0;

        #10;

        reset = 0;

        // Shift in 1
        serial_in = 1;
        #10;

        // Shift in 0
        serial_in = 0;
        #10;

        // Shift in 1
        serial_in = 1;
        #10;

        // Shift in 1
        serial_in = 1;
        #10;

        // Shift in 0
        serial_in = 0;
        #10;

        $stop;

    end

endmodule