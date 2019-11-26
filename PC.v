module PC(
    output reg [31:0] currentAddress,
    input [31:0] nextAddress,//jmp_jr
    input reset, clk
);

always @(posedge clk)
begin
if(reset == 0'b1)
    currentAddress = 0;
else
    currentAddress = nextAddress;
end
endmodule // PC


module ExtendedPC(
    output [31:0] currentAddress,
    input [31:0] jumbSteps,
    input[25:0] full_instruction,
    input[31:0] data1,
    input select,
    input select_Jump,
    input select_JR,
    input reset, clk
);

wire [31:0] nextAddress;
wire [31:0] addressPlus4, jumbOffset, jumbAddress;
wire[27:0]jAdd_befor_concat;
wire [31:0]jAdd;
wire [31:0]mux_jump_output;
wire [31:0]mux_jr_output;
FullAdder add4(addressPlus4, currentAddress, 4);

ShiftLeftRegister26 shiftLeft(jAdd_befor_concat, full_instruction, 2);
ShiftLeftRegister shiftLeft2(jumbOffset, jumbSteps, 2);
FullAdder addJumb(jumbAddress, addressPlus4, jumbOffset);
//Jadd
MuxTwoToOne32 mux_jump(mux_jump_output, nextAddress, jAdd, select_Jump);
//JumpAddress
MuxTwoToOne32 mux(nextAddress, addressPlus4, jumbAddress, select);
//JR
MuxTwoToOne32 mux_jr(mux_jr_output, mux_jump_output, data1, select_JR);
PC pc(currentAddress, mux_jr_output, reset, clk);
assign jAdd = {addressPlus4[31:28],jAdd_befor_concat};
// assign nextAddress = (select == 1'b0) ? currentAddress +4 : (jumbAddress << 2) + currentAddress +4;
//  always@(*) begin
//       $monitor("nextAddr:%d\tmux:%d",nextAddress,mux_jr_output);
//  end

endmodule // ExtendedPC


module PCTest;
    
    wire clk;
    wire [31:0] currentAddress;

    reg [31:0] jumbAddress;
    reg reset, select,select_JR,select_Jump;

    Clock clock(clk);
    ExtendedPC pc(currentAddress, jumbAddress, select,select_JR,select_Jump ,reset, clk);

    initial
    begin
    $monitor($time,,, "muxt: %d", mux_jump_output);
        
        jumbAddress = 100;
        
        select = 0;
        reset = 1;
        #2
        reset = 0;
        #20
        select = 1;
        #2
        select = 0;
        #10

        jumbAddress = 10;
        select = 1;
        #2
        select = 0;
        #20

        reset = 1;
        // #10
        // reset = 0;
    end


endmodule // PCTest