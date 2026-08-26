module branch_logic (

    input        branch,
    input [2:0]  funct3,
    input [31:0] a,
    input [31:0] b,

    output reg branch_taken

);

    always @(*) begin

        branch_taken = 1'b0;

        if (branch) begin

            case (funct3)

                // BEQ
                3'b000:
                    branch_taken = (a == b);

                // BNE
                3'b001:
                    branch_taken = (a != b);

                // BLT
                3'b100:
                    branch_taken = ($signed(a) < $signed(b));

                // BGE
                3'b101:
                    branch_taken = ($signed(a) >= $signed(b));

                default:
                    branch_taken = 1'b0;

            endcase

        end

    end

endmodule