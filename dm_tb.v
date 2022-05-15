`include "dm.v"
module dm_tb;
    logic clk, memwrite;
    logic [7:0] address, writedata;
    wire [7:0] readdata;
    dm testDm(.clk(clk), .memwrite(memwrite), .address(address),
              .writedata(writedata), .readdata(readdata));
    
    initial begin
        clk = 1'b0;
        forever begin
            #10 clk = !clk;
        end
    end

    initial begin
        $display("clk memw address  wdata    rdata");
        $monitor("%1b   %1b    %8b %8b %8b", clk, memwrite, address, writedata,
        readdata);
    end

    initial begin
        memwrite = 1'b1;
        address = 8'b0;
        writedata = 8'd10;
        
        #20;
        address = 8'b1;
        writedata = 8'd20;

        #20;
        address = 8'b0;
        writedata = 8'd30;

        #20;
        memwrite = 1'b0;
        address = 8'b1;
        writedata = 8'd40;

        #20;
        address = 8'b0;
        writedata = 8'd50;

        #20;
        $finish;
    end
endmodule