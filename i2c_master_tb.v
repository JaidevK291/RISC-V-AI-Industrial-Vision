`timescale 1ns/1ps

module i2c_master_tb;

    reg clk;
    reg reset;
    reg start;

    reg [7:0] device_addr;
    reg [7:0] reg_addr;
    reg [7:0] data_in;

    wire scl;
    wire sda;
    wire busy;
    wire done;


    // I2C Master
    i2c_master uut (

        .clk(clk),
        .reset(reset),
        .start(start),

        .device_addr(device_addr),
        .reg_addr(reg_addr),
        .data_in(data_in),

        .scl(scl),
        .sda(sda),
        .busy(busy),
        .done(done)
    );


    // FPGA Clock
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk         = 0;
        reset       = 1;
        start       = 0;

        // Example data
        device_addr = 8'h42;
        reg_addr    = 8'h12;
        data_in     = 8'h80;


        // Reset
        #20;
        reset = 0;


        // Start I2C transaction
        #20;
        start = 1;

        #10;
        start = 0;


        // Wait for transaction
        #500;

        $stop;

    end

endmodule