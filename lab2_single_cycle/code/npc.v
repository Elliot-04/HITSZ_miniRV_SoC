`include "defines.vh"

module npc (
    input wire  [1:0]  op_i,       // 控制信号
    input wire  [31:0] pc_i,
    input wire         br_i,       // 分支指令是否需要跳转
    input wire  [31:0] j_pc_i,     // JALR指令跳转地址
    input wire  [31:0] offset_i,   // JAL指令偏移量
    output wire [31:0] pc4_o,
    output reg  [31:0] npc_o
);

    assign pc4_o = pc_i + 32'd4; 

    always @ (*) begin
        case (op_i)
            `NPC_OP_PC4:   npc_o = pc_i + 32'd4;                       
            `NPC_OP_BTYPE: npc_o = br_i ? (pc_i + offset_i) : (pc_i + 32'd4); 
            `NPC_OP_JAL:   npc_o = pc_i + offset_i;                      
            `NPC_OP_ALU:   npc_o = j_pc_i;                       
            default:       npc_o = pc_i + 32'd4;
        endcase
    end

endmodule