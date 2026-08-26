module thresholding (
    input  [12:0] gradient,
    output reg edge_detected
);

    parameter THRESHOLD = 13'd500;

    always @(*) begin
        if (gradient >= THRESHOLD)
            edge_detected = 1'b1;
        else
            edge_detected = 1'b0;
    end

endmodule