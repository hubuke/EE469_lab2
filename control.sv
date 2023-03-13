`timescale 1ns/1ps

// define all macros for rv32i instructions
`define LUI 7'b0110111
`define AUIPC 7'b0010111
`define JAL 7'b1101111
`define JALR 7'b1100111
`define BRANCH 7'b1100011
`define LOAD 7'b0000011
`define STORE 7'b0100011
`define OP_IMM 7'b0010011
`define OP 7'b0110011

module control (opcode, funct3, funct7, RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, targetA_sel);
    input logic [6:0] opcode;
    input logic [2:0] funct3;
    input logic [6:0] funct7;

    output logic RegWriteD;
    output logic [1:0] ResultSrcD;
    output logic MemWriteD;
    output logic JumpD;
    output logic BranchD;
    output logic [3:0] ALUControlD;
    output logic ALUSrcD;
    output logic targetA_sel;

    always_comb begin
        RegWriteD = 1'b0;
        ResultSrcD = 2'bx;
        MemWriteD = 1'b0;
        JumpD = 1'b0;
        BranchD = 1'b0;
        ALUControlD = 4'b0000;
        ALUSrcD = 1'b0;
        targetA_sel = 1'b0;

        case (opcode)
            `LUI: begin
                RegWriteD = 1'b1;
                ALUSrcD = 1'b1;
                ResultSrcD = 2'b00;
                ALUControlD = 4'b0111; // result = srcb
            end
            `AUIPC: begin // rd <= pc + imm
                RegWriteD = 1'b1;
                ResultSrcD = 2'b11; // PCTargetW
            end
            `JAL: begin // rd <= pc + 4; pc <= pc + imm
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10; // pc+4
                JumpD = 1'b1;
            end
            `JALR: begin // rd <= pc + 4; pc <= (rs1 + imm)
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                targetA_sel = 1'b1; // rs1
                JumpD = 1'b1;
            end
            `BRANCH: begin
                BranchD = 1'b1;
                case (funct3)
                    3'b000: ALUControlD = 4'b0001; // beq, branch if zero == 1
                    3'b001: ALUControlD = 4'b0001; // bne, branch if zero == 0
                    3'b100: ALUControlD = 4'b0001; // blt, branch if negative == 1
                    3'b101: ALUControlD = 4'b0001; // bge, branch if negative == 0
                    3'b110: ALUControlD = 4'b1010; // bltu
                    3'b111: ALUControlD = 4'b1010; // bgeu
                    default: ALUControlD = 4'b0000; 
                endcase
            end
            `LOAD: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b01;
                ALUSrcD = 1'b1;
                ALUControlD = 4'b0000;
            end
            `STORE: begin
                ALUSrcD = 1'b1;
                MemWriteD = 1'b1;
                ALUControlD = 4'b0000;
            end
            `OP_IMM: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                ALUSrcD = 1'b1;
                case (funct3)
                    3'b000: ALUControlD = 4'b0000; // addi
                    3'b010: ALUControlD = 4'b1011; // slti
                    3'b011: ALUControlD = 4'b1010; // sltiu
                    3'b100: ALUControlD = 4'b0100; // xori
                    3'b110: ALUControlD = 4'b0011; // ori
                    3'b111: ALUControlD = 4'b0010; // andi
                    3'b001: ALUControlD = 4'b0101; // slli
                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            ALUControlD = 4'b0110; // srli
                        end else begin
                            ALUControlD = 4'b1001; // srai
                        end
                    end

                    default: ALUControlD = 4'b0000;
                endcase
            end
            `OP: begin
                RegWriteD = 1'b1;
                ALUSrcD = 1'b0;
                ResultSrcD = 2'b00;
                case (funct3)
                    3'b000: ALUControlD = 4'b0000; // add
                    3'b010: ALUControlD = 4'b1011; // slt
                    3'b011: ALUControlD = 4'b1010; // sltu
                    3'b100: ALUControlD = 4'b0100; // xor
                    3'b110: ALUControlD = 4'b0011; // or
                    3'b111: ALUControlD = 4'b0010; // and
                    3'b001: ALUControlD = 4'b0101; // sll
                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            ALUControlD = 4'b0110; // srl
                        end else begin
                            ALUControlD = 4'b1001; // sra
                        end
                    end
                    default: ALUControlD = 4'b0000;
                endcase
            end
            default: begin
                RegWriteD = 1'b0;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUControlD = 4'b0000;
                ALUSrcD = 1'b0;
            end
        endcase
    end
endmodule

