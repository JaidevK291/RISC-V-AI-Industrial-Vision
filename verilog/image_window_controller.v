 module image_window_controller (

    input clk,
    input reset,

    // Frame buffer read interface
    output reg read_enable,
    output reg [9:0] read_x,
    output reg [9:0] read_y,
    input [7:0] read_data,

    // Start processing a 3x3 window
    input start,

    // 3x3 output pixel window
    output reg [7:0] pixel00,
    output reg [7:0] pixel01,
    output reg [7:0] pixel02,

    output reg [7:0] pixel10,
    output reg [7:0] pixel11,
    output reg [7:0] pixel12,

    output reg [7:0] pixel20,
    output reg [7:0] pixel21,
    output reg [7:0] pixel22,

    // Indicates all 9 pixels are ready
    output reg window_valid

);

    // FSM states
    reg [3:0] state;

    localparam IDLE = 4'd0;
    localparam READ00 = 4'd1;
    localparam READ01 = 4'd2;
    localparam READ02 = 4'd3;
    localparam READ10 = 4'd4;
    localparam READ11 = 4'd5;
    localparam READ12 = 4'd6;
    localparam READ20 = 4'd7;
    localparam READ21 = 4'd8;
    localparam READ22 = 4'd9;
    localparam DONE   = 4'd10;


    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state <= IDLE;

            read_enable <= 1'b0;
            read_x <= 10'd0;
            read_y <= 10'd0;

            pixel00 <= 8'd0;
            pixel01 <= 8'd0;
            pixel02 <= 8'd0;

            pixel10 <= 8'd0;
            pixel11 <= 8'd0;
            pixel12 <= 8'd0;

            pixel20 <= 8'd0;
            pixel21 <= 8'd0;
            pixel22 <= 8'd0;

            window_valid <= 1'b0;

        end

        else begin

            // Default values
            read_enable <= 1'b0;
            window_valid <= 1'b0;

            case (state)

                // =====================================
                // WAIT FOR START
                // =====================================

                IDLE: begin

                    if (start) begin
                        state <= READ00;
                    end

                end


                // =====================================
                // READ 3x3 WINDOW
                // =====================================

                READ00: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd0;
                    read_y <= 10'd0;
                    pixel00 <= read_data;
                    state <= READ01;
                end

                READ01: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd1;
                    read_y <= 10'd0;
                    pixel01 <= read_data;
                    state <= READ02;
                end

                READ02: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd2;
                    read_y <= 10'd0;
                    pixel02 <= read_data;
                    state <= READ10;
                end

                READ10: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd0;
                    read_y <= 10'd1;
                    pixel10 <= read_data;
                    state <= READ11;
                end

                READ11: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd1;
                    read_y <= 10'd1;
                    pixel11 <= read_data;
                    state <= READ12;
                end

                READ12: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd2;
                    read_y <= 10'd1;
                    pixel12 <= read_data;
                    state <= READ20;
                end

                READ20: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd0;
                    read_y <= 10'd2;
                    pixel20 <= read_data;
                    state <= READ21;
                end

                READ21: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd1;
                    read_y <= 10'd2;
                    pixel21 <= read_data;
                    state <= READ22;
                end

                READ22: begin
                    read_enable <= 1'b1;
                    read_x <= 10'd2;
                    read_y <= 10'd2;
                    pixel22 <= read_data;
                    state <= DONE;
                end


                // =====================================
                // WINDOW READY
                // =====================================

                DONE: begin

                    window_valid <= 1'b1;

                    state <= IDLE;

                end


                default: begin
                    state <= IDLE;
                end

            endcase

        end

    end

endmodule