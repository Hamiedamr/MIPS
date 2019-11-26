module AluControl(
	output reg[2:0] aluControl,
	input[5:0] funct,
	input [1:0] aluOp
);
always @(aluOp, funct) 
if(aluOp == 2'b00)
	aluControl <= 3'b010;  	//(Add) addi, lw, sw
else if (aluOp == 2'b01)
	aluControl <= 3'b110;	//(Sub) beq, bne	

else if (aluOp == 2'b11) 	//ori
	aluControl = 3'b001;
	
else if (aluOp == 2'b10)	//R-type
	begin
		if(funct == 32)
			aluControl <= 3'b010;	//Add 
		else if(funct == 34)		
			aluControl <= 3'b110;	//Sub
		else if(funct == 36)
			aluControl <= 3'b000;	//And
		else if(funct == 37)
			aluControl <=3'b001;	//Or
		else if(funct == 42)
			aluControl <= 3'b111;	//Slt
	end
// else
// 	aluControl <= 3'b000;
	
endmodule

module tb_alu();
reg[5:0] funct;
reg[1:0]aluOp;
wire[2:0] aluControl;
reg [31:0] instructions[0:5];
reg [31:0] instruction;

integer file;
integer i;
AluControl A (aluControl, funct, aluOp);
initial begin
	i = 0;
	$monitor("%b, %b, %b, %b", funct, aluOp, aluControl, instruction);
	$readmemb("binaryCode.txt", instructions);
	aluOp = 2'b10;
	for(i = 0; i < 6; i = i + 1)
		begin
		#10
		instruction = 32'b00000010010100111000100000100010;
		funct  = instruction[5:0];
			
		end	
	
	//Decalre Control unit here
	//aluOp value =  output of control unit
	end

endmodule
