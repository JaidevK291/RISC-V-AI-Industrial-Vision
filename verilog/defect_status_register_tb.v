`timescale 1ns/1ps

module defect_status_register_tb;

    reg clk;
    reg reset;
    reg defect_detected;
    reg read_enable;

    wire [31:0] status_data;


    defect_status_register uut (

        .clk(clk),
        .reset(reset),
        .defect_detected(defect_detected),
        .read_enable(read_enable),
        .status_data(status_data)

    );


    // Clock
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;
        defect_detected = 0;
        read_enable = 0;

        // Reset system
        #15;
        reset = 0;


        // Read initial status
        #10;
        read_enable = 1;

        #20;


        // Stop reading
        read_enable = 0;


        // Defect detected
        #10;
        defect_detected = 1;

        #10;
        defect_detected = 0;


        // RISC-V reads status
        #10;
        read_enable = 1;

        #30;


        $stop;

    end

endmodule