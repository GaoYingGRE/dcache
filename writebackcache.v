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
	output	BUS_COMMAND	proc2Dmem_command,
	output	logic	[63:0]	proc2Dmem_addr,
	output	logic	stall	
	);


dcachemem dmem(
	.data_in(Dmem2proc_data),
	.read_enable(read_enable),
	.write_enable(write_enable),
	.tag_in(dmem_tag),
	.index_in(dmem_index),

# output
	.data_out(cachemem_data),
	.dirty(cachemem_dirty),
	.miss(cachemem_miss),
	.dirty_tag(cachemem_tag),
	.dirty_index(cachemem_index)
	);

dcachecontroller dcontroller(
		# //response is for the new one
	.Dmem2proc_response,
	# //tag is for the finished one
	.Dmem2proc_tag,
	.Dmem2proc_data(Dmem2proc_data),
	
	.proc2Dcache_addr,
	.proc2Dcache_command,
	
	.cachemem_data(cachemem_data),
	.cachemem_miss(cachemem_miss),
	.cachemem_dirty(cachemem_dirty),
	.cachemem_tag(cachemem_tag),
	.cachemem_index(cachemem_index),
	
	# output
	.proc2Dmem_command(proc2Dmem_command),
	.proc2Dmem_addr(proc2Dmem_addr),
	
	.index_out(dmem_index),
	.tag_out(dmem_tag),
	.read_enable(read_enable),
	.write_enable(write_enable),
	.data_out(Dcache2proc_data),
	.mem_response(Dcache2proc_response),
	.mem_tag(Dcache2proc_tag),
	.stall(stall)
	);
