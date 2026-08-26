`timescale 1ns/1ps

module branch_logic_tb;

    reg branch;
    reg [2:0] funct3;

    reg [31:0] a;
    reg [31:0] b;

    wire branch_taken;


    branch_logic uut (

        .branch(branch),
        .funct3(funct3),

        .a(a),
        .b(b),

        .branch_taken(branch_taken)

    );


    initial begin

        // -----------------------
        // Test 1: BEQ TRUE
        // 10 == 10
        // -----------------------

        branch = 1;
        funct3 = 3'b000;

        a = 32'd10;
        b = 32'd10;

        #20;


        // -----------------------
        // Test 2: BEQ FALSE
        // -----------------------

        a = 32'd10;
        b = 32'd20;

        #20;


        // -----------------------
        // Test 3: BNE TRUE
        // -----------------------

        funct3 = 3'b001;

        a = 32'd10;
        b = 32'd20;

        #20;


        // -----------------------
        // Test 4: BLT TRUE
        // -----------------------

        funct3 = 3'b100;

        a = 32'd5;
        b = 32'd10;

        #20;


        // -----------------------
        // Test 5: BGE TRUE
        // -----------------------

        funct3 = 3'b101;

        a = 32'd10;
        b = 32'd5;

        #20;


        // Disable branch
        branch = 0;

        #20;

        $stop;

    end

endmodule