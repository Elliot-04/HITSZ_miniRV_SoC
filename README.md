# HITSZ_miniRV_SoC
- 本项目为HITSZ 2025年夏季学期《计算机设计与实践课程》代码，项目名称为基于miniRV的SoC设计，实现了单周期CPU和理想流水线CPU。

## 项目文件结构
```
- miniRV_SoC
    |- lab1_miniRV_asm           // 实验1：汇编语言程序设计
    |
    |- lab2_single_cycle         // 实验2：单周期CPU及SoC设计
    |   |- assembly              // 用于下板演示的实验1汇编程序
    |   |- code                  // 单周期SoC源代码
    |   |- image                 // 单周期CPU数据通路图
    |   |- test                  // 仿真测试相关文件
    |
    |- lab3_pipeline             // 实验3：流水线CPU及SoC设计
    |   |- assembly              // 用于下板演示的实验1汇编程序
    |   |- code                  // 理想流水线SoC源代码
    |   |- image                 // 理想流水线CPU数据通路图
    |   |- test                  // 仿真测试相关文件
    |
    |- lab_report.pdf            // 实验报告
    |- lab_table.xlsx            // 数据通路表、控制信号取值表
    |- README.md

```
## 项目说明
1. 单周期和流水线CPU具体设计与实现请参见实验报告
2. `image`中的数据通路图使用**ioDraw**软件绘制，可导入`.iodraw`文件进行编辑
3. 实验报告中**单周期**CPU仿真分析的反汇编测试用例来自Trace测试框架`cdp-tests\asm\*.dump`
4. 由于`lab3`仅实现了**理想流水线**CPU，无法运行Trace测试，只能通过Vivado运行仿真进行测试，实验报告中仿真分析的测试指令来自`lab3_pipeline/test/pipeline_test.asm`
5. 外设代码基于**EGO1**开发板编写，如使用Minisys开发板请自行修改相关信号的高低电平及位宽
6. 信号命名规范：输入信号使用后缀_i，如addr_i；输出信号使用后缀_o，如data_o
