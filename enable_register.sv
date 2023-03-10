`timescale 1ns / 1ps

module enable_register (clk, reset, EN, in, out);
    input logic clk;
    input logic reset;
    input logic EN;
    input logic [31:0] in;
    output logic [31:0] out;

    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 0;
        end else if (EN) begin
            out <= in;
        end else begin
            out <= out;
        end
    end
endmodule