module fp_alu (A, B, ALUCtrl, ALUResult);
    input [31:0] A, B;
    input [3:0] ALUCtrl;
    output reg [31:0] ALUResult;
    //////////////////////////////////////////////////////////////
    wire [31:0] CVT_Out, MUL_Out, ADD_Out, CLASS_Out, CMP_Out, MINMAX_Out;
    wire [1:0] cmp_sel;
    wire min_max_sel;
    //////////////////////////////////////////////////////////////
    fp_cvt fp_cvt (A, CVT_Out);
    fp_class fclass (A, CLASS_Out);
    fp_mul fp_mul (A, B, MUL_Out);
    fp_add fp_add (A, B, ADD_Out);
    fp_cmp cmp (A, B, cmp_sel, CMP_Out);
    fp_min_max min_max (A, B, min_max_sel, MINMAX_Out);
    //////////////////////////////////////////////////////////////
    assign min_max_sel = ALUCtrl == 4'b0011;
    assign cmp_sel = (ALUCtrl == 4'b0100) ? 2'b00 : 
                     ((ALUCtrl == 4'b0101) ? 2'b01 :
                     ((ALUCtrl == 4'b0110) ? 2'b10 : 2'b00)); 
    
    always @(*) begin
        case (ALUCtrl)
            4'b0000: ALUResult = ADD_Out;
            4'b0001: ALUResult = MUL_Out;
            4'b0010, 4'b0011: ALUResult = MINMAX_Out;
            4'b0100, 4'b0101, 4'b0110: ALUResult = CMP_Out; 
            4'b0111: ALUResult = CLASS_Out;
            4'b1111: ALUResult = CVT_Out;
            default : ALUResult = 32'b0;
        endcase
    end
endmodule