`timescale 1ns/1ps

module vsync_href_handler_tb;

    reg pclk;
    reg reset;
    reg vsync;
    reg href;

    wire frame_active;
    wire line_active;
    wire pixel_valid;


    // Instantiate module
    vsync_href_handler uut (

        .pclk(pclk),
        .reset(reset),
        .vsync(vsync),
        .href(href),

        .frame_active(frame_active),
        .line_active(line_active),
        .pixel_valid(pixel_valid)

    );


    // Generate camera pixel clock
    always #5 pclk = ~pclk;


    initial begin

        // Initial values
        pclk  = 0;
        reset = 1;
        vsync = 1;
        href  = 0;

        // Reset
        #20;
        reset = 0;


        // Frame starts
        #20;
        vsync = 0;


        // First valid line
        #20;
        href = 1;

        #40;


        // Line ends
        href = 0;

        #30;


        // Second valid line
        href = 1;

        #40;


        // End line
        href = 0;

        #20;


        // End frame
        vsync = 1;

        #30;

        $stop;

    end

endmodule