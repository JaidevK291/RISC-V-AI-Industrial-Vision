`timescale 1ns/1ps

module counter_tb;

reg clk;
reg reset;

wire [3:0] count;

counter uut (
    .clk(clk),
    .reset(reset),
    .count(count)
);

// Clock generation
initial begin
    clk = 0;

    forever #5 clk = ~clk;
end

initial begin

    // Reset counter
    reset = 1;
    #10;

    // Start counting
    reset = 0;
    #100;

    // Reset again
    reset = 1;
    #10;

    $stop;

end

endmodule