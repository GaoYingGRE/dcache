module dcachemem(
	input	[`DCACHE_BLOCK_SIZE-1:0]	data_in,
	input	read_enable,
	input	write_enable,
	input	[`DCACHE_TAG_SIZE-1:0]	tag_in,
	input	[`DCACHE_INDEX_SIZE-1:0]	index_in,

	output	logic [`DCACHE_BLOCK_SIZE-1:0]	data_out,
	output	logic dirty,
	output	logic miss,
	output	dirty_tag,
	output	dirty_index
);

# here we have 1bit for valid, 1bit for dirty, 64 bit for data, 
# since we have 4-way associate cache, we will use 2 bit for index, 1KB cache, so 

logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0][`DCACHE_BLOCK_SIZE-1:0] internal_data;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0][`DCACHE_BLOCK_SIZE-1:0] n_internal_data;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0][`DCACHE_TAG_SIZE-1:0] internal_tag;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0][`DCACHE_TAG_SIZE-1:0] n_internal_tag;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0]	internal_valid;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0]	n_internal_valid;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0]	internal_dirty;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0]	n_internal_dirty;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0]	internal_reference;
logic [`DCACHE_INDEX_SIZE-1:0][`DCACHE_WAY_SIZE-1:0]	n_internal_reference;

logic tmp_way;

always_ff@(posedge clock) begin
	if(reset) begin
		internal_valid <= #1 0;
		internal_dirty <= #1 0;
		internal_data <= #1 0;
		internal_tag <= #1 0;
		internal_reference <= #1 0;
	end
	else begin
		internal_data <= #1 n_internal_data;
		internal_valid <= #1 n_internal_valid;
		internal_dirty <= #1 n_internal_dirty;
		internal_tag <= #1 n_internal_tag;
		internal_reference <= #1 n_internal_reference;
	end
end

always_comb begin
	n_internal_data = internal_data;
	n_internal_valid = internal_valid;
	n_internal_dirty = internal_dirty;
	n_internal_tag = internal_tag;
	n_internal_reference = internal_reference;
	tmp_way=0;
	data_out = 0;
	dirty_index=0;
	dirty_tag=0;
	dirty=0;
	if(internal_tag[index_in][1]==tag_in && internal_valid[index_in][1]==1) begin
		n_internal_reference[index_in][1]=1;
		n_internal_reference[index_in][0]=0;
		miss=0;
	end
	else if(internal_tag[index_in][0]==tag_in && internal_valid[index_in][0]==1) begin
		n_internal_reference[index_in][0]=1;
		n_internal_reference[index_in][1]=0;
		miss=0;
	end
	else begin
		miss=1;
	end

	if(miss==1) begin
		tmp_way = internal_reference[index_in][0]==0 ? 0:1;
		# evict 1
		if(read_enable || write_enable) begin
			dirty = internal_dirty[index_in][tmp_way];
			data_out = internal_data[index_in][tmp_way];
			dirty_tag = internal_tag[index_in][tmp_way];
			dirty_index = index_in;
		end
	end

	else if(miss==0) begin
		tmp_way = internal_tag[index_in][1]==tag_in ? 1:0;
		if(read_enable) begin
			data_out = internal_data[index_in][tmp_way];
		end
		else if(write_enable) begin
			n_internal_data[index_in][tmp_way] = data_in;
		end
	end

	
end