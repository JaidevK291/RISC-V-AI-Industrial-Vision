`timescale 1ns/1ps

module spi_slave_tb;

    reg sclk;
    reg reset;
    reg cs;
    reg mosi;
    reg [7:0] data_in;

    wire miso;
    wire [7:0] data_out;
    wire data_valid;

    spi_slave uut (
        .sclk(sclk),
        .reset(reset),
        .cs(cs),
        .mosi(mosi),
        .data_in(data_in),
        .miso(miso),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    initial begin

        sclk = 0;
        reset = 1;
        cs = 1;
        mosi = 0;

        // Data the slave will send back
        data_in = 8'b00110011;

        #20;
        reset = 0;

        // Activate slave
        #20;
        cs = 0;

        // Send 10101010 to slave
        #10;

        mosi = 1; #10; sclk = 1; #10; sclk = 0;
        mosi = 0; #10; sclk = 1; #10; sclk = 0;
        mosi = 1; #10; sclk = 1; #10; sclk = 0;
        mosi = 0; #10; sclk = 1; #10; sclk = 0;
        mosi = 1; #10; sclk = 1; #10; sclk = 0;
        mosi = 0; #10; sclk = 1; #10; sclk = 0;
        mosi = 1; #10; sclk = 1; #10; sclk = 0;
        mosi = 0; #10; sclk = 1; #10; sclk = 0;

        // Deactivate slave
        #20;
        cs = 1;

        #30;

        $stop;

    end

endmodule