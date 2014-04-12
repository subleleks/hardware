
module clock(
	input iCLK,
	input iMAX_CLK,
	input iMANUAL_CLK,
	input [7:0] iLIMIT,
	output oOUT_CLK,
	output reg [1:0] oSTATE
);

reg [31:0] fast_counter, slow_counter;
wire [31:0] fast_limit, slow_limit;

initial begin
	oSTATE <= 0;
	fast_counter <= 0;
	slow_counter <= 0;
end

always @(posedge iCLK) begin
	oSTATE <= oSTATE + 1;
end

assign fast_limit = {24'b0, iLIMIT};
assign slow_limit = {8'b0, iLIMIT, 16'b0};

always @(posedge iMAX_CLK) begin
	fast_counter <= (fast_counter < fast_limit) ? fast_counter + 1 : 0;
	slow_counter <= (slow_counter < slow_limit) ? slow_counter + 1 : 0;
end

always @(oSTATE) begin
	case (oSTATE)
		2'b00: oOUT_CLK <= iMANUAL_CLK;
		2'b01: oOUT_CLK <= slow_counter == slow_limit - 1;
		2'b10: oOUT_CLK <= fast_counter == fast_limit - 1;
		2'b11: oOUT_CLK <= iMAX_CLK;
		
		default: oOUT_CLK <= 0;
	endcase
end

endmodule
