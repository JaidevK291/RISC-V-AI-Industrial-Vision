`timescale 1ns/1ps

module sobel_x_tb;

    reg [7:0] p00, p01, p02;
    reg [7:0] p10, p11, p12;
    reg [7:0] p20, p21, p22;

    wire signed [11:0] gx;


    sobel_x uut (
        .p00(p00),
        .p01(p01),
        .p02(p02),

        .p10(p10),
        .p11(p11),
        .p12(p12),

        .p20(p20),
        .p21(p21),
        .p22(p22),

        .gx(gx)
    );


    initial begin

        // ================================
        // Test 1: Strong vertical edge
        // Dark on left, bright on right
        // ================================

        p00 = 10;   p01 = 10;   p02 = 200;
        p10 = 10;   p11 = 10;   p12 = 200;
        p20 = 10;   p21 = 10;   p22 = 200;

        #50;


        // ================================
        // Test 2: No strong edge
        // All pixels similar
        // ================================

        p00 = 100;  p01 = 100;  p02 = 100;
        p10 = 100;  p11 = 100;  p12 = 100;
        p20 = 100;  p21 = 100;  p22 = 100;

        #50;


        // ================================
        // Test 3: Opposite edge
        // Bright on left, dark on right
        // ================================

        p00 = 200;  p01 = 100;  p02 = 10;
        p10 = 200;  p11 = 100;  p12 = 10;
        p20 = 200;  p21 = 100;  p22 = 10;

        #50;

        $stop;

    end

endmodule