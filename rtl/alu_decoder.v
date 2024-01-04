//Input: ALUOp, funct3(Instr[14:12]), opcode[5](Instr[5]), funct7[5](Instr[30])
//Output: ALUCtrl
module alu_decoder (
    ALUOp, funct3, op_5, funct7_5, ALUCtrl
);
    input [1:0] ALUOp;
    input [2:0] funct3;
    input op_5, funct7_5;
    output reg [1:0] ALUCtrl;
    ///////////////////////////////////////////////////
    always @(ALUOp, funct3, op_5, funct7_5) begin
        case (ALUOp)            
            2'b00:  ALUCtrl = 2'b00;                                            //LW & JALR                            
            2'b01:  ALUCtrl = 2'b01;                                            //SW
            2'b10:  case ({funct3, op_5, funct7_5})
                        5'b000_0_0, 5'b000_0_1, 5'b000_1_0: ALUCtrl = 2'b00;    //ADD & ADDI
                        5'b000_1_1: ALUCtrl = 2'b01;                            //SUB
                        5'b111_1_0: ALUCtrl = 2'b10;                            //AND & ANDI
                        5'b110_1_0: ALUCtrl = 2'b11;                            //OR  & ORI 
                        default: ALUCtrl = 2'bxx; 
                    endcase 
            default: ALUCtrl = 2'bxx;
        endcase
    end
endmodule
