`timescale 1ns/1ps

module mux_tb;

reg i0;
reg i1;
reg s;

wire y;

mux uut (
    .i0(i0),
    .i1(i1),
    .s(s),
    .y(y)
);

initial begin

    // i0=0, i1=1, select i0
    i0 = 0;
    i1 = 1;
    s  = 0;
    #10;

    // i0=0, i1=1, select i1
    i0 = 0;
    i1 = 1;
    s  = 1;
    #10;

    // i0=1, i1=0, select i0
    i0 = 1;
    i1 = 0;
    s  = 0;
    #10;

    // i0=1, i1=0, select i1
    i0 = 1;
    i1 = 0;
    s  = 1;
    #10;

    $stop;

end

endmodule