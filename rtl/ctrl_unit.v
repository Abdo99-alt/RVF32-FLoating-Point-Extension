module ctrl_unit (
    opcode, funct5, funct3, funct7_5, Zero, ImmSrc, ALUCtrl, RegWrite, ALUSrc,
    MemWrite, ResultSrc, PCSrc, Jump, fp_RegWrite, add_sub, fp_ALUCtrl
);
    input [6:0] opcode;
    input [4:0] funct5;
    input [2:0] funct3;
    input funct7_5, Zero;
    output wire [1:0] ImmSrc, ALUCtrl;
    output wire RegWrite, ALUSrc, MemWrite, PCSrc, Jump, fp_RegWrite, add_sub;
    output wire [1:0] ResultSrc;
    output wire [3:0] fp_ALUCtrl;
    //////////////////////////////////////////////////////////
    wire [1:0] ALUOp;
    wire Branch;
    //////////////////////////////////////////////////////////
    assign PCSrc = (Zero & Branch & ~funct3[0]) | (~Zero & Branch & funct3[0]) | Jump;
    assign add_sub = (~| fp_ALUCtrl) & funct5[0];
    //Instantiate building blocks
    main_decoder main_decoder (opcode, funct5, RegWrite, ImmSrc, ALUSrc, Branch, MemWrite,
                                 ResultSrc, ALUOp, Jump, fp_RegWrite);
    alu_decoder alu_decoder (ALUOp, funct3, opcode[5], funct7_5, ALUCtrl);
    fp_alu_decoder fp_alu_decoder (.funct5(funct5), .Instr14_12(funct3), .ALUCtrl(fp_ALUCtrl));
endmodule