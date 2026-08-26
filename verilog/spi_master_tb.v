`timescale 1ns/1ps

module spi_master_tb;

    reg clk;
    reg reset;
    reg start;
    reg [7:0] data_in;
    reg miso;

    wire mosi;
    wire sclk;
    wire cs;
    wire [7:0] data_out;
    wire busy;

    // SPI Master
    spi_master uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .miso(miso),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .data_out(data_out),
        .busy(busy)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk     = 0;
        reset   = 1;
        start   = 0;
        data_in = 8'b00000000;
        miso    = 0;

        // Reset
        #20;
        reset = 0;

        // Start SPI transfer
        #20;
        data_in = 8'b10101010;
        start   = 1;

        #10;
        start = 0;

        // Change MISO data for testing
        #40  miso = 1;
        #40  miso = 0;
        #40  miso = 1;
        #40  miso = 0;
        #40  miso = 1;
        #40  miso = 0;
        #40  miso = 1;
        #40  miso = 0;

        #100;

        $stop;
    end

endmodule