`timescale 1ns/1ps

module riscv32_pipeline(clk, reset);
    input logic clk, reset;

    logic [31:0] pc_in;
    logic [31:0] pc_out;
    logic [31:0] PCPlus4F;
    logic [31:0] PCTargetE;
    logic [31:0] instruction;

    logic [2:0] state;

    logic [6:0] opcode;
    logic [4:0] rdD, rdE, rdM, rdW;
    logic [4:0] Rs1D, Rs1E;
    logic [4:0] Rs2D, Rs2E;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] immD, immE;

    logic [31:0] RD1D, RD1E;
    logic [31:0] RD2D, RD2E;

    logic [31:0] SrcAE, SrcBE;
    logic [31:0] WriteDataE, WriteDataM;

    logic [31:0] ALUResultE, ALUResultM;

    logic [31:0] ResultW;


    logic zero, negative, carryout, overflow;
    // control signals
    logic RegWriteD, RegWriteE, RegWriteM, RegWriteW;

    // hazard signals
    logic StallF, StallD;
    logic FlushD, FlushE;
    logic ForwardAE, ForwardBE;


    // output signals
    logic result_out;
    logic [31:0] registers [31:0];
    logic [31:0] reg_10;

    localparam pc_increment = 32'h00000004;

    // datapath
    pc      pc0 (.clk, .reset, .pc_in, .pc_out, .state);
    adder   pc_adder0 (.A(pc_out), .B(pc_increment), .out(PCPlus4F));
    mux2_1  pc_mux (.out(pc_in), .i0(PCPlus4F), .i1(PCTargetE), .sel());
    memory #(.is_instruction(1)) instr_mem0 (.clk, .A(pc_out), .WD(32'bx), .MemWrite(1'b0), .RD(instruction));
    D_Reg   D_Reg0 (.clk, .reset(reset | FlushD), .EN(StallD), .instrF, .PCF, .PCPlus4F, .instrD(instruction), .PCD, .PCPlus4D);
    instr_decoder decoder0 (.instruction, .opcode, .rd(rdD), .rs1(Rs1D), .rs2(Rs2D), .funct3, .funct7, .imm);
    register_file reg_file0 (.clk, .A1(Rs1D), .A2(Rs2D), .A3(RdW), .WD3(ResultW), .WE3(RegWriteW), .RD1(RD1D), .RD2(RD2D), .result_out, .registers, .reg_10);
    E_Reg   E_Reg0 (.clk, .reset(FlushE), .RD1D, .RD2D, .PCD, .Rs1D, .Rs2D, .immD, .PCPlus4D, .RD1E, .RD2E, .PCE, .Rs1E, .Rs2E, .RdE, .immE, .PCPlus4E,
                .RegWriteD, .ResultSrcD, .MemWriteD, .JumpD, .BranchD, .ALUControlD, .ALUSrcD, .RegWriteE, .ResultSrcE, .MemWriteE,
                .JumpE, .BranchE, .ALUControlE, .ALUSrcE);
    mux4_1  scra_forward_mux (.out(SrcAE), .i0(RD1E), .i1(ResultW), .i2(ALUResultM), .i3(32'bx), .sel(ForwardAE));
    mux4_1  srcb_forward_mux (.out(WriteDataE), .i0(RD2E), .i1(ResultW), .i2(ALUResultM), .i3(32'bx), .sel(ForwardBE)); 
    mux2_1  srcb_mux (.out(SrcBE), .i0(WriteDataE), .i1(immE), .sel(ALUSrcE));
    adder   pc_imm_adder (.A(PCE), .B(immE), .out(PCTargetE));
    alu alu0 (.srca(SrcAE), .srcb(SrcBE), .alu_op(ALUControlE), .result(ALUResultE), .zero, .negative, .carryout, .overflow);
    M_Reg M_Reg0 (.clk, .reset, .RegWriteE, .ResultSrcE, .MemWriteE, .RegWriteM, .ResultSrcM, .MemWriteM, 
              .ALUResultE, .WriteDataE, .RdE, .PCPlus4E, .ALUResultM, .WriteDataM, .RdM, .PCPlus4M);


    // control


endmodule