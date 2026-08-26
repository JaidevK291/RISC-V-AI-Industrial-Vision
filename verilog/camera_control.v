module camera_control (
    input clk,
    input reset,
    input start_config,

    // Connection to I2C controller
    output reg i2c_start,
    output reg [7:0] device_addr,
    output reg [7:0] reg_addr,
    output reg [7:0] data_out,

    input i2c_busy,
    input i2c_done,

    output reg config_done
);

    // FSM states
    parameter IDLE       = 3'd0;
    parameter START_I2C  = 3'd1;
    parameter WAIT_I2C   = 3'd2;
    parameter FINISH     = 3'd3;

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state       <= IDLE;
            i2c_start   <= 1'b0;
            device_addr <= 8'h42;
            reg_addr    <= 8'h00;
            data_out    <= 8'h00;
            config_done <= 1'b0;

        end
        else begin

            // Default values
            i2c_start   <= 1'b0;
            config_done <= 1'b0;

            case (state)

                // =====================
                // IDLE
                // =====================
                IDLE: begin

                    if (start_config) begin

                        // Example OV7670 configuration
                        device_addr <= 8'h42;
                        reg_addr    <= 8'h12;
                        data_out    <= 8'h80;

                        state <= START_I2C;

                    end

                end


                // =====================
                // START I2C TRANSACTION
                // =====================
                START_I2C: begin

                    i2c_start <= 1'b1;

                    state <= WAIT_I2C;

                end


                // =====================
                // WAIT FOR I2C
                // =====================
                WAIT_I2C: begin

                    if (i2c_done) begin

                        state <= FINISH;

                    end

                end


                // =====================
                // CONFIGURATION FINISHED
                // =====================
                FINISH: begin

                    config_done <= 1'b1;

                    state <= IDLE;

                end


                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end

endmodule