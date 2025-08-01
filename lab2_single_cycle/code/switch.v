module switch (
    input  wire         rst_i,
    input  wire         clk_i,
    input  wire [31:0]  addr_i,
    input  wire [15:0]  sw_i,
    output reg  [31:0]  rdata_o
);
    always @(*) begin
        if (rst_i) begin
            rdata_o = 32'd0;
        end else begin
            rdata_o = {16'd0, sw_i};
        end
    end

endmodule