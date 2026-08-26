module mmio_interface (

    input clk,
    input reset,

    // Address from processor
    input  [31:0] address,

    // Processor control
    input         read_enable,

    // Defect status from image processing
    input         defect_detected,

    // Data returned to RISC-V
    output reg [31:0] read_data

);

    // MMIO address
    parameter DEFECT_STATUS_ADDR = 32'h40000000;

    always @(*) begin

        read_data = 32'd0;

        if (read_enable) begin

            if (address == DEFECT_STATUS_ADDR)
                read_data = {31'd0, defect_detected};

        end

    end

endmodule