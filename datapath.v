`include "pc.v"
`include "im.v"
`include "control.v"
`include "registers.v"
`include "alu.v"
`include "dm.v"

module datapath;
    // initializations
    wire regwrite, memwrite, rori, aluordm, branch, zero, branchornext;
    wire [2:0] aluop;
    wire [7:0] pcin, pcout, nexti, branchi, writedata, data1, data2, aluin,
    aluout, dmout, finalvalue;
    wire [23:0] instruction;

    assign branchornext = branch && zero;
    assign nexti = pcout + 1;
    assign pcin = branchornext ? branchi : nexti;
    assign aluin = rori ? data2 : instruction[17:10];
    assign writedata = aluordm ? aluout : dmout;

    // clk and monitor
    logic clk;
    initial begin
        clk = 1'b0;
        forever begin
            #10 clk = !clk;
        end
    end

    // module declarations
    pc myPc(.clk(clk), .pcin(pcin), .pcout(pcout));
    im myIm(.address(pcout), .instruction(instruction));
    control myControl(.opcode(instruction[23:18]), .regwrite(regwrite),
    .memwrite(memwrite), .rori(rori), .aluordm(aluordm), .branch(branch),
    .aluop(aluop));
    registers myRegisters(.clk(clk), .regwrite(regwrite),
    .read1(instruction[9:5]), .read2(instruction[14:10]),
    .writereg(instruction[4:0]), .writedata(writedata), .data1(data1),
    .data2(data2), .branchi(branchi), .finalvalue(finalvalue));
    alu myAlu(.a(data1), .b(aluin), .ctrl(aluop), .result(aluout),
    .zero(zero));
    dm myDm(.clk(clk), .memwrite(memwrite), .address(data2),
    .writedata(data1), .readdata(dmout));

    // testing
    initial begin
        $dumpfile("gtk.vcd");
        $dumpvars(0, clk, pcout, instruction, aluout, regwrite, memwrite, rori, aluordm, branch, dmout, branchi);
        $monitor("%8b", finalvalue);
    end

    // integer i;
    // initial begin
    //     i = 1;
    // end
    // always @clk begin
    //     i = i + 1;
    //     if (i == 50) $finish;
    // end
endmodule