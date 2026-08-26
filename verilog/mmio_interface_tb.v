`timescale 1ns/1ps

module mmio_interface_tb;

    reg clk;
    reg reset;

    reg [31:0] address;
    reg read_enable;

    reg defect_detected;

    wire [31:0] read_data;


    mmio_interface uut (

        .clk(clk),
        .reset(reset),

        .address(address),
        .read_enable(read_enable),

        .defect_detected(defect_detected),

        .read_data(read_data)

    );


    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;

        address = 0;
        read_enable = 0;
        defect_detected = 0;

        #10;
        reset = 0;


        // Normal product
        address = 32'h40000000;
        read_enable = 1;
        defect_detected = 0;

        #20;


        // Defect detected
        defect_detected = 1;

        #20;


        // Invalid address
        address = 32'h00000000;

        #20;


        read_enable = 0;

        #20;

        $stop;

    end

endmodule