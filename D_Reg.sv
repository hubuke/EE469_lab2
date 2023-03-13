`timescale 1ns/1ps

module D_Reg(clk, reset, EN, instrF, PCF, PCPlus4F, instrD, PCD, PCPlus4D);
    input logic clk, reset, EN;
    input logic [31:0] instrF, PCF, PCPlus4F;
    output logic [31:0] instrD, PCD, PCPlus4D;

    always_ff @(posedge clk) begin
        if(reset) begin
            instrD <= 32'h00000000;
            PCD <= 32'h00000000;
            PCPlus4D <= 32'h00000000;
        end 
        else if(!EN) begin
            instrD <= instrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end 
        else begin
            instrD <= instrD;
            PCD <= PCD;
            PCPlus4D <= PCPlus4D;
        end
    end
endmodule