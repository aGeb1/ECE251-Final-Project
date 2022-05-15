`ifndef _control
`define _control
module control(
    input wire [5:0] opcode,
    output wire regwrite, memwrite, rori, aluordm, branch,
    // rori is r when 1, aluordm is alu when 1
    output wire [2:0] aluop);

    wire [2:0] type = opcode[5:3];

    assign aluop = opcode[2:0];
    assign aluordm = opcode[5];
    assign regwrite = opcode[5] | (type == 3'b001);
    assign rori = (type == 3'b100);
    assign branch = (type == 3'b000);
    assign memwrite = (type == 3'b010);
endmodule
`endif