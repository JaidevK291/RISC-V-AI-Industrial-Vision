`timescale 1ns/1ps

module sliding_window_3x3_tb;

    reg [7:0] p00_in;
    reg [7:0] p01_in;
    reg [7:0] p02_in;

    reg [7:0] p10_in;
    reg [7:0] p11_in;
    reg [7:0] p12_in;

    reg [7:0] p20_in;
    reg [7:0] p21_in;
    reg [7:0] p22_in;


    wire [7:0] p00;
    wire [7:0] p01;
    wire [7:0] p02;

    wire [7:0] p10;
    wire [7:0] p11;
    wire [7:0] p12;

    wire [7:0] p20;
    wire [7:0] p21;
    wire [7:0] p22;


    sliding_window_3x3 uut (

        .p00_in(p00_in),
        .p01_in(p01_in),
        .p02_in(p02_in),

        .p10_in(p10_in),
        .p11_in(p11_in),
        .p12_in(p12_in),

        .p20_in(p20_in),
        .p21_in(p21_in),
        .p22_in(p22_in),

        .p00(p00),
        .p01(p01),
        .p02(p02),

        .p10(p10),
        .p11(p11),
        .p12(p12),

        .p20(p20),
        .p21(p21),
        .p22(p22)

    );


    initial begin

        // First 3×3 pixel window

        p00_in = 8'd10;
        p01_in = 8'd20;
        p02_in = 8'd30;

        p10_in = 8'd40;
        p11_in = 8'd50;
        p12_in = 8'd60;

        p20_in = 8'd70;
        p21_in = 8'd80;
        p22_in = 8'd90;

        #50;


        // Second window

        p00_in = 8'd20;
        p01_in = 8'd30;
        p02_in = 8'd40;

        p10_in = 8'd50;
        p11_in = 8'd60;
        p12_in = 8'd70;

        p20_in = 8'd80;
        p21_in = 8'd90;
        p22_in = 8'd100;

        #50;

        $stop;

    end

endmodule