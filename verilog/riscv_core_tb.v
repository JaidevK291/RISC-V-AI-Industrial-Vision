`timescale 1ns/1ps

module riscv_core_tb;

    reg clk;
    reg reset;
    reg defect_detected;

    // DUT
    riscv_core uut (
        .clk(clk),
        .reset(reset),
        .defect_detected(defect_detected)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        defect_detected = 0;

        #20;
        reset = 0;

        // Normal condition
        #100;

        // Simulate defect detection
        defect_detected = 1;

        #100;

        // Clear defect
        defect_detected = 0;

        #50;

        $stop;
    end

endmodule