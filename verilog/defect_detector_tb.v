`timescale 1ns/1ps

module defect_detector_tb;

    reg clk;
    reg reset;
    reg edge_detected;

    wire defect_detected;
    wire [7:0] edge_count;


    defect_detector uut (
        .clk(clk),
        .reset(reset),
        .edge_detected(edge_detected),
        .defect_detected(defect_detected),
        .edge_count(edge_count)
    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;
        edge_detected = 0;

        // Reset
        #15;
        reset = 0;


        // Edge 1
        #10;
        edge_detected = 1;
        #10;
        edge_detected = 0;

        // Edge 2
        #10;
        edge_detected = 1;
        #10;
        edge_detected = 0;

        // Edge 3
        #10;
        edge_detected = 1;
        #10;
        edge_detected = 0;

        // Edge 4
        #10;
        edge_detected = 1;
        #10;
        edge_detected = 0;

        // Edge 5 → DEFECT
        #10;
        edge_detected = 1;
        #10;
        edge_detected = 0;

        #20;

        $stop;

    end

endmodule