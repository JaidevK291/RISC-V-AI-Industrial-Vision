`timescale 1ns/1ps

module pixel_clock_handler_tb;

    reg pclk;
    reg reset;
    reg pixel_valid;

    wire pixel_enable;


    // Instantiate module
    pixel_clock_handler uut (
        .pclk(pclk),
        .reset(reset),
        .pixel_valid(pixel_valid),
        .pixel_enable(pixel_enable)
    );


    // Generate Pixel Clock
    always #5 pclk = ~pclk;


    initial begin

        // Initial values
        pclk        = 0;
        reset       = 1;
        pixel_valid = 0;

        // Reset
        #20;
        reset = 0;

        // No valid pixel
        #20;
        pixel_valid = 0;

        // Valid pixels
        #10;
        pixel_valid = 1;

        #40;

        // Invalid again
        pixel_valid = 0;

        #30;

        // Another valid pixel section
        pixel_valid = 1;

        #30;

        pixel_valid = 0;

        #30;

        $stop;

    end

endmodule