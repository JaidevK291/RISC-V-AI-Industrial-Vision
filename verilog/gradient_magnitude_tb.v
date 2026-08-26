`timescale 1ns/1ps

module gradient_magnitude_tb;

    reg signed [11:0] gx;
    reg signed [11:0] gy;

    wire [12:0] gradient;


    gradient_magnitude uut (
        .gx(gx),
        .gy(gy),
        .gradient(gradient)
    );


    initial begin

        // Test 1: Strong X edge
        gx = 760;
        gy = 0;

        #30;


        // Test 2: Strong Y edge
        gx = 0;
        gy = 760;

        #30;


        // Test 3: Both directions
        gx = 500;
        gy = 300;

        #30;


        // Test 4: Negative values
        gx = -760;
        gy = -200;

        #30;


        // Test 5: No edge
        gx = 0;
        gy = 0;

        #30;

        $stop;

    end

endmodule