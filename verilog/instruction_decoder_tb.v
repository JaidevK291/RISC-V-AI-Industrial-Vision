`timescale 1ns/1ps

module instruction_decoder_tb;

    reg [31:0] instruction;

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;


    instruction_decoder uut (

        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7)

    );


    initial begin

        // addi x1, x0, 5
        instruction = 32'h00500093;

        #30;

        // addi x2, x0, 10
        instruction = 32'h00A00113;

        #30;

        // add x3, x1, x2
        instruction = 32'h002081B3;

        #30;

        $stop;

    end

endmodule