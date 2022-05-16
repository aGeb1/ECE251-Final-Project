`include "im.v"

module im_tb;
    reg [7:0] in;
    wire [7:0] in2;
    wire [23:0] out;

    im testIm(.address(in2), .instruction(out));

    initial begin
        $display("in       out");
        $monitor("%8b %24b", in, out);
    end
    
    assign in2 = in;

    integer i;
    initial begin
        in = 8'b0;
        #10;
        for (i=0; i<255; i=i+1) begin
            #20 {in} = {in} + 1;
        end
        $finish;
    end
endmodule