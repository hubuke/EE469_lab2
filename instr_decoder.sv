`timescale 1ns/1ps

module instr_decoder (instruction, opcode, rd, rs1, rs2, funct3, funct7, imm);
    input logic [31:0] instruction;
    output logic [6:0] opcode;
    output logic [4:0] rd;
    output logic [4:0] rs1;
    output logic [4:0] rs2;
    output logic [2:0] funct3;
    output logic [6:0] funct7;
    output logic [31:0] imm;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    get_imm imm0 (.instruction(instruction), .imm(imm));
endmodule