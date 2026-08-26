`timescale 1ns/1ps

module image_processing_pipeline_tb;

    reg clk;
    reg reset;

    reg [7:0] pixel00, pixel01, pixel02;
    reg [7:0] pixel10, pixel11, pixel12;
    reg [7:0] pixel20, pixel21, pixel22;

    wire defect_detected;
    wire edge_detected;


    // DUT
    image_processing_pipeline uut (

        .clk(clk),
        .reset(reset),

        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),

        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),

        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),

        .defect_detected(defect_detected),
        .edge_detected(edge_detected)
    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk = 0;
        reset = 1;

        // All pixels initially dark
        pixel00 = 0;
        pixel01 = 0;
        pixel02 = 0;

        pixel10 = 0;
        pixel11 = 0;
        pixel12 = 0;

        pixel20 = 0;
        pixel21 = 0;
        pixel22 = 0;

        #20;
        reset = 0;


        // ============================
        // TEST 1: Uniform Image
        // Expected: No edge
        // ============================

        pixel00 = 8'd50;
        pixel01 = 8'd50;
        pixel02 = 8'd50;

        pixel10 = 8'd50;
        pixel11 = 8'd50;
        pixel12 = 8'd50;

        pixel20 = 8'd50;
        pixel21 = 8'd50;
        pixel22 = 8'd50;

        #30;


        // ============================
        // TEST 2: Vertical Edge
        // Expected: Edge detected
        // ============================

        pixel00 = 8'd10;
        pixel01 = 8'd10;
        pixel02 = 8'd200;

        pixel10 = 8'd10;
        pixel11 = 8'd10;
        pixel12 = 8'd200;

        pixel20 = 8'd10;
        pixel21 = 8'd10;
        pixel22 = 8'd200;

        #30;


        // ============================
        // TEST 3: Horizontal Edge
        // Expected: Edge detected
        // ============================

        pixel00 = 8'd10;
        pixel01 = 8'd10;
        pixel02 = 8'd10;

        pixel10 = 8'd10;
        pixel11 = 8'd10;
        pixel12 = 8'd10;

        pixel20 = 8'd200;
        pixel21 = 8'd200;
        pixel22 = 8'd200;

        #30;


        // ============================
        // TEST 4: Strong Edge
        // ============================

        pixel00 = 8'd0;
        pixel01 = 8'd0;
        pixel02 = 8'd255;

        pixel10 = 8'd0;
        pixel11 = 8'd0;
        pixel12 = 8'd255;

        pixel20 = 8'd0;
        pixel21 = 8'd0;
        pixel22 = 8'd255;

        #30;


        // ============================
        // TEST 5: Another Strong Edge
        // ============================

        pixel00 = 8'd255;
        pixel01 = 8'd255;
        pixel02 = 8'd0;

        pixel10 = 8'd255;
        pixel11 = 8'd255;
        pixel12 = 8'd0;

        pixel20 = 8'd255;
        pixel21 = 8'd255;
        pixel22 = 8'd0;

        #30;


        // ============================
        // TEST 6: Another Edge
        // This should help reach
        // defect threshold
        // ============================

        pixel00 = 8'd0;
        pixel01 = 8'd255;
        pixel02 = 8'd255;

        pixel10 = 8'd0;
        pixel11 = 8'd255;
        pixel12 = 8'd255;

        pixel20 = 8'd0;
        pixel21 = 8'd255;
        pixel22 = 8'd255;

        #30;


        $stop;

    end

endmodule