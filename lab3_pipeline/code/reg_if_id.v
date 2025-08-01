module reg_if_id (
    input wire        clk_i,
    input wire        rst_i,
    input wire [31:0] inst_i,
    input wire [31:0] pc_i,
    input wire [31:0] pc4_i,
    output reg [31:0] inst_o,
    output reg [31:0] pc_o,
    output reg [31:0] pc4_o
);

    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i)    pc_o <= 32'b0;
        else          pc_o <= pc_i;
    end

    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i)    pc4_o <= 32'b0;
        else          pc4_o <= pc4_i;
    end

    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i)    inst_o <= 32'b0;
        else          inst_o <= inst_i;
    end

endmodule