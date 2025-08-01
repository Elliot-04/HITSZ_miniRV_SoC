module led_timer (
    input wire clk_i,         
    input wire rst_i,        
    input wire we_i,     
    output reg [7:0] led_en_o      
);  
    
    reg        timer_inc;    // 计时器增量信号
    wire       timer_end;    // 计时器周期结束标志
    reg [24:0] timer_value;  // 计时器计数值

    assign timer_end = timer_inc & (timer_value == 25'd29999);  

    always @(posedge clk_i or posedge rst_i) begin      
        if (rst_i)             led_en_o <= 8'b00000001;  // 复位时，默认使能第一个数码管
        else if (timer_end)    led_en_o <= {led_en_o[6:0],led_en_o[7]};   // 每个计时周期结束时，将使能信号循环左移一位，切换到下一个数码管
        else                   led_en_o <= led_en_o;
    end

    always @(posedge clk_i or posedge rst_i) begin      
        if (rst_i)             timer_inc <= 1'b0;
        else if (we_i)         timer_inc <= 1'b1;
        else                   timer_inc <= timer_inc;
    end

    always @(posedge clk_i or posedge rst_i) begin      
        if (rst_i)              timer_value <= 25'd0;
        else if (timer_end)     timer_value <= 25'd0;  // 一个周期结束，计数器清零
        else if (timer_inc)     timer_value <= timer_value + 25'd1;  // 计时器启动后，每个时钟周期加1
        else                    timer_value <= timer_value;
    end

endmodule 