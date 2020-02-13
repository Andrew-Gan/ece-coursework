module myLP (DIP, i_S1_NC, i_S1_NO, i_S2_NC, i_S2_NO, o_TOPRED, o_MIDRED, o_BOTRED, 
             o_DIS1, o_DIS2, o_DIS3, o_DIS4, o_JUMBO, o_YEL);

/*

ECE 270 Lab Practical Exam - Spring 2018

IMPORTANT - Place your solution code where indicated

Name: ?
Login ID: ?
Lab Div: ?

*/

// ====== DO NOT MODIFY BELOW ======

// DIP switches (MSB...LSB)
input wire [7:0] DIP /*synthesis loc="26,25,24,23,76,77,78,79"*/;		

// ACTIVE LOW pushbutton contacts 
// S1 is on RIGHT, S2 is on LEFT
input wire i_S1_NC /*synthesis loc="58"*/;					
input wire i_S1_NO /*synthesis loc="59"*/;					
input wire i_S2_NC /*synthesis loc="60"*/;					
input wire i_S2_NO /*synthesis loc="61"*/;					

// ACTIVE LOW red LEDs (MSB..LSB)
output wire [7:0] o_TOPRED /*synthesis loc="28,29,30,31,32,33,39,40"*/;			
output wire [7:0] o_MIDRED /*synthesis loc="130,131,132,133,134,135,138,139"*/;		
output wire [7:0] o_BOTRED /*synthesis loc="112,111,105,104,103,102,101,100"*/;		

// ACTIVE LOW 7-segment displays (DIS4..DIS1)
output wire [6:0] o_DIS1 /*synthesis loc="87,86,85,84,83,81,80"*/;			
output wire [6:0] o_DIS2 /*synthesis loc="98,97,96,95,94,93,88"*/;			
output wire [6:0] o_DIS3 /*synthesis loc="125,124,123,122,121,120,116"*/;		
output wire [6:0] o_DIS4 /*synthesis loc="44,48,49,50,51,52,53"*/;	
		
// ACTIVE LOW jumbo LEDs (unused, RED, YELLOW, GREEN)
output wire [3:0] o_JUMBO /*synthesis loc="143,142,141,140*/;
			
// ACTIVE LOW yellow LEDs (next to pushbuttons, left..right)
output wire [1:0] o_YEL /*synthesis loc="63,62*/;				

// ACTIVE HIGH level conversions
wire S1_NC, S1_NO, S2_NC, S2_NO;
wire [7:0] TOPRED;
wire [7:0] MIDRED;
wire [7:0] BOTRED;
wire [6:0] DIS1;
wire [6:0] DIS2;
wire [6:0] DIS3;
wire [6:0] DIS4;
wire J_unused, J_RED, J_YEL, J_GRN;
wire YEL_RGT, YEL_LFT;

assign S1_NC = ~i_S1_NC;
assign S1_NO = ~i_S1_NO;
assign S2_NC = ~i_S2_NC;
assign S2_NO = ~i_S2_NO;
assign o_TOPRED = ~TOPRED;
assign o_MIDRED = ~MIDRED;
assign o_BOTRED = ~BOTRED;
assign o_DIS1 = ~DIS1;
assign o_DIS2 = ~DIS2;
assign o_DIS3 = ~DIS3;
assign o_DIS4 = ~DIS4;
assign o_JUMBO = {~J_unused, ~J_GRN, ~J_YEL, ~J_RED};
assign o_YEL = {~YEL_RGT, ~YEL_LFT};


// Internal oscillator
wire osc_dis, tmr_rst, osc_out, tmr_out;
assign osc_dis = 1'b0;
assign tmr_rst = 1'b0;

defparam I1.TIMER_DIV = "1048576";
OSCTIMER I1 (.DYNOSCDIS(osc_dis), .TIMERRES(tmr_rst), .OSCOUT(osc_out), .TIMEROUT(tmr_out));


// 7-segment alphanumeric display code
localparam blank = 7'b0000000;
localparam char0 = 7'b1111110;
localparam char1 = 7'b0110000;
localparam char2 = 7'b1101101;
localparam char3 = 7'b1111001;
localparam char4 = 7'b0110011;
localparam char5 = 7'b1011011;
localparam char6 = 7'b1011111;
localparam char7 = 7'b1110000;
localparam char8 = 7'b1111111;
localparam char9 = 7'b1111011;
localparam charA = 7'b1110111;
localparam charB = 7'b0011111;
localparam charC = 7'b1001110;
localparam charD = 7'b0111101;
localparam charE = 7'b1001111;
localparam charF = 7'b1000111;
localparam charG = 7'b1111011;
localparam charH = 7'b0110111;
localparam charI = 7'b0010000;
localparam charJ = 7'b0111000;
localparam charL = 7'b0001110;
localparam charN = 7'b0010101;
localparam charO = 7'b0011101;
localparam charP = 7'b1100111;
localparam charR = 7'b0000101;
localparam charS = 7'b1011011;
localparam charU = 7'b0111110;
localparam charY = 7'b0111011;


// Bounceless Switches - routed to (small) yellow LEDs
// RIGHT PB is S1 -> YEL_RGT, LEFT PB is S2 -> YEL_LFT

wire S1BC, S2BC;

bounceless_switch RGTPB(.CLR(S1_NC), .SET(S1_NO), .Q(S1BC));
bounceless_switch LFTPB(.CLR(S2_NC), .SET(S2_NO), .Q(S2BC));

assign YEL_RGT = S1BC;  
assign YEL_LFT = S2BC;  

// ====== DO NOT MODIFY ABOVE ======

// add your Lab Practical code here

wire ALE, ALX, ALY;
reg [3:0] AQ, qCC;
wire [3:0] next_AQ, next_qCC;
reg [3:0] X, Y;
reg M;
reg [20:0] DISP;

assign BOTRED[7:0] = DIP[7:0];
assign {ALE, ALX, ALY} = DIP[7:5];
assign TOPRED[3:0] = AQ;
assign TOPRED[7:4] = ALE == 1'b0 ? 4'bzzzz : ALE & (ALX ^ ALY) ? qCC : ALE & ~(ALX | ALY) ? {1'b0, qCC[2], qCC[1], 1'b0} : {1'bz, qCC[2], qCC[1], 1'bz};
assign {DIS3, DIS2, DIS1} = DISP;

cla4 LP(X, Y, M, next_AQ, next_qCC[3], next_qCC[2], next_qCC[1], next_qCC[0]);

always @(posedge S1BC, posedge S2BC) begin
  if(S2BC == 1'b1) begin
    AQ  = 4'b0000;
    qCC = 4'b0000;
  end
  else if(S1BC == 1'b1) begin
    case ({ALE, ALX, ALY})
      3'b100 : {X, Y, M} = {DIP[3:0], 	4'b0000, 	1'b0};
      3'b101 : {X, Y, M} = {DIP[3:0], 	AQ,	 	1'b0};
      3'b110 : {X, Y, M} = {AQ, 	DIP[3:0],      	1'b1};
      3'b111 : {X, Y, M} = {DIP[3:0] & AQ, 	4'b0000, 1'b0};
    endcase
    case ({ALE, ALX, ALY})
      3'b100 : DISP = {charL, charD, charA};
      3'b101 : DISP = {charA, charD, charD};
      3'b110 : DISP = {charS, charU, charB};
      3'b111 : DISP = {charA, charN, charD};
    endcase
    {AQ, qCC} = {next_AQ, next_qCC};
  end
end 

endmodule

module cla4(X, Y, M, S, oCF, oZF, oNF, oVF);
  input wire [3:0] 	X, Y;		// X, Y parameters
  input wire		M;		// M selector
  wire [3:0] 		P, G;			// propagate and generate
  output wire [3:0]	S;
  output wire 		oCF, oZF, oNF, oVF;	// four flags

  assign P = X ^ (Y ^ {4{M}});
  assign G = X & (Y ^ {4{M}});
  assign S = (P ^ (G << 1)) + M;
  assign oCF = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
  assign oZF = ~(S[3] | S[2] | S[1] | S[0]);
  assign oNF = S[3];
  assign oVF = ~P & (X[3] ^ S[3]);

// 0110
// 0010 minus should = 1101
// p = 1011
// g = 0100
// g << 1 = 1000
// p ^ g = 0011
// p ^ g + 1 = 0100

endmodule

// ====== DO NOT MODIFY BELOW ======
 
module bounceless_switch(CLR, SET, Q);

// Force Verilog to synthesize a D flip-flop with
//   asynchronous set and clear inputs

// Functions as an S-R latch

input CLR;
input SET;
output reg Q;

wire CLK;
wire D;

assign CLK = 1'b0;
assign D = 1'b0;

always @(posedge CLK, posedge SET, posedge CLR)
begin
	if (CLR == 1'b1) begin
		Q <= 1'b0;
	end else if (SET == 1'b1) begin
		Q <= 1'b1;
	end else begin
		Q <= D;
	end
end

endmodule
