`timescale 1ns/1ps

module spi_integration_tb;

    // Clock and control
    reg clk;
    reg reset;
    reg start;

    // Data
    reg [7:0] master_data;
    reg [7:0] slave_data;

    // SPI connections
    wire mosi;
    wire miso;
    wire sclk;
    wire cs;

    // Master outputs
    wire [7:0] master_received;
    wire master_busy;

    // Slave outputs
    wire [7:0] slave_received;
    wire slave_valid;


    // =====================================================
    // SPI MASTER
    // =====================================================

    spi_master master (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(master_data),
        .miso(miso),

        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),

        .data_out(master_received),
        .busy(master_busy)
    );


    // =====================================================
    // SPI SLAVE
    // =====================================================

    spi_slave slave (
        .sclk(sclk),
        .reset(reset),
        .cs(cs),
        .mosi(mosi),

        .data_in(slave_data),
        .miso(miso),

        .data_out(slave_received),
        .data_valid(slave_valid)
    );


    // =====================================================
    // CLOCK
    // 10 ns period = 100 MHz
    // =====================================================

    always #5 clk = ~clk;


    // =====================================================
    // TEST
    // =====================================================

    initial begin

        // Initial values
        clk        = 1'b0;
        reset      = 1'b1;
        start      = 1'b0;

        master_data = 8'b10101010;
        slave_data  = 8'b00110011;

        // Reset
        #20;
        reset = 1'b0;

        // Wait
        #20;

        // Start SPI transfer
        start = 1'b1;

        #10;
        start = 1'b0;

        // Wait until master finishes
        wait(master_busy == 1'b1);
        wait(master_busy == 1'b0);

        #50;

        // Display results
        $display("==========================================");
        $display("       SPI MASTER-SLAVE INTEGRATION       ");
        $display("==========================================");

        $display("Master transmitted : %b", master_data);
        $display("Slave received     : %b", slave_received);

        $display("Slave transmitted  : %b", slave_data);
        $display("Master received    : %b", master_received);

        $display("Slave data valid   : %b", slave_valid);

        $display("==========================================");

        // Automatic verification
        if (slave_received == master_data)
            $display("PASS: Slave received correct data");
        else
            $display("FAIL: Slave received incorrect data");

        if (master_received == slave_data)
            $display("PASS: Master received correct data");
        else
            $display("FAIL: Master received incorrect data");

        $display("==========================================");

        #20;

        $stop;

    end

endmodule