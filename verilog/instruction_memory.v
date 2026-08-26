module instruction_memory (

    input  [31:0] address,
    output reg [31:0] instruction

);

    reg [31:0] memory [0:15];

    initial begin

        // Sample RISC-V instructions

        memory[0] = 32'h00500093;
        // addi x1, x0, 5

        memory[1] = 32'h00A00113;
        // addi x2, x0, 10

        memory[2] = 32'h002081B3;
        // add x3, x1, x2

        memory[3] = 32'h00000013;
        // nop

        memory[4] = 32'h00000013;
        memory[5] = 32'h00000013;
        memory[6] = 32'h00000013;
        memory[7] = 32'h00000013;

    end


    always @(*) begin

        // PC addresses are byte addresses
        // Divide by 4 to access instruction memory

        instruction = memory[address[5:2]];

    end

endmodule