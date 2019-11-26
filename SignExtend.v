module SignExtend(
    output [31:0] extenddedAddress,
    input [15:0] address
);

assign extenddedAddress = { {16{address[15]}}, address};

endmodule // SignExtend

module SignExtendTest;

reg [15:0] in;
wire [31:0] out;

SignExtend signExtend(out, in);

initial
begin
    $monitor("input: %b, output: %b_%b", in, out[31:16], out[15:0]);

    in = 16'b1011_0101_0000_0000;

    #5
    in = 16'b0101_0101_0000_0000;


end
endmodule // SignExtendTest;
