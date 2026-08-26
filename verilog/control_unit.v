module control_unit (
    input [6:0] opcode,

    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg branch,
    output reg [3:0] alu_control
);

    parameter ALU_ADD = 4'b0000;
    parameter ALU_SUB = 4'b0001;
    parameter ALU_AND = 4'b0010;
    parameter ALU_OR  = 4'b0011;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SLT = 4'b0101;

    always @(*) begin

        // Default values
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        alu_control = ALU_ADD;

        case (opcode)

            // R-Type: ADD, SUB, AND, OR
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_control = ALU_ADD;
            end

            // I-Type: ADDI
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_control = ALU_ADD;
            end

            // Load Word (LW)
            7'b0000011: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_control = ALU_ADD;
            end

            // Store Word (SW)
            7'b0100011: begin
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_control = ALU_ADD;
            end

            // Branch
            7'b1100011: begin
                branch      = 1'b1;
                alu_control = ALU_SUB;
            end

            default: begin
                reg_write   = 1'b0;
                alu_src     = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                mem_to_reg  = 1'b0;
                branch      = 1'b0;
                alu_control = ALU_ADD;
            end

        endcase

    end

endmodule