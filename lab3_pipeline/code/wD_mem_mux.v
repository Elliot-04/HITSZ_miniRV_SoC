module wD_mem_mux (
    input wire [31:0] wD_i,       
    input wire [31:0] dram_i,
    input wire [1 :0] rf_wsel_i,
    output reg [31:0] wD_o
);

    always @(*) begin
        case (rf_wsel_i)
            `RF_WSEL_PC:     wD_o = wD_i;
            `RF_WSEL_EXT:    wD_o = wD_i;  
            `RF_WSEL_ALU:    wD_o = wD_i;
            `RF_WSEL_DRAM:   wD_o = dram_i; 
            default:         wD_o = 32'd0;
        endcase
    end

endmodule 