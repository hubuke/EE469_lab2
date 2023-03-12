`timescale 1ns/1ps

module M_Reg (clk, reset, RegWriteE, ResultSrcE, MemWriteE, RegWriteM, ResultSrcM, MemWriteM, 
              ALUResultE, WriteDataE, RdE, PCPlus4E, ALUResultM, WriteDataM, RdM, PCPlus4M);
    input logic clk, reset;
    input logic RegWriteE, MemWriteE;
    input logic [1:0] ResultSrcE;
    input logic [31:0] ALUResultE, WriteDataE, PCPlus4E;
    input logic [4:0] RdE;

    output logic RegWriteM, MemWriteM;
    output logic [1:0] ResultSrcM;
    output logic [31:0] ALUResultM, WriteDataM, PCPlus4M;
    output logic [4:0] RdM;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWriteM <= 0;
            ResultSrcM <= 0;
            MemWriteM <= 0;
            ALUResultM <= 0;
            WriteDataM <= 0;
            RdM <= 0;
            PCPlus4M <= 0;
        end else begin
            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            PCPlus4M <= PCPlus4E;
        end
    end
endmodule