module spi_master (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    input miso,

    output reg mosi,
    output reg sclk,
    output reg cs,

    output reg [7:0] data_out,
    output reg busy
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            mosi      <= 1'b0;
            sclk      <= 1'b0;
            cs        <= 1'b1;
            busy      <= 1'b0;
            shift_reg <= 8'b0;
            data_out  <= 8'b0;
            bit_count <= 3'b0;

        end
        else begin

            if (!busy) begin

                sclk <= 1'b0;
                cs   <= 1'b1;

                if (start) begin

                    busy      <= 1'b1;
                    cs        <= 1'b0;
                    shift_reg <= data_in;
                    bit_count <= 3'd0;

                    // Send MSB first
                    mosi <= data_in[7];

                end

            end
            else begin

                // Toggle SPI clock
                sclk <= ~sclk;

                // On one clock phase
                if (sclk == 1'b0) begin

                    // Read MISO
                    data_out <= {data_out[6:0], miso};

                end

                // On opposite clock phase
                else begin

                    if (bit_count == 3'd7) begin

                        busy <= 1'b0;
                        cs   <= 1'b1;
                        sclk <= 1'b0;

                    end
                    else begin

                        shift_reg <= {shift_reg[6:0], 1'b0};

                        // Next MOSI bit
                        mosi <= shift_reg[6];

                        bit_count <= bit_count + 1'b1;

                    end

                end

            end

        end

    end

endmodule