module fetch_stage #(
    parameter BOOT_ADDR = 32'h0000_0000,
    parameter ROM_FILE  = "imem.hex"
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    output wire [31:0] current_pc,
    output wire [31:0] fetched_instruction
);

    // Instantiate the Program Counter
    program_counter #(
        .RESET_VECTOR(BOOT_ADDR)
    ) pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .pc(current_pc)
    );

    // Instantiate the Instruction ROM
    // CHANGE IT TO LOOK EXACTLY LIKE THIS:
    instruction_rom rom_inst (
        .pc_addr(current_pc),
        .instruction(fetched_instruction)
    );

endmodule