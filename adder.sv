`timescale 1ns / 1ps

module adder(A, B, out);
    input logic     [31:0] A;
    input logic     [31:0] B;
    output logic    [31:0] out;

    always_comb begin
        out = A + B;
    end
endmodule

