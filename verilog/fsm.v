module fsm (
    input        clk,
    input        reset,
    input        start,
    output reg   active
);

    // State encoding
    parameter IDLE   = 1'b0;
    parameter ACTIVE = 1'b1;

    reg state;
    reg next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)

            IDLE: begin
                if (start)
                    next_state = ACTIVE;
                else
                    next_state = IDLE;
            end

            ACTIVE: begin
                if (start)
                    next_state = ACTIVE;
                else
                    next_state = IDLE;
            end

            default:
                next_state = IDLE;

        endcase
    end

    // Output logic
    always @(*) begin
        case (state)

            IDLE:
                active = 1'b0;

            ACTIVE:
                active = 1'b1;

            default:
                active = 1'b0;

        endcase
    end

endmodule