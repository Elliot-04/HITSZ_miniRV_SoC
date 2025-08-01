`timescale 1ns / 1ps
`include "defines.vh"

module pc (
    input wire        rst_i,
    input wire        clk_i,
    input wire [31:0] din_i,
    output reg [31:0] pc_o
);

`ifdef RUN_TRACE
    reg flag;   //设置标志位
    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc_o <= 32'h00000000;
            flag = 1'b0;
        end else begin
            if (flag) begin
                pc_o <= din_i;
            end else begin
                flag = 1'b1;
            end
        end
    end
`else
    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc_o <= 32'h00000000;
        end else begin
            pc_o <= din_i;
        end
    end
`endif
    
endmodule