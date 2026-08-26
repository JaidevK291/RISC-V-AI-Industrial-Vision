`timescale 1ns/1ps

module thresholding_tb;

    reg [12:0] gradient;
    wire edge_detected;


    thresholding uut (
        .gradient(gradient),
        .edge_detected(edge_detected)
    );


    initial begin

        // Test 1: No edge
        gradient = 13'd100;
        #30;

        // Test 2: Below threshold
        gradient = 13'd400;
        #30;

        // Test 3: Exactly threshold
        gradient = 13'd500;
        #30;

        // Test 4: Strong edge
        gradient = 13'd760;
        #30;

        // Test 5: Very strong edge
        gradient = 13'd960;
        #30;

        // Test 6: No edge
        gradient = 13'd0;
        #30;

        $stop;

    end

endmodule