`include "control.v"

module control_tb;
    reg [5:0] opcode;
    output regwrite, memwrite, rori, aluordm, branch;
    output [2:0] aluop;

    control testControl(
        .opcode(opcode), .regwrite(regwrite), .memwrite(memwrite),
        .rori(rori), .aluordm(aluordm), .branch(branch), .aluop(aluop));
    
    initial begin
        $display("opcode aluop, rw, mw, rori, aord, b");
        $monitor("%6b %3b    %1b   %1b   %1b     %1b     %1b",
        opcode, aluop, regwrite, memwrite, rori, aluordm, branch);
    end

    initial begin
        #100;
        opcode = 6'b000000;

        #100;
        opcode = 6'b001001;

        #100;
        opcode = 6'b010010;

        #100;
        opcode = 6'b100100;

        #100;
        opcode = 6'b101101;

        #100;
        opcode = 6'b10110;
        $finish;
    end
endmodule