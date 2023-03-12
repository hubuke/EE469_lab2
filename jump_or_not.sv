`timescale 1ns/1ps

module jump_or_not (zero, negative, overflow, carry, JumpE, BranchE, funct3E, jump_or_notE);
    input logic zero, negative, overflow, carry, JumpE, BranchE, funct3E;
    output logic jump_or_notE;

    always_comb begin
        jump_or_notE = 1'b0;
        if (JumpE) begin
            jump_or_notE = 1'b1;
        end
        else if (BranchE) begin
            case (funct3E)
                3'b000: jump_or_notE = zero; // beq
                3'b001: jump_or_notE = !zero; // bne
                3'b100: jump_or_notE = negative; // blt
                3'b101: jump_or_notE = !negative; // bge
                3'b110: jump_or_notE = negative; // bltu
                3'b111: jump_or_notE = !negative; // bgeu
                default: jump_or_notE = 1'b0;
            endcase
        end
        else begin
            jump_or_notE = 1'b0;
        end
    end
endmodule