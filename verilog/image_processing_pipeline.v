module image_processing_pipeline (

    input clk,
    input reset,

    // 3x3 RGB pixel window inputs
    input [7:0] pixel00,
    input [7:0] pixel01,
    input [7:0] pixel02,

    input [7:0] pixel10,
    input [7:0] pixel11,
    input [7:0] pixel12,

    input [7:0] pixel20,
    input [7:0] pixel21,
    input [7:0] pixel22,

    output defect_detected,
    output edge_detected
);

    // Grayscale pixels
    wire [7:0] gray00, gray01, gray02;
    wire [7:0] gray10, gray11, gray12;
    wire [7:0] gray20, gray21, gray22;

    // Sobel window outputs
    wire [7:0] p00, p01, p02;
    wire [7:0] p10, p11, p12;
    wire [7:0] p20, p21, p22;

    // Sobel results
    wire signed [11:0] gx;
    wire signed [11:0] gy;

    wire [12:0] gradient;

    wire [7:0] edge_count;


    // ============================
    // Grayscale Conversion
    // ============================

    grayscale_converter g0 (.rgb_pixel(pixel00), .gray_pixel(gray00));
    grayscale_converter g1 (.rgb_pixel(pixel01), .gray_pixel(gray01));
    grayscale_converter g2 (.rgb_pixel(pixel02), .gray_pixel(gray02));

    grayscale_converter g3 (.rgb_pixel(pixel10), .gray_pixel(gray10));
    grayscale_converter g4 (.rgb_pixel(pixel11), .gray_pixel(gray11));
    grayscale_converter g5 (.rgb_pixel(pixel12), .gray_pixel(gray12));

    grayscale_converter g6 (.rgb_pixel(pixel20), .gray_pixel(gray20));
    grayscale_converter g7 (.rgb_pixel(pixel21), .gray_pixel(gray21));
    grayscale_converter g8 (.rgb_pixel(pixel22), .gray_pixel(gray22));


    // ============================
    // 3x3 Sliding Window
    // ============================

    sliding_window_3x3 window0 (

        .p00_in(gray00),
        .p01_in(gray01),
        .p02_in(gray02),

        .p10_in(gray10),
        .p11_in(gray11),
        .p12_in(gray12),

        .p20_in(gray20),
        .p21_in(gray21),
        .p22_in(gray22),

        .p00(p00),
        .p01(p01),
        .p02(p02),

        .p10(p10),
        .p11(p11),
        .p12(p12),

        .p20(p20),
        .p21(p21),
        .p22(p22)
    );


    // ============================
    // Sobel X
    // ============================

    sobel_x sobelx0 (
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22),
        .gx(gx)
    );


    // ============================
    // Sobel Y
    // ============================

    sobel_y sobely0 (
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22),
        .gy(gy)
    );


    // ============================
    // Gradient
    // ============================

    gradient_magnitude grad0 (
        .gx(gx),
        .gy(gy),
        .gradient(gradient)
    );


    // ============================
    // Threshold
    // ============================

    thresholding threshold0 (
        .gradient(gradient),
        .edge_detected(edge_detected)
    );


    // ============================
    // Defect Detector
    // ============================

    defect_detector defect0 (
        .clk(clk),
        .reset(reset),
        .edge_detected(edge_detected),
        .defect_detected(defect_detected),
        .edge_count(edge_count)
    );

endmodule