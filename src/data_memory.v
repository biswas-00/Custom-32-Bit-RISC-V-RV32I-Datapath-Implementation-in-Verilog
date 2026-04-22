module data_memory #(
    parameter RAM_DEPTH = 256 // Number of 32-bit words
)(
    input  wire        clk,
    input  wire        we,       // Write Enable (driven by MemWrite control signal)
    input  wire [31:0] a,        // Address (driven by ALUResult)
    input  wire [31:0] wd,       // Write Data (driven by rd2 from the register file)
    output wire [31:0] rd        // Read Data (going back to registers on a Load)
);

    // The actual RAM array
    reg [31:0] RAM [0:RAM_DEPTH-1];

    // Initialize all RAM to 0 for clean simulation
    integer i;
    initial begin
        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            RAM[i] = 32'd0;
        end
    end

    // Asynchronous Read (Instantly output data at the given address)
    // We use a[31:2] to convert byte addresses (0, 4, 8) to word indices (0, 1, 2)
    assign rd = RAM[a[31:2]];

    // Synchronous Write (Only save data on the clock edge if Write Enable is high)
    always @(posedge clk) begin
        if (we) begin
            RAM[a[31:2]] <= wd;
        end
    end

endmodule