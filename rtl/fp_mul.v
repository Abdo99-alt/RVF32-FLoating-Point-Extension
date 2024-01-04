/////////////////////////////////////////////////////////////////////////////////
//This module is to preform the multiplication on 32-bit floating point numbers//
//•	Snan * [ANYCLASS] = Snan                                                   //
//•	Qnan * [ANYCLASS] = Qnan                                                   //
//•	Inf * Inf [Normal] [Subnormal] = Inf                                       //
//•	Inf * Zero = Qnan                                                          //
//•	Subnormal * Subnormal = Zero                                               //
/////////////////////////////////////////////////////////////////////////////////
module fp_mul (a, b, p);
    `include "ieee-754-flags.vh"

    input [NEXP+NSIG:0] a, b;
    output [NEXP+NSIG:0] p;
    ////////////////////////////////////////////////////////////////////////////////////
    reg [NEXP+NSIG:0] ptmp;		                //Internal register to hold the product
    reg psign;
    wire signed [NEXP+1:0] aExp, bExp;	
    reg signed [NEXP+1:0]  t1Exp, t2Exp, pExp;   //Temporary storage for product exponent							
    wire [NSIG:0] aSig, bSig;
    reg [NSIG:0] pSig ;
    wire [(2*NSIG)+1:0] rawSig;		                //Holds the product of aSig , bSig
    reg [NSIG:0] tSig;			            //Temporary storage for truncated significand
    reg [NSIG+1:0] roSig;                       //Rounded significand

    wire [NEXP+NSIG:0] aFlags, bFlags;
    /////////////////////////////////////////////////////////////////////////////////////
    fp_class aClass(a, aFlags, aExp, aSig);
    fp_class bClass(b, bFlags, bExp, bSig);
    
    assign rawSig = aSig * bSig;
    always @(*) begin
        ptmp = {1'b0 , {NEXP{1'b1}} , 1'b0 , {NSIG-1{1'b1}}};
        psign = a[NEXP+NSIG] ^ b[NEXP+NSIG];
        ////////////////////////////////////////////////////////////
        ////////////////////////Special Cases///////////////////////
        if ((aFlags[SNAN] | bFlags[SNAN]) == 1) begin
            ptmp = (aFlags[SNAN] == 1) ? a : b;
            //Snan = 1;
        end
        else if ((aFlags[QNAN] | bFlags[QNAN]) == 1) begin
            ptmp = (aFlags[QNAN] == 1) ? a : b;
            //Qnan = 1;
        end
        else if ((aFlags[INF] | aFlags[N_INF] | bFlags[INF] | bFlags[N_INF]) == 1) begin
            if ((aFlags[ZERO] | bFlags[ZERO]) == 1) begin
                ptmp = {psign , {NEXP{1'b1}} , 23'h002a};
                //Qnan = 1;
            end
            else begin
                ptmp = {psign , {NEXP{1'b1}} ,{NSIG{1'b0}}};
                //Inf = 1;
            end
        end
        else if ((aFlags[ZERO] | bFlags[ZERO]) == 1 || (aFlags[SUBNORMAL] | 
                aFlags[N_SUBNORMAL]) & (bFlags[SUBNORMAL] | bFlags[N_SUBNORMAL]) == 1) 
        begin
            ptmp = {psign , {NEXP+NSIG{1'b0}}};
            //Zero = 1;
        end
        ///////////////////////////////////////////////////////////////
        else begin
            t1Exp = aExp + bExp;
            /////////////////////////////////////////////////////////
            ///////////////////////Normalization/////////////////////
            if(rawSig[2*NSIG+1] == 1) begin               //product needs to be normalized
                t2Exp = t1Exp + 1;
                tSig = rawSig[2*NSIG+1:NSIG+1];		        //significand is truncated to 24 bits--Don't forget the implied 1
                //////////////////////////////////////////////////////////
                ////////////Rounding to nearest (Ties To Even)////////////
                if (rawSig[NSIG:0] > 24'h7ff_fff) begin        //Add 1 to the remaining bits
                    roSig = tSig + 1;
                end 
                else if (rawSig[NSIG:0] < 24'h7ff_fff) begin   //Do nothing
                    roSig = tSig;
                end
                else begin                                   //Check for tSig[7]: EVEN or ODD
                    roSig = tSig + tSig[0];
                end
            end
            else begin						        //product needs no normalization
                t2Exp = t1Exp;
                tSig = rawSig[2*NSIG:NSIG];
                //////////////////////////////////////////////////////////
                ////////////Rounding to nearest (Ties To Even)////////////
                if (rawSig[NSIG-1:0] > 23'h3ff_fff) begin        //Add 1 to the remaining bits
                    roSig = tSig + 1;
                end 
                else if (rawSig[NSIG-1:0] < 23'h3ff_fff) begin   //Do nothing
                    roSig = tSig;
                end
                else begin                                   //Check for tSig[7]: EVEN or ODD
                    roSig = tSig + tSig[0];
                end
            end
            t2Exp = t2Exp + roSig[NSIG+1];
            
            ///////////////////////////////////////////////////////////
            //////////////////////Constructing Result//////////////////
            if (t2Exp < -149) begin			        //Zero product
                ptmp = {psign , {NEXP+NSIG{1'b0}}};	    
                //Zero = 1;
            end
            else if (t2Exp < -126)	begin			//Subnormal product 
                if (roSig[NSIG+1])
                    pSig = roSig[NSIG+1:1] >> (-126 - t2Exp);	
                else
                    pSig = roSig[NSIG:0] >> (-126 - t2Exp);	
                ptmp = {psign , {NEXP{1'b0}} , pSig[NSIG-1:0]};	
                //Subnormal = 1;
            end
            else if (t2Exp > 127) begin				//Infinity product
                ptmp = {psign , {NEXP{1'b1}} , 23'b0};
                //Inf = 1;
            end
            else begin							    //Normal product
                pExp = t2Exp + BIAS;	
                if (roSig[NSIG+1])
                    pSig = roSig[NSIG+1:1];	
                else
                    pSig = roSig[NSIG:0];
                ptmp = {psign , pExp[NEXP-1:0] , pSig[NSIG-1:0]};
                //Normal = 1;
            end
        end
    end
    assign p = ptmp;
        
endmodule
