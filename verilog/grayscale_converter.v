module grayscale_converter (
    input  [7:0] rgb_pixel,
    output reg [7:0] gray_pixel
);

    reg [7:0] red;
    reg [7:0] green;
    reg [7:0] blue;

    always @(*) begin

        // Extract RGB332
        // RRR GG BBB
        red   = {rgb_pixel[7:5], 5'b00000};
        green = {rgb_pixel[4:3], 6'b000000};
        blue  = {rgb_pixel[2:0], 5'b00000};

        // Simple grayscale approximation
        gray_pixel = (red + green + blue) / 3;

    end

endmodule