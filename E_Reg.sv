`timescale 1ns/1ps

module E_Reg (clk, reset, RD1D, RD2D, PCD, Rs1D, Rs2D, immD, PCPlus4D, RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, immE, PCPlus4E,
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, RegWriteE, ResultSrcE, MemWriteE, 
                JumpE, BranchE, ALUControlE, ALUSrcE, funct3D, funct3E);

    input logic clk, reset;
    input logic [31:0] RD1D, RD2D, PCD, immD, PCPlus4D;
    input logic [4:0] Rs1D, Rs2D;
    output logic [31:0] RD1E, RD2E, PCE, immE, PCPlus4E;
    output logic [4:0] Rs1E, Rs2E, RdE;
    input logic [2:0] funct3D;
    output logic [2:0] funct3E;

    input logic RegWriteD, MemWriteD, JumpD, BranchD;
    input logic [1:0] ResultSrcD;
    input logic [3:0] ALUControlD;
    input logic ALUSrcD;

    output logic RegWriteE, MemWriteE, JumpE, BranchE;
    output logic [1:0] ResultSrcE;
    output logic [3:0] ALUControlE;
    output logic ALUSrcE;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            immE <= 0;
            PCPlus4E <= 0;
            RegWriteE <= 0;
            ResultSrcE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUControlE <= 0;
            ALUSrcE <= 0;
            funct3E <= 0;
        end
        else begin
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= Rs2D;
            immE <= immD;
            PCPlus4E <= PCPlus4D;
            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            funct3E <= funct3D;
        end
    end

endmodule