
module top(
	input CLOCK_50,
	input [3:0] KEY,
	input [17:0] SW,
	output [8:0] LEDG,
	output [17:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7
);

wire wClock;
clock clock0(
	.iStateClock(KEY[1]),
	.iMaxClock(CLOCK_50),
	.iManualClock(KEY[0]),
	.iLimit(SW[7:0]),
	.oClock(wClock),
	.oState(LEDG[1:0])
);

subleq cpu(
	.iClock(wClock),
	.iReset(~KEY[3])
);

wire [31:0] decoder7_num;
assign decoder7_num = 32'h0ACEF0DA;
decoder7 dec0(.in(decoder7_num[3:0]),   .out(HEX0));
decoder7 dec1(.in(decoder7_num[7:4]),   .out(HEX1));
decoder7 dec2(.in(decoder7_num[11:8]),  .out(HEX2));
decoder7 dec3(.in(decoder7_num[15:12]), .out(HEX3));
decoder7 dec4(.in(decoder7_num[19:16]), .out(HEX4));
decoder7 dec5(.in(decoder7_num[23:20]), .out(HEX5));
decoder7 dec6(.in(decoder7_num[27:24]), .out(HEX6));
decoder7 dec7(.in(decoder7_num[31:28]), .out(HEX7));

endmodule
