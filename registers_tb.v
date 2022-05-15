`include "registers.v"
`timescale 1ns/10ps

module registers_tb;
    logic clk, regwrite;
    logic [4:0] read1, read2, writereg;
    logic [7:0] writedata;
    output [7:0] data1, data2, branchi;

    initial begin
        clk = 1'b0;
        forever begin
            #10 clk = !clk;
        end
    end

    registers testRegisters
    (.clk(clk), .regwrite(regwrite),
    .read1(read1), .read2(read2), .writereg(writereg),
    .writedata(writedata),
    .data1(data1), .data2(data2), .branchi(branchi));

    initial begin
        // Writing to XZR
        regwrite = 1'b1;
        writedata = 8'd10;
        read1 = 5'd0;
        read2 = 5'd0;
        writereg = 5'd0;
        #100;

        // Reading and writing to the same register
        regwrite = 1'b1;
        writedata = 8'd5;
        read1 = 5'd0;
        read2 = 5'd1;
        writereg = 5'd1;
        #100;

        // Writing to another register, reading from a register I haven't
        // written to.
        regwrite = 1'b1;
        writedata = 8'd10;
        read1 = 5'd0;
        read2 = 5'd1;
        writereg = 5'd2;
        #100;

        // No writing, reading X1 and X2
        regwrite = 1'b0;
        read1 = 5'd1;
        read2 = 5'd2;
        #100;
        $finish;
    end
endmodule