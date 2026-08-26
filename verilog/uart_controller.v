module uart_controller #(
    parameter CLKS_PER_BIT = 4
)(
    input clk,
    input reset,

    // Transmitter interface
    input       tx_start,
    input [7:0] tx_data,
    output      tx,
    output      tx_busy,

    // Receiver interface
    input       rx,
    output [7:0] rx_data,
    output       rx_valid
);

    // UART Transmitter
    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_tx_inst (

        .clk(clk),
        .reset(reset),
        .start(tx_start),
        .data_in(tx_data),

        .tx(tx),
        .busy(tx_busy)
    );


    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_rx_inst (

        .clk(clk),
        .reset(reset),
        .rx(rx),

        .data_out(rx_data),
        .data_valid(rx_valid)
    );

endmodule