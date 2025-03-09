`timescale 10ns / 100ps

module axi_sram_stream (
    input         clk, 
    input         rstn,
    input         tready,
    input         [31:0] sramd,
    output wire   tvalid,
    output reg    [31:0] tdata,
    output reg    [31:0] sram_addr
);

    reg [31:0] addr;
    reg [31:0] rdata;
    reg        ffen;
    reg        muxsel;
    reg        data_valid;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr <= 32'h0;
        end else begin
            if (tvalid && tready) begin
                addr <= addr + 1;
            end
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_valid <= 1'b0;
        end else begin
            if (!data_valid) begin
                data_valid <= 1'b1; 
            end else begin
                data_valid <= 1'b1;
            end
        end
    end
    
    assign tvalid = data_valid;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rdata <= 32'h0;
            ffen  <= 1'b0;
        end else begin
            if (!tready) begin
                rdata <= sramd;
                ffen  <= 1'b1;
            end else begin
                ffen  <= 1'b0;
            end
        end
    end

    always @(*) begin
        tdata = (ffen) ? rdata : sramd;
    end

    always @(*) begin
        sram_addr = addr + 1;
    end

endmodule