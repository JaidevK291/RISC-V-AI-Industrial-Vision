module defect_detector (
    input clk,
    input reset,
    input edge_detected,

    output reg defect_detected,
    output reg [7:0] edge_count
);

    parameter DEFECT_THRESHOLD = 8'd5;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            edge_count       <= 8'd0;
            defect_detected  <= 1'b0;
        end

        else begin

            if (edge_detected) begin

                edge_count <= edge_count + 1'b1;

                // Check whether next edge reaches threshold
                if (edge_count + 1'b1 >= DEFECT_THRESHOLD)
                    defect_detected <= 1'b1;

            end

        end

    end

endmodule