`timescale 1ns / 1ps
`include "defines.vh"

// 注：仅实现了理想流水线，无法使用TRACE进行测试
module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata
);

    //控制信号
    wire        npc_op;
    wire        id_rf_we, ex_rf_we, mem_rf_we, wb_rf_we;
    wire [1 :0] id_rf_wsel, ex_rf_wsel, mem_rf_wsel;
    wire [2 :0] sext_op;
    wire [3 :0] id_alu_op, ex_alu_op;
    wire        id_alub_sel, ex_alub_sel;
    wire        id_ram_we, ex_ram_we, mem_ram_we;
    wire [2 :0] id_br, ex_br;

    //数据信号
    wire [31:0] if_pc, id_pc, ex_pc;
    wire [31:0] if_pc4, id_pc4, ex_pc4;
    wire [31:0] npc;
    wire [31:0] j_pc;
    wire [31:0] id_inst;
    wire [31:0] id_imm, ex_imm, mem_imm;
    wire [31:0] wD, ex_wD, mem_wD, wb_wD;
    wire [4 :0] ex_wR, mem_wR, wb_wR;
    wire [31:0] id_rD1, ex_rD1;
    wire [31:0] id_rD2, ex_rD2, mem_rD2;
    wire br_f;
    wire [31:0] ex_aluc, mem_aluc;
   
    assign inst_addr = if_pc[15:2];

    npc u_npc (
        // input
        .op_i(npc_op),       
        .pc_i(if_pc),
        .j_pc_i(j_pc),
        // output
        .pc4_o(if_pc4),
        .npc_o(npc)
    );

    pc u_pc (
        // input
        .rst_i(cpu_rst),
        .clk_i(cpu_clk),
        .din_i(npc),
        // output
        .pc_o(if_pc)
    );

    reg_if_id u_reg_if_id (
        //input
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),
        .pc_i(if_pc),
        .pc4_i(if_pc4),
        .inst_i(inst),
        //output
        .pc_o(id_pc),
        .pc4_o(id_pc4),
        .inst_o(id_inst)
    );

    sext u_sext (
        //input
        .inst_i(id_inst[31:7]),      
        .op_i(sext_op),   
        //output
        .imm_o(id_imm)
    );

    rf u_rf (
        //input
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),
        .rR1_i(id_inst[19:15]),       
        .rR2_i(id_inst[24:20]),
        .wR_i(wb_wR),
        .wD_i(wb_wD),
        .we_i(wb_rf_we),      
        //output
        .rD1_o(id_rD1),
        .rD2_o(id_rD2)
    );

    control u_control (
        //input
        .inst_i(id_inst),
        //output
        .br_o(id_br),
        .rf_we_o(id_rf_we),
        .rf_wsel_o(id_rf_wsel),
        .sext_op_o(sext_op),
        .alu_op_o(id_alu_op),
        .alub_sel_o(id_alub_sel),
        .ram_we_o(id_ram_we)
    );

    reg_id_ex u_reg_id_ex (
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),  
        //数据信号
        .rD1_i(id_rD1),
        .rD2_i(id_rD2),
        .wR_i(id_inst[11:7]),
        .pc_i(id_pc),
        .pc4_i(id_pc4),
        .imm_i(id_imm),
        .rD1_o(ex_rD1),
        .rD2_o(ex_rD2),
        .wR_o(ex_wR),
        .pc_o(ex_pc),
        .pc4_o(ex_pc4),
        .imm_o(ex_imm),
        //控制信号
        .rf_wsel_i(id_rf_wsel),
        .br_i(id_br),
        .rf_we_i(id_rf_we),
        .alu_op_i(id_alu_op),
        .alub_sel_i(id_alub_sel),
        .ram_we_i(id_ram_we),
        .rf_wsel_o(ex_rf_wsel),
        .br_o(ex_br),
        .rf_we_o(ex_rf_we),
        .alu_op_o(ex_alu_op),
        .alub_sel_o(ex_alub_sel),
        .ram_we_o(ex_ram_we)
    );

    alu u_alu (
        //input
        .alub_sel_i(ex_alub_sel),
        .op_i(ex_alu_op),
        .A_i(ex_rD1),
        .B_i(ex_rD2),  
        .imm_i(ex_imm),
        //output
        .C_o(ex_aluc),
        .br_f_o(br_f)         
    );

    jump_detect u_jump_detect (
        //input
        .br_i(ex_br),   
        .br_f_i(br_f),
        .pc_i(ex_pc),
        .imm_i(ex_imm),
        .aluc_i(ex_aluc),
        //output
        .npc_op_o(npc_op),
        .j_pc_o(j_pc)
    );

    wD_ex_mux u_wD_ex_mux (
        //input
        .aluc_i(ex_aluc),       
        .sext_i(ex_imm),
        .pc4_i(ex_pc4),
        .rf_wsel_i(ex_rf_wsel),
        //output
        .wD_o(ex_wD)
    );

    reg_ex_mem u_reg_ex_mem (
        //input
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),  
        .wD_i(ex_wD),
        .wR_i(ex_wR),
        .rD2_i(ex_rD2),
        .aluc_i(ex_aluc),
        .rf_wsel_i(ex_rf_wsel),
        .rf_we_i(ex_rf_we),
        .ram_we_i(ex_ram_we),
        //output
        .wD_o(mem_wD),
        .wR_o(mem_wR),
        .rD2_o(mem_rD2),
        .aluc_o(mem_aluc),
        .rf_wsel_o(mem_rf_wsel),
        .rf_we_o(mem_rf_we),
        .ram_we_o(mem_ram_we)
    );

    wD_mem_mux u_wD_mem_mux (
        //input
        .wD_i(mem_wD),       
        .dram_i(Bus_rdata),
        .rf_wsel_i(mem_rf_wsel),
        //output
        .wD_o(wD)
    );

    reg_mem_wb u_reg_mem_wb (
        //input
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),
        .wR_i(mem_wR),
        .wD_i(wD),
        .rf_we_i(mem_rf_we),
        //output
        .wR_o(wb_wR),
        .wD_o(wb_wD),
        .rf_we_o(wb_rf_we)
    );

    assign Bus_addr = mem_aluc;
    assign Bus_wdata = mem_rD2;
    assign Bus_we = mem_ram_we;

endmodule