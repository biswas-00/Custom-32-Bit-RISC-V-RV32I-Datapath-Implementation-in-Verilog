module instruction_rom #(
    parameter MEM_DEPTH = 256         // Number of 32-bit words
)(
    input  wire [31:0] pc_addr,
    output wire [31:0] instruction
);

    // Declare a 2D array: MEM_DEPTH words, each 32 bits wide
    reg [31:0] memory [0:MEM_DEPTH-1];

    // Initialize memory block directly into silicon
    initial begin
        // Hardwiring the '40 + 20 = 60 (111100)' program
        memory[0] = 32'h02800093; // addi x1, x0, 40
        memory[1] = 32'h01400113; // addi x2, x0, 20
        memory[2] = 32'h002081B3; // add x3, x1, x2
        memory[3] = 32'h00000013; // nop
        memory[4] = 32'h00302223; // sw x3, 4(x0)
        
        memory[5] = 32'h00000000;
        memory[6] = 32'h00000000;
    end
    // Asynchronous read for standard single-cycle fetch logic
    // Using pc_addr[31:2] to convert byte address to word index
    assign instruction = memory[pc_addr[31:2]];

endmodule
