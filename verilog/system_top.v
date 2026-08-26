module system_top (

    input clk,
    input reset,

    // Camera interface
    input vsync,
    input href,
    input [7:0] camera_data,

    // Processing control
    input start_processing,

    // UART output
    output uart_tx,

    // Debug outputs
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

        .vsync(vsync),
        .href(href),
        .camera_data(camera_data),

        .start_processing(start_processing),

        .edge_detected(image_edge_detected),
        .defect_detected(image_defect_detected),

        .status_read_enable(1'b1),
        .status_data(image_status_data)

    );


    // =====================================================
    // CPU TO UART SIGNALS
    // =====================================================

    wire [31:0] uart_address;
    wire [31:0] uart_write_data;
    wire uart_mem_write;


    // =====================================================
    // RISC-V CORE
    // =====================================================

    riscv_core cpu (

        .clk(clk),
        .reset(reset),

        .defect_detected(image_defect_detected),

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

        .address(uart_address),
        .write_data(uart_write_data),
        .mem_write(uart_mem_write),

        .uart_tx(uart_tx)

    );


    // =====================================================
    // DEBUG OUTPUTS
    // =====================================================

    assign edge_detected   = image_edge_detected;
    assign defect_detected = image_defect_detected;


endmodule