`timescale 1ns/1ps

module frame_buffer_tb;

    reg clk;
    reg reset;

    // Write signals
    reg write_enable;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;
    reg [7:0] pixel_data;

    // Read signals
    reg read_enable;
    reg [9:0] read_x;
    reg [9:0] read_y;

    wire [7:0] read_data;


    // Instantiate Frame Buffer
    frame_buffer #(
        .FRAME_WIDTH(8),
        .FRAME_HEIGHT(4)
    ) uut (

        .clk(clk),
        .reset(reset),

        .write_enable(write_enable),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .pixel_data(pixel_data),

        .read_enable(read_enable),
        .read_x(read_x),
        .read_y(read_y),

        .read_data(read_data)
    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk = 0;
        reset = 1;

        write_enable = 0;
        pixel_x = 0;
        pixel_y = 0;
        pixel_data = 0;

        read_enable = 0;
        read_x = 0;
        read_y = 0;


        // Reset
        #20;
        reset = 0;


        // =================================
        // WRITE PIXEL 1
        // Position (0,0)
        // =================================

        #10;

        pixel_x = 0;
        pixel_y = 0;
        pixel_data = 8'h12;
        write_enable = 1;

        #10;

        write_enable = 0;


        // =================================
        // WRITE PIXEL 2
        // Position (1,0)
        // =================================

        #10;

        pixel_x = 1;
        pixel_y = 0;
        pixel_data = 8'h34;
        write_enable = 1;

        #10;

        write_enable = 0;


        // =================================
        // WRITE PIXEL 3
        // Position (2,1)
        // =================================

        #10;

        pixel_x = 2;
        pixel_y = 1;
        pixel_data = 8'h56;
        write_enable = 1;

        #10;

        write_enable = 0;


        // =================================
        // READ PIXEL (0,0)
        // Expected = 0x12
        // =================================

        #20;

        read_x = 0;
        read_y = 0;
        read_enable = 1;

        #10;

        read_enable = 0;


        // =================================
        // READ PIXEL (1,0)
        // Expected = 0x34
        // =================================

        #20;

        read_x = 1;
        read_y = 0;
        read_enable = 1;

        #10;

        read_enable = 0;


        // =================================
        // READ PIXEL (2,1)
        // Expected = 0x56
        // =================================

        #20;

        read_x = 2;
        read_y = 1;
        read_enable = 1;

        #10;

        read_enable = 0;


        #30;

        $stop;

    end

endmodule