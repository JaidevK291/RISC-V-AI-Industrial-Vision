module sobel_x (
    input  [7:0] p00,
    input  [7:0] p01,
    input  [7:0] p02,

    input  [7:0] p10,
    input  [7:0] p11,
    input  [7:0] p12,

    input  [7:0] p20,
    input  [7:0] p21,
    input  [7:0] p22,

    output reg signed [11:0] gx
);

    always @(*) begin

        gx = -$signed({1'b0, p00})
             + $signed({1'b0, p02})
             - ($signed({1'b0, p10}) <<< 1)
             + ($signed({1'b0, p12}) <<< 1)
             - $signed({1'b0, p20})
             + $signed({1'b0, p22});

    end

endmodule