
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
	.iState(SW[9:8]),
	.iMaxClock(CLOCK_50),
	.iManualClock(KEY[0]),
	.iLimit(SW[7:0]),
	.oClock(wClock)
);
/*
wire [1:0] wcounter;
wire [12:0] wIP;
wire [63:0] wInstr;
wire [63:0] wA;
wire [63:0] wq;
wire [63:0] wsub;
subleq64 cpu64(
	.iClock(wClock),
	.iReset(~KEY[3]),
	.ocounter(wcounter),
	.oIP(wIP),
	.oInstr(wInstr),
	.oA(wA),
	.oq(wq),
	.osub(wsub)
);

always @(SW[15:13], wcounter, wIP, wInstr, wA, wq, wsub) begin
	case (SW[15:13])
		3'd0:		wDebug <= {62'b0, wcounter};
		3'd1:		wDebug <= {51'b0, wIP};
		3'd2:		wDebug <= wInstr;
		3'd3:		wDebug <= wA;
		3'd4:		wDebug <= wq;
		3'd5:		wDebug <= wsub;
		default:	wDebug <= 64'b0;
	endcase
end
*/
wire [2:0] wcounter;
wire [31:0] wIP;
wire [31:0] wA;
wire [31:0] wB;
wire [31:0] wJ;
wire [31:0] wq;
wire [31:0] wsub;
subleq32 cpu32(
	.iClock(wClock),
	.iReset(~KEY[3]),
	.ocounter(wcounter),
	.oIP(wIP),
	.oA(wA),
	.oB(wB),
	.oJ(wJ),
	.oq(wq),
	.osub(wsub)
);

always @(SW[15:13], wcounter, wIP, wA, wB, wJ, wq, wsub) begin
	case (SW[15:13])
		3'd0:		wDebug <= {61'b0, wcounter};
		3'd1:		wDebug <= {32'b0, wIP};
		3'd2:		wDebug <= {32'b0, wA};
		3'd3:		wDebug <= {32'b0, wB};
		3'd4:		wDebug <= {32'b0, wJ};
		3'd5:		wDebug <= {32'b0, wq};
		3'd6:		wDebug <= {32'b0, wsub};
		default:	wDebug <= 64'b0;
	endcase
end

wire [31:0] decoder7_num;
wire [63:0] wDebug;
assign decoder7_num = SW[17] ? wDebug[63:32] : wDebug[31:0];
decoder7 dec0(.in(decoder7_num[3:0]),   .out(HEX0));
decoder7 dec1(.in(decoder7_num[7:4]),   .out(HEX1));
decoder7 dec2(.in(decoder7_num[11:8]),  .out(HEX2));
decoder7 dec3(.in(decoder7_num[15:12]), .out(HEX3));
decoder7 dec4(.in(decoder7_num[19:16]), .out(HEX4));
decoder7 dec5(.in(decoder7_num[23:20]), .out(HEX5));
decoder7 dec6(.in(decoder7_num[27:24]), .out(HEX6));
decoder7 dec7(.in(decoder7_num[31:28]), .out(HEX7));

endmodule
