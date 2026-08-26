module comparator (
    input  [1:0] a,
    input  [1:0] b,

    output       greater,
    output       equal,
    output       less
);

assign greater = (a > b);
assign equal   = (a == b);
assign less    = (a < b);

endmodule