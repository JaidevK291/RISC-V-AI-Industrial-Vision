module vsync_href_handler (
    input  pclk,
    input  reset,
    input  vsync,
    input  href,

    output reg frame_active,
    output reg line_active,
    output reg pixel_valid
);

    always @(posedge pclk or posedge reset) begin

        if (reset) begin

            frame_active <= 1'b0;
            line_active  <= 1'b0;
            pixel_valid  <= 1'b0;

        end
        else begin

            // VSYNC = 1 means frame synchronization period
            if (vsync == 1'b1) begin

                frame_active <= 1'b0;
                line_active  <= 1'b0;
                pixel_valid  <= 1'b0;

            end
            else begin

                // Frame is active when VSYNC = 0
                frame_active <= 1'b1;

                // HREF = 1 means valid pixel line
                if (href == 1'b1) begin

                    line_active <= 1'b1;
                    pixel_valid <= 1'b1;

                end
                else begin

                    line_active <= 1'b0;
                    pixel_valid <= 1'b0;

                end

            end

        end

    end

endmodule