`timescale 1ns/1ps

module image_inspection_subsystem_tb;

    reg clk;
    reg reset;

    // Camera inputs
    reg vsync;
    reg href;
    reg [7:0] camera_data;

    // Processing control
    reg start_processing;

    // Status read control
    reg status_read_enable;

    // Outputs
    wire edge_detected;
    wire defect_detected;
    wire [31:0] status_data;


    // =============================================
    // DUT
    // =============================================

    image_inspection_subsystem uut (

        .clk(clk),
        .reset(reset),

        .vsync(vsync),
        .href(href),
        .camera_data(camera_data),

        .start_processing(start_processing),

        .edge_detected(edge_detected),
        .defect_detected(defect_detected),

        .status_read_enable(status_read_enable),
        .status_data(status_data)

    );


    // =============================================
    // CLOCK
    // =============================================

    always #5 clk = ~clk;


    // =============================================
    // CAMERA PIXEL TASK
    // =============================================

    task send_pixel;
        input [7:0] data;
        begin
            href = 1'b1;
            camera_data = data;
            #10;
        end
    endtask


    // =============================================
    // TEST
    // =============================================

    initial begin

        // Initial values
        clk = 0;
        reset = 1;

        vsync = 0;
        href = 0;
        camera_data = 0;

        start_processing = 0;
        status_read_enable = 0;


        // =========================================
        // RESET
        // =========================================

        #20;
        reset = 0;


        // =========================================
        // START OF FRAME
        // =========================================

        // VSYNC pulse resets frame coordinates
        vsync = 1;
        #10;

        vsync = 0;


        // =========================================
        // SEND 3x3 IMAGE
        //
        // Strong vertical edge:
        //
        // 0   0   255
        // 0   0   255
        // 0   0   255
        // =========================================


        // -------- Row 0 --------

        send_pixel(8'd0);
        send_pixel(8'd0);
        send_pixel(8'd255);

        // End of line
        href = 0;
        #10;


        // -------- Row 1 --------

        send_pixel(8'd0);
        send_pixel(8'd0);
        send_pixel(8'd255);

        href = 0;
        #10;


        // -------- Row 2 --------

        send_pixel(8'd0);
        send_pixel(8'd0);
        send_pixel(8'd255);

        href = 0;
        #20;


        // =========================================
        // START IMAGE PROCESSING
        // =========================================

        start_processing = 1;
        #10;

        start_processing = 0;


        // Wait for 3x3 window controller
        // and image processing pipeline
        #400;


        // =========================================
        // READ DEFECT STATUS
        // =========================================

        status_read_enable = 1;

        #20;


        // =========================================
        // CHECK RESULTS
        // =========================================

        $display("------------------------------");

        if (edge_detected)
            $display("EDGE DETECTED: PASS");
        else
            $display("EDGE DETECTED: CHECK");

        if (defect_detected)
            $display("DEFECT DETECTED: PASS");
        else
            $display("DEFECT DETECTED: CHECK");

        if (status_data == 32'd1)
            $display("DEFECT STATUS REGISTER: PASS");
        else
            $display("DEFECT STATUS REGISTER: CHECK");

        $display("------------------------------");


        #20;

        $stop;

    end

endmodule