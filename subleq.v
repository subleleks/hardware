
module subleq(
	input iCLK,
	input iRST
);

// =============================================================================
// counter
// =============================================================================
reg [1:0] counter;
initial begin
	counter <= 0;
end
always @(posedge iCLK) begin
	counter <= (iRST || counter[1]) ? 0 : counter + 1;
end

// =============================================================================
// IP
// =============================================================================
reg [12:0] IP;
initial begin
	IP <= 0;
end
always @(posedge iCLK) begin
	IP <= iRST ? 0 : (~counter[1] ? IP : (leq ? Jaddr + IP : IP + 1));
end

// =============================================================================
// memory
// =============================================================================
wire [63:0] q_a, q_b;
mem mem0(
	.address_a(counter[0] ? q_a[38:26] + IP : IP),
	.address_b(counter[0] ? q_a[25:13] + IP : Baddr + IP),
	.clock(iCLK),
	.data_a(0),
	.data_b(sub),
	.wren_a(0),
	.wren_b(counter[1]),
	.q_a(q_a),
	.q_b(q_b)
);

// =============================================================================
// auxiliary registers
// =============================================================================
reg [12:0] Baddr, Jaddr;
always @(posedge iCLK) begin
	Baddr <= counter[0] ? q_a[25:13] : Baddr;
	Jaddr <= counter[0] ? q_a[12:0]  : Jaddr;
end

// =============================================================================
// subleq
// =============================================================================
wire [63:0] sub;
assign sub = q_b - q_a;
wire leq;
assign leq = sub <= 0;

endmodule
