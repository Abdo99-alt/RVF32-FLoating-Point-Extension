/////////////////////////////////////////////////////////////////
//This module determines the class of the floating-point number//
/////////////////////////////////////////////////////////////////

module fp_class (f, fFlags, fExp, fSig);
    `include "ieee-754-flags.vh"
    input [NSIG+NEXP:0] f;
    output wire [NSIG+NEXP:0] fFlags;
    output reg signed [NEXP+1:0] fExp;
    output reg [NSIG:0] fSig;
    /////////////////////////////////////////////////////	
    reg [4:0] sa;
    wire expOnes, expZeroes, sigZeroes;

    assign expOnes   =  &f[NEXP+NSIG-1:NSIG];
    assign expZeroes = ~|f[NEXP+NSIG-1:NSIG];
    assign sigZeroes = ~|f[NSIG-1:0];

    assign fFlags[SNAN]         =  expOnes   & ~sigZeroes & ~f[NSIG-1];
    assign fFlags[QNAN]         =  expOnes                &  f[NSIG-1];
    assign fFlags[INF]          =  expOnes   &  sigZeroes & ~f[NSIG+NEXP];
    assign fFlags[N_INF]        =  expOnes   &  sigZeroes &  f[NSIG+NEXP];
    assign fFlags[ZERO]         =  expZeroes &  sigZeroes & ~f[NSIG+NEXP];
    assign fFlags[N_ZERO]       =  expZeroes &  sigZeroes &  f[NSIG+NEXP];
    assign fFlags[SUBNORMAL]    =  expZeroes & ~sigZeroes & ~f[NSIG+NEXP];
    assign fFlags[N_SUBNORMAL]  =  expZeroes & ~sigZeroes &  f[NSIG+NEXP];
    assign fFlags[NORMAL]       = ~expOnes   & ~expZeroes & ~f[NSIG+NEXP];
    assign fFlags[N_NORMAL]     = ~expOnes   & ~expZeroes &  f[NSIG+NEXP];
    assign fFlags[NSIG+NEXP:10] = 22'b0;
    
    always @(f) begin
        fExp = f[30:23];
        fSig = {1'b1 , f[22:0]};
        sa = 0;
        if ((fFlags[NORMAL] | fFlags[N_NORMAL]) == 1) begin
            fExp = f[30:23] - 127;
            fSig = {1'b1 , f[22:0]};
        end
        else if ((fFlags[SUBNORMAL] | fFlags[N_SUBNORMAL]) == 1) begin
            casez (f[22:0])
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
                default: sa = 23;
            endcase
            fExp = -126 - sa;
            fSig = {1'b1 , (f[22:0] << sa)};
        end
    end
endmodule