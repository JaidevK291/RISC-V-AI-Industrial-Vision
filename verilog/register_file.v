module register_file (

    input clk,
    input reset,

    // Read register addresses
    input [4:0] rs1,
    input [4:0] rs2,

    // Write register address
    input [4:0] rd,

    // Data to write
    input [31:0] write_data,

    // Write enable
    input reg_write,

    // Read outputs
    output [31:0] read_data1,
    output [31:0] read_data2
);

    // 32 registers, each 32-bit
    reg [31:0] registers [0:31];

    integer i;

    // Reset and write operation
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end

        else if (reg_write && rd != 5'd0) begin
            // Never allow writing to x0
            registers[rd] <= write_data;
        end

    end


    // Register x0 is always zero
    assign read_data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];

    assign read_data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

endmodule