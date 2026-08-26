module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0] alu_control,

    output reg [31:0] result,
    output zero
);

    parameter ALU_ADD = 4'b0000;
    parameter ALU_SUB = 4'b0001;
    parameter ALU_AND = 4'b0010;
    parameter ALU_OR  = 4'b0011;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SLT = 4'b0101;

    always @(*) begin
        case (alu_control)

            ALU_ADD: result = a + b;

            ALU_SUB: result = a - b;

            ALU_AND: result = a & b;

            ALU_OR:  result = a | b;

            ALU_XOR: result = a ^ b;

            ALU_SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;

            default: result = 32'd0;

        endcase
    end

    assign zero = (result == 32'd0);

endmodule