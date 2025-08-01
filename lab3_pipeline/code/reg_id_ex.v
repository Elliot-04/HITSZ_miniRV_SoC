module reg_id_ex (
    input wire        clk_i,
    input wire        rst_i,  
    input wire [31:0] rD1_i,
    input wire [31:0] rD2_i,
    input wire [1 :0] rf_wsel_i,
    input wire [2 :0] br_i,
    input wire        rf_we_i,
    input wire [3 :0] alu_op_i,
    input wire        alub_sel_i,
    input wire        ram_we_i,
    input wire [4 :0] wR_i,
    input wire [31:0] pc_i,
    input wire [31:0] pc4_i,
    input wire [31:0] imm_i,
    output reg [31:0] rD1_o,
    output reg [31:0] rD2_o,
    output reg [4 :0] wR_o,
    output reg [31:0] pc_o,
    output reg [31:0] pc4_o,
    output reg [31:0] imm_o,
    output reg [1 :0] rf_wsel_o,
    output reg [2 :0] br_o,
    output reg        rf_we_o,
    output reg [3 :0] alu_op_o,
    output reg        alub_sel_o,
    output reg        ram_we_o
);

    //数据信号寄存
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    wR_o <= 5'b0;
        else          wR_o <= wR_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    pc4_o <= 32'b0;
        else          pc4_o <= pc4_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    pc_o <= 32'b0;
        else          pc_o <= pc_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    imm_o <= 32'b0;
        else          imm_o <= imm_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    rD1_o <= 32'b0;
        else          rD1_o <= rD1_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    rD2_o <= 32'b0;
        else          rD2_o <= rD2_i;
    end

    //控制信号寄存
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    rf_wsel_o <= 2'b0;
        else          rf_wsel_o <= rf_wsel_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    rf_we_o <= 1'b0;
        else          rf_we_o <= rf_we_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    br_o <= 3'b0;
        else          br_o <= br_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    alu_op_o <= 4'b0;
        else          alu_op_o <= alu_op_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    alub_sel_o <= 1'b0;
        else          alub_sel_o <= alub_sel_i;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)    ram_we_o <= 1'b0;
        else          ram_we_o <= ram_we_i;
    end

endmodule