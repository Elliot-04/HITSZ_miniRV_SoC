`timescale 1ns / 1ps
`include "defines.vh"

module alu (   
    input wire  [31:0] A_i,
    input wire  [31:0] B_i,   
    input wire  [31:0] imm_i,                  // SEXT扩展后的立即数
    input wire         alub_sel_i,             // 选择ALUB端口的数据来源
    input wire  [3:0]  op_i,                   // 根据指令类型选择ALU运算方式
    output reg  [31:0] C_o,
    output reg         br_f_o                  // 分支指令是否需要跳转的标志位
);

    wire [4:0]  shamt = B[4:0];
    wire [31:0] A = A_i;
    wire [31:0] B = alub_sel_i ? imm_i : B_i;

    always @(*) begin
        case (op_i)
            `ALU_OP_ADD: C_o = A + B;
            `ALU_OP_SUB: C_o = A + (~B) + 1;
            `ALU_OP_AND: C_o = A & B;
            `ALU_OP_OR:  C_o = A | B;
            `ALU_OP_XOR: C_o = A ^ B;
            `ALU_OP_SRA: C_o = $signed(A) >>> shamt;
            `ALU_OP_SLL: C_o = A << shamt;
            `ALU_OP_SRL: C_o = A >> shamt;
            `ALU_OP_BNE: br_f_o = (A != B) ? 1'b1 : 1'b0;
            `ALU_OP_BEQ: br_f_o = (A == B) ? 1'b1 : 1'b0;
            `ALU_OP_BGE: begin
                C_o = A + (~B) + 1;
                br_f_o = (~C_o[31]) ? 1'b1 : 1'b0;
            end
            `ALU_OP_BLT: begin
                C_o = A + (~B) + 1;
                br_f_o = (C_o[31]) ? 1'b1 : 1'b0;
            end
            default: C_o = 32'd0;
        endcase
    end 

endmodule