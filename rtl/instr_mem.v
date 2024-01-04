//Single port ROM used to store instructions only//
///////////////////////////////////////////////////
module instr_mem (
    PC, Instr 
);
    input [31:0] PC;
    output wire [31:0] Instr;
    ///////////////////////////////////////////////
    reg [31:0] instr_mem [255:0];
    ///////////////////////////////////////////////
    initial begin
        $readmemh ("program.s", instr_mem);
    end
    assign Instr = instr_mem[PC[9:2]];
endmodule