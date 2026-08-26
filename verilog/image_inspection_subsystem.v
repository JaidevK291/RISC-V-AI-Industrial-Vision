module image_inspection_subsystem (

    input clk,
    input reset,

    // Camera interface
    input vsync,
    input href,
    input [7:0] camera_data,

    // Start 3x3 image processing
    input start_processing,

    // Final outputs
    output edge_detected,
    output defect_detected,

    // RISC-V status interface
    input status_read_enable,
    output [31:0] status_data
);


    // ============================================
    // CAMERA CAPTURE SIGNALS
    // ============================================

    wire [7:0] captured_pixel;
    wire pixel_valid;
    wire frame_active;


    camera_capture camera0 (

        .pclk(clk),
        .reset(reset),

        .vsync(vsync),
        .href(href),
        .camera_data(camera_data),

        .pixel_data(captured_pixel),
        .pixel_valid(pixel_valid),
        .frame_active(frame_active)

    );


    // ============================================
    // PIXEL COORDINATE GENERATOR
    // ============================================

    reg [9:0] pixel_x;
    reg [9:0] pixel_y;


    always @(posedge clk or posedge reset) begin

        if (reset) begin

            pixel_x <= 10'd0;
            pixel_y <= 10'd0;

        end

        else if (vsync) begin

            // New frame
            pixel_x <= 10'd0;
            pixel_y <= 10'd0;

        end

        else if (pixel_valid) begin

            pixel_x <= pixel_x + 1'b1;

        end

        else if (!href && frame_active) begin

            // End of line
            pixel_x <= 10'd0;
            pixel_y <= pixel_y + 1'b1;

        end

    end


    // ============================================
    // FRAME BUFFER
    // ============================================

    wire read_enable;
    wire [9:0] read_x;
    wire [9:0] read_y;
    wire [7:0] read_data;


    frame_buffer #(
        .FRAME_WIDTH(8),
        .FRAME_HEIGHT(4)
    ) frame_buffer0 (

        .clk(clk),
        .reset(reset),

        // Write from camera
        .write_enable(pixel_valid),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .pixel_data(captured_pixel),

        // Read from window controller
        .read_enable(read_enable),
        .read_x(read_x),
        .read_y(read_y),
        .read_data(read_data)

    );


    // ============================================
    // IMAGE WINDOW CONTROLLER
    // ============================================

    wire [7:0] pixel00;
    wire [7:0] pixel01;
    wire [7:0] pixel02;

    wire [7:0] pixel10;
    wire [7:0] pixel11;
    wire [7:0] pixel12;

    wire [7:0] pixel20;
    wire [7:0] pixel21;
    wire [7:0] pixel22;

    wire window_valid;


    image_window_controller window_controller0 (

        .clk(clk),
        .reset(reset),

        .read_enable(read_enable),
        .read_x(read_x),
        .read_y(read_y),
        .read_data(read_data),

        .start(start_processing),

        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),

        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),

        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),

        .window_valid(window_valid)

    );


    // ============================================
    // IMAGE PROCESSING PIPELINE
    // ============================================

    wire pipeline_edge;
    wire pipeline_defect;


    image_processing_integration processing0 (

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

        .window_valid(window_valid),

        .edge_detected(pipeline_edge),
        .defect_detected(pipeline_defect)

    );


    assign edge_detected = pipeline_edge;
    assign defect_detected = pipeline_defect;


    // ============================================
    // DEFECT STATUS REGISTER
    // ============================================

    defect_status_register status_register0 (

        .clk(clk),
        .reset(reset),

        .defect_detected(pipeline_defect),

        .read_enable(status_read_enable),

        .status_data(status_data)

    );


endmodule