module imm_gen (
    input  wire [31:0] inst,
    input  wire [2:0]  imm_src,
    output reg  [31:0] imm
);

    always @(*) begin
        case (imm_src)
            // I-Type (e.g., addi, lw): Top 12 bits of instruction
            3'b000: imm = {{20{inst[31]}}, inst[31:20]};                             
            
            // S-Type (e.g., sw): Split between top 7 and lower 5
            3'b001: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};                 
            
            // B-Type (e.g., beq): Scrambled, with an implicit 0 at the end
            3'b010: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};  
            
            // U-Type (e.g., lui): Top 20 bits, padded with 12 zeros at the bottom
            3'b011: imm = {inst[31:12], 12'b0};                                      
            
            // J-Type (e.g., jal): Scrambled 20-bit jump address
            3'b100: imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            
            // Default catch-all
            default: imm = 32'b0;
        endcase
    end

endmodule