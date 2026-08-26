module uart_mmio (

    input clk,
    input reset,

    // Processor interface
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,

    // UART interface
    output reg uart_start,
    output reg [7:0] uart_data

);

    // UART MMIO address
    parameter UART_TX_ADDR = 32'h40000004;

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            uart_start <= 1'b0;
            uart_data  <= 8'd0;

        end

        else begin

            // Default: start signal is one clock pulse
            uart_start <= 1'b0;

            // Processor writes to UART address
            if (mem_write && address == UART_TX_ADDR) begin

                uart_data  <= write_data[7:0];
                uart_start <= 1'b1;

            end

        end

    end

endmodule