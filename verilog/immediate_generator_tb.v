`timescale 1ns/1ps

module immediate_generator_tb;

    reg [31:0] instruction;

    wire [31:0] immediate;


    immediate_generator uut (

        .instruction(instruction),
        .immediate(immediate)

    );


    initial begin

        // =============================
        // I-Type
        // addi x1, x0, 5
        // =============================

        instruction = 32'h00500093;

        #20;


        // =============================
        // I-Type negative immediate
        // addi x1, x0, -1
        // =============================

        instruction = 32'hFFF00093;

        #20;


        // =============================
        // S-Type example
        // =============================

        instruction = 32'h0020A023;

        #20;


        // =============================
        // B-Type example
        // =============================

        instruction = 32'h00208463;

        #20;


        // =============================
        // U-Type
        // =============================

        instruction = 32'h123450B7;

        #20;


        // =============================
        // J-Type
        // =============================

        instruction = 32'h0000006F;

        #20;


        $stop;

    end

endmodule