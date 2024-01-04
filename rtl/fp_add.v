module fp_add (a, b, s);
    `include "ieee-754-flags.vh"
    localparam CLOG2_NSIG = $clog2(NSIG+1);
    
    input [NEXP+NSIG:0] a, b;
    output [NEXP+NSIG:0] s;
    //IO Related Signals
    wire signed [NEXP+1:0] aExp, bExp, expOut;
    wire [NSIG:0] aSig, bSig, sigOut;
    wire [31:0] aFlags, bFlags;
    wire aSign, bSign;

    //Significands Related Signals
    reg signed [NSIG+1:0] shiftAmt;
    reg signed [EMAX+2:EMIN-NSIG] augendSig, addendSig, normSig;
    wire signed [EMAX+2:EMIN-NSIG] absSig, bigSig, sumSig;

    //Exponents Related Signals
    reg signed [NEXP+1:0] adjExp, normExp, biasExp;
    wire signed [NEXP+1:0] bigExp;

    //Signs Related Signals
    reg sumSign;
    wire absSign;

    reg [CLOG2_NSIG-1:0] sa;
    reg subtract;
    reg [NEXP+NSIG:0] alwaysS;
    //////////////////////////////////////////////////////////////////////////////////////
    fp_class aClass(a, aFlags, aExp, aSig);
    fp_class bClass(b, bFlags, bExp, bSig);
    //////////////////////////////////////////////////////////////////////////////////////
    assign aSign = a[NEXP+NSIG];
    assign bSign = b[NEXP+NSIG];
    always @(*) begin
        subtract = a[NEXP+NSIG] ^ b[NEXP+NSIG];

        if (aFlags[SNAN] | bFlags[SNAN]) begin
            alwaysS = aFlags[SNAN] ? a : b;
        end
        else if (aFlags[QNAN] | bFlags[QNAN]) begin
            alwaysS = aFlags[QNAN] ? a : b;
        end
        else if (aFlags[ZERO] | bFlags[ZERO]) begin
            alwaysS = aFlags[ZERO] ? b : a;
        end
        else if (aFlags[INF] & bFlags[INF]) begin
            alwaysS = {aSign, {{NEXP{1'b1}}},{NSIG{subtract}}};
        end
        else if (aFlags[INF] | bFlags[INF]) begin
            alwaysS = aFlags[INF] ? a : b;
        end
        // a and b are both (sub-)normal numbers
        else begin
            augendSig = 0;
            addendSig = 0;
            sa = 0;

            if (aExp < bExp) begin
                sumSign = bSign;
                shiftAmt = bExp - aExp;
                augendSig[EMAX:EMAX-NSIG] = bSig;
                addendSig[EMAX:EMAX-NSIG] = aSig;
                adjExp = bExp;
            end
            else begin
                sumSign = aSign;
                shiftAmt = aExp - bExp;
                augendSig[EMAX:EMAX-NSIG] = aSig;
                addendSig[EMAX:EMAX-NSIG] = bSig;
                adjExp = aExp;
            end

            addendSig = addendSig >> shiftAmt;
            normSig = bigSig;

            case (normSig[EMAX-1:EMAX-23])
                23'b1??????????????????????: sa = 1;
                23'b01?????????????????????: sa = 2;
                23'b001????????????????????: sa = 3;
                23'b0001???????????????????: sa = 4;
                23'b00001??????????????????: sa = 5;
                23'b000001?????????????????: sa = 6;
                23'b0000001????????????????: sa = 7;
                23'b00000001???????????????: sa = 8;
                23'b000000001??????????????: sa = 9;
                23'b0000000001?????????????: sa = 10;
                23'b00000000001????????????: sa = 11;
                23'b000000000001???????????: sa = 12;
                23'b0000000000001??????????: sa = 13;
                23'b00000000000001?????????: sa = 14;
                23'b000000000000001????????: sa = 15;
                23'b0000000000000001???????: sa = 16;
                23'b00000000000000001??????: sa = 17;
                23'b000000000000000001?????: sa = 18;
                23'b0000000000000000001????: sa = 19;
                23'b00000000000000000001???: sa = 20;
                23'b000000000000000000001??: sa = 21;
                23'b0000000000000000000001?: sa = 22;
                23'b00000000000000000000001: sa = 23;
                default: sa = 24;
            endcase
            normSig = normSig[EMAX] ? bigSig : (normSig << sa);
            normExp = normSig[EMAX] ? bigExp : (bigExp - sa);

            if (~| normSig) begin
                alwaysS = {{NEXP+NSIG+1{1'b0}}};
            end
            else if (expOut < EMIN)begin
                alwaysS = {absSign, {NEXP{1'b0}}, sigOut[NSIG:1]};
            end
            else if (expOut > EMAX) begin
                alwaysS = {absSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            end
            else begin
                biasExp = normExp + BIAS;
                //biasExp = expOut + BIAS;
                alwaysS = {absSign, biasExp[NEXP-1:0], sigOut[NSIG-1:0]};
            end
        end
    end
    // Compute sum/difference of significands
    assign sumSig = subtract ? (augendSig + ~addendSig + 279'b1) : (augendSig + addendSig);

    // Adjusted sign if absSum = -sigSum:
    assign absSign = sumSign ^ sumSig[EMAX+2];
    assign absSig = sumSig[EMAX+2] ? (42'b0 + ~sumSig + 279'b1) : (42'b0 + sumSig);
    
    // See if the addition caused a carry-out. If so, adjust the significad and the exponent.
    assign bigSig = absSig >> absSig[EMAX+1];
    assign bigExp = adjExp + absSig[EMAX+1];

    assign sigOut = normSig[EMAX : EMAX-23];
    assign s = alwaysS;
endmodule
