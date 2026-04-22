module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire       funct7_5, // Need bit 5 of funct7 to tell ADD from SUB
    
    output reg  [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // Force Addition (Load/Store)
            2'b01: ALUControl = 3'b001; // Force Subtraction (Branching)
            2'b10: begin // R-Type or I-Type Math
                case (funct3)
                    3'b000: begin
                        // If it's an R-type SUB, funct7_5 is 1. Otherwise, it's ADD.
                        if (funct7_5) ALUControl = 3'b001; // SUB
                        else          ALUControl = 3'b000; // ADD
                    end
                    3'b010: ALUControl = 3'b101; // SLT (Set Less Than)
                    3'b110: ALUControl = 3'b011; // OR
                    3'b111: ALUControl = 3'b010; // AND
                    default: ALUControl = 3'b000;
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end

endmodule