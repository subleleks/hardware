
module subleq(
	input iClock,
	input iReset,
	output [2:0] ocounter,
	output [31:0] oIP,
	output [31:0] oA,
	output [31:0] oB,
	output [31:0] oJ,
	output [31:0] oq,
	output [31:0] osub,
	output oleq
);

// =============================================================================
// outputs
// =============================================================================
assign ocounter = counter;
assign oIP = IP;
assign oA = A;
assign oB = B;
assign oJ = J;
assign oq = q;
assign osub = sub;
assign oleq = leq;

// =============================================================================
// counter
// =============================================================================
reg [2:0] counter;
initial begin
	counter <= 3'd0;
end
always @(posedge iClock) begin
	counter <= (iReset || counter == 3'd5) ? 3'd0 : counter + 3'd1;
end

// =============================================================================
// IP
// =============================================================================
reg [31:0] IP;
initial begin
	IP <= 32'd0;
end
always @(posedge iClock) begin
	if (iReset) begin
		IP <= 32'd0;
	end else if (counter <= 3'd2) begin // in the first 3 cycles, increment
		IP <= IP + 32'd1;
	end else if (counter == 3'd5) begin // in the last cycle, jump or continue
		IP <= leq ? J : IP;
	end
end

// =============================================================================
// memory
// =============================================================================
wire [31:0] address;
wire [31:0] q;
always @(counter, IP, A, B) begin
	if (counter <= 3'd2) begin // in the first 3 cycles, address comes from IP
		address <= IP;
	end else if (counter == 3'd3) begin // in the fourth cycle, read A
		address <= A;
	end else begin // in the fifth cycle, read B. in the last cycle, write B
		address <= B;
	end
end
mem mem0(
	.address(address[12:0]),
	.clock(iClock),
	.data(sub),
	.wren(counter == 3'd5), // write in the last cycle
	.q(q)
);

// =============================================================================
// auxiliary registers
// =============================================================================
reg [31:0] A, B, J;
always @(posedge iClock) begin
	// register A. write A address in the second cycle and A itself in the fifth
	if (counter == 3'd1 || counter == 3'd4) begin
		A <= q;
	end
	
	// register B. write B address in the third cycle
	if (counter == 3'd2) begin
		B <= q;
	end
	
	// register J. write the jump address in the fourth cycle
	if (counter == 3'd3) begin
		J <= q;
	end
end

// =============================================================================
// subleq
// =============================================================================
wire [31:0] sub;
assign sub = q - A;
wire leq;
assign leq = sub <= 0;

endmodule
