module riscv_core (

    input clk,
    input reset,

    // Defect status from image processing system
    input defect_detected

);

    // =====================================================
    // PROGRAM COUNTER SIGNALS
    // =====================================================

    wire [31:0] pc;
    wire [31:0] next_pc;


    // =====================================================
    // INSTRUCTION MEMORY
    // =====================================================

    wire [31:0] instruction;


    // =====================================================
    // INSTRUCTION DECODER SIGNALS
    // =====================================================

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;


    // =====================================================
    // REGISTER FILE SIGNALS
    // =====================================================

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;


    // =====================================================
    // IMMEDIATE GENERATOR
    // =====================================================

    wire [31:0] immediate;


    // =====================================================
    // CONTROL UNIT SIGNALS
    // =====================================================

    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire branch;

    wire [3:0] alu_control;


    // =====================================================
    // ALU SIGNALS
    // =====================================================

    wire [31:0] alu_input_b;
    wire [31:0] alu_result;
    wire zero;


    // =====================================================
    // DATA MEMORY SIGNALS
    // =====================================================

    // MMIO SIGNALS
    wire [31:0] mmio_read_data;
    wire        mmio_selected;
    wire [31:0] processor_read_data;

    // =====================================================
    // BRANCH SIGNALS
    // =====================================================

    wire branch_taken;


    // =====================================================
    // 1. PROGRAM COUNTER
    // =====================================================

    program_counter pc_unit (

        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)

    );


    // =====================================================
    // 2. INSTRUCTION MEMORY
    // =====================================================

    instruction_memory imem (

        .address(pc),
        .instruction(instruction)

    );


    // =====================================================
    // 3. INSTRUCTION DECODER
    // =====================================================

    instruction_decoder decoder (

        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)

    );


    // =====================================================
    // 4. CONTROL UNIT
    // =====================================================

    control_unit control (

        .opcode(opcode),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_control(alu_control)

    );


    // =====================================================
    // 5. REGISTER FILE
    // =====================================================

    register_file registers (

        .clk(clk),
        .reset(reset),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .write_data(write_back_data),
        .reg_write(reg_write),

        .read_data1(read_data1),
        .read_data2(read_data2)

    );


    // =====================================================
    // 6. IMMEDIATE GENERATOR
    // =====================================================

    immediate_generator imm_gen (

        .instruction(instruction),
        .immediate(immediate)

    );


    // =====================================================
    // 7. ALU INPUT MUX
    //
    // alu_src = 0 → Register Data 2
    // alu_src = 1 → Immediate
    // =====================================================

    assign alu_input_b =
        (alu_src) ? immediate : read_data2;


    // =====================================================
    // 8. ALU
    // =====================================================

    alu alu_unit (

        .a(read_data1),
        .b(alu_input_b),

        .alu_control(alu_control),

        .result(alu_result),
        .zero(zero)

    );


    // =====================================================
    // 9. DATA MEMORY
    // =====================================================

    data_memory dmem (

        .clk(clk),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(alu_result),

        .write_data(read_data2),

        .read_data(memory_read_data)

    );


    // =====================================================
    // 10. WRITE BACK MUX
    //
    // mem_to_reg = 0 → ALU Result
    // mem_to_reg = 1 → Memory Data
    // =====================================================

    assign write_back_data =
        (mem_to_reg) ? memory_read_data : alu_result;


    // =====================================================
    // 11. BRANCH LOGIC
    // =====================================================

    branch_logic branch_unit (

        .branch(branch),
        .funct3(funct3),

        .a(read_data1),
        .b(read_data2),

        .branch_taken(branch_taken)

    );


    // =====================================================
    // 12. PC NEXT LOGIC
    // =====================================================

    pc_next_logic pc_logic (

        .pc(pc),
        .immediate(immediate),

        .branch_taken(branch_taken),

        .next_pc(next_pc)

    );


endmodule