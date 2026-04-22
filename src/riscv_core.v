module riscv_core (
    input  wire       clk,
    input  wire       rst_n,
    output wire [5:0] leds   // NEW: Physical output for your board's LEDs
);

    // =========================================================================
    // INTERNAL WIRES (The Assembly Line Belts)
    // =========================================================================
    
    // 1. Fetch -> Decode
    wire [31:0] pc_F;
    wire [31:0] instr_F;
    
    // 2. Decode -> Execute
    wire [31:0] rd1_D;
    wire [31:0] rd2_D;
    wire [31:0] imm_D;
    wire [4:0]  rd_D;
    wire [2:0]  funct3_D;
    wire [6:0]  funct7_D;
    
    // Control Wires routing from Decode to later stages
    wire        ALUSrc_D;
    wire        MemWrite_D;
    wire [1:0]  ResultSrc_D;
    wire [1:0]  ALUOp_D;
    wire        Branch_D; // Reserved for future Branch logic
    wire        Jump_D;   // Reserved for future Jump logic

    // 3. Execute -> Memory
    wire [31:0] ALUResult_E;
    wire [31:0] WriteData_E;
    wire [4:0]  rd_E;
    wire        Zero_E;   // Reserved for future Branch logic

    // 4. Memory -> Writeback
    wire [31:0] ReadData_M;
    wire [31:0] ALUResult_M;
    wire [4:0]  rd_M;

    // 5. Writeback -> Decode (THE FEEDBACK LOOP)
    wire [31:0] Result_W; 
    // Notice how rd_M and Result_W will be routed back into the Decode stage below!

    // =========================================================================
    // HARDWARE INSTANTIATION (Plugging the machines in)
    // =========================================================================

    // Stage 1: Fetch
    fetch_stage fetch_inst (
        .clk(clk),
        .rst_n(rst_n),
        .stall(1'b0),          // Tied to 0 for linear execution
        .current_pc(pc_F),
        .fetched_instruction(instr_F)
    );

    // Stage 2: Decode
    decode_stage decode_inst (
        .clk(clk),
        .instruction(instr_F),
        
        // The Writeback Feedback Loop inputs
        .Result_W(Result_W),   // Final answer coming from Stage 5
        .WriteReg_W(rd_M),     // Destination register coming from Stage 4
        .RegWrite_W(1'b1),     // Hardwired to 1 for this test, controlled by a pipeline register in advanced designs
        
        // Datapath Outputs
        .rd1(rd1_D),
        .rd2(rd2_D),
        .immediate(imm_D),
        .rd(rd_D),
        .funct3(funct3_D),
        .funct7(funct7_D),
        
        // Control Signals
        .ALUSrc(ALUSrc_D),
        .MemWrite(MemWrite_D),
        .ResultSrc(ResultSrc_D),
        .Branch(Branch_D),
        .ALUOp(ALUOp_D),
        .Jump(Jump_D)
    );

    // Stage 3: Execute
    execute_stage execute_inst (
        .rd1(rd1_D),
        .rd2(rd2_D),
        .immediate(imm_D),
        .rd_in(rd_D),
        
        .ALUSrc(ALUSrc_D),
        .ALUOp(ALUOp_D),
        .funct3(funct3_D),
        .funct7_5(funct7_D[5]), // Pass specifically bit 5 of funct7
        
        .ALUResult(ALUResult_E),
        .WriteData(WriteData_E),
        .rd_out(rd_E),
        .Zero(Zero_E)
    );

    // Stage 4: Memory
    memory_stage memory_inst (
        .clk(clk),
        .MemWrite(MemWrite_D), // Passed from Decode
        .ALUResult(ALUResult_E),
        .WriteData(WriteData_E),
        .rd_in(rd_E),
        
        .ReadData(ReadData_M),
        .ALUResult_out(ALUResult_M),
        .rd_out(rd_M)
    );

    // Stage 5: Writeback
    writeback_stage writeback_inst (
        .ResultSrc(ResultSrc_D), // Passed from Decode
        .ALUResult(ALUResult_M), 
        .ReadData(ReadData_M),
        .Result(Result_W)        // Loops back up to Decode Stage!
    );
    // =========================================================
    // THE LED LATCH (6-Bit Hardware Camera)
    // =========================================================
    reg [5:0] led_latch;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led_latch <= 6'b000000; // Reset all 6 to OFF
        end else if (MemWrite_D) begin
            led_latch <= rd2_D[5:0]; // Grab the bottom 6 bits!
        end
    end
    
    assign leds = led_latch;

endmodule