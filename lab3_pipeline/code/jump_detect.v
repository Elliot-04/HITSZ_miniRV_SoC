`include "defines.vh"

module jump_detect (
    input wire [2 :0] br_i,       // 跳转指令类型
    input wire        br_f_i,     // 是否跳转标志
    input wire [31:0] pc_i,
    input wire [31:0] imm_i,
    input wire [31:0] aluc_i,
    output reg        npc_op_o,
    output reg [31:0] j_pc_o
);

    always @(*) begin
        if (br_i[2] & br_f_i)          npc_op_o = 1'b1;      // B型指令 & 跳转
        else if (br_i[2] & !br_f_i)    npc_op_o = 1'b0;      // B型指令 & 不跳转
        else if (br_i[1])              npc_op_o = 1'b1;      // JAL
        else if (br_i[0])              npc_op_o = 1'b1;      // JALR
        else                           npc_op_o = 1'b0; 
    end

    always @(*) begin
        if (br_i[2] & br_f_i)      j_pc_o = pc_i + imm_i;      // B型指令 & 跳转
        else if (br_i[1])          j_pc_o = pc_i + imm_i;      // JAL
        else if (br_i[0])          j_pc_o = aluc_i;          // JALR
        else                       j_pc_o = pc_i + 32'd4;
    end
    
endmodule