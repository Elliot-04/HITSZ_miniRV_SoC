`timescale 1ns / 1ps
// 此testbench可用于测试外设下板和CPU执行不含冲突的指令，如需测试下板请将代码中的相关注释解除

module tb_miniRV_SoC;

    // 输入信号
    reg         fpga_rstn;    // 低电平有效复位
    reg         fpga_clk;     // 时钟
    reg [15:0]  sw;           // 拨码开关输入
    reg [4:0]   button;       // 按键开关输入

    // 输出信号
    wire [7:0]  dig_en;       // 数码管使能
    wire        DN_A0, DN_A1, DN_B0, DN_B1, DN_C0, DN_C1, DN_D0, DN_D1;
    wire        DN_E0, DN_E1, DN_F0, DN_F1, DN_G0, DN_G1, DN_DP0, DN_DP1;
    wire [15:0] led;          // LED输出
    wire        cpu_clk;      // 由 myCPU 模块驱动

    // **测试下板前请解除下列注释
    //wire[31:0] Bus_addr;
    
    // 实例化 miniRV_SoC
    miniRV_SoC uut (
        .fpga_rstn(fpga_rstn),
        .fpga_clk(fpga_clk),
        .sw(sw),
        .button(button),
        .dig_en(dig_en),
        .DN_A0(DN_A0), .DN_A1(DN_A1),
        .DN_B0(DN_B0), .DN_B1(DN_B1),
        .DN_C0(DN_C0), .DN_C1(DN_C1),
        .DN_D0(DN_D0), .DN_D1(DN_D1),
        .DN_E0(DN_E0), .DN_E1(DN_E1),
        .DN_F0(DN_F0), .DN_F1(DN_F1),
        .DN_G0(DN_G0), .DN_G1(DN_G1),
        .DN_DP0(DN_DP0), .DN_DP1(DN_DP1),
        .led(led)
    );

    

    // 50MHz 主时钟生成
    initial begin
        fpga_clk = 0;
        forever #10 fpga_clk = ~fpga_clk;
    end

    // 激励信号生成
    initial begin
        // 初始化信号
        fpga_rstn = 0;  // 复位
        sw = 16'h0000;
        button = 5'b00000;
        
        // 等待 myCPU 内部的 cpu_clk 稳定 
        #20000;  // 保持复位 100ns

        // 释放复位
        fpga_rstn = 1;

        // **测试下板前请解除下列注释
//        #456700;
//        wait(tb_miniRV_SoC.uut.Bus_addr == 32'hfffff000)
//        sw = 16'h0001;
//        #100000;
//        sw = 16'h0002;
//        #100000;
//        wait(tb_miniRV_SoC.uut.Bus_addr == 32'hfffff000)
//        #50;
//        sw = 16'h0003;
//        wait(led[0] == 1)
//        #1000;
//        sw = 16'h0000;

        #2000000;
        $finish;
    end

    // 监控信号
    initial begin
        $monitor("Time=%0t fpga_rstn=%b cpu_clk=%b", $time, fpga_rstn, cpu_clk);
    end

    // 导出波形
    initial begin
        $dumpfile("tb_miniRV_SoC.vcd");
        $dumpvars(0, tb_miniRV_SoC);
    end

endmodule