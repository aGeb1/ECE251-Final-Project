// 7 Bit ALU
// I'm thinking maybe use a mux instead of a case block

`ifndef _alu
`define _alu

module alu(
    input [7:0] a, b,
    input [2:0] ctrl,
    output wire [7:0] result,
    output zero);

    wire asign, bsign, diffsign;
    wire [7:0] diff, slt;
    reg [7:0] _result;
    
    assign result = _result;
    assign zero = (0 == result);
    assign diff = a - b;
    assign asign = a[7];
    assign bsign = b[7];
    assign diffsign = diff[7];
    assign slt = (asign && ~bsign) ||
                 (asign && diffsign) ||
                 (~bsign && diffsign);

    // initial begin
    //     $display("ctrl z a        b        result  asign bsign dsign");
    //     $monitor("%2b   %b %8b %8b %8b %b     %b     %d    ",
    //     ctrl, zero, a, b, result, asign, bsign, diffsign);
    // end

    always @* begin
        case (ctrl)
            3'b000: _result = a + b;
            3'b001: _result = diff;
            3'b010: _result = a & b;
            3'b011: _result = a | b;
            3'b100: _result = slt;
            3'b101: _result = a << b;
            3'b110: _result = a >> b;
            default: _result = 8'd0;
        endcase
    end
endmodule
`endif