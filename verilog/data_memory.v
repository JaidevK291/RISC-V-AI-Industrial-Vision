module data_memory (

    input clk,

    // ============================================
    // CONTROL SIGNALS
    // ============================================
    input mem_read,
    input mem_write,

    // ============================================
    // ADDRESS FROM ALU
    // ============================================
    input [31:0] address,

    // ============================================
    // DATA TO STORE (SW)
    // ============================================
    input [31:0] write_data,

    // ============================================
    // DATA READ (LW)
    // ============================================
    output reg [31:0] read_data

);

    // ============================================
    // DATA MEMORY
    // 16 words × 32 bits
    // ============================================

    reg [31:0] memory [0:15];

    integer i;


    // ============================================
    // MEMORY INITIALIZATION
    // ============================================

    initial begin

        for (i = 0; i < 16; i = i + 1) begin

            memory[i] = 32'd0;

        end

    end


    // ============================================
    // STORE WORD OPERATION
    //
    // RISC-V addresses are byte addresses.
    // address[5:2] converts byte address
    // into word address.
    // ============================================

    always @(posedge clk) begin

        if (mem_write) begin

            memory[address[5:2]] <= write_data;

        end

    end


    // ============================================
    // LOAD WORD OPERATION
    // ============================================

    always @(*) begin

        if (mem_read) begin

            read_data = memory[address[5:2]];

        end

        else begin

            read_data = 32'd0;

        end

    end


endmodule