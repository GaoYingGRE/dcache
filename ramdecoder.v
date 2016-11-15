// here we are going to implement 1KB ram design with 10 address lines
module ramdecoder(
	input [9:0] A,
	output [1023:0] MEM
	);

always_comb begin
	for(int bit_in_word = 0; bit_in_word < 1024; bit_in_word++) begin
 		MEM[bit_in_word] = 0;
 		if (bit_in_word==A)
 			MEM[bit_in_word] = 1;
	end
end 
	
endmodule