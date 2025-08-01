module button (
    input  wire         rst_i,
    input  wire         clk_i,
    input  wire [31:0]  addr_i,
    input  wire [4:0]   btn_i,
    output reg  [31:0]  data_o
);

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            data_o <= 32'd0;
        end else begin
            data_o <= {27'd0, btn_i};
        end
    end

endmodule