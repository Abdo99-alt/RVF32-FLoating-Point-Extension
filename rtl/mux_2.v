module mux_2 (
    A, B, sel, MUXOut
);
    input [31:0] A, B;
    input sel;
    output wire [31:0] MUXOut;
    /////////////////////////////////////////
    assign MUXOut = (sel == 1'b0) ? A : B;
endmodule