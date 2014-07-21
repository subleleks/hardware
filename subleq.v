
module subleq(
	input iClock,
	input iReset,
	output reg [12:0] IP
);

// =============================================================================
// counter
// =============================================================================
reg [1:0] counter;
initial begin
	counter <= 2'd0;
end
always @(posedge iClock) begin
	counter <= iReset ? 2'd0 : counter + 2'd1;
end

// =============================================================================
// IP
// =============================================================================
initial begin
	IP <= 13'd0;
end
always @(posedge iClock) begin
	if (iReset) begin
		IP <= 13'd0;
	end else if (counter == 2'd3) begin
		IP <= leq ? Instr[12:0] : IP + 13'd1;
	end
end

// =============================================================================
// memory
// =============================================================================
wire [63:0] q;
wire [12:0] address;
always @(IP, Instr, counter) begin
	case (counter)
		2'd0: address <= IP;
		2'd1: address <= q[38:26];
		default: address <= Instr[25:13]; // for states 2 and 3
	endcase
end
mem mem0(
	.address(address),
	.clock(iClock),
	.data(sub),
	.wren(counter == 2'd3),
	.q(q)
);

// =============================================================================
// auxiliary registers
// =============================================================================
reg [63:0] Instr, A;
always @(posedge iClock) begin
	if (counter == 2'd1) begin
		Instr <= q;
	end else if (counter == 2'd2) begin
		A <= q;
	end
end

// =============================================================================
// subleq
// =============================================================================
wire [63:0] sub;
assign sub = q - A;
wire leq;
assign leq = sub <= 0;

endmodule
