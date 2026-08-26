`timescale 1ns/1ps

module pc_next_logic_tb;

    reg [31:0] pc;
    reg [31:0] immediate;
    reg branch_taken;

    wire [31:0] next_pc;


    pc_next_logic uut (

        .pc(pc),
        .immediate(immediate),
        .branch_taken(branch_taken),
        .next_pc(next_pc)

    );


    initial begin

        // Test 1: Normal execution
        // PC = 0 -> 4

        pc = 32'd0;
        immediate = 32'd16;
        branch_taken = 0;

        #20;


        // Test 2: Normal execution
        // PC = 4 -> 8

        pc = 32'd4;
        branch_taken = 0;

        #20;


        // Test 3: Branch taken
        // PC = 8 + 16 = 24

        pc = 32'd8;
        immediate = 32'd16;
        branch_taken = 1;

        #20;


        // Test 4: Branch taken
        // PC = 100 + 20 = 120

        pc = 32'd100;
        immediate = 32'd20;
        branch_taken = 1;

        #20;


        // Test 5: Normal execution
        // PC = 100 -> 104

        branch_taken = 0;

        #20;


        $stop;

    end

endmodule