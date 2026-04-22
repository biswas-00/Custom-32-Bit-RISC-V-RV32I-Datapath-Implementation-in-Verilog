module memory_stage (
    input  wire        clk,
    
    // Control Signals from Decode Stage
    input  wire        MemWrite,
    
    // Datapath Inputs from Execute Stage
    input  wire [31:0] ALUResult,   // The calculated memory address
    input  wire [31:0] WriteData,   // The data we want to save (rd2)
    input  wire [4:0]  rd_in,       // Destination register (passed through)
    
    // Outputs to the Writeback Stage
    output wire [31:0] ReadData,    // The data we just read from RAM
    output wire [31:0] ALUResult_out, // Passed through for R-type/I-type math
    output wire [4:0]  rd_out       // Passed through
);

    // 1. Pass-through assignments
    assign ALUResult_out = ALUResult;
    assign rd_out        = rd_in;

    // 2. Instantiate the Data Memory
    data_memory #(
        .RAM_DEPTH(256)
    ) dmem (
        .clk(clk),
        .we(MemWrite),
        .a(ALUResult),
        .wd(WriteData),
        .rd(ReadData)
    );

endmodule