`timescale 1ns/1ps

module basic_gates_tb;

reg a;
reg b;

wire and_out;
wire or_out;
wire not_out;
wire nand_out;
wire nor_out;
wire xor_out;
wire xnor_out;

basic_gates uut (
    .a(a),
    .b(b),
    .and_out(and_out),
    .or_out(or_out),
    .not_out(not_out),
    .nand_out(nand_out),
    .nor_out(nor_out),
    .xor_out(xor_out),
    .xnor_out(xnor_out)
);

initial begin

    // 00
    a = 0;
    b = 0;
    #10;

    // 01
    a = 0;
    b = 1;
    #10;

    // 10
    a = 1;
    b = 0;
    #10;

    // 11
    a = 1;
    b = 1;
    #10;

    $stop;

end

endmodule