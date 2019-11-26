module Test(
    output z,
    input x
);

assign z = ~x;

endmodule

module TestTest;

wire out;
reg in;

Test t(out, in);

initial 
begin
$monitor("in: %b, out: %b", in, out);
    in = 0;
    #10

    in = 1;
end
endmodule // TestTest