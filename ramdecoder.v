// here we are going to implement 1KB ram design with 10 address lines
module ramdecoder(
	input [9:0] A,
	output [1023:0] MEM
	);

always_comb begin
 	MEM = 0;
 	MEM[A] = 1;
end 
	
endmodule