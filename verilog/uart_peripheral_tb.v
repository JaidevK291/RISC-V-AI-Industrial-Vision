`timescale 1ns/1ps

module uart_peripheral_tb;

    reg clk;
    reg reset;

    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_write;

    wire uart_tx;


    uart_peripheral uut (

        .clk(clk),
        .reset(reset),

        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),

        .uart_tx(uart_tx)

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

        // Send 'A'
        #20;
        address = 32'h40000004;
        write_data = 32'h00000041;
        mem_write = 1;

        #10;
        mem_write = 0;

        // Wait for UART transmission
        #500;

        $stop;

    end

endmodule