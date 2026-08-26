module image_processing_integration (

    input clk,
    input reset,

    // --------------------------------
    // Input from image window controller
    // --------------------------------
    input [7:0] pixel00,
    input [7:0] pixel01,
    input [7:0] pixel02,

    input [7:0] pixel10,
    input [7:0] pixel11,
    input [7:0] pixel12,

    input [7:0] pixel20,
    input [7:0] pixel21,
    input [7:0] pixel22,

    input window_valid,

    // --------------------------------
    // Processing outputs
    // --------------------------------
    output edge_detected,
    output defect_detected

);

    // Connect 3x3 window to image pipeline

    image_processing_pipeline pipeline0 (

        .clk(clk),
        .reset(reset),

        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),

        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),

        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),

        .edge_detected(edge_detected),
        .defect_detected(defect_detected)

    );

endmodule