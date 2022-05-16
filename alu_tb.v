`include "alu.v"

module alu_tb;
    parameter N = 8;
    reg [N-1:0] a;
    reg [N-1:0] b;
    reg [2:0] ctrl;

    output [N-1:0] result;
    wire zero;

    alu testAlu (.a(a), .b(b), .ctrl(ctrl), .result(result), .zero(zero));
    logic clk;

    integer i;
    
    initial begin
        $display("ctrl z a        b        result");
        $monitor("%2b   %b %8b %8b %8b",
        ctrl, zero, a, b, result);
    end

    initial begin
        clk = 1'b0;
        forever begin
            #10 clk = !clk;
        end
    end

    initial begin
        a = 8'b00000101;
        b = 8'b00000011;
        ctrl = 3'b000;
        #100;
        for (i=0; i<7; i = i + 1)
        begin
            {ctrl} = {ctrl} + 1'b1; #100;
        end
        #100;
        a = 8'b10101010;
        b = 8'b01010101;
        ctrl = 3'b000;
        #100;
        a = 8'b00111100;
        b = 8'b10000001;
        $finish;
    end
endmodule