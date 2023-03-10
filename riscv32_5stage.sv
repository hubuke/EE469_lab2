`timescale 1ns/1ps

module riscv32_5stage(clk, reset);
    input logic clk, reset;

    logic [31:0] pc_in;
    logic [31:0] pc_out;
    logic [31:0] pc_plus_4;
    logic [31:0] target_address;
    logic [31:0] instruction;

    logic [2:0] state;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] imm;

    localparam pc_increment = 32'h00000004;

    // datapath
    pc pc0 (.clk, .reset, .pc_in, .pc_out, .state);
    pc_adder pc_adder0 (.A(pc_out), .B(pc_increment), .out(pc_plus_4));
    mux2_1 pc_mux (.out(pc_in), .i0(pc_plus_4), .i1(target_address), .sel());
    memory #(.is_instruction(1)) instr_mem0 (.clk, .A(pc_out), .WD(32'bx), .MemWrite(1'b0), .RD(instruction));
    instr_decoder decoder0 (.instruction, .opcode, .rd, .rs1, .rs2, .funct3, .funct7, .imm);

    alu alu0 (.srca, .srcb, .alu_op, .result, .zero, .negative, .carryout, .overflow);

    // control


endmodule