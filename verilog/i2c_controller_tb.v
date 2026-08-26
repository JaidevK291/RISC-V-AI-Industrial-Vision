`timescale 1ns/1ps

module i2c_controller_tb;

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


    // Instantiate I2C Controller
    i2c_controller uut (

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


    // Clock generation
    always #5 clk = ~clk;


    // Test sequence
    initial begin

        clk = 0;
        reset = 1;
        start = 0;

        // Example transaction
        device_addr = 8'h42;
        reg_addr    = 8'h12;
        data_in     = 8'h80;

        // Reset
        #20;
        reset = 0;

        // Start transaction
        #20;
        start = 1;

        #10;
        start = 0;

        // Wait for operation
        #500;

        $stop;

    end

endmodule