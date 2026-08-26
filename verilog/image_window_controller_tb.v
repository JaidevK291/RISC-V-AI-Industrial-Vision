`timescale 1ns/1ps

module image_window_controller_tb;

    reg clk;
    reg reset;
    reg start;

    // Frame buffer write signals
    reg write_enable;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;
    reg [7:0] pixel_data;

    // Controller ↔ Frame buffer signals
    wire read_enable;
    wire [9:0] read_x;
    wire [9:0] read_y;
    wire [7:0] read_data;

    // 3x3 window outputs
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


    // =============================================
    // FRAME BUFFER
    // =============================================

    frame_buffer #(
        .FRAME_WIDTH(8),
        .FRAME_HEIGHT(4)
    ) fb (

        .clk(clk),
        .reset(reset),

        // Write interface
        .write_enable(write_enable),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .pixel_data(pixel_data),

        // Read interface
        .read_enable(read_enable),
        .read_x(read_x),
        .read_y(read_y),

        .read_data(read_data)

    );


    // =============================================
    // IMAGE WINDOW CONTROLLER
    // =============================================

    image_window_controller uut (

        .clk(clk),
        .reset(reset),

        .read_enable(read_enable),
        .read_x(read_x),
        .read_y(read_y),
        .read_data(read_data),

        .start(start),

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


    // =============================================
    // CLOCK
    // =============================================

    always #5 clk = ~clk;


    // =============================================
    // TEST
    // =============================================

    initial begin

        // Initial values
        clk = 0;
        reset = 1;
        start = 0;

        write_enable = 0;
        pixel_x = 0;
        pixel_y = 0;
        pixel_data = 0;

        // Reset
        #20;
        reset = 0;


        // =========================================
        // WRITE 3x3 PIXELS INTO FRAME BUFFER
        // =========================================

        // Row 0
        write_enable = 1;

        pixel_x = 0; pixel_y = 0; pixel_data = 8'd10;
        #10;

        pixel_x = 1; pixel_y = 0; pixel_data = 8'd20;
        #10;

        pixel_x = 2; pixel_y = 0; pixel_data = 8'd30;
        #10;


        // Row 1
        pixel_x = 0; pixel_y = 1; pixel_data = 8'd40;
        #10;

        pixel_x = 1; pixel_y = 1; pixel_data = 8'd50;
        #10;

        pixel_x = 2; pixel_y = 1; pixel_data = 8'd60;
        #10;


        // Row 2
        pixel_x = 0; pixel_y = 2; pixel_data = 8'd70;
        #10;

        pixel_x = 1; pixel_y = 2; pixel_data = 8'd80;
        #10;

        pixel_x = 2; pixel_y = 2; pixel_data = 8'd90;
        #10;


        // Stop writing
        write_enable = 0;

        #20;


        // =========================================
        // START WINDOW READ
        // =========================================

        start = 1;

        #10;

        start = 0;


        // Wait for controller
        #200;


        $stop;

    end

endmodule