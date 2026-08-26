`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg reset;

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;

    reg [31:0] write_data;
    reg reg_write;

    wire [31:0] read_data1;
    wire [31:0] read_data2;


    register_file uut (

        .clk(clk),
        .reset(reset),

        .rs1(rs1),
        .rs2(rs2),

        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),

        .read_data1(read_data1),
        .read_data2(read_data2)

    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk = 0;
        reset = 1;

        rs1 = 0;
        rs2 = 0;
        rd = 0;

        write_data = 0;
        reg_write = 0;


        // Reset
        #15;
        reset = 0;


        // ==========================
        // Write x1 = 5
        // ==========================

        #5;
        rd = 5'd1;
        write_data = 32'd5;
        reg_write = 1;

        #10;


        // ==========================
        // Write x2 = 10
        // ==========================

        rd = 5'd2;
        write_data = 32'd10;

        #10;


        // Stop writing
        reg_write = 0;


        // ==========================
        // Read x1 and x2
        // ==========================

        rs1 = 5'd1;
        rs2 = 5'd2;

        #20;


        // ==========================
        // Try writing x0 = 99
        // x0 must remain 0
        // ==========================

        rd = 5'd0;
        write_data = 32'd99;
        reg_write = 1;

        #10;

        reg_write = 0;

        rs1 = 5'd0;

        #20;

        $stop;

    end

endmodule