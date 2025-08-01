`timescale 1ns / 1ps
`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // 数据信号
    wire [31:0] pc;
    wire [31:0] npc; 
    wire [31:0] imm;
    wire [31:0] pc4;
    wire [31:0] rD1,rD2;
    wire [31:0] aluc;
    wire [31:0] wD;
    wire bf;

    // 控制信号
    wire [1 :0] npc_op;
    wire        rf_we;
    wire [1 :0] rf_wsel;
    wire [2 :0] sext_op;
    wire [3 :0] alu_op;
    wire        alub_sel;
    wire        ram_we;
   
`ifdef RUN_TRACE
    assign inst_addr = pc[15:0];
`else
    assign inst_addr = pc[15:2];
`endif

    pc u_pc(
        // input
        .rst_i(cpu_rst),
        .clk_i(cpu_clk),
        .din_i(npc),
        // output
        .pc_o(pc)
    );

    npc u_npc(
        // input
        .op_i(npc_op),       
        .pc_i(pc),
        .br_i(bf),
        .j_pc_i(aluc),
        .offset_i(imm),
        // output
        .pc4_o(pc4),
        .npc_o(npc)
    );

    sext u_sext(
        // input
        .inst_i(inst[31:7]),      
        .op_i(sext_op),   
        // output
        .imm_o(imm)
    );

    rf u_rf(
        // input
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),
        .rR1_i(inst[19:15]),       
        .rR2_i(inst[24:20]),
        .wR_i(inst[11:7]),
        .aluc_i(aluc),       
        .dram_i(Bus_rdata),
        .imm_i(imm),
        .pc4_i(pc4),
        .rf_wsel_i(rf_wsel),
        .we_i(rf_we),      
        // output
        .rD1_o(rD1),
        .rD2_o(rD2)
`ifdef RUN_TRACE
        ,
        .wD(wD)
`endif
    );

    alu u_alu(
        // input
        .alub_sel_i(alub_sel),
        .op_i(alu_op),
        .A_i(rD1),
        .B_i(rD2),  
        .imm_i(imm),
        // output
        .C_o(aluc),
        .br_f_o(bf)        
    );

    control u_control(
        // input
        .inst_i(inst),
        .br_f_i(bf),
        // output
        .npc_op_o(npc_op),
        .rf_we_o(rf_we),
        .rf_wsel_o(rf_wsel),
        .sext_op_o(sext_op),
        .alu_op_o(alu_op),
        .alub_sel_o(alub_sel),
        .ram_we_o(ram_we)
    );

    assign Bus_addr = aluc;
    assign Bus_wdata = rD2;
    assign Bus_we = ram_we;

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1;
    assign debug_wb_pc        = pc;
    assign debug_wb_ena       = rf_we;
    assign debug_wb_reg       = inst[11:7];
    assign debug_wb_value     = wD;
`endif

endmodule