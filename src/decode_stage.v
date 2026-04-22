module decode_stage (
    input  wire        clk,
    input  wire [31:0] instruction,
    
    // Writeback Inputs (Data coming back from the end of the pipeline)
    input  wire [31:0] Result_W,    // The final data to save
    input  wire [4:0]  WriteReg_W,  // Which register to save it to
    input  wire        RegWrite_W,  // Write Enable signal
    
    // Datapath Outputs (Going to the Execute/ALU Stage)
    output wire [31:0] rd1,         // Register Data 1
    output wire [31:0] rd2,         // Register Data 2
    output wire [31:0] immediate,   // Unscrambled Immediate
    output wire [4:0]  rd,          // Destination Register Address
    output wire [2:0]  funct3,
    output wire [6:0]  funct7,
    
    // Generated Control Signals
    output wire        ALUSrc,
    output wire        MemWrite,
    output wire [1:0]  ResultSrc,
    output wire        Branch,
    output wire [1:0]  ALUOp,
    output wire        Jump
);

    // Internal wires
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] imm_src_wire;
    wire       RegWrite_Ctrl; // We generate this, but pass it down the pipeline

    // 1. Basic Instruction Slicing
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // 2. The Brain: Control Unit
    control_unit main_ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite_Ctrl),
        .ImmSrc(imm_src_wire),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .Jump(Jump)
    );

    // 3. The Decoder Ring: Immediate Generator
    imm_gen immediate_generator (
        .inst(instruction),
        .imm_src(imm_src_wire),
        .imm(immediate)
    );

    // 4. The Scratchpad: Register File
    register_file reg_file_inst (
        .clk(clk),
        .ra1(rs1),          // Read Address 1
        .rd1(rd1),          // Read Data 1 out
        .ra2(rs2),          // Read Address 2
        .rd2(rd2),          // Read Data 2 out
        .we3(RegWrite_Ctrl),   // Write Enable (from Writeback)
        .wa3(WriteReg_W),   // Write Address (from Writeback)
        .wd3(Result_W)      // Write Data (from Writeback)
    );

endmodule