`timescale 1ns/1ps

module uart_mmio_tb;

    reg clk;
    reg reset;

    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_write;

    wire uart_start;
    wire [7:0] uart_data;


    uart_mmio uut (

        .clk(clk),
        .reset(reset),

        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),

        .uart_start(uart_start),
        .uart_data(uart_data)

    );


    // Clock
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;

        address = 32'd0;
        write_data = 32'd0;
        mem_write = 0;

        #20;

        reset = 0;


        // Test 1: Write 'A' (ASCII 65)
        address = 32'h40000004;
        write_data = 32'h00000041;
        mem_write = 1;

        #10;

        mem_write = 0;

        #30;


        // Test 2: Write 'B' (ASCII 66)
        address = 32'h40000004;
        write_data = 32'h00000042;
        mem_write = 1;

        #10;

        mem_write = 0;

        #30;


        // Test 3: Invalid address
        address = 32'h00000000;
        write_data = 32'h00000043;
        mem_write = 1;

        #10;

        mem_write = 0;

        #30;

        $stop;

    end

endmodule