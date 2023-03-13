`timescale 1ns/1ps

module W_Reg (clk, reset, RegWriteM, ResultSrcM, RegWriteW, ResultSrcW, ALUResultM, 
              ReadDataM, RdM, PCPlus4M, ALUResultW, ReadDataW, RdW, PCPlus4W, PCTargetM, PCTargetW);
    input logic clk, reset;
    input logic RegWriteM;
    input logic [1:0] ResultSrcM;
    input logic [31:0] ALUResultM, ReadDataM, PCPlus4M, PCTargetM;
    input logic [4:0] RdM;

    output logic RegWriteW;
    output logic [1:0] ResultSrcW;
    output logic [31:0] ALUResultW, ReadDataW, PCPlus4W, PCTargetW;
    output logic [4:0] RdW;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWriteW <= 0;
            ResultSrcW <= 0;
            ALUResultW <= 0;
            ReadDataW <= 0;
            RdW <= 0;
            PCPlus4W <= 0;
            PCTargetW <= 0;
        end else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
            RdW <= RdM;
            PCPlus4W <= PCPlus4M;
            PCTargetW <= PCTargetM;
        end
    end
endmodule