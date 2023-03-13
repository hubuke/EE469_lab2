`timescale 1ns / 1ps

module top(CLK100MHZ, SW, LED);
    input   logic               CLK100MHZ;
    input   logic [15:0]        SW;
    output  logic [15:0]        LED;

    logic         [31:0]        divided_clocks, reg_10;
    logic                       result_out;
    logic         [31:0]        pc_out;

    parameter i = 5;

    clock_divider clk_divider (.clock(CLK100MHZ), .reset(SW[15]), .divided_clocks(divided_clocks));

    riscv32_pipeline cpu (.clk(divided_clocks[i]), .reset(SW[0]), .result_out(result_out), .reg_10);

    assign LED[0] = result_out;
    assign LED[1] = divided_clocks[i];

    assign LED[15:12] = reg_10[3:0]; // 4 LSBs of reg_10
    assign LED[11:8] = pc_out[7:4]; // 4 MSBs of reg_10
    assign LED[7:6] = pc_out[3:2]; // 4 LSBs of pc_out
endmodule