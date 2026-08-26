`timescale 1ns/1ps

module pixel_counter_tb;

    reg pclk;
    reg reset;

    reg vsync;
    reg href;
    reg pixel_valid;

    wire [9:0] pixel_x;
    wire [9:0] pixel_y;


    pixel_counter #(
        .FRAME_WIDTH(8),
        .FRAME_HEIGHT(4)
    ) uut (

        .pclk(pclk),
        .reset(reset),

        .vsync(vsync),
        .href(href),
        .pixel_valid(pixel_valid),

        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );


    // Pixel clock
    always #5 pclk = ~pclk;


    initial begin

        // Initial values
        pclk        = 0;
        reset       = 1;
        vsync       = 1;
        href        = 0;
        pixel_valid = 0;


        // Reset
        #20;
        reset = 0;


        // Start frame
        #20;
        vsync = 0;


        // -------------------------
        // LINE 0
        // -------------------------
        href = 1;
        pixel_valid = 1;

        // 8 pixels
        #80;

        // End line
        href = 0;
        pixel_valid = 0;

        #20;


        // -------------------------
        // LINE 1
        // -------------------------
        href = 1;
        pixel_valid = 1;

        #80;

        href = 0;
        pixel_valid = 0;

        #20;


        // -------------------------
        // LINE 2
        // -------------------------
        href = 1;
        pixel_valid = 1;

        #80;

        href = 0;
        pixel_valid = 0;

        #20;


        // -------------------------
        // LINE 3
        // -------------------------
        href = 1;
        pixel_valid = 1;

        #80;

        href = 0;
        pixel_valid = 0;

        #20;


        // End frame
        vsync = 1;

        #30;

        $stop;

    end

endmodule