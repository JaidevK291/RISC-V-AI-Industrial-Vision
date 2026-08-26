`timescale 1ns/1ps

module camera_capture_tb;

    reg pclk;
    reg reset;
    reg vsync;
    reg href;
    reg [7:0] camera_data;

    wire [7:0] pixel_data;
    wire pixel_valid;
    wire frame_active;


    // Instantiate Camera Capture Module
    camera_capture uut (

        .pclk(pclk),
        .reset(reset),
        .vsync(vsync),
        .href(href),
        .camera_data(camera_data),

        .pixel_data(pixel_data),
        .pixel_valid(pixel_valid),
        .frame_active(frame_active)
    );


    // Camera Pixel Clock
    always #5 pclk = ~pclk;


    initial begin

        // Initial values
        pclk        = 0;
        reset       = 1;
        vsync       = 1;
        href        = 0;
        camera_data = 8'h00;


        // Reset
        #20;
        reset = 0;


        // Start frame
        #20;
        vsync = 0;


        // First valid pixel
        href = 1;
        camera_data = 8'h12;

        #10;

        // Second valid pixel
        camera_data = 8'h34;

        #10;

        // Third valid pixel
        camera_data = 8'h56;

        #10;

        // Fourth valid pixel
        camera_data = 8'h78;

        #10;


        // End valid line
        href = 0;

        #20;


        // End frame
        vsync = 1;

        #30;

        $stop;

    end

endmodule