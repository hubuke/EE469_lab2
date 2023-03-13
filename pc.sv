`timescale 1ns/1ps

module pc #(reset_pc = 32'h00000000) (clk, reset, pc_in, pc_out);
    input logic clk, reset;
    input logic [31:0] pc_in;
    output logic [31:0] pc_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            pc_out <= reset_pc;
        end else begin
            pc_out <= pc_in;
        end
    end
endmodule

// module pc_tb();
//     logic clk, reset;
//     logic [31:0] pc_in;
//     logic [31:0] pc_out;
//     logic [2:0] state;

//     parameter CLOCK_PERIOD = 10;

//     initial begin
//         clk <= 0;
//         forever #(CLOCK_PERIOD/2) clk <= ~clk;//toggle the clock indefinitely
//     end

//     pc dut (.clk(clk), .reset(reset), .pc_in(pc_in), .pc_out(pc_out), .state(state));

//     initial begin
//         reset = 1; @(posedge clk);
//         reset = 0; @(posedge clk);
//         for (int i = 0; i < 1000; i++) begin
//             pc_in = $random; @(posedge clk);
//         end
//         $stop;
//     end
// endmodule