
module clock(
	input iStateClock,
	input [1:0] iState,
	input iMaxClock,
	input iManualClock,
	input [7:0] iLimit,
	output oClock
);

reg [1:0] state;
reg [31:0] slow_counter, fast_counter;
wire [31:0] slow_limit, fast_limit;

initial begin
	state <= 2'd0;
	slow_counter <= 32'd0;
	fast_counter <= 32'd0;
end

always @(posedge iStateClock) begin
	state <= iState;
end

assign slow_limit = {8'b0, iLimit, 16'b0};
assign fast_limit = {24'b0, iLimit};

always @(posedge iMaxClock) begin
	slow_counter <= (slow_counter != slow_limit) ? slow_counter + 32'd1 : 32'd0;
	fast_counter <= (fast_counter != fast_limit) ? fast_counter + 32'd1 : 32'd0;
end

always @(state) begin
	case (state)
		2'b00: oClock <= iManualClock;
		2'b01: oClock <= slow_counter == (slow_limit - 32'd1);
		2'b10: oClock <= fast_counter == (fast_limit - 32'd1);
		2'b11: oClock <= iMaxClock;
	endcase
end

endmodule
