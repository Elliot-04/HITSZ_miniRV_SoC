module reg_ex_mem (
    input wire        clk_i,
    input wire        rst_i,
    input wire [31:0] wD_i,
    input wire [4 :0] wR_i,
    input wire [1 :0] rf_wsel_i,
    input wire        rf_we_i,
    input wire        ram_we_i,
    input wire [31:0] rD2_i,
    input wire [31:0] aluc_i,
    output reg [31:0] wD_o,
    output reg [4 :0] wR_o,
    output reg [31:0] rD2_o,
    output reg [31:0] aluc_o,
    output reg [1 :0] rf_wsel_o,
    output reg        rf_we_o,
    output reg        ram_we_o
);
    
    //数据信号寄存
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    wD_o <= 32'b0;
        else          wD_o <= wD_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    wR_o <= 5'b0;
        else          wR_o <= wR_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    rD2_o <= 32'b0;
        else          rD2_o <= rD2_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    aluc_o <= 32'b0;
        else          aluc_o <= aluc_i;
    end

    //控制信号寄存
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)     rf_wsel_o <= 2'b0;
        else           rf_wsel_o <= rf_wsel_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)     rf_we_o <= 1'b0;
        else           rf_we_o <= rf_we_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)     ram_we_o <= 1'b0;
        else           ram_we_o <= ram_we_i;
    end

endmodule