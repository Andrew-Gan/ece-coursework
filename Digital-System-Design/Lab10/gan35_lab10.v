module lab10_top (DIP,i_S1_NC,i_S1_NO,i_S2_NC,i_S2_NO,o_TOPRED,o_MIDRED,o_BOTRED,o_DIS1,o_DIS2,o_DIS3,o_DIS4,o_JUMBO,o_LED_YELLOW);

/*

ECE 270 Lab Experiment 10 - Spring 2019

IMPORTANT - Edit in your identifying information below.
Your completed file must be submitted on-line in order to receive credit for this experiment.

Name: Andrew Gan
Login ID: gan35
Lab Div: 9

*/

// ====== DO NOT MODIFY BELOW ======

// DIP switches (MSB on the left)
input wire [7:0] DIP /*synthesis loc="26,25,24,23,76,77,78,79"*/;		

// ACTIVE LOW pushbutton contacts 
// S1 is on RIGHT, S2 is on LEFT
input wire i_S1_NC /*synthesis loc="58"*/;		// ACTIVE LOW normally closed (down position)
input wire i_S1_NO /*synthesis loc="59"*/;		// ACTIVE LOW normally opened (up position)
input wire i_S2_NC /*synthesis loc="60"*/;		// ACTIVE LOW normally closed (down position)
input wire i_S2_NO /*synthesis loc="61"*/;		// ACTIVE LOW normally opened (up position)

// ACTIVE LOW red LEDs (MSB..LSB)
output wire [7:0] o_TOPRED /*synthesis loc="28,29,30,31,32,33,39,40"*/;		// ACTIVE LOW first row of LED (from top, MSB on the left)
output wire [7:0] o_MIDRED /*synthesis loc="130,131,132,133,134,135,138,139"*/;	// ACTIVE LOW second row of LED (from top, MSB on the left)
output wire [7:0] o_BOTRED /*synthesis loc="112,111,105,104,103,102,101,100"*/;	// ACTIVE LOW third row of LED (from top, MSB on the left)

// ACTIVE LOW 7-segment displays (DIS4..DIS1)
output wire [6:0] o_DIS1 /*synthesis loc="87,86,85,84,83,81,80"*/;		// ACTIVE LOW right-most 7-segment
output wire [6:0] o_DIS2 /*synthesis loc="98,97,96,95,94,93,88"*/;		// ACTIVE LOW second-right most 7-segment
output wire [6:0] o_DIS3 /*synthesis loc="125,124,123,122,121,120,116"*/;	// ACTIVE LOW second left-most 7-segment
output wire [6:0] o_DIS4 /*synthesis loc="44,48,49,50,51,52,53"*/;		// ACTIVE LOW left-most 7-segment

// ACTIVE LOW jumbo LEDs (RED, YELLOW, GREEN)
output wire [2:0] o_JUMBO /*synthesis loc="142,141,140"*/;		// ACTIVE LOW Jumbo G-Y-R LED (GREEN, YELLOW, RED)
// ACTIVE LOW yellow LEDs (next to pushbuttons, left..right)
output wire [1:0] o_LED_YELLOW /*synthesis loc="62,63"*/;		// ACTIVE LOW yellow LED next to pushbuttons

// ACTIVE HIGH I/O level conversions
wire S1_NC, S1_NO, S2_NC, S2_NO;
wire [7:0] TOPRED;
wire [7:0] MIDRED;
wire [7:0] BOTRED;
wire [6:0] DIS1;
wire [6:0] DIS2;
wire [6:0] DIS3;
wire [6:0] DIS4;
wire [2:0] JUMBO;            // JUMBO_G = [2], JUMBO_Y = [1], JUMBO_R = [0]
wire YEL_LFT, YEL_RGT;

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
assign o_JUMBO = ~JUMBO;
assign o_LED_YELLOW = {~YEL_LFT, ~YEL_RGT};

// On-chip oscillator - enable/disable controlled by DIP[1]
wire osc_dis, tmr_rst, osc_out, tmr_out;
assign osc_dis = 1'b0;  
assign tmr_rst = 1'b0; 

defparam I1.TIMER_DIV = "1048576";  // largest clock divisor possible for device = 2 ^ 20
OSCTIMER I1 (.DYNOSCDIS(osc_dis), .TIMERRES(tmr_rst), .OSCOUT(osc_out), .TIMEROUT(tmr_out));

// Frequency divider (for on-chip oscillator)

wire tim_div2;
wire tim_div4;

frequency_divider FDIVBY2 (.clk(tmr_out), .rst(S2BC), .clk_out(tim_div2));
frequency_divider FDIVBY4 (.clk(tim_div2), .rst(S2BC), .clk_out(tim_div4));

assign JUMBO = {tim_div4, tim_div2, tmr_out};  // JUMBO LEDs display clocking signals

// Bounceless switches - routed to (small) yellow LEDs
// RIGHT PB is S1 -> YEL_RGT, LEFT PB is S2 -> YEL_LFT

wire S1BC, S2BC;

bounceless_switch RGTPB(.CLR(S1_NC), .SET(S1_NO), .Q(S1BC));
bounceless_switch LFTPB(.CLR(S2_NC), .SET(S2_NO), .Q(S2BC));

assign YEL_RGT = S1BC;   // right pushbutton will be used for manual clocking 
assign YEL_LFT = S2BC;   // left pushbutton will be used for asynchronous reset 

assign BOTRED = DIP;    // display state of DIP switches on bottom row of red LEDs

// ======================= DO NOT MODIFY ABOVE ============================

// Step 1 - Verify the functionality of the top level module provided

// Step 2 - Instantiate and test your scrolling display shift register

// dispshift STEP2(.CLK(S1BC) /*.CLK(tim_div4)*/, .RST(S2BC), .inCHAR(DIP[6:0]), .outDISP({DIS4,DIS3,DIS2,DIS1}));

// Step 3 - Instantiate your character sequence generator state machine
//          Comment out the "dispshift" instantiation used for Step 2

 wire [6:0] lookup;

msggen STEP3A(.CLK(tim_div4), .RST(S2BC), .mSEL(DIP[1:0]), .outCHAR(lookup));
dispshift STEP3B(.CLK(tim_div4), .RST(S2BC), .inCHAR(lookup), .outDISP({DIS4,DIS3,DIS2,DIS1}));

// Step 4 - Instantiate your 4-bit Johnson counter (route output to right-most MIDRED)

 wire [3:0] johnstate;
 assign MIDRED [3:0] = johnstate;

john4sc J4BIT(/*.CLK(S1BC)*/ .CLK(tim_div2), .RST(S2BC), .Q(johnstate));

// Step 5 - Instantiate your Johnson counter state decoder (route output to TOPRED)

 wire [8:1] johnseq;
 assign TOPRED = johnseq;

johndec J4DEC(.inJSTATE(johnstate), .outDECODE(johnseq));


endmodule  // =========== end of top-level module =================================================

// Bounceless switch module (provided)

  module bounceless_switch(CLR, SET, Q);

  input wire CLR;
  input wire SET;
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

// Clock frequency divider module (provided)

  module frequency_divider(clk, rst, clk_out);

  input wire clk;
  input wire rst;
  output reg clk_out;

  always @(posedge clk, posedge rst)
  begin
	if (rst == 1'b1) begin
		clk_out <= 0;
	end else begin
		clk_out <= ! clk_out; 
	end
  end 

  endmodule


// Step 2 - Display shift register (7-segment X 4)

module dispshift(CLK, RST, inCHAR, outDISP);

  input wire CLK;
  input wire RST;
  input wire[6:0] inCHAR;
  output reg [27:0] outDISP;

// Place your code for Step 2 below

  always @ (posedge CLK, posedge RST) begin
    if(RST == 1'b1)
      outDISP <= 28'd0;
    else begin
      outDISP[6:0]   <= inCHAR;
      outDISP[13:7]  <= outDISP[ 6: 0];
      outDISP[20:14] <= outDISP[13: 7];
      outDISP[27:21] <= outDISP[20:14];
    end
  end

endmodule   // ------------ end of Step 2


// Step 3 - Message string generator (lookup)

module msggen(CLK, RST, mSEL, outCHAR);

 input wire CLK;
 input wire RST;
 input wire [1:0] mSEL;
 output reg [6:0] outCHAR;
 reg [5:0] CQ;
 reg [5:0] next_CQ;

// 7-segment display code definitions
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

// State name definitions
localparam A00 = 6'd00;		// xxxg
localparam A01 = 6'd01;		// xxgo
localparam A02 = 6'd02;		// xgox
localparam A03 = 6'd03;		// goxP
localparam A04 = 6'd04;		// oxPU
localparam A05 = 6'd05;		// xPUr
localparam A06 = 6'd06; 	// PUrd
localparam A07 = 6'd07; 	// UrdU
localparam A08 = 6'd08; 	// rdUE
localparam A09 = 6'd09; 	// dUEx
localparam A10 = 6'd10; 	// UExx
localparam A11 = 6'd11; 	// Exxx	
localparam A12 = 6'd12; 	// xxxn
localparam A13 = 6'd13; 	// xxno
localparam A14 = 6'd14; 	// xnoI
localparam A15 = 6'd15; 	// noIS
localparam A16 = 6'd16; 	// oISE
localparam A17 = 6'd17; 	// ISEx
localparam A18 = 6'd18; 	// SExx
localparam A19 = 6'd19; 	// Exxx
localparam A20 = 6'd20; 	// xxxb
localparam A21 = 6'd21; 	// xxbo
localparam A22 = 6'd22; 	// xboI
localparam A23 = 6'd23; 	// boIL
localparam A24 = 6'd24; 	// oILE
localparam A25 = 6'd25; 	// ILEr
localparam A26 = 6'd26;		// LErx
localparam A27 = 6'd27;		// ErxU
localparam A28 = 6'd28; 	// rxUP
localparam A29 = 6'd29; 	// xUPx
localparam A30 = 6'd30; 	// UPxx
localparam A31 = 6'd31; 	// Pxxx
localparam A32 = 6'd32; 	// xxxI
localparam A33 = 6'd33; 	// xxIU
localparam A34 = 6'd34; 	// xIUx
localparam A35 = 6'd35; 	// IUxL
localparam A36 = 6'd36; 	// UxLo
localparam A37 = 6'd37; 	// xLoS
localparam A38 = 6'd38; 	// LoSE
localparam A39 = 6'd39; 	// oSEr
localparam A40 = 6'd40; 	// SErS
localparam A41 = 6'd41; 	// ErSx
localparam A42 = 6'd42; 	// rSxx
localparam A43 = 6'd43;		// Sxxx
// That should be enough...add more if you wish

// Place your code for Step 3 below
always @(posedge CLK, posedge RST) begin
  if(CQ == A11 | CQ == A19 | CQ == A31 | CQ == A43) begin
    if(mSEL == 2'b00)
      next_CQ = A00;
    else if(mSEL == 2'b01)
      next_CQ = A12;
    else if(mSEL == 2'b10)
      next_CQ = A20;
    else if(mSEL == 2'b11)
      next_CQ = A32;
    end
  else
    next_CQ = CQ + 1;
  if(RST == 1'b1)
    CQ = A11;
  else
    CQ = next_CQ;
end

always @(CQ) begin
  if(CQ == A00)
    outCHAR = charG;
  else if(CQ == A01 | CQ == A13 | CQ == A21 | CQ == A36)
    outCHAR = charO;
  else if(CQ == A02 | CQ == A09 | CQ == A10 | CQ == A11 | CQ == A17 | CQ == A18 | CQ == A19 | CQ == A26 | CQ == A29 | CQ == A30 | CQ == A31 | CQ == A34 | CQ == A41 | CQ == A42 | CQ == A43)
    outCHAR = blank;
  else if(CQ == A03 | CQ == A28)
    outCHAR = charP;
  else if(CQ == A04 | CQ == A07 | CQ == A27 | CQ == A33)
    outCHAR = charU;
  else if(CQ == A05 | CQ == A25 | CQ == A39)
    outCHAR = charR;
  else if(CQ == A06)
    outCHAR = charD;
  else if(CQ == A08 | CQ == A16 | CQ == A24 | CQ == A38)
    outCHAR = charE;
  else if(CQ == A12)
    outCHAR = charN;
  else if(CQ == A14 | CQ == A22 | CQ == A32)
    outCHAR = charI;
  else if(CQ == A15 | CQ ==  A37 | CQ == A40)
    outCHAR = charS;
  else if(CQ == A20)
    outCHAR = charB;
  else if(CQ == A23 | CQ == A35)
    outCHAR = charL;
end

endmodule  // ------------ end of Step 3

// Step 4 - Self-Starting 4-bit Johnson Counter

module john4sc(CLK, RST, Q);
	
  input wire CLK; 
  input wire RST;	
  output reg [3:0] Q; 

// Place your code for Step 4 below

always @(posedge CLK, posedge RST) begin
  if(RST == 1'b1)
    Q <= 4'b0000;
  else begin
    Q[3] <= Q[2];
    Q[2] <= Q[1];
    Q[1] <= Q[0];
    Q[0] <= ~Q[3];
  end
end

endmodule  // ------------ end of Step 4

// Step 5 - Johnson Counter State Decoder

module johndec(inJSTATE, outDECODE);

  input wire [3:0] inJSTATE;
  output wire [8:1] outDECODE;
  
// Place your code for Step 5 below
  assign outDECODE[1] = ~inJSTATE[3] & ~inJSTATE[0];
  assign outDECODE[2] =  inJSTATE[0] & ~inJSTATE[1];
  assign outDECODE[3] =  inJSTATE[1] & ~inJSTATE[2];
  assign outDECODE[4] =  inJSTATE[2] & ~inJSTATE[3];
  assign outDECODE[5] =  inJSTATE[3] &  inJSTATE[0];
  assign outDECODE[6] = ~inJSTATE[0] &  inJSTATE[1];
  assign outDECODE[7] = ~inJSTATE[1] &  inJSTATE[2];
  assign outDECODE[8] = ~inJSTATE[2] &  inJSTATE[3];

endmodule  // ------------ end of Step 5
