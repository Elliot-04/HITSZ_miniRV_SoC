`include "defines.vh"

module sext (
    input wire [24:0] inst_i,       // inst[31:7]
    input wire [2:0]  op_i,         // 控制扩展方式
    output reg [31:0] imm_o         // 扩展后的立即数
);
    
    always @(*) begin
        case (op_i)
            `SEXT_OP_B: imm_o = inst_i[24]? {20'hFFFFF,inst_i[0],inst_i[23:18],inst_i[4:1],1'b0} : {20'h00000,inst_i[0],inst_i[23:18],inst_i[4:1],1'b0};
            `SEXT_OP_I: imm_o = inst_i[24]? {20'hFFFFF,inst_i[24:13]} : {20'h00000,inst_i[24:13]};       
            `SEXT_OP_SHIFT: imm_o = {27'd0,inst_i[17:13]};        
            `SEXT_OP_U: imm_o = {inst_i[24:5],12'h000};    
            `SEXT_OP_J: imm_o = inst_i[24]? {12'hFFF,inst_i[12:5],inst_i[13],inst_i[23:14],1'b0} : {12'h000,inst_i[12:5],inst_i[13],inst_i[23:14],1'b0};
            `SEXT_OP_S: imm_o = inst_i[24]? {20'hFFFFF,inst_i[24:18],inst_i[4:0]} : {20'h00000,inst_i[24:18],inst_i[4:0]};  
            default: imm_o =32'h00000000;
        endcase
    end

endmodule