module uart_rx #(
    parameter CLKS_PER_BIT = 4
)(
    input       clk,
    input       reset,
    input       rx,

    output reg [7:0] data_out,
    output reg       data_valid
);

    // UART Receiver states
    parameter IDLE  = 3'd0;
    parameter START = 3'd1;
    parameter DATA  = 3'd2;
    parameter STOP  = 3'd3;

    reg [2:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            state      <= IDLE;
            clk_count  <= 0;
            bit_index  <= 0;
            data_out   <= 0;
            data_valid <= 0;
        end

        else begin

            // Default: data_valid is normally LOW
            data_valid <= 1'b0;

            case (state)

                // -------------------------
                // IDLE STATE
                // -------------------------
                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;

                    // Detect START bit
                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                // -------------------------
                // START BIT
                // -------------------------
                START: begin

                    // Wait for one bit time
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;

                        // Confirm RX is still LOW
                        if (rx == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                    else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end

                // -------------------------
                // RECEIVE DATA BITS
                // -------------------------
                DATA: begin

                    if (clk_count == CLKS_PER_BIT - 1) begin

                        clk_count <= 0;

                        // UART receives LSB first
                        data_out[bit_index] <= rx;

                        if (bit_index == 3'd7) begin
                            bit_index <= 0;
                            state <= STOP;
                        end
                        else begin
                            bit_index <= bit_index + 1'b1;
                        end

                    end
                    else begin
                        clk_count <= clk_count + 1'b1;
                    end

                end

                // -------------------------
                // STOP BIT
                // -------------------------
                STOP: begin

                    if (clk_count == CLKS_PER_BIT - 1) begin

                        clk_count  <= 0;
                        data_valid <= 1'b1;
                        state      <= IDLE;

                    end
                    else begin
                        clk_count <= clk_count + 1'b1;
                    end

                end

                default: begin
                    state <= IDLE;
                end

            endcase

        end

    end

endmodule