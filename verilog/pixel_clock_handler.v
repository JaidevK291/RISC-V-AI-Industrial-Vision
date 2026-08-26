module pixel_clock_handler (
    input       pclk,
    input       reset,
    input       pixel_valid,

    output reg  pixel_enable
);

    always @(posedge pclk or posedge reset) begin

        if (reset) begin
            pixel_enable <= 1'b0;
        end

        else begin

            // Enable processing only when camera pixel is valid
            if (pixel_valid)
                pixel_enable <= 1'b1;
            else
                pixel_enable <= 1'b0;

        end

    end

endmodule