`timescale 1ns / 1ps
`include "defines.vh"

module control (
    input wire [31:0] inst_i,           // 输入指令
    input wire        br_f_i,           // 分支指令是否需要跳转的标志位
    output reg [1:0]  npc_op_o,         // 控制NPC产生指令地址
    output reg [1:0]  rf_wsel_o,        // 控制RF写入数据的来源
    output reg [2:0]  sext_op_o,        // 控制SEXT符号扩展方式
    output reg        ram_we_o,         // 控制DRAM的读写操作
    output reg [3:0]  alu_op_o,         // 控制ALU的运算类型
    output reg        rf_we_o,          // 控制RF写使能
    output reg        alub_sel_o        // 控制ALU输入端B的数据来源
);

    wire [6:0] opcode = inst_i [6:0];
    wire [2:0] func3  = inst_i [14:12];
    wire [6:0] func7  = inst_i [31:25];

    // rf_we_o
    always @(*) begin
        case (opcode)
            7'b1100011:  rf_we_o = `RF_WE_DISABLE;        // B型
            7'b0100011:  rf_we_o = `RF_WE_DISABLE;        // SW
            default:     rf_we_o = `RF_WE_ENABLE;
        endcase
    end

    // ram_we_o
    always @(*) begin
        if (opcode == 7'b0100011) begin     // SW
            ram_we_o = `RAM_WE_WRITE;
        end else begin
            ram_we_o = `RAM_WE_READ;
        end
    end

    // sext_op_o
    always @(*) begin
        case (opcode)
            7'b0010011: begin       // I型
                case (func3)
                    3'b000:  sext_op_o = `SEXT_OP_I;      // ADDI
                    3'b111:  sext_op_o = `SEXT_OP_I;      // ANDI
                    3'b110:  sext_op_o = `SEXT_OP_I;      // ORI
                    3'b100:  sext_op_o = `SEXT_OP_I;      // XORI
                    3'b010:  sext_op_o = `SEXT_OP_I;      // SLTI
                    3'b001:  sext_op_o = `SEXT_OP_SHIFT;  // SLLI
                    3'b101:  sext_op_o = `SEXT_OP_SHIFT;  // SRLI/SRAI
                    default: sext_op_o = `SEXT_OP_I;
                endcase
            end
            7'b0000011:  sext_op_o = `SEXT_OP_I;         // LW
            7'b1100111:  sext_op_o = `SEXT_OP_I;         // JALR
            7'b0100011:  sext_op_o = `SEXT_OP_S;         // SW
            7'b1100011:  sext_op_o = `SEXT_OP_B;         // B型
            7'b0110111:  sext_op_o = `SEXT_OP_U;         // U型
            7'b1101111:  sext_op_o = `SEXT_OP_J;         // J型
            default:     sext_op_o = `SEXT_OP_I;
        endcase
    end

    // alu_op_o
    always @(*) begin
        case (opcode)
            7'b0110011:      // R型
                case (func3)
                    3'b000:  alu_op_o = (func7 == 7'b00000000)? `ALU_OP_ADD : `ALU_OP_SUB;  // ADD/SUB
                    3'b111:  alu_op_o = `ALU_OP_AND;                                        // AND
                    3'b110:  alu_op_o = `ALU_OP_OR;                                         // OR       
                    3'b100:  alu_op_o = `ALU_OP_XOR;                                        // XOR        
                    3'b001:  alu_op_o = `ALU_OP_SLL;                                        // SLL    
                    3'b101:  alu_op_o = (func7 == 7'b00000000)? `ALU_OP_SRL : `ALU_OP_SRA;  // SRL/SRA
                    default: alu_op_o = `ALU_OP_ADD;                                   
                endcase

            7'b0010011:      // I型
                case (func3)
                    3'b000:  alu_op_o = `ALU_OP_ADD;                                        // ADDI
                    3'b111:  alu_op_o = `ALU_OP_AND;                                        // ANDI
                    3'b110:  alu_op_o = `ALU_OP_OR;                                         // ORI
                    3'b100:  alu_op_o = `ALU_OP_XOR;                                        // XORI 
                    3'b001:  alu_op_o = `ALU_OP_SLL;                                        // SLLI
                    3'b101:  alu_op_o = (func7 == 7'b00000000)? `ALU_OP_SRL : `ALU_OP_SRA;  // SRLI/SRAI
                    default: alu_op_o = `ALU_OP_ADD;
                endcase  

            7'b0000011:  alu_op_o = `ALU_OP_ADD;    // LW
            7'b1100111:  alu_op_o = `ALU_OP_ADD;    // JALR
            7'b0100011:  alu_op_o = `ALU_OP_ADD;    // SW

            7'b1100011:      // B型
                case (func3)
                    3'b000:  alu_op_o = `ALU_OP_BEQ;       // BEQ
                    3'b001:  alu_op_o = `ALU_OP_BNE;       // BNE
                    3'b100:  alu_op_o = `ALU_OP_BLT;       // BLT
                    3'b101:  alu_op_o = `ALU_OP_BGE;       // BGE
                    default: alu_op_o = `ALU_OP_ADD;
                endcase
            default: alu_op_o = `ALU_OP_ADD;
        endcase
    end

    // npc_op_o
    always @(*) begin
        case (opcode)
            7'b0110011:  npc_op_o = `NPC_OP_PC4;                      // R型
            7'b0010011:  npc_op_o = `NPC_OP_PC4;                      // I型
            7'b0000011:  npc_op_o = `NPC_OP_PC4;                      // LW
            7'b1100111:  npc_op_o = `NPC_OP_ALU;                      // JALR
            7'b0100011:  npc_op_o = `NPC_OP_PC4;                      // SW
            7'b1100011:  npc_op_o = br_f_i ? `NPC_OP_BTYPE : `NPC_OP_PC4;  // B型
            7'b0110111:  npc_op_o = `NPC_OP_PC4;                      // U型
            7'b1101111:  npc_op_o = `NPC_OP_JAL;                      // J型
            default:     npc_op_o = `NPC_OP_PC4;
        endcase
    end

    // rf_wsel_o
    always @(*) begin
        case (opcode)
            7'b0110011:  rf_wsel_o = `RF_WSEL_ALU;      // R型
            7'b0010011:  rf_wsel_o = `RF_WSEL_ALU;      // I型
            7'b0000011:  rf_wsel_o = `RF_WSEL_DRAM;     // LW
            7'b1100111:  rf_wsel_o = `RF_WSEL_PC;       // JALR
            7'b0110111:  rf_wsel_o = `RF_WSEL_EXT;      // U型
            7'b1101111:  rf_wsel_o = `RF_WSEL_PC;       // J型
            default:     rf_wsel_o = `RF_WSEL_PC;
        endcase
    end

    // alub_sel_o
    always @(*) begin
        case (opcode)
            7'b0110011:  alub_sel_o = `ALUB_SEL_RD2;      // R型
            7'b0010011:  alub_sel_o = `ALUB_SEL_EXT;      // I型
            7'b0000011:  alub_sel_o = `ALUB_SEL_EXT;      // LW
            7'b1100111:  alub_sel_o = `ALUB_SEL_EXT;      // JALR
            7'b0100011:  alub_sel_o = `ALUB_SEL_EXT;      // SW
            7'b1100011:  alub_sel_o = `ALUB_SEL_RD2;      // B型
            default:     alub_sel_o = `ALUB_SEL_RD2;
        endcase
    end

endmodule