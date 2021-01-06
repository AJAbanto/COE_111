`timescale 1ns / 1ps


module tb();

    reg clk;
    reg nrst;
    wire tx;
    
    top uut(.clk(clk),.nrst(nrst),.tx(tx));
    
    //clock generator
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        nrst = 0;
        #20;
        nrst = 1;
        #100000000;
        //$finish;
    end
endmodule
