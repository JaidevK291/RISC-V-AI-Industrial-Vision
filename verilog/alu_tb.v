`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_control;

    wire [31:0] result;
    wire zero;


    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );


    initial begin

        // ADD: 10 + 5 = 15
        a = 32'd10;
        b = 32'd5;
        alu_control = 4'b0000;
        #20;

        // SUB: 10 - 5 = 5
        alu_control = 4'b0001;
        #20;

        // AND
        a = 32'b1100;
        b = 32'b1010;
        alu_control = 4'b0010;
        #20;

        // OR
        alu_control = 4'b0011;
        #20;

        // XOR
        alu_control = 4'b0100;
        #20;

        // SLT: 5 < 10 = 1
        a = 32'd5;
        b = 32'd10;
        alu_control = 4'b0101;
        #20;

        // Test ZERO flag
        a = 32'd10;
        b = 32'd10;
        alu_control = 4'b0001;
        #20;

        $stop;

    end

endmodule