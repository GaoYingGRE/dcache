module adder(
	input [31:0] a,
	input [31:0] b,
	input cin,
	output cout,
	output [31:0] s
);

assign {cout, s}=cin+a+b;