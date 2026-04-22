module register_file (
    input  wire        clk,
    
    // Read Port 1
    input  wire [4:0]  ra1, // Read Address 1 (driven by rs1)
    output wire [31:0] rd1, // Read Data 1
    
    // Read Port 2
    input  wire [4:0]  ra2, // Read Address 2 (driven by rs2)
    output wire [31:0] rd2, // Read Data 2
    
    // Write Port (Driven later by the Writeback Stage)
    input  wire        we3, // Write Enable
    input  wire [4:0]  wa3, // Write Address (driven by rd)
    input  wire [31:0] wd3  // Write Data
);

    // Create 32 registers, each 32 bits wide
    reg [31:0] registers [31:0];

    // Initialize all registers to 0 (useful for simulation)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'd0;
        end
    end

    // Asynchronous Reads
    // If address is 0, force output to 0. Otherwise, read the array.
    assign rd1 = (ra1 != 5'd0) ? registers[ra1] : 32'd0;
    assign rd2 = (ra2 != 5'd0) ? registers[ra2] : 32'd0;

    // Synchronous Write
    always @(posedge clk) begin
        // Only write if Write Enable is high AND we are not trying to write to x0
        if (we3 && wa3 != 5'd0) begin
            registers[wa3] <= wd3;
        end
    end

endmodule