`timescale 1ns/1ps

module memory_mapped_io_tb;

    reg [31:0] address;
    reg        read_enable;
    reg [31:0] defect_status_data;

    wire [31:0] read_data;


    memory_mapped_io uut (

        .address(address),
        .read_enable(read_enable),
        .defect_status_data(defect_status_data),
        .read_data(read_data)

    );


    initial begin

        // Initial values
        address = 32'h00000000;
        read_enable = 0;
        defect_status_data = 32'h00000001;

        #20;


        // Test 1: Correct address
        // RISC-V reads defect status
        address = 32'h40000000;
        read_enable = 1;

        #30;


        // Test 2: Wrong address
        address = 32'h40000004;

        #30;


        // Test 3: Read disabled
        read_enable = 0;

        #30;


        $stop;

    end

endmodule