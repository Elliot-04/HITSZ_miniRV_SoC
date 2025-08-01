`timescale 1ns / 1ps

module pc (
    input wire        rst_i,
    input wire        clk_i,
    input wire [31:0] din_i,
    output reg [31:0] pc_o
);
    
    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            pc_o <= 32'h00000000;
        end else begin
            pc_o <= din_i;
        end
    end

endmodule