module gradient_magnitude (
    input  signed [11:0] gx,
    input  signed [11:0] gy,

    output reg [12:0] gradient
);

    reg [11:0] abs_gx;
    reg [11:0] abs_gy;

    always @(*) begin

        // Absolute value of Gx
        if (gx < 0)
            abs_gx = -gx;
        else
            abs_gx = gx;

        // Absolute value of Gy
        if (gy < 0)
            abs_gy = -gy;
        else
            abs_gy = gy;

        // Gradient magnitude approximation
        gradient = abs_gx + abs_gy;

    end

endmodule