`ifndef _dm
`define _dm
module dm(
    input wire clk, memwrite,
    input wire [7:0] address, writedata,
    output wire [7:0] readdata);

    reg [7:0] memory [0:127];
    
    always @(posedge clk) begin
        if (memwrite) begin
            memory[address] <= writedata;
        end
    end

    assign readdata = memwrite ? writedata : memory[address];
endmodule
`endif