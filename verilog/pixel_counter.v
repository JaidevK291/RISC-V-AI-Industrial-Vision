module pixel_counter #(
    parameter FRAME_WIDTH  = 8,
    parameter FRAME_HEIGHT = 4
)(
    input pclk,
    input reset,

    input vsync,
    input href,
    input pixel_valid,

    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y
);

    always @(posedge pclk or posedge reset) begin

        if (reset) begin

            pixel_x <= 0;
            pixel_y <= 0;

        end
        else begin

            // New frame
            if (vsync == 1'b1) begin

                pixel_x <= 0;
                pixel_y <= 0;

            end

            // Valid pixel
            else if (pixel_valid && href) begin

                // End of line
                if (pixel_x == FRAME_WIDTH - 1) begin

                    pixel_x <= 0;

                    // Next line
                    if (pixel_y == FRAME_HEIGHT - 1)
                        pixel_y <= 0;
                    else
                        pixel_y <= pixel_y + 1;

                end
                else begin

                    pixel_x <= pixel_x + 1;

                end

            end

        end

    end

endmodule