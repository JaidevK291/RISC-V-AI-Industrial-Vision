`timescale 1ns/1ps

module d_ff_tb;

reg d;
reg clk;

wire q;

d_ff uut (
    .d(d),
    .clk(clk),
    .q(q)
);

// Clock generation
initial begin
    clk = 0;

    forever #5 clk = ~clk;
end

// Test data
initial begin

    // Initial value
    d = 0;

    #12;

    // Change D to 1
    d = 1;

    #10;

    // Change D to 0
    d = 0;

    #10;

    // Change D to 1
    d = 1;

    #10;

    $stop;

end

endmodule