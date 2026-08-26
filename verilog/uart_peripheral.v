module uart_peripheral (

    input clk,
    input reset,

    // Processor interface
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,

    // UART serial output
    output uart_tx

);

    // Internal signals
    wire uart_start;
    wire [7:0] uart_data;
    wire uart_busy;


    // ============================================
    // UART MMIO
    // ============================================

    uart_mmio uart_mmio_unit (

        .clk(clk),
        .reset(reset),

        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),

        .uart_start(uart_start),
        .uart_data(uart_data)

    );


    // ============================================
    // UART TRANSMITTER
    // ============================================

    uart_tx uart_tx_unit (

        .clk(clk),
        .reset(reset),

        .start(uart_start),
        .data_in(uart_data),

        .tx(uart_tx),
        .busy(uart_busy)

    );

endmodule