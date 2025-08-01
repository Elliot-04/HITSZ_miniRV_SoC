module digleds (
   input wire        clk_i,
   input wire        rst_i,
   input wire [31:0] addr_i,   // 写地址
   input wire        we_i,     // 写使能
   input wire [31:0] wdata_i,
   output wire [7:0] dig_en_o, // 数码管位选信号，高电平有效
   output reg        DN_A0,
   output reg        DN_B0,
   output reg        DN_C0,
   output reg        DN_D0,
   output reg        DN_E0,
   output reg        DN_F0,
   output reg        DN_G0,
   output reg        DN_DP0,
   output reg        DN_A1,
   output reg        DN_B1,
   output reg        DN_C1,
   output reg        DN_D1,
   output reg        DN_E1,
   output reg        DN_F1,
   output reg        DN_G1,
   output reg        DN_DP1
);

    reg  [31:0] wdata_reg;              // 存储要显示的8个16进制数
    wire [63:0] seg_out;                // 存储8个数码管的段选信号
    wire [31:0] wdata_wire = wdata_reg;
    
    // 当CPU向数码管地址写入数据时，更新 wdata_reg
    always @(posedge clk_i or posedge rst_i) begin      
        if (rst_i)                                    wdata_reg <= 32'hFFFF_FFFF;
        else if (we_i && addr_i == 32'hFFFFF000)      wdata_reg <= wdata_i;      
        else                                          wdata_reg <= wdata_reg;
    end
    
    // 根据 dig_en_o 选择对应的段码数据输出段选信号
    always @(*) begin
            case (dig_en_o) 
                8'b00000001:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[63:56];
                8'b00000010:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[55:48];
                8'b00000100:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[47:40];
                8'b00001000:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[39:32];
                8'b00010000:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[31:24];
                8'b00100000:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[23:16];
                8'b01000000:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[15:8];
                8'b10000000:  {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = seg_out[7:0];
                default:      {DN_A0,DN_B0,DN_C0,DN_D0,DN_E0,DN_F0,DN_G0,DN_DP0} = 8'b0000_0000;
            endcase
        end

    // 例化数码管计时器
    led_timer u_led_timer (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .we_i(we_i),
        .led_en_o(dig_en_o)
    );

    // 例化数码管显示模块
    tube u_tube_0 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[3:0]),
        .seg_o(seg_out[63:56])
    );

    tube u_tube_1 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[7:4]),
        .seg_o(seg_out[55:48])
    );

    tube u_tube_2 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[11:8]),
        .seg_o(seg_out[47:40])
    );

    tube u_tube_3 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[15:12]),
        .seg_o(seg_out[39:32])
    );

    tube u_tube_4 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[19:16]),
        .seg_o(seg_out[31:24])
    );

    tube u_tube_5 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[23:20]),
        .seg_o(seg_out[23:16])
    );

    tube u_tube_6 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[27:24]),
        .seg_o(seg_out[15:8])
    );

    tube u_tube_7 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .dig_i(wdata_wire[31:28]),
        .seg_o(seg_out[7:0])
    );

endmodule 