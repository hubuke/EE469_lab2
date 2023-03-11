`timescale 1ns/1ps

module riscv32_pipeline(clk, reset);
    input logic clk, reset;

    logic [31:0] pc_in;
    logic [31:0] pc_out;
    logic [31:0] PCPlus4F;
    logic [31:0] target_address;
    logic [31:0] instruction;

    logic [2:0] state;

    logic [6:0] opcode;
    logic [4:0] rdD, rdE, rdM, rdW;
    logic [4:0] rs1D, rs1E;
    logic [4:0] rs2D, rs2E;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] immD, immE;

    logic [31:0] RD1D, RD1E;
    logic [31:0] RD2D, RD2E;

    logic [31:0] ResultW;

    logic StallF, StallD;

    logic RegWriteD, RegWriteE, RegWriteM, RegWriteW;

    
    logic result_out;
    logic [31:0] registers [31:0];
    logic [31:0] reg_10;

    localparam pc_increment = 32'h00000004;

    // datapath
    pc pc0 (.clk, .reset, .pc_in, .pc_out, .state);
    pc_adder pc_adder0 (.A(pc_out), .B(pc_increment), .out(PCPlus4F));
    mux2_1 pc_mux (.out(pc_in), .i0(PCPlus4F), .i1(target_address), .sel());
    memory #(.is_instruction(1)) instr_mem0 (.clk, .A(pc_out), .WD(32'bx), .MemWrite(1'b0), .RD(instruction));
    ID ID0 (.clk, .reset(reset | FlushID), .EN(StallD), .instrF, .PCF, .PCPlus4F, .instrD(instruction), .PCD, .PCPlus4D);
    instr_decoder decoder0 (.instruction, .opcode, .rd(rdD), .rs1(rs1D), .rs2(rs2d), .funct3, .funct7, .imm);
    register_file reg_file0 (.clk, .A1(rs1D), .A2(rs2D), .A3(RdW), .WD3(ResultW), .WE3(RegWriteW), .RD1(RD1D), .RD2(RD2D), .result_out, .registers, .reg_10);
    


    alu alu0 (.srca, .srcb, .alu_op, .result, .zero, .negative, .carryout, .overflow);

    // control


endmodule