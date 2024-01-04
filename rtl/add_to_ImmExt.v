module add_to_ImmExt (
    A, B, Sum
);
    input [31:0] A, B;
    output wire [31:0] Sum;
    /////////////////////////////////////
    assign Sum = A + B;
endmodule