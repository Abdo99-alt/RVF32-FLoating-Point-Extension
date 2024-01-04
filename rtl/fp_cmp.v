module fp_cmp (a, b, sel, res);
    `include "ieee-754-flags.vh"
    input [31:0] a, b;
    input [1:0] sel;
    output reg [31:0] res;
    //////////////////////////////////////////////////////
    wire aSign, bSign;
    wire [7:0] aExp, bExp;
    wire [22:0] aSig, bSig;
    wire [31:0] aFlags, bFlags;
    //////////////////////////////////////////////////////
    fp_class aClass (.f(a), .fFlags(aFlags));
    fp_class bClass (.f(b), .fFlags(bFlags));
    
    assign aSign = a[31];
    assign aExp = a[30:23];
    assign aSig = a[22:0];
    assign bSign = b[31];
    assign bExp = b[30:23];
    assign bSig = b[22:0];

    always @(*) begin
        if (aFlags[SNAN] | bFlags[SNAN]) begin
            res = 32'b0;
        end
        else begin
            case (sel)
                //Less than or Equal
                2'b00: if (aSign == 0 && bSign == 1) begin
                        res = 32'b0;
                    end
                    else if (bExp < aExp) begin
                        res = 32'b0;
                    end
                    else begin
                        res = (bSig < aSig) ? 32'b0 : 32'b1;
                    end
                //Less than
                2'b01: if (aSign == 1 && bSign == 0) begin
                        res = 32'b1;
                    end
                    else if (aExp < bExp) begin
                        res = 32'b1;
                    end
                    else begin
                        res = (aSig < bSig) ? 32'b1 : 32'b0;
                    end
                //Equal
                2'b10: if (a == b) begin
                        res = 32'b1;
                    end
                    else begin
                        res = 32'b0;
                    end
                default: res = 32'b0;
            endcase
        end
    end
endmodule