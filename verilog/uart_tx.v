module uart_tx #(
    parameter CLKS_PER_BIT = 4
)(
    input        clk,
    input        reset,
    input        start,
    input  [7:0]  data_in,

    output reg   tx,
    output reg   busy
);

    // UART states
    parameter IDLE  = 3'd0;
    parameter START = 3'd1;
    parameter DATA  = 3'd2;
    parameter STOP  = 3'd3;

    reg [2:0] state;

    reg [7:0] data_reg;
    reg [2:0] bit_index;

    reg [15:0] clk_count;

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state     <= IDLE;
            tx        <= 1'b1;
            busy      <= 1'b0;
            data_reg  <= 8'b0;
            bit_index <= 3'b0;
            clk_count <= 16'b0;

        end
        else begin

            case (state)

                // -------------------------
                // IDLE
                // -------------------------
                IDLE: begin

                    tx        <= 1'b1;
                    busy      <= 1'b0;
                    clk_count <= 16'b0;
                    bit_index <= 3'b0;

                    if (start) begin
                        data_reg <= data_in;
                        busy     <= 1'b1;
                        state    <= START;
                    end

                end

                // -------------------------
                // START BIT
                // -------------------------
                START: begin

                    tx <= 1'b0;

                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 16'b0;
                        state     <= DATA;
                    end
                    else begin
                        clk_count <= clk_count + 1'b1;
                    end

                end

                // -------------------------
                // DATA BITS
                // -------------------------
                DATA: begin

                    tx <= data_reg[bit_index];

                    if (clk_count == CLKS_PER_BIT - 1) begin

                        clk_count <= 16'b0;

                        if (bit_index == 3'd7) begin
                            bit_index <= 3'b0;
                            state     <= STOP;
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

                    tx <= 1'b1;

                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 16'b0;
                        busy      <= 1'b0;
                        state     <= IDLE;
                    end
                    else begin
                        clk_count <= clk_count + 1'b1;
                    end

                end

                default: begin
                    state <= IDLE;
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                end

            endcase

        end

    end

endmodule