module frame_buffer #(
    parameter FRAME_WIDTH  = 8,
    parameter FRAME_HEIGHT = 4
)(
    input clk,
    input reset,

    // Write interface
    input write_enable,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [7:0] pixel_data,

    // Read interface
    input read_enable,
    input [9:0] read_x,
    input [9:0] read_y,

    output reg [7:0] read_data
);

    // Total number of pixels
    localparam MEMORY_SIZE = FRAME_WIDTH * FRAME_HEIGHT;

    // Frame buffer memory
    reg [7:0] memory [0:MEMORY_SIZE-1];

    // Address calculation
    integer write_address;
    integer read_address;

    always @(posedge clk) begin

        if (reset) begin
            read_data <= 8'h00;
        end

        else begin

            // -------------------------
            // WRITE PIXEL TO MEMORY
            // -------------------------
            if (write_enable) begin

                write_address = pixel_y * FRAME_WIDTH + pixel_x;

                if (write_address < MEMORY_SIZE)
                    memory[write_address] <= pixel_data;

            end


            // -------------------------
            // READ PIXEL FROM MEMORY
            // -------------------------
            if (read_enable) begin

                read_address = read_y * FRAME_WIDTH + read_x;

                if (read_address < MEMORY_SIZE)
                    read_data <= memory[read_address];

            end

        end

    end

endmodule