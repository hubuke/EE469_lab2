`timescale 1ns/1ps

module riscv32_pipeline(clk, reset, result_out, reg_10);
    input logic clk, reset;

    logic [31:0] pc_in;
    logic [31:0] PCF, PCD, PCE;
    logic [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
    logic [31:0] PCTargetE, PCTargetM, PCTargetW;
    logic [31:0] instrF, instrD;

    logic [6:0] opcode;
    logic [4:0] RdD, RdE, RdM, RdW;
    logic [4:0] Rs1D, Rs1E;
    logic [4:0] Rs2D, Rs2E;
    logic [2:0] funct3D, funct3E;
    logic [6:0] funct7D, funct7E;
    logic [31:0] immD, immE;

    logic [31:0] RD1D, RD1E;
    logic [31:0] RD2D, RD2E;

    logic [31:0] SrcAE, SrcBE;
    logic [31:0] WriteDataE, WriteDataM;

    logic [31:0] ALUResultE, ALUResultM, ALUResultW;

    logic [31:0] ResultM, ResultW;

    logic [31:0] ReadDataM, ReadDataW;

    logic [31:0] targetA;
    logic jump_or_notE;


    logic zero, negative, carryout, overflow;
    // control signals
    logic RegWriteD, RegWriteE, RegWriteM, RegWriteW;
    logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
    logic MemWriteD, MemWriteE, MemWriteM;
    logic JumpD, JumpE;
    logic BranchD, BranchE;
    logic [3:0] ALUControlD, ALUControlE;
    logic ALUSrcD, ALUSrcE;
    logic targetA_selD, targetA_selE;

    // hazard signals
    logic StallF, StallD;
    logic FlushD, FlushE;
    logic [1:0] ForwardAE, ForwardBE;


    // output signals
    output logic result_out;
    logic [31:0] registers [31:0];
    output logic [31:0] reg_10;

    localparam pc_increment = 32'h00000004;

    // datapath
    pc      pc0 (.clk, .reset, .pc_in, .pc_out(PCF), .EN(StallF));
    adder   pc_adder0 (.A(PCF), .B(pc_increment), .out(PCPlus4F));
    jump_or_not jump_or_not0 (.zero, .negative, .overflow, .carry(carryout), .JumpE, .BranchE, .funct3E, .jump_or_notE);
    mux2_1  pc_mux (.out(pc_in), .i0(PCPlus4F), .i1(PCTargetE), .sel(jump_or_notE));

    memory #(.is_instruction(1)) instr_mem0 (.clk, .A(PCF), .WD(32'bx), .MemWrite(1'b0), .RD(instrF));
    D_Reg   D_Reg0 (.clk, .reset(reset | FlushD), .EN(StallD), .instrF, .PCF, .PCPlus4F, .instrD, .PCD, .PCPlus4D);
    instr_decoder decoder0 (.instruction(instrD), .opcode, .rd(RdD), .rs1(Rs1D), .rs2(Rs2D), .funct3(funct3D), .funct7(funct7D), .imm(immD));
    register_file reg_file0 (.clk, .A1(Rs1D), .A2(Rs2D), .A3(RdW), .WD3(ResultW), .WE3(RegWriteW), .RD1(RD1D), .RD2(RD2D), .result_out, .registers, .reg_10);
    E_Reg   E_Reg0 (.clk, .reset(reset | FlushE), .RD1D, .RD2D, .PCD, .Rs1D, .Rs2D, .immD, .PCPlus4D, .RD1E, .RD2E, .PCE, .Rs1E, .Rs2E, .RdD, .RdE, .immE, .PCPlus4E,
                .RegWriteD, .ResultSrcD, .MemWriteD, .JumpD, .BranchD, .ALUControlD, .ALUSrcD, .RegWriteE, .ResultSrcE, .MemWriteE,
                .JumpE, .BranchE, .ALUControlE, .ALUSrcE, .funct3D, .funct3E, .targetA_selD, .targetA_selE);
    mux4_1  scra_forward_mux (.out(SrcAE), .i0(RD1E), .i1(ResultW), .i2(ResultM), .i3(32'bx), .sel(ForwardAE));
    mux4_1  srcb_forward_mux (.out(WriteDataE), .i0(RD2E), .i1(ResultW), .i2(ResultM), .i3(32'bx), .sel(ForwardBE));
    mux2_1  srcb_mux (.out(SrcBE), .i0(WriteDataE), .i1(immE), .sel(ALUSrcE));
    mux2_1  pce_mux (.out(targetA), .i0(PCE), .i1(SrcAE), .sel(targetA_selE));
    adder   pc_imm_adder (.A(targetA), .B(immE), .out(PCTargetE));
    alu alu0 (.srca(SrcAE), .srcb(SrcBE), .alu_op(ALUControlE), .result(ALUResultE), .zero, .negative, .carryout, .overflow);
    M_Reg M_Reg0 (.clk, .reset, .RegWriteE, .ResultSrcE, .MemWriteE, .RegWriteM, .ResultSrcM, .MemWriteM,
              .ALUResultE, .WriteDataE, .RdE, .PCPlus4E, .ALUResultM, .WriteDataM, .RdM, .PCPlus4M, .PCTargetE, .PCTargetM);

    mux4_1 result_mux_M (.out(ResultM), .i0(ALUResultM), .i1(32'bx), .i2(PCPlus4M), .i3(PCTargetM), .sel(ResultSrcM));

    memory #(.is_instruction(0)) data_mem0 (.clk, .A(ALUResultM), .WD(WriteDataM), .MemWrite(MemWriteM), .RD(ReadDataM));
    W_Reg W_Reg0 (.clk, .reset, .RegWriteM, .ResultSrcM, .RegWriteW, .ResultSrcW, .ALUResultM,
                .ReadDataM, .RdM, .PCPlus4M, .ALUResultW, .ReadDataW, .RdW, .PCPlus4W, .PCTargetM, .PCTargetW);

    mux4_1 result_mux (.out(ResultW), .i0(ALUResultW), .i1(ReadDataW), .i2(PCPlus4W), .i3(PCTargetW), .sel(ResultSrcW));

    // control
    control control0 (.opcode(opcode), .funct3(funct3D), .funct7(funct7D), .RegWriteD, .ResultSrcD, .MemWriteD, .JumpD, .BranchD, .ALUControlD, .ALUSrcD, .targetA_sel(targetA_selD));

    // hazard detection
    hazard hazard0 (.Rs1D, .Rs2D, .RdE, .Rs1E, .Rs2E, .PCSrcE(jump_or_notE), .ResultSrcE, .RdM, .RegWriteM, .RdW, .RegWriteW, .StallF, .StallD,
                    .FlushD, .FlushE, .ForwardAE, .ForwardBE);

endmodule

`timescale 1ns / 1ps

module rv32_tb ();
    logic clk, reset;

    parameter CLOCK_PERIOD = 20;
    // clock
    initial begin
        clk <= 0;
        forever begin
            #(CLOCK_PERIOD) clk <= ~clk;
        end
    end

    riscv32_pipeline dut (clk, reset);

    initial begin
        reset <=1; @(posedge clk);
        reset <=0; @(posedge clk);
        reset <=0; @(posedge clk);

        for (int i = 0; i < 10000; i = i + 1) @(posedge clk);
        $stop;
    end


endmodule