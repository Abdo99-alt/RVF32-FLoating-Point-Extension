//Input: opcode (Instr[6:0])
//Output: RegWrite, ImmSrc, ALUSrc, Branch, MemWrite, ResultSrc, ALUOp, Jump
module main_decoder (
    opcode, funct5, RegWrite, ImmSrc, ALUSrc, Branch, MemWrite, ResultSrc, ALUOp ,Jump, fp_RegWrite 
);
    input [6:0] opcode;
    input [4:0] funct5;
    output wire RegWrite, ALUSrc, Branch, MemWrite, Jump, fp_RegWrite;
    output wire [1:0] ImmSrc, ALUOp, ResultSrc;
    /////////////////////////////////////////////////////////////
    reg [11:0] controls;
    /////////////////////////////////////////////////////////////
    assign {RegWrite, ImmSrc, ALUSrc, Branch, MemWrite, ResultSrc, ALUOp, Jump, fp_RegWrite} = controls;
    always @(*) begin
        case (opcode)
            7'b0000011: controls = 12'b1_00_1_0_0_01_00_0_0;  //LW
            7'b0100011: controls = 12'b0_01_1_0_1_00_00_0_0;  //SW
            7'b1100011: controls = 12'b0_10_0_1_0_00_01_0_0;  //BEQ & BNE
            7'b0110011: controls = 12'b1_00_0_0_0_00_10_0_0;  //R-Type
            7'b0010011: controls = 12'b1_00_1_0_0_00_10_0_0;  //ADDI & ORI & ANDI
            7'b1101111: controls = 12'b1_11_0_0_0_00_00_1_0;  //JAL
            7'b1100111: controls = 12'b1_00_1_0_0_00_00_1_0;  //JALR
            7'b0000111: controls = 12'b0_00_1_0_0_01_00_0_1;  //FLW
            7'b0100111: controls = 12'b0_01_1_0_1_00_00_0_0;  //FSW
            7'b1010011: case (funct5)
                            //ADD, SUB, MUL, MIN, MAX, CVT.S.W
                            5'b00000, 5'b00001, 5'b00010, 
                            5'b00101, 5'b11000, 5'b11010: controls = 12'b0_00_0_0_0_00_00_0_1;
                            //LE, EQ, LT, CVT.W.S, CLASS
                            5'b11000, 5'b10100, 5'b11100: controls = 12'b1_00_0_0_0_10_00_0_0;
                            default: controls = 12'bxxxxxxxxxxxx;
                        endcase
            default: controls = 12'bxxxxxxxxxxxx;
        endcase 
    end   
endmodule