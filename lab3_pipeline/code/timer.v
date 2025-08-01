module timer(
    input  wire         rst_i,
    input  wire         clk_i,
    input  wire [31:0]  addr_i,
    input  wire         we_i,      // 修改计时器值的写使能 
    input  wire         wef_i,     // 修改计时器分频系数的写使能
    input  wire [31:0]  wdata_i,
    output reg  [31:0]  rdata_o
);

    reg  [31:0] timer_value;      // 计时器当前值
    reg  [31:0] divider;          // 分频系数
    reg  [31:0] clk_counter;      // 时钟周期计数器
    
    // 写数据
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            timer_value  <= 32'b0;
            divider      <= 32'b0;      
            clk_counter  <= 32'b0;
        end
        else begin
            // 设置分频系数
            if (wef_i && addr_i == 32'hFFFF_F024) begin
                divider <= wdata_i;
                clk_counter <= 32'b0;
            end
            
            // 修改计时器的值
            if (we_i && addr_i == 32'hFFFF_F020) begin
                timer_value <= wdata_i;
                clk_counter <= 32'b0;    
            end
            else begin
                // 检查是否达到分频周期
                if (clk_counter >= divider + 1) begin
                    timer_value <= timer_value + 1;  
                    clk_counter <= 32'b0;            
                end
                else begin
                    clk_counter <= clk_counter + 1; 
                end
            end
        end
    end
    
    // 读数据
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            rdata_o <= 32'b0;  
        end
        else if (!we_i && addr_i == 32'hFFFF_F020) begin
            rdata_o <= timer_value;  
        end
        else begin
            rdata_o <= rdata_o;  
        end
    end

endmodule