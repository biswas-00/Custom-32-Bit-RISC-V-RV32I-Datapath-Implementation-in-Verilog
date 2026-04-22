module execute_stage (
    // Inputs from Decode Stage
    input  wire [31:0] rd1,
    input  wire [31:0] rd2,
    input  wire [31:0] immediate,
    input  wire [4:0]  rd_in,       // Destination register (passed through)
    
    // Control Signals from Decode Stage
    input  wire        ALUSrc,
    input  wire [1:0]  ALUOp,
    input  wire [2:0]  funct3,
    input  wire        funct7_5,    // Bit 30 of the raw instruction
    
    // Outputs to Memory/Writeback Stage
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData,   // This is just rd2, passed along for Store instructions
    output wire [4:0]  rd_out,      // Passed through
    output wire        Zero
);

    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [2:0]  ALUControl;

    // 1. Datapath Routing
    assign SrcA = rd1;
    // ALUSrc Multiplexer: If ALUSrc is 1, use Immediate. If 0, use rd2.
    assign SrcB = ALUSrc ? immediate : rd2; 
    
    // Pass rd2 directly to the output for Store instructions (e.g., sw)
    assign WriteData = rd2;
    // Pass destination register down the pipeline
    assign rd_out = rd_in;

    // 2. Instantiate ALU Decoder
    alu_control alu_ctrl_inst (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUControl(ALUControl)
    );

    // 3. Instantiate the ALU
    alu alu_inst (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

endmodule