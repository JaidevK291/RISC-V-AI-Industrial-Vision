`timescale 1ns/1ps

module program_counter_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;


    program_counter uut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;

        #15;
        reset = 0;

        #100;

        $stop;

    end

endmodule