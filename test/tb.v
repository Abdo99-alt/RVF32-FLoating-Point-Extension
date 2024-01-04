module tb;
    reg clk, reset;
    ///////////////////////////////////////
    top top (clk, reset);
    ///////////////////////////////////////
    localparam PERIOD = 10;
    ///////////////////////////////////////
    initial begin
        clk = 1'b0;
        forever begin
            #(PERIOD/2) clk = ~clk;
        end
    end
    initial begin
        reset = 1'b1;
        #6  reset = 1'b0;
    end
endmodule
