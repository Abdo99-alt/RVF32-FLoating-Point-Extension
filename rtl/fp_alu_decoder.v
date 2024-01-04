module fp_alu_decoder (funct5, Instr14_12, ALUCtrl);
    input [4:0] funct5;
    input [2:0] Instr14_12;
    output reg [3:0] ALUCtrl;
    ///////////////////////////////////////////////////
    always @(*) begin
        case (funct5)
            5'b00000, 5'b00001: ALUCtrl = 4'b0000;      //ADD, SUB    
            5'b00010: ALUCtrl = 4'b0001;                //MUL
            5'b00101: 
                    case (Instr14_12)
                        4'b000: ALUCtrl = 4'b0010;       //MIN
                        4'b001: ALUCtrl = 4'b0011;       //MAX
                        default: ALUCtrl = 4'b0;
                    endcase
            5'b10100: 
                    case (Instr14_12)
                        4'b000: ALUCtrl = 4'b0100;       //LEQ
                        4'b001: ALUCtrl = 4'b0101;       //LT
                        4'b010: ALUCtrl = 4'b0110;       //EQ
                        default: ALUCtrl = 4'b0;
                    endcase
            5'b11100: ALUCtrl = 4'b0111;                 //CLASS
            5'b11010: ALUCtrl = 4'b1111;                 //CVT.S.W
            default:  ALUCtrl = 4'b0;
        endcase
    end
endmodule