module ControlUnit(
	output reg regDst, 
	branch,
	memToReg,
	memWrite,
	aluSrc,
	regWrite,
	jump,
	jump_register,
	output reg [1:0] aluOp,
	
	input [5:0] opcode, funct
);
always @(opcode, funct)
begin
	
    //first, reset all signals
 
	regDst = 1'b0;
	branch = 1'b0;
	memToReg = 1'b0;
	memWrite = 1'b0;
	aluSrc = 1'b0;
	regWrite = 1'b0;
	aluOp = 2'b00;
	jump = 1'b0;
	jump_register = 1'b0;

	// R type
	if(opcode == 0)
	begin
		regDst = 1'b1;
		// regWrite = 1'b1;
		aluOp = 2'b10;

		// if not jr
		if(funct != 8)
		begin
			regWrite = 1'b1;
		end
		else if(funct == 8) 
			begin
			jump = 1'b1;
			jump_register = 1'b1;
			end
	end

	// For branch instructions beq bnq
	else if(opcode == 4 | opcode == 5) 
	begin
		branch   = 1'b1;
		aluOp = 2'b01;
	end

	// For memory write operation
	// sw use memory to write
	else if(opcode == 43)
	begin
		aluSrc = 1'b1;
		memWrite = 1'b1;
	end

	// For memory read operation
	// lw
	else if(opcode == 35)
	begin
		aluSrc = 1'b1;
		memToReg = 1'b1;
		regWrite = 1'b1;
	end

	//addi
	else if(opcode == 8)
	begin
		aluSrc = 1'b1;
		regWrite = 1'b1;
	end

	//ori
	else if(opcode == 13)
	begin
		aluSrc = 1'b1;
		regWrite = 1'b1;
		aluOp = 2'b11;
	end
	else if(opcode == 2)
	begin
		jump = 1'b1;
	end

	// J type
	// Do nothing!..
	// All signals already 0.
	end
		
endmodule




module ControlUnit_tb();
wire regDst;
wire branch;
wire memToReg;
wire memWrite;
wire aluSrc;
wire regWrite;
wire jump;
wire jump_register;
wire [1:0] aluOp;
reg [5:0] opcode, funct;

reg [31:0] mem[0:256];
integer i = 0, max = 256;
integer file;
ControlUnit CO(regDst, branch, memToReg, memWrite, aluSrc,
			regWrite,jump, aluOp, opcode, funct);
initial begin


$readmemb ("binaryCode.txt", mem);
$monitor (" %b ",mem[1]);

for (i=0 ; i < max ; i=i+1 )
#1
 begin
 if (^mem[i] === 1'bx)
	max = i;
 opcode <= mem[i][31:26];
 funct <= mem[i][5:0];
$monitor ("regDst: %b, branch: %b, memToReg: %b, memWrite: %b, aluSrc: %b, regWrite: %b, aluOp: %b, opcode: %d, funct: %d",
	regDst, branch, memToReg, memWrite, aluSrc, regWrite, aluOp, opcode, funct);
  end 
end
endmodule

