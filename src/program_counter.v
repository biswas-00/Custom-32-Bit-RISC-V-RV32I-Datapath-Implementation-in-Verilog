module program_counter #(
    parameter RESET_VECTOR = 32'h0000_0000 // Configurable boot address
)(
    input  wire        clk,
    input  wire        rst_n,      // Active-low reset (standard practice)
    input  wire        stall,      // Halts the PC when high
    output reg  [31:0] pc
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= RESET_VECTOR;
        end else if (!stall) begin
            pc <= pc + 32'd4;      // RISC-V instructions are 4 bytes long
        end
        // If stall is high, pc keeps its current value implicitly
    end

endmodule