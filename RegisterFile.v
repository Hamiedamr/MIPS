module RegisterFile(
	output [31:0] data1, data2,
	input [4:0] readAddress1, readAddress2, writeRegAddress,
	input [31:0] writeData,
	input writeEnable,
	input clk
	);

reg [31:0] rf [0:31];
integer file;

assign data1 = rf[readAddress1];
assign data2 = rf[readAddress2];

initial
begin
	rf[0] = 0;
end

always@(posedge clk)
begin
if(writeEnable)
begin
	rf[writeRegAddress] <= writeData;
	file = $fopen("RegData.txt");
    $fdisplay(file, "\n@%h //%d", writeRegAddress, writeRegAddress);
    $fdisplay(file, "%b //%d" , writeData, writeData);
end

end
endmodule


module RegFileTest;

wire [31:0] data1, data2;
reg[4:0] readAddress1, readAddress2, writeReg;
reg [31:0] writeData;

reg writeEnable;
wire clk;

reg [31:0] i;

Clock clock (clk);

RegisterFile registerFile(data1, data2, readAddress1, readAddress2, writeReg, writeData, writeEnable, clk);



initial
begin
$monitor($time,,, "readAddress1: %d, readAddress2: %d, data1: %d, data2: %d",
readAddress1, readAddress2, data1, data2);
readAddress1 = 0;
readAddress2 = 0;
writeReg = 0;
writeData = 0;
// writeEnable = 1;

i = 1;

writeEnable = 1;

repeat(31)@(posedge clk)
begin
	
	writeData <= i;
	writeReg <= i;
	i <= i +1;
	
end
writeEnable = 0;
#5
writeEnable = 0;

#10
readAddress1 = 2;
readAddress2 = 3;

#10
readAddress1 = 1;
readAddress2 = 2;

// #10
// readAddress1 = 0;
// readAddress2 = 1;

// #10
// writeData = 5;
// writeReg = 0;
// writeEnable = 1;

// #2
// writeData = 6;
// writeReg = 1;

// #10
// writeEnable = 0;

// readAddress1 = 31;
// readAddress2 = 1;

end



endmodule
