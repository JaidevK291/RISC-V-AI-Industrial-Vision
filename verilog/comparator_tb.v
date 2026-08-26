`timescale 1ns/1ps

module comparator_tb;

reg [1:0] a;
reg [1:0] b;

wire greater;
wire equal;
wire less;

comparator uut (
    .a(a),
    .b(b),
    .greater(greater),
    .equal(equal),
    .less(less)
);

initial begin

    // A = 0, B = 0
    a = 2'b00;
    b = 2'b00;
    #10;

    // A = 1, B = 0
    a = 2'b01;
    b = 2'b00;
    #10;

    // A = 0, B = 1
    a = 2'b00;
    b = 2'b01;
    #10;

    // A = 2, B = 2
    a = 2'b10;
    b = 2'b10;
    #10;

    // A = 3, B = 1
    a = 2'b11;
    b = 2'b01;
    #10;

    // A = 1, B = 3
    a = 2'b01;
    b = 2'b11;
    #10;

    $stop;

end

endmodule