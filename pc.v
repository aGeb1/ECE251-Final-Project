`ifndef _pc
`define _pc
module pc(
    input wire clk,
    input wire [7:0] pcin,
    output wire [7:0] pcout);

    reg reset;
    reg [7:0] _pcout;
    assign pcout = _pcout;

    initial begin
        reset = 1'b0;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
    end

    always @(negedge clk or posedge reset) begin
        if (reset)
            _pcout = 8'b0;
        else if (pcin == 8'd255)
            $finish;
        else
            _pcout = pcin;
    end
endmodule
`endif