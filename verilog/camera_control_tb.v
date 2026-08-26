`timescale 1ns/1ps

module camera_control_tb;

    reg clk;
    reg reset;
    reg start_config;

    wire i2c_start;
    wire [7:0] device_addr;
    wire [7:0] reg_addr;
    wire [7:0] data_out;

    reg i2c_busy;
    reg i2c_done;

    wire config_done;


    camera_control uut (

        .clk(clk),
        .reset(reset),
        .start_config(start_config),

        .i2c_start(i2c_start),
        .device_addr(device_addr),
        .reg_addr(reg_addr),
        .data_out(data_out),

        .i2c_busy(i2c_busy),
        .i2c_done(i2c_done),

        .config_done(config_done)
    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        clk          = 0;
        reset        = 1;
        start_config = 0;

        i2c_busy = 0;
        i2c_done = 0;

        // Reset
        #20;
        reset = 0;

        // Start camera configuration
        #20;
        start_config = 1;

        #10;
        start_config = 0;

        // Simulate I2C busy
        #20;
        i2c_busy = 1;

        // Simulate I2C complete
        #100;
        i2c_busy = 0;
        i2c_done = 1;

        #10;
        i2c_done = 0;

        #50;

        $stop;

    end

endmodule