module fp_min_max (a, b, sel, res);
    input [31:0] a, b;
    input sel;
    output reg [31:0] res;
    //////////////////////////////////////////////////
    wire aSign, bSign;
    wire [7:0] aExp, bExp;
    wire [22:0] aSig, bSig;

    assign aSign = a[31];
    assign aExp = a[30:23];
    assign aSig = a[22:0];
    assign bSign = b[31];
    assign bExp = b[30:23];
    assign bSig = b[22:0];
    
    always @(*) begin
        case (sel)
            //Find the minimum
            1'b0: if (aSign == 1 && bSign == 0) begin
                    res = a;
                end 
                else if (aSign == 0 && bSign == 1) begin
                    res = b;
                end
                else if (aExp < bExp) begin
                    res = a;
                end
                else if (bExp < aExp) begin
                    res = b;
                end
                else begin
                    res = (aSig < bSig) ? a : b;
                end
            //Find the maximum
            1'b1: if (aSign == 1 && bSign == 0) begin
                    res = b;
                end 
                else if (aSign == 0 && bSign == 1) begin
                    res = a;
                end
                else if (aExp < bExp) begin
                    res = b;
                end
                else if (bExp < aExp) begin
                    res = a;
                end
                else begin
                    res = (aSig < bSig) ? b : a;
                end
            default: res = 32'b0;
        endcase
    end
endmodule