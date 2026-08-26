`timescale 1ns/1ps

module instruction_memory_tb;

    reg [31:0] address;

    wire [31:0] instruction;


    instruction_memory uut (

        .address(address),
        .instruction(instruction)

    );


    initial begin

        // Instruction 0
        address = 32'd0;
        #20;

        // Instruction 1
        address = 32'd4;
        #20;

        // Instruction 2
        address = 32'd8;
        #20;

        // Instruction 3
        address = 32'd12;
        #20;

        // Instruction 4
        address = 32'd16;
        #20;

        $stop;

    end

endmodule