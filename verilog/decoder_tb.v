`timescale 1ns/1ps

module decoder_tb;

reg a;
reg b;

wire y0;
wire y1;
wire y2;
wire y3;

decoder uut (
    .a(a),
    .b(b),
    .y0(y0),
    .y1(y1),
    .y2(y2),
    .y3(y3)
);

initial begin

    // Test 00
    a = 0;
    b = 0;
    #10;

    // Test 01
    a = 0;
    b = 1;
    #10;

    // Test 10
    a = 1;
    b = 0;
    #10;

    // Test 11
    a = 1;
    b = 1;
    #10;

    $stop;

end

endmodule