module defect_status_register (

    input clk,
    input reset,

    input defect_detected,

    // RISC-V read interface
    input read_enable,

    output reg [31:0] status_data
);

    reg defect_status;

    // Store defect status
    always @(posedge clk or posedge reset) begin

        if (reset)
            defect_status <= 1'b0;

        else if (defect_detected)
            defect_status <= 1'b1;

    end


    // RISC-V readable status register
    always @(*) begin

        if (read_enable)
            status_data = {31'd0, defect_status};

        else
            status_data = 32'd0;

    end

endmodule