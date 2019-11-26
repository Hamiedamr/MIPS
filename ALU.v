module Alu(
    output reg [31:0] aluOut,
    output zero,
    input [31:0] in1, in2,
    input [2:0] aluCtrl
    );

assign zero = aluOut == 0;

always@(aluCtrl, in1, in2)

begin
case (aluCtrl)
3'b000: aluOut <= in1 & in2;         //And
3'b001: aluOut <= in1 | in2;         //Or
3'b010: aluOut <= in1 + in2;         //Add
3'b110: aluOut <= in1 - in2;         //Sub
3'b111: aluOut <= in1 < in2 ? 1:0;   //Slt

// 4'b100010: aluOut <= ~(in1 | in2);
endcase
end

endmodule


module ExtendedAlu(
    output [31:0] aluOut,
    output zero,
    input [31:0] in1, in2,
    input [5:0] funct,
    input [1:0] aluOp
);

wire [2:0] aluCtrl;

AluControl aluControl(aluCtrl, funct, aluOp);
Alu alu(aluOut, zero, in1, in2, aluCtrl);
endmodule // ExtendedAlu


module ALUTest;

reg [31:0] in1, in2;
// reg [2:0] aluCtrl;
wire [31:0] out;
wire zeroFlag;

wire regDst;
wire branch;
wire memRead;
wire memToReg;
wire memWrite;
wire aluSrc;
wire regWrite;
wire [1:0] aluOp;

// reg [2:0] aluCtrl;
// reg [5:0] opcode, funct;

reg [31:0] instruction;
reg [7:0] instructions[0:1023];

integer i, max;
ControlUnit controlUnit(regDst, branch, memRead, memToReg, memWrite, aluSrc,
			regWrite, aluOp, instruction[31:26], instruction[5:0]);
            
ExtendedAlu extendedAlu(out, zeroFlag, in1, in2, instruction[5:0], aluOp);
// ExtendedAlu extendedAlu(out, zeroFlag, in1, in2, 6'b100010, 2'b10);

// Alu alu(out, zeroFlag, in1, in2, aluCtrl);
initial
begin

$monitor("aluOp: %b, in1: %d, in2: %d, out: %d, zero: %b, instruction: %b", aluOp, in1, in2, out, zeroFlag, instruction);

$readmemb ("binaryCode.txt", instructions);
 
max = 255;

in1 = 5;
in2 = 5;
for (i=0 ; i < max ; i=i +4)
#1
begin
if (^instructions[i] === 1'bx)
	max = i;
instruction = {instructions[i], instructions[i +1],
instructions[i +2], instructions[i +3]};
end

// instruction = 32'b00000010010100111000100000100000;
// in1 = 5;
// in2 = 3;
// // aluCtrl = 3'b010;
// #10
// instruction = 32'b10001110001100100000000000010100;
// #10
// instruction = 32'b00010001010010010000000000100010;
// #10
// instruction = 32'b00010001010010010000000000100010;
// in1 = 3;
// in2 = 3;

end
endmodule
