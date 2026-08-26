`timescale 1ns/1ps

module data_memory_tb;

    reg clk;

    reg mem_read;
    reg mem_write;

    reg [31:0] address;
    reg [31:0] write_data;

    wire [31:0] read_data;


    data_memory uut (

        .clk(clk),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(address),
        .write_data(write_data),

        .read_data(read_data)

    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;


        // ==========================
        // Store 100 at address 0
        // ==========================

        #10;

        address = 32'd0;
        write_data = 32'd100;
        mem_write = 1;

        #10;

        mem_write = 0;


        // ==========================
        // Store 200 at address 4
        // ==========================

        #10;

        address = 32'd4;
        write_data = 32'd200;
        mem_write = 1;

        #10;

        mem_write = 0;


        // ==========================
        // Read address 0
        // ==========================

        #10;

        address = 32'd0;
        mem_read = 1;

        #20;


        // ==========================
        // Read address 4
        // ==========================

        address = 32'd4;

        #20;


        // Stop reading
        mem_read = 0;

        #20;

        $stop;

    end

endmodule