module i2c_controller (
    input clk,
    input reset,

    // Control inputs
    input start,
    input [7:0] device_addr,
    input [7:0] reg_addr,
    input [7:0] data_in,

    // I2C outputs
    output scl,
    output sda,

    // Status outputs
    output busy,
    output done
);

    // Instantiate the I2C Master
    i2c_master i2c_master_inst (

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

endmodule