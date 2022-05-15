`ifndef _im
`define _im
module im(
    input wire [7:0] address,
    output wire [23:0] instruction);

    parameter IM_DATA = "im_data.txt";
    reg [23:0] memory [0:255];

    initial $readmemh(IM_DATA, memory);
    
    assign instruction = memory[address];
endmodule
`endif