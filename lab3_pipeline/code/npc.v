`include "defines.vh"

module npc (
    input wire         op_i,       // 控制信号
    input wire  [31:0] pc_i,
    input wire  [31:0] j_pc_i,     // 跳转地址
    output wire [31:0] pc4_o,
    output wire [31:0] npc_o
);

    assign pc4_o = pc_i + 32'd4; 
    assign npc_o = op_i ? j_pc_i : pc_i + 32'd4;

endmodule