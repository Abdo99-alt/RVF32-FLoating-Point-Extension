//ALU module implements 4 main operations as follows:
//ALUCtrl operation
//  00        add
//  01        sub
//  10        and
//  11        or
///////////////////////////////////////////
module alu #(parameter N = 32)
            (A, B, ALUCtrl, ALUResult, Zero);
    input [N-1 : 0] A, B;
    input [1:0] ALUCtrl;
    output reg [N-1 : 0] ALUResult;
    output wire Zero;
    ///////////////////////////////////////
    assign Zero = (ALUResult == 0) ? 1'b1 : 1'b0;
    always @(A or B or ALUCtrl) begin
        case (ALUCtrl)
            2'b00:  ALUResult = A + B;
            2'b01:  ALUResult = A - B;
            2'b10:  ALUResult = A & B;
            2'b11:  ALUResult = A | B; 
            default: ALUResult = 32'h0000; 
        endcase
    end
endmodule