// here we implement a write back cache
module dcache(
	input	clock,
	input	reset,
	
	input	[3:0]	Dmem2proc_response,
	input	[3:0]	Dmem2proc_tag,
	input	[`DCACHE_BLOCK_SIZE-1:0]	Dmem2proc_data,
	
	input	[63:0]	proc2Dcache_addr,
	input	BUS_COMMAND	proc2Dcache_command,
	input	[`DCACHE_BLOCK_SIZE-1:0]	proc2Dcache_data,
	
	output	logic	[`DCACHE_BLOCK_SIZE-1:0]	Dcache2proc_data,
	output	logic	[3:0]	Dcache2proc_tag,
	output	logic	[3:0]	Dcache2proc_response,
	output	logic	hit	
	);
	
always_comb begin



end

always_ff()
endmodule


dcachemem dmem(
	
	
	);

dcachecontroller dcontroller(
	
	);