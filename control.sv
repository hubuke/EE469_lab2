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

module control(opcode, funct3, funct7, RegWrite, MemWrite, PCsel);
    input logic [6:0] opcode;
    input logic [2:0] funct3;

    output logic RegWrite;
    output logic MemWrite;

endmodule

