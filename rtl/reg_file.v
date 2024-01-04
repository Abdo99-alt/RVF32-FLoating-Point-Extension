//Triple port register file 
//2 ports to read from, 1 to write to

module reg_file (
    A1, A2, A3, clk, WE3, WD3, RD1, RD2 
);
    input [4:0] A1, A2, A3;
    input clk, WE3;
    input [31:0] WD3;
    output wire [31:0] RD1, RD2;
    /////////////////////////////////////////
    reg [31:0] rf [31:0];
    /////////////////////////////////////////
    always @(posedge clk) begin
        if (WE3 == 1'b1)
            rf[A3] <= WD3;
    end
    assign RD1 = (A1 != 0) ? rf[A1] : 0;
    assign RD2 = (A2 != 0) ? rf[A2] : 0;
endmodule