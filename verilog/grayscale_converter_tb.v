`timescale 1ns/1ps

module grayscale_converter_tb;

    reg [7:0] rgb_pixel;

    wire [7:0] gray_pixel;


    // Instantiate module
    grayscale_converter uut (
        .rgb_pixel(rgb_pixel),
        .gray_pixel(gray_pixel)
    );


    initial begin

        // Test 1: Black
        rgb_pixel = 8'b00000000;
        #20;

        // Test 2: White
        rgb_pixel = 8'b11111111;
        #20;

        // Test 3: Red dominant
        rgb_pixel = 8'b11100000;
        #20;

        // Test 4: Green dominant
        rgb_pixel = 8'b00011000;
        #20;

        // Test 5: Blue dominant
        rgb_pixel = 8'b00000111;
        #20;

        // Test 6: Mixed color
        rgb_pixel = 8'b10110110;
        #20;

        $stop;

    end

endmodule