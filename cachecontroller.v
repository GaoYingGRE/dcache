module dcachecontroller(
	//response is for the new one
	input	[3:0]	Dmem2proc_response,
	//tag is for the finished one
	input	[3:0]	Dmem2proc_tag,
	input	[`DCACHE_BLOCK_SIZE-1:0]	Dmem2proc_data,
	
	input	[63:0]	proc2Dcache_addr,
	input	BUS_COMMAND	proc2Dcache_command,
	
	input	[`DCACHE_BLOCK_SIZE-1:0]	cachemem_data,
	input	cachemem_miss,
	input	cachemem_dirty,
	input	cachemem_tag,
	input	cachemem_index,
	
	output	BUS_COMMAND	proc2Dmem_command,
	output	logic	[63:0]	proc2Dmem_addr,
	
	output	logic	[`DCACHE_INDEX_SIZE-1:0]	index_out,
	output	logic	[`DCACHE_TAG_SIZE-1:0]	tag_out,
	output	logic	read_enable,
	output	logic	write_enable,
	output	logic	[`DCACHE_BLOCK_SIZE-1:0]	data_out,
	output	logic	[3:0]	mem_response,
	output	logic	[3:0]	mem_tag,
	output	logic	stall
	
	);
	
	logic	[15:0][63:0]	internal_waiting_addr;
	logic	[15:0][63:0]	n_internal_waiting_addr;
	assign n_internal_waiting_addr = internal_waiting_addr;
	
	always_ff@(posedge clock) begin
		if(reset) begin
			internal_waiting_addr <= #1 0;		
		end
		else begin
			internal_waiting_addr <= #1 n_internal_waiting_addr;
		end
	
	end
	
	always_comb begin
		write_enable=0;
		read_enable=0;
		proc2Dmem_command=`BUS_NONE;
		proc2Dmem_addr=0;
		index_out=0;
		tag_out=0;
		mem_response=Dmem2proc_response;
		mem_tag=Dmem2proc_tag;
		stall=0;
		if(Dmem2proc_tag!=0) begin
			stall=1;
			write_enable=1;
			{index_out, tag_out}=internal_waiting_addr[Dmem2proc_tag];
			data_out=Dmem2proc_data,
		end
		else if(cachemem_dirty) begin
			stall=1;
			data_out=cachemem_data;
			proc2Dmem_command = `BUS_STORE;
			proc2Dmem_addr={cachemem_index, cachemem_tag};
		end
		else begin
			if(proc2Dcache_command==`BUS_LOAD) begin
				read_enable=1;
				{index_out, tag_out}=proc2Dcache_addr;
				if(cachemem_miss) begin
					n_internal_waiting_addr[Dmem2proc_response]=proc2Dcache_addr;
					proc2Dmem_command = `BUS_LOAD;
					proc2Dmem_addr=proc2Dcache_addr;
				end
				else begin
					data_out=cachemem_data;				
				end			
			end
			else if(proc2Dcache_command==`BUS_STORE) begin
				write_enable=1;
				{index_out, tag_out}=proc2Dcache_addr;
				if(cachemem_miss) begin
					n_internal_waiting_addr[Dmem2proc_response]=proc2Dcache_addr;
					proc2Dmem_command = `BUS_LOAD;
					proc2Dmem_addr=proc2Dcache_addr;
					stall=1;
				end
			end
		end
	end
	
	
endmodule