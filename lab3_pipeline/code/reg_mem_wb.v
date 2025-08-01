module reg_mem_wb (
    input wire        clk_i,
    input wire        rst_i,  
    input wire [4 :0] wR_i,
    input wire [31:0] wD_i,
    input wire        rf_we_i,
    output reg [4 :0] wR_o,
    output reg [31:0] wD_o,
    output reg        rf_we_o
);

    //数据信号寄存
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i)      wR_o <= 5'b0;
        else            wR_o <= wR_i;
    end 

    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i)      wD_o <= 32'b0;
        else            wD_o <= wD_i;
    end

    //控制信号寄存
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i)      rf_we_o <= 1'b0;
        else            rf_we_o <= rf_we_i;
    end

endmodule