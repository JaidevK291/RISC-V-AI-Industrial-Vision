module camera_capture (
    input        pclk,
    input        reset,
    input        vsync,
    input        href,
    input  [7:0] camera_data,

    output reg [7:0] pixel_data,
    output reg       pixel_valid,
    output reg       frame_active
);

    always @(posedge pclk or posedge reset) begin

        if (reset) begin

            pixel_data  <= 8'b00000000;
            pixel_valid <= 1'b0;
            frame_active <= 1'b0;

        end
        else begin

            // Default: no new pixel
            pixel_valid <= 1'b0;

            // VSYNC indicates frame boundary
            if (vsync == 1'b1) begin

                frame_active <= 1'b0;

            end
            else begin

                frame_active <= 1'b1;

                // HREF = 1 means valid pixel data
                if (href == 1'b1) begin

                    pixel_data  <= camera_data;
                    pixel_valid <= 1'b1;

                end

            end

        end

    end

endmodule