`include "defines.vh"

module rf (
    input wire         clk_i,
    input wire         rst_i,
    input wire  [4:0]  rR1_i,       
    input wire  [4:0]  rR2_i,
    input wire  [4:0]  wR_i,
    input wire  [31:0] wD_i,
    input wire         we_i,       
    output wire [31:0] rD1_o,
    output wire [31:0] rD2_o
);
    
    reg [31:0] rf[31:0];
    assign rD1_o = rf[rR1_i];
    assign rD2_o = rf[rR2_i];

    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            rf[0] <= 32'd0; 
            rf[1] <= 32'd0; 
            rf[2] <= 32'd0; 
            rf[3] <= 32'd0; 
            rf[4] <= 32'd0; 
            rf[5] <= 32'd0; 
            rf[6] <= 32'd0; 
            rf[7] <= 32'd0; 
            rf[8] <= 32'd0; 
            rf[9] <= 32'd0; 
            rf[10] <= 32'd0;
            rf[11] <= 32'd0;
            rf[12] <= 32'd0;
            rf[13] <= 32'd0;
            rf[14] <= 32'd0;
            rf[15] <= 32'd0;
            rf[16] <= 32'd0;
            rf[17] <= 32'd0;
            rf[18] <= 32'd0;
            rf[19] <= 32'd0;
            rf[20] <= 32'd0;
            rf[21] <= 32'd0;
            rf[22] <= 32'd0;
            rf[23] <= 32'd0;
            rf[24] <= 32'd0;
            rf[25] <= 32'd0;
            rf[26] <= 32'd0;
            rf[27] <= 32'd0;
            rf[28] <= 32'd0;
            rf[29] <= 32'd0;
            rf[30] <= 32'd0;
            rf[31] <= 32'd0;
        end else if (we_i && (wR_i != 5'd0)) begin    // 写入x0寄存器无效
            rf[wR_i] <= wD_i;
        end else begin
            rf[0] <= 32'd0;    
        end
    end

endmodule