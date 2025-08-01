module led (
    input wire        rst_i,       
    input wire        clk_i,       
    input wire [31:0] addr_i,      
    input wire        we_i,        // 写使能
    input wire [31:0] wdata_i,     // 写入数据
    output reg [15:0] led_o        // 16位LED输出信号
);

    // 当写使能有效且地址匹配时，将写入数据的低16位赋值给LED输出
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            led_o <= 16'd0;
        end else if (we_i && addr_i == 32'hFFFFF060) begin
            led_o <= wdata_i[15:0];   
        end else begin
            led_o <= led_o;
        end
    end
    
endmodule