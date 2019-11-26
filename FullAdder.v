module FullAdder(
    output [31:0] sum,
    input [31:0] input1, input2
    );

assign sum = input1 + input2;
endmodule


module FullAdderTest;
reg [31:0] in1, in2;
wire [31:0] out;

FullAdder fullAdder(out, in1, in2);

initial
begin
$monitor($time,,, "%d, %d, %d", in1, in2, out);

in1 = 0;
in2 = 0;

#5
in1 = 3;
in2 = 20;

// #5
// in1 = 2;
// in2 = 2;

// #5
// in1 = 3;
// in2 = 3;
end

endmodule
