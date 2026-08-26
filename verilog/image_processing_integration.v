module image_processing_integration (

    input clk,
    input reset,

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

    output reg edge_detected,
    output reg defect_detected
);

    wire pipeline_edge;
    wire pipeline_defect;

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

        .edge_detected(pipeline_edge),
        .defect_detected(pipeline_defect)
    );

    // Register outputs only when a complete
    // 3x3 pixel window is available
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            edge_detected   <= 1'b0;
            defect_detected <= 1'b0;
        end

        else if (window_valid) begin
            edge_detected   <= pipeline_edge;
            defect_detected <= pipeline_defect;
        end

        else begin
            edge_detected   <= 1'b0;
            defect_detected <= 1'b0;
        end

    end

endmodule