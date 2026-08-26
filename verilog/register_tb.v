`timescale 1ns/1ps

module register_tb;

reg clk;
reg enable;
reg [3:0] d;

wire [3:0] q;

register uut (
    .clk(clk),
    .enable(enable),
    .d(d),
    .q(q)
);

// Clock generation
initial begin
    clk = 0;

    forever #5 clk = ~clk;
end

initial begin

    // Initially disabled
    enable = 0;
    d = 4'b0000;
    #10;

    // Enable and store 1010
    enable = 1;
    d = 4'b1010;
    #10;

    // Change data and store 1100
    d = 4'b1100;
    #10;

    // Disable - Q should remain 1100
    enable = 0;
    d = 4'b0011;
    #10;

    // Enable - now store 0011
    enable = 1;
    #10;

    $stop;

end

endmodule