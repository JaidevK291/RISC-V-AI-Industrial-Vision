module sliding_window_3x3 (
    input  [7:0] p00_in,
    input  [7:0] p01_in,
    input  [7:0] p02_in,

    input  [7:0] p10_in,
    input  [7:0] p11_in,
    input  [7:0] p12_in,

    input  [7:0] p20_in,
    input  [7:0] p21_in,
    input  [7:0] p22_in,

    output reg [7:0] p00,
    output reg [7:0] p01,
    output reg [7:0] p02,

    output reg [7:0] p10,
    output reg [7:0] p11,
    output reg [7:0] p12,

    output reg [7:0] p20,
    output reg [7:0] p21,
    output reg [7:0] p22
);

    always @(*) begin

        p00 = p00_in;
        p01 = p01_in;
        p02 = p02_in;

        p10 = p10_in;
        p11 = p11_in;
        p12 = p12_in;

        p20 = p20_in;
        p21 = p21_in;
        p22 = p22_in;

    end

endmodule