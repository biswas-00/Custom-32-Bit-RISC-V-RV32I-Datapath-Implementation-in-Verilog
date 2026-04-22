module control_unit (
    input  wire [6:0] opcode,
    
    // Control Signals
    output reg        RegWrite,  // 1 if we are writing a result to a register
    output reg  [2:0] ImmSrc,    // Tells imm_gen how to unscramble the immediate
    output reg        ALUSrc,    // 0 = ALU reads rs2, 1 = ALU reads immediate
    output reg        MemWrite,  // 1 if we are saving data to RAM
    output reg  [1:0] ResultSrc, // 00 = ALU result, 01 = RAM data, 10 = PC+4
    output reg        Branch,    // 1 if this is a branch instruction (e.g., BEQ)
    output reg  [1:0] ALUOp,     // 2-bit code telling the ALU Decoder what math to do
    output reg        Jump       // 1 if this is a jump instruction (e.g., JAL)
);

    // RISC-V Standard Base Opcodes
    localparam OPCODE_LOAD  = 7'b0000011; // lw
    localparam OPCODE_STORE = 7'b0100011; // sw
    localparam OPCODE_ITYPE = 7'b0010011; // addi, slti, etc.
    localparam OPCODE_RTYPE = 7'b0110011; // add, sub, and, or
    localparam OPCODE_BTYPE = 7'b1100011; // beq, bne
    localparam OPCODE_JAL   = 7'b1101111; // jal

    always @(*) begin
        // 1. Default Assignments (Crucial to prevent inferred latches!)
        RegWrite  = 1'b0;
        ImmSrc    = 3'b000;
        ALUSrc    = 1'b0;
        MemWrite  = 1'b0;
        ResultSrc = 2'b00;
        Branch    = 1'b0;
        ALUOp     = 2'b00;
        Jump      = 1'b0;

        // 2. Opcode Decoding
        case (opcode)
            OPCODE_RTYPE: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            
            OPCODE_ITYPE: begin // This handles 'addi' instructions!
                RegWrite = 1'b1;
                ImmSrc   = 3'b000; // I-Type unscrambling
                ALUSrc   = 1'b1;   // Force ALU to read the immediate, not rs2
                ALUOp    = 2'b10;
            end
            
            OPCODE_LOAD: begin
                RegWrite  = 1'b1;
                ImmSrc    = 3'b000;
                ALUSrc    = 1'b1;
                ResultSrc = 2'b01; // Route memory data back to the register
                ALUOp     = 2'b00; // Force ALU to Add (Base + Offset)
            end
            
            OPCODE_STORE: begin
                ImmSrc   = 3'b001; // S-Type unscrambling
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;  // Force ALU to Add (Base + Offset)
            end
            
            OPCODE_BTYPE: begin
                ImmSrc = 3'b010; // B-Type unscrambling
                Branch = 1'b1;
                ALUOp  = 2'b01;  // Force ALU to Subtract (for comparison)
            end
            
            OPCODE_JAL: begin
                RegWrite  = 1'b1;
                ImmSrc    = 3'b100; // J-Type unscrambling
                ResultSrc = 2'b10;  // Save the return address (PC+4)
                Jump      = 1'b1;
            end
            
            default: ; // Do nothing, keep defaults
        endcase
    end

endmodule