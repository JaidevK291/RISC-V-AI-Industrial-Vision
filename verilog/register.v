module register_file (

    input clk,
    input reset,

    // Source registers
    input [4:0] rs1,
    input [4:0] rs2,

    // Destination register
    input [4:0] rd,

    // Write data
    input [31:0] write_data,
    input reg_write,

    // Read data
    output reg [31:0] read_data1,
    output reg [31:0] read_data2

);

    // 32 registers × 32 bits
    reg [31:0] registers [0:31];

    integer i;


    // ============================================
    // REGISTER WRITE / RESET
    // ============================================

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            // Reset all registers
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;

        end

        else begin

            // x0 must always remain zero
            registers[0] <= 32'd0;

            // Write only when enabled
            if (reg_write && rd != 5'd0)
                registers[rd] <= write_data;

        end

    end


    // ============================================
    // REGISTER READ PORT 1
    // ============================================

    always @(*) begin

        if (rs1 == 5'd0)
            read_data1 = 32'd0;
        else
            read_data1 = registers[rs1];

    end


    // ============================================
    // REGISTER READ PORT 2
    // ============================================

    always @(*) begin

        if (rs2 == 5'd0)
            read_data2 = 32'd0;
        else
            read_data2 = registers[rs2];

    end

endmodule