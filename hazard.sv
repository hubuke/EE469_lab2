`timescale 1ns/1ps

module hazard (Rs1D, Rs2D, RdE, Rs1E, Rs2E, PCSrcE, ResultSrcE, RdM, RegWriteM, RdW, RegWriteW, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);
    input logic [4:0] Rs1D, Rs2D, RdE, Rs1E, Rs2E, RdM, RdW;
    input logic PCSrcE, RegWriteM, RegWriteW;
    input logic [1:0] ResultSrcE;

    output logic StallF, StallD, FlushD, FlushE;

    output logic [1:0] ForwardAE, ForwardBE;

    logic lwStall;

    always_comb begin
        StallF = 0;
        StallD = 0;
        FlushD = 0;
        FlushE = 0;
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;

        if (RegWriteM && (Rs1E == RdM) && (Rs1E != 0)) begin
            ForwardAE = 2'b10;
        end else if (RegWriteW && (Rs1E == RdW) && (Rs1E != 0)) begin
            ForwardAE = 2'b01;
        end else begin
            ForwardAE = 2'b00;
        end

        if (RegWriteM && (Rs2E == RdM) && (Rs2E != 0)) begin
            ForwardBE = 2'b10;
        end else if (RegWriteW && (Rs2E == RdW) && (Rs2E != 0)) begin
            ForwardBE = 2'b01;
        end else begin
            ForwardBE = 2'b00;
        end

        lwStall = (ResultSrcE == 2'b10) & ((Rs1D == RdE) | (Rs2D == RdE));
        StallF = lwStall;
        StallD = lwStall;

        FlushD = PCSrcE;
        FlushE = lwStall | PCSrcE;
    end

endmodule