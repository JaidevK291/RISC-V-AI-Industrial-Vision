module clock_divider (
    input        clk,
    input        reset,
    output reg   slow_clk
);

    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count    <= 3'b000;
            slow_clk <= 1'b0;
        end
        else begin
            if (count == 3'd3) begin
                count    <= 3'b000;
                slow_clk <= ~slow_clk;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule