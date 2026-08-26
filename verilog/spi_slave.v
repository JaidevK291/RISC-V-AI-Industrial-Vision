module system_top (

    input clk,
    input reset,

    // ============================================
    // CAMERA INPUT INTERFACE
    // ============================================

    input vsync,
    input href,
    input [7:0] camera_data,

    // Start image processing
    input start_processing,


    // ============================================
    // UART OUTPUT
    // ============================================

    output uart_tx,


    // ============================================
    // DEBUG OUTPUTS
    // ============================================

    output edge_detected,
    output defect_detected

);


    // =====================================================
    // IMAGE INSPECTION SIGNALS
    // =====================================================

    wire image_edge_detected;
    wire image_defect_detected;

    wire [31:0] image_status_data;


    // =====================================================
    // IMAGE INSPECTION SUBSYSTEM
    // =====================================================

    image_inspection_subsystem image_system (

        .clk(clk),
        .reset(reset),

        // Camera interface
        .vsync(vsync),
        .href(href),
        .camera_data(camera_data),

        // Processing control
        .start_processing(start_processing),

        // Detection results
        .edge_detected(image_edge_detected),
        .defect_detected(image_defect_detected),

        // Status register interface
        .status_read_enable(1'b1),
        .status_data(image_status_data)

    );


    // =====================================================
    // RISC-V TO UART SIGNALS
    // =====================================================

    wire [31:0] uart_address;
    wire [31:0] uart_write_data;
    wire        uart_mem_write;


    // =====================================================
    // RISC-V CORE
    // =====================================================

    // IMPORTANT:
    // This must match the module name inside riscv_core.v

    riscv_core_uart cpu (

        .clk(clk),
        .reset(reset),

        // Defect information from image system
        .defect_detected(image_defect_detected),

        // UART MMIO signals
        .uart_address(uart_address),
        .uart_write_data(uart_write_data),
        .uart_mem_write(uart_mem_write)

    );


    // =====================================================
    // UART PERIPHERAL
    // =====================================================

    uart_peripheral uart0 (

        .clk(clk),
        .reset(reset),

        // Processor interface
        .address(uart_address),
        .write_data(uart_write_data),
        .mem_write(uart_mem_write),

        // Serial output
        .uart_tx(uart_tx)

    );


    // =====================================================
    // DEBUG OUTPUT CONNECTIONS
    // =====================================================

    assign edge_detected   = image_edge_detected;
    assign defect_detected = image_defect_detected;


endmodule