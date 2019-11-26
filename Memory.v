module DataMemory(
    output [31:0] dataOut,
    input [31:0] address,
    input [31:0] writeData,
    input writeEnable,
    input clk
);
reg [7:0] memorySlotes [0:1023];
integer file;
assign dataOut = {memorySlotes[address], memorySlotes[address +1],
                    memorySlotes[address +2], memorySlotes[address +3]};

initial
begin
    file = $fopen("DataMemory.txt");
end
always@(posedge clk)
begin
if(writeEnable)
begin
	memorySlotes[address] <= writeData[31:24];
    memorySlotes[address +1] <= writeData[23:16];
    memorySlotes[address +2] <= writeData[15:8];
    memorySlotes[address +3] <= writeData[7:0];
    $fdisplay(file, "\n@%h//%d", address, address);
    $fdisplay(file, "%b" , writeData[31:24]);
    $fdisplay(file, "%b", writeData[23:16]);
    $fdisplay(file, "%b", writeData[15:8]);
    $fdisplay(file, "%b //%d", writeData[7:0], writeData);
end
end

endmodule // DataMemory


module InstructionMemory(
    output [31:0] dataOut,
    input [31:0] address
);
reg [7:0] memorySlotes [0:1023];

assign dataOut = {memorySlotes[address], memorySlotes[address +1],
memorySlotes[address +2], memorySlotes[address +3]};

initial
begin    
// memorySlotes [0] = 8'b1;
$readmemb ("binaryInstructions.txt", memorySlotes);
end
endmodule // InstructionMemory




module InstructionMemoryTest;
wire [31:0] data;
reg[31:0] address;

InstructionMemory instructionMemory(data, address);

initial
begin
$monitor($time,,, "address: %d, data: %b", address, data);

address = 0;

#10
repeat(20)
begin
    #10
    address = address +4;
end


end
endmodule // InstructionMemoryTest

module DataMemoryTest;
wire [31:0] data;
reg[31:0] address;

reg [31:0] writeData;

reg writeEnable;
wire clk;

reg [31:0] i, j;

Clock clock (clk);

DataMemory dataMemory(data, address, writeData, writeEnable, clk);


initial
begin
$monitor($time,,, "address: %d, data: %d, %b", address, data, data);

address = 0;

writeData = 0;
writeEnable = 1;

i = 0;
j = 0;
repeat(256)@(posedge clk)
begin
	writeData <= writeData +4;
	address <= address +4;
	// i <= i +4;
    // j <= j + 1000;
    
end


#5
writeEnable = 0;

// #10
// address = 0;
// #10
// address = 8;

// #10
// address = 1020;
// #10
// address = 100;
// #10
// address = 1000;

// #10
// writeEnable = 1;
// writeData = 2000;
// #10
// writeEnable = 0;

// #10
// address = 0;
// #10
// address = 8;

// #10
// address = 1020;
// #10
// address = 100;
// #10
// address = 1000;

end
endmodule // DataMemoryTest