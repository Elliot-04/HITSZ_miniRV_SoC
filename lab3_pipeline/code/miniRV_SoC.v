`timescale 1ns / 1ps
`include "defines.vh"

// 注：仅实现了理想流水线，无法使用TRACE进行测试
module miniRV_SoC (
    input  wire         fpga_rstn,   // Low active
    input  wire         fpga_clk,
    input  wire [15:0]  sw,
    input  wire [4:0]   button,
    output wire [7:0]   dig_en,
    output wire         DN_A0, DN_A1,
    output wire         DN_B0, DN_B1,
    output wire         DN_C0, DN_C1,
    output wire         DN_D0, DN_D1,
    output wire         DN_E0, DN_E1,
    output wire         DN_F0, DN_F1,
    output wire         DN_G0, DN_G1,
    output wire         DN_DP0, DN_DP1,
    output wire [15:0]  led
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
    wire [13:0] inst_addr;
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_we;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         we_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // Interface to switches
    wire         rst_to_sw;
    wire         clk_to_sw;
    wire [31:0]  addr_to_sw;
    wire [31:0]  rdata_from_sw;
    
    // Interface to 7-digs LEDs
    wire         rst_to_dig;
    wire         clk_to_dig;
    wire [31:0]  addr_to_dig;
    wire         we_to_dig;
    wire [31:0]  wdata_to_dig;

    // Interface to LEDs
    wire         rst_to_led;
    wire         clk_to_led;
    wire [31:0]  addr_to_led;
    wire         we_to_led;
    wire [31:0]  wdata_to_led;

    // Interface to buttons
    wire         rst_to_btn;
    wire         clk_to_btn;
    wire [31:0]  addr_to_btn;
    wire [31:0]  rdata_from_btn;

    // Interface to Timer
    wire         rst_to_timer;
    wire         clk_to_timer;
    wire [31:0]  addr_to_timer;
    wire         we_to_timer;
    wire         wef_to_timer;
    wire [31:0]  wdata_to_timer;
    wire [31:0]  rdata_from_timer;

    assign DN_A1 = DN_A0;
    assign DN_B1 = DN_B0;
    assign DN_C1 = DN_C0;
    assign DN_D1 = DN_D0;
    assign DN_E1 = DN_E0;
    assign DN_F1 = DN_F0;
    assign DN_G1 = DN_G0;
    assign DN_DP1 = DN_DP0;
    
    // 下板时，使用PLL分频后的时钟
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (fpga_rstn),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
    
    myCPU Core_cpu (
        .cpu_rst            (!fpga_rstn),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_we             (Bus_we),
        .Bus_wdata          (Bus_wdata)

    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (!fpga_rstn),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .we_from_cpu        (Bus_we),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .we_to_dram         (we_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (rst_to_dig),
        .clk_to_dig         (clk_to_dig),
        .addr_to_dig        (addr_to_dig),
        .we_to_dig          (we_to_dig),
        .wdata_to_dig       (wdata_to_dig),

        // Interface to LEDs
        .rst_to_led         (rst_to_led),
        .clk_to_led         (clk_to_led),
        .addr_to_led        (addr_to_led),
        .we_to_led          (we_to_led),
        .wdata_to_led       (wdata_to_led),

        // Interface to switches
        .rst_to_sw          (rst_to_sw),
        .clk_to_sw          (clk_to_sw),
        .addr_to_sw         (addr_to_sw),
        .rdata_from_sw      (rdata_from_sw),

        // Interface to buttons
        .rst_to_btn         (rst_to_btn),
        .clk_to_btn         (clk_to_btn),       
        .addr_to_btn        (addr_to_btn),
        .rdata_from_btn     (rdata_from_btn),

        // Interface to Timer
        .rst_to_timer       (rst_to_timer),
        .clk_to_timer       (clk_to_timer),
        .addr_to_timer      (addr_to_timer),
        .we_to_timer        (we_to_timer),
        .wef_to_timer       (wef_to_timer),
        .wdata_to_timer     (wdata_to_timer),
        .rdata_from_timer   (rdata_from_timer)
    );

    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (addr_bridge2dram[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (we_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
    // 实例化外设I/O接口电路模块
    led u_led(
        .rst_i(rst_to_led),
        .clk_i(clk_to_led),
        .addr_i(addr_to_led),
        .we_i(we_to_led),
        .wdata_i(wdata_to_led),
        .led_o(led)
    );

    timer u_timer(
        .clk_i(clk_to_timer),
        .rst_i(rst_to_timer),
        .addr_i(addr_to_timer),
        .we_i(we_to_timer),
        .wef_i(wef_to_timer),
        .wdata_i(wdata_to_timer),
        .rdata_o(rdata_from_timer)
    );

    switch u_switch(
        .rst_i(rst_to_sw),
        .clk_i(clk_to_sw),
        .addr_i(addr_to_sw),
        .sw_i(sw),
        .rdata_o(rdata_from_sw)
    );

    digleds u_digleds(
        .rst_i(rst_to_dig),
        .clk_i(clk_to_dig),
        .addr_i(addr_to_dig),
        .we_i(we_to_dig),
        .wdata_i(wdata_to_dig),
        .dig_en_o(dig_en),
        .DN_A0(DN_A0),
        .DN_B0(DN_B0),
        .DN_C0(DN_C0),
        .DN_D0(DN_D0),
        .DN_E0(DN_E0),
        .DN_F0(DN_F0),
        .DN_G0(DN_G0),
        .DN_DP0(DN_DP0),
        .DN_A1(DN_A1),
        .DN_B1(DN_B1),
        .DN_C1(DN_C1),
        .DN_D1(DN_D1),
        .DN_E1(DN_E1),
        .DN_F1(DN_F1),
        .DN_G1(DN_G1),
        .DN_DP1(DN_DP1)
    );

    button u_button(
        .rst_i(rst_to_btn),
        .clk_i(clk_to_btn),
        .addr_i(addr_to_btn),
        .btn_i(button),
        .data_o(rdata_from_btn)
    );
    
endmodule
