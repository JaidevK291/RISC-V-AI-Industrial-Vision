module i2c_master (
    input clk,
    input reset,
    input start,

    input [7:0] device_addr,
    input [7:0] reg_addr,
    input [7:0] data_in,

    output reg scl,
    output reg sda,
    output reg busy,
    output reg done
);

    // FSM states
    parameter IDLE        = 4'd0;
    parameter START       = 4'd1;
    parameter SEND_DEVICE = 4'd2;
    parameter SEND_REG    = 4'd3;
    parameter SEND_DATA   = 4'd4;
    parameter STOP        = 4'd5;
    parameter DONE        = 4'd6;

    reg [3:0] state;

    reg [7:0] shift_data;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state       <= IDLE;
            scl         <= 1'b1;
            sda         <= 1'b1;
            busy        <= 1'b0;
            done        <= 1'b0;
            shift_data  <= 8'b0;
            bit_count   <= 3'b0;

        end

        else begin

            // Default
            done <= 1'b0;

            case (state)

                // =====================
                // IDLE
                // =====================
                IDLE: begin

                    scl       <= 1'b1;
                    sda       <= 1'b1;
                    busy      <= 1'b0;
                    bit_count <= 3'b0;

                    if (start) begin

                        busy  <= 1'b1;
                        state <= START;

                    end

                end


                // =====================
                // START CONDITION
                // SDA: 1 -> 0 while SCL = 1
                // =====================
                START: begin

                    scl        <= 1'b1;
                    sda        <= 1'b0;

                    shift_data <= device_addr;
                    bit_count  <= 3'd7;

                    state <= SEND_DEVICE;

                end


                // =====================
                // SEND DEVICE ADDRESS
                // =====================
                SEND_DEVICE: begin

                    scl <= 1'b0;

                    sda <= shift_data[bit_count];

                    scl <= 1'b1;

                    if (bit_count == 0) begin

                        shift_data <= reg_addr;
                        bit_count  <= 3'd7;
                        state      <= SEND_REG;

                    end
                    else begin

                        bit_count <= bit_count - 1'b1;

                    end

                end


                // =====================
                // SEND REGISTER ADDRESS
                // =====================
                SEND_REG: begin

                    scl <= 1'b0;

                    sda <= shift_data[bit_count];

                    scl <= 1'b1;

                    if (bit_count == 0) begin

                        shift_data <= data_in;
                        bit_count  <= 3'd7;
                        state      <= SEND_DATA;

                    end
                    else begin

                        bit_count <= bit_count - 1'b1;

                    end

                end


                // =====================
                // SEND DATA
                // =====================
                SEND_DATA: begin

                    scl <= 1'b0;

                    sda <= shift_data[bit_count];

                    scl <= 1'b1;

                    if (bit_count == 0) begin

                        state <= STOP;

                    end
                    else begin

                        bit_count <= bit_count - 1'b1;

                    end

                end


                // =====================
                // STOP CONDITION
                // SDA: 0 -> 1 while SCL = 1
                // =====================
                STOP: begin

                    scl   <= 1'b1;
                    sda   <= 1'b1;

                    state <= DONE;

                end


                // =====================
                // DONE
                // =====================
                DONE: begin

                    busy  <= 1'b0;
                    done  <= 1'b1;

                    state <= IDLE;

                end


                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end

endmodule