//Single port RAM used to store data only (accessed word by word)
///////////////////////////////////////////////////////////////////
module data_mem (
    clk, WE, WD, A, RD
);
    input clk, WE;
    input [31:0] WD;
    input [31:0] A;
    output wire [31:0] RD;
    //////////////////////////////////////////////////
    reg [31:0] data_mem [255:0];
    //////////////////////////////////////////////////
    always @(posedge clk) begin
        if (WE == 1'b1)
            data_mem[A[7:0]] <= WD;
    end
    assign RD = data_mem[A[7:0]];
endmodule