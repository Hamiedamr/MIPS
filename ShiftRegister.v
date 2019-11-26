module ShiftLeftRegister(
    output [31:0] out,
    input [31:0] in,
    input [5:0] shiftAmmount
);
assign out = in << shiftAmmount;
endmodule // ShiftRegister
module ShiftLeftRegister26(
    output [27:0] out,
    input [25:0] in,
    input [5:0] shiftAmmount
);
assign out = (in << shiftAmmount);
endmodule

module shiftRegTest;

wire [31:0]out;
reg [31:0] in;
reg [5:0] shiftAmmount;

ShiftLeftRegister sh(out, in, shiftAmmount);

initial
begin
$monitor("in: %d, out:%d", in, out);
    shiftAmmount = 2;
    in = 10;
    #2
    in = 100;

end

endmodule // shiftRegTest