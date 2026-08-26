module memory_mapped_io (

    input  [31:0] address,
    input         read_enable,

    input  [31:0] defect_status_data,

    output reg [31:0] read_data
);

    // Memory mapped address
    parameter DEFECT_STATUS_ADDR = 32'h40000000;

    always @(*) begin

        read_data = 32'h00000000;

        if (read_enable) begin

            if (address == DEFECT_STATUS_ADDR)
                read_data = defect_status_data;

        end

    end

endmodule