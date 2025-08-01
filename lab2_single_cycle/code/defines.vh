// Annotate this macro before synthesis
// `define RUN_TRACE

// rf_wsel
`define RF_WSEL_ALU       2'b00
`define RF_WSEL_DRAM      2'b01
`define RF_WSEL_EXT       2'b10
`define RF_WSEL_PC        2'b11

// rf_we
`define RF_WE_DISABLE     1'b0
`define RF_WE_ENABLE      1'b1

// sext_op
`define SEXT_OP_I          3'b000
`define SEXT_OP_S          3'b001
`define SEXT_OP_B          3'b010
`define SEXT_OP_U          3'b011
`define SEXT_OP_J          3'b100
`define SEXT_OP_SHIFT      3'b101

// alu_op
`define ALU_OP_ADD            4'b0000
`define ALU_OP_SUB            4'b0001
`define ALU_OP_AND            4'b0010
`define ALU_OP_OR             4'b0011
`define ALU_OP_XOR            4'b0100
`define ALU_OP_SLL            4'b0101
`define ALU_OP_SRL            4'b0110
`define ALU_OP_SRA            4'b0111
`define ALU_OP_BEQ            4'b1000
`define ALU_OP_BNE            4'b1001
`define ALU_OP_BLT            4'b1010
`define ALU_OP_BGE            4'b1011

// npc_op
`define NPC_OP_PC4    2'b00
`define NPC_OP_BTYPE  2'b01
`define NPC_OP_JAL    2'b10
`define NPC_OP_ALU    2'b11

// alub_sel
`define ALUB_SEL_RD2       1'b0
`define ALUB_SEL_EXT       1'b1

// ram_we
`define RAM_WE_WRITE          1'b1
`define RAM_WE_READ           1'b0

// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG      32'hFFFF_F000
`define PERI_ADDR_LED      32'hFFFF_F060
`define PERI_ADDR_SW       32'hFFFF_F070
`define PERI_ADDR_BTN      32'hFFFF_F078
`define PERI_ADDR_TIMER_WR 32'hFFFF_F020
`define PERI_ADDR_TIMER_W  32'hFFFF_F024