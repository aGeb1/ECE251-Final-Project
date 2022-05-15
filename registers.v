`ifndef _registers
`define _registers

module registers(
    input wire clk, regwrite,
    input wire [4:0] read1, read2, writereg,
    input wire [7:0] writedata,
    output wire [7:0] data1, data2, branchi, finalvalue);
    
    reg [7:0] regs [31:0];
    reg [7:0] _data1, _data2, _branchi;
    assign data1 = _data1;
    assign data2 = _data2;
    assign branchi = _branchi;
    assign finalvalue = regs[1];

    // initial begin
    //     $display("clk X1       X2       X3       R1    R2    D1       D2       ");
    //     $monitor("%b   %8b %8b %8b %5b %5b %8b %8b",
    //     clk, regs[1][7:0], regs[2][7:0], regs[3][7:0], read1, read2, _data1, _data2);
    // end

    always @(read1, regs[read1]) begin
        if (read1 == 5'b0)
            _data1 = 8'b0;
        else if ((read1 == writereg) && regwrite && clk) //finicky conditional
            _data1 = writedata;
        else
            _data1 = regs[read1]; 
    end

    always @(read2, regs[read2]) begin
        if (read2 == 5'b0)
            _data2 = 8'b0;
        else if ((read2 == writereg) && regwrite && clk) //finicky conditional
            _data2 = writedata;
        else
            _data2 = regs[read2];
    end

    always @(writereg, regs[writereg]) begin
        if (writereg == 5'b0)
            _branchi = 8'b0;
        // else if (regwrite && clk)
        //     _branchi = writedata;
        else
            _branchi = regs[writereg];
    end

    always @(posedge clk) begin
        if (regwrite && writereg != 4'b0) begin
            regs[writereg] <= writedata;
        end
    end
endmodule
`endif