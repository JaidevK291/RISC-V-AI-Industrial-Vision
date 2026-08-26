`timescale 1ns/1ps

module simple_ram_tb;

    reg        clk;
    reg        we;
    reg  [3:0] addr;
    reg  [7:0] data_in;

    wire [7:0] data_out;

    simple_ram uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin

        clk     = 0;
        we      = 0;
        addr    = 0;
        data_in = 0;

        // Write 10101010 to address 3
        #10;
        we      = 1;
        addr    = 4'd3;
        data_in = 8'b10101010;

        #10;

        // Write 11001100 to address 5
        addr    = 4'd5;
        data_in = 8'b11001100;

        #10;

        // Read address 3
        we   = 0;
        addr = 4'd3;

        #10;

        // Read address 5
        addr = 4'd5;

        #10;

        $stop;

    end

endmodule