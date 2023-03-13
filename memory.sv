`timescale 1ns/1ps

module memory #(parameter is_instruction = 0) (clk, reset, A, WD, MemWrite, RD); // , mem0, mem1, mem2, mem3
    input logic clk, reset;
    input logic [31:0] A; // 32-bit address
    input logic [31:0] WD;
    input logic MemWrite;
    output logic [31:0] RD;

    localparam mem_size = 4096;
    localparam zero_byte = 8'b0;
    
    reg [7:0] mem [0:(mem_size/4 - 1)]; // LSByte

    initial begin
        if (is_instruction == 1) begin
            $readmemh("test.mem", mem);
        end else begin
            $readmemh("data.mem", mem);
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (!reset && MemWrite) begin
            mem[A] <= WD[31:24];
            mem[A+1] <= WD[23:16];
            mem[A+2] <= WD[15:8];
            mem[A+3] <= WD[7:0];
        end
    end

    always_comb begin
        if (reset) begin
            RD = {zero_byte, zero_byte, zero_byte, zero_byte};
        end else begin
            RD = {mem[A], mem[A+1], mem[A+2], mem[A+3]};
        end
    end
endmodule