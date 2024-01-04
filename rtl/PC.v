//This models the Program Counter unit
/////////////////////////////////////////////////////
module PC (
    clk, reset, PC, PCNext
);
    input clk, reset;
    input [31:0] PCNext;
    output reg [31:0] PC;
    ///////////////////////////////////////
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            PC <= 32'h0000;
        else 
            PC <= PCNext;
    end
endmodule