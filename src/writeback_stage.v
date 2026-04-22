module writeback_stage (
    // Control Signal from the Control Unit
    input  wire [1:0]  ResultSrc,
    
    // Datapath Inputs (The potential answers)
    input  wire [31:0] ALUResult,   // Answer from the Execute Stage
    input  wire [31:0] ReadData,    // Answer from the Memory Stage
    
    // The Final Output
    output reg  [31:0] Result       // This gets wired all the way back to Decode!
);

    // The Final Multiplexer
    always @(*) begin
        case (ResultSrc)
            2'b00: Result = ALUResult; // Math instruction
            2'b01: Result = ReadData;  // Load instruction
            2'b10: Result = 32'd0;     // Placeholder for PC+4 (Jump return addresses)
            default: Result = 32'd0;
        endcase
    end

endmodule