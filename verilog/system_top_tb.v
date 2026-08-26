`timescale 1ns/1ps

module system_top_tb;

    // ============================================
    // INPUTS
    // ============================================

    reg clk;
    reg reset;

    reg vsync;
    reg href;
    reg [7:0] camera_data;

    reg start_processing;


    // ============================================
    // OUTPUTS
    // ============================================

    wire uart_tx;
    wire edge_detected;
    wire defect_detected;


    // ============================================
    // DUT
    // ============================================

    system_top uut (

        .clk(clk),
        .reset(reset),

        .vsync(vsync),
        .href(href),
        .camera_data(camera_data),

        .start_processing(start_processing),

        .uart_tx(uart_tx),

        .edge_detected(edge_detected),
        .defect_detected(defect_detected)

    );


    // ============================================
    // CLOCK
    // ============================================

    always #5 clk = ~clk;


    // ============================================
    // SEND ONE CAMERA PIXEL
    // ============================================

    task send_pixel;
        input [7:0] data;

        begin
            href = 1'b1;
            camera_data = data;

            #10;
        end
    endtask


    // ============================================
    // MAIN TEST
    // ============================================

    initial begin

        // Initial values
        clk = 0;
        reset = 1;

        vsync = 0;
        href = 0;
        camera_data = 8'd0;

        start_processing = 0;


        // ============================================
        // RESET
        // ============================================

        #20;

        reset = 0;


        // ============================================
        // START OF FRAME
        // ============================================

        vsync = 1'b1;

        #10;

        vsync = 1'b0;


        // ============================================
        // SEND TEST IMAGE
        //
        // 0     0     255
        // 0     0     255
        // 0     0     255
        //
        // Creates a strong vertical edge
        // ============================================


        // ROW 1
        send_pixel(8'd0);
        send_pixel(8'd0);
        send_pixel(8'd255);

        href = 0;

        #10;


        // ROW 2
        send_pixel(8'd0);
        send_pixel(8'd0);
        send_pixel(8'd255);

        href = 0;

        #10;


        // ROW 3
        send_pixel(8'd0);
        send_pixel(8'd0);
        send_pixel(8'd255);

        href = 0;

        #20;


        // ============================================
        // START PROCESSING
        // ============================================

        start_processing = 1'b1;

        #10;

        start_processing = 1'b0;


        // ============================================
        // WAIT FOR COMPLETE PROCESSING
        // ============================================

        #500;


        // ============================================
        // DISPLAY RESULTS
        // ============================================

        $display("========================================");
        $display(" RISC-V AI INDUSTRIAL VISION SYSTEM");
        $display(" FINAL SYSTEM TEST");
        $display("========================================");

        if (edge_detected)
            $display("EDGE DETECTION     : PASS");
        else
            $display("EDGE DETECTION     : CHECK");

        if (defect_detected)
            $display("DEFECT DETECTION   : PASS");
        else
            $display("DEFECT DETECTION   : CHECK");

        $display("UART TX SIGNAL     : %b", uart_tx);

        $display("========================================");


        #100;

        $stop;

    end


    // ============================================
    // MONITOR DEFECT
    // ============================================

    always @(posedge defect_detected) begin

        $display("TIME %0t : DEFECT DETECTED!", $time);

    end


endmodule