module wD_ex_mux (
    input wire [31:0] aluc_i,       
    input wire [31:0] sext_i,
    input wire [31:0] pc4_i,
    input wire [1 :0] rf_wsel_i,
    output reg [31:0] wD_o
);

    always @(*) begin
        case (rf_wsel_i)
            `RF_WSEL_PC:   wD_o = pc4_i;
            `RF_WSEL_ALU:  wD_o = aluc_i;
            `RF_WSEL_EXT:  wD_o = sext_i;  
            default:       wD_o = 32'd0;
        endcase
    end

endmodule 