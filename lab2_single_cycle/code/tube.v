module tube (
    input  wire       clk_i,
    input  wire       rst_i,
    input  wire [3:0] dig_i,
    output reg  [7:0] seg_o // 数码管段选信号，高电平有效
);
   
   // 根据要显示的数字输出对应的段选信号
    always @(*) begin
        case (dig_i)
            4'd0: seg_o = 8'b11111100;
            4'd1: seg_o = 8'b01100000;
            4'd2: seg_o = 8'b11011010;
            4'd3: seg_o = 8'b11110010;
            4'd4: seg_o = 8'b01100110;
            4'd5: seg_o = 8'b10110110;
            4'd6: seg_o = 8'b10111110;
            4'd7: seg_o = 8'b11100000;
            4'd8: seg_o = 8'b11111110;
            4'd9: seg_o = 8'b11100110;
            4'd10: seg_o = 8'b11101110;
            4'd11: seg_o = 8'b00111110;
            4'd12: seg_o = 8'b00011010;
            4'd13: seg_o = 8'b01111010;
            4'd14: seg_o = 8'b10011110;
            4'd15: seg_o = 8'b10001110;
            default: seg_o = 8'b00000000;
        endcase
    end

endmodule 