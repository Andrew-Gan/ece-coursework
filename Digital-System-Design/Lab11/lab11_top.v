module lab11_top (DIP,i_S1_NC,i_S1_NO,i_S2_NC,i_S2_NO,o_TOPRED,o_MIDRED,o_BOTRED,o_DIS1,o_DIS2,o_DIS3,o_DIS4,o_JUMBO,o_LED_YELLOW);

/*

ECE 270 Lab Experiment 11 - Spring 2019

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

// Bounceless switches - routed to (small) yellow LEDs
// RIGHT PB is S1 -> YEL_RGT, LEFT PB is S2 -> YEL_LFT

wire S1BC, S2BC;

bounceless_switch RGTPB(.CLR(S1_NC), .SET(S1_NO), .Q(S1BC));
bounceless_switch LFTPB(.CLR(S2_NC), .SET(S2_NO), .Q(S2BC));

assign YEL_RGT = S1BC;   // right pushbutton will be used for clocking sequence recognizer 
assign YEL_LFT = S2BC;   // left pushbutton will be used for asynchronous reset 

assign BOTRED = DIP;    // display state of DIP switches on bottom row of red LEDs

// ======================= DO NOT MODIFY ABOVE ============================

// Step 1 - Instantiate and test your scrolling display and message string generator (from Lab 10)
//          Modify it so that a new message starts immediately upon being selected

wire [6:0] lookup;
wire [1:0] msgnum;

//assign msgnum = DIP[1:0]; // comment out after testing

msggen STEP1A(.CLK(tim_div4), .RST(S2BC), .mSEL(msgnum), .outCHAR(lookup));
 
dispshift STEP1B(.CLK(tim_div4), .RST(S2BC), .inCHAR(lookup), .outDISP({DIS4,DIS3,DIS2,DIS1}));

// Step 2 - Instantiate your 3-bit binary counter module with integrated 3:8 decoder
//          It should have both an asynchronous reset (ARST) and a synchronous reset (SRST)
//          Clock this counter using the right pushbutton (S1BC)
//          It should also include an enable (EN)

wire[2:0] pointer;
wire syncrst, cnten;

//assign cnten = DIP[3];    // comment out after testing
//assign syncrst = DIP[2];  // comment out after testing

up_count_decode STEP2(.CLK(S1BC), .ARST(S2BC), .SRST(syncrst), .EN(cnten), .count_state(pointer), .count_decode(MIDRED));

//assign TOPRED[2:0] = pointer;  // comment out after testing

// Step 3 - Instantiate your 8-bit linear feedback shift register module
//          Use DIP[4] to control the LFSR enable and DIP[5] to show/hide its state

wire[7:0] randcombo;

 lfsr STEP3(.CLK(tim_div4), .RST(S2BC), .EN(DIP[4]), .qcombo(randcombo));

 assign TOPRED = randcombo & {8{DIP[5]}};  // AND with DIP[5] to "show/hide" LFSR state

// Step 4 - Instantiate your match detector that determines if the "input_combo_bit" matches
//          the corresponding "randcombo" bit (indexed by "pointer")

wire MO;  // MO=1 if input_combo_bit (entered on DIP[7]) matches corresponding random combo bit

 match_detect STEP4(.inBIT(DIP[7]), .rCOMBO(randcombo), .PTR(pointer), .match_out(MO));

// assign JUMBO[2] = MO;  // comment out after testing

// Step 5 - Instantiate your sequencer recognizer state machine
//          Synchronous relock is controlled by DIP[6]

wire [2:0] jumbo_leds;

 dcl STEP5(.CLK(S1BC), .ARST(S2BC), .inM(MO), .inR(DIP[6]), .outNMSG(msgnum), .outLED(jumbo_leds), .outSRST(syncrst), .outEN(cnten));

 assign JUMBO[2:1] = jumbo_leds[2:1];         // GRN and YEL
 assign JUMBO[0] = tim_div2 & jumbo_leds[0];  // blinking RED


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


// Step 1A - Display shift register (7-segment X 4) - copied from Lab 10

module dispshift(CLK, RST, inCHAR, outDISP);

  input wire CLK;
  input wire RST;
  input wire[6:0] inCHAR;
  output reg [27:0] outDISP;

// Place your code for Step 1A below

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

endmodule   // ------------ end of Step 1A


// Step 1B - Message string generator (lookup) - adapted from Lab 10
// Modify it so that a newly selected message starts immediately when mSEL changes

module msggen(CLK, RST, mSEL, outCHAR);

// mSEL = 0: blank
// mSEL = 1: SECURE
// mSEL = 2: OPEN
// mSEL = 3: ERROR

 input wire CLK;
 input wire RST;
 input wire [1:0] mSEL;
 output reg [6:0] outCHAR;
 reg [5:0] CQ;
 reg [5:0] next_CQ;

// 7-segment display code definitions
localparam blank = 7'b0000000;
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
localparam A00 = 6'd00;        	// ''
localparam A01 = 6'd01;		// ''
localparam A02 = 6'd02;		// ''
localparam A03 = 6'd03;		// S
localparam A04 = 6'd04;		// E
localparam A05 = 6'd05;		// C
localparam A06 = 6'd06; 	// u
localparam A07 = 6'd07; 	// r
localparam A08 = 6'd08; 	// E
localparam A09 = 6'd09;		// o
localparam A10 = 6'd10;		// P
localparam A11 = 6'd11;		// n
localparam A12 = 6'd12;		// r
localparam A13 = 6'd13;		// r
localparam A14 = 6'd14; 	// E (used by 'open')
localparam A15 = 6'd15;		// E (used by 'error')
localparam A16 = 6'd16; 	// r (used by 'error')
localparam A17 = 6'd17;		// o (used by 'error')
localparam A18 = 6'd18; 	// r (used by 'error')

// Place your code for Step 1B below

always @(posedge RST, posedge CLK) begin
  if(RST == 1'b1) begin
    if(mSEL == 2'b00)
      next_CQ = A00;
    else if(mSEL == 2'b01)
      next_CQ = A03;
    else if(mSEL == 2'b10)
      next_CQ = A09;
    else if(mSEL == 2'b11)
      next_CQ = A08;
  end
  else begin
    if(mSEL == 2'b00)
      next_CQ = A00;
    else if(mSEL == 2'b01) begin
      if(CQ == A08)
        next_CQ = A00;
      else if (CQ <= A07)
        next_CQ = CQ + 1;
      else
        next_CQ = A03;
    end
    else if(mSEL == 2'b10) begin
      if(CQ == A09 | CQ == A00 | CQ == A01)
        next_CQ = CQ + 1;
      else if(CQ == A10)
        next_CQ = A14;
      else if(CQ == A14)
        next_CQ = A11;
      else if(CQ == A11)
        next_CQ = A00;
      else
        next_CQ = A09;
    end
    else if(mSEL == 2'b11) begin
      if(CQ == A15)
        next_CQ = A16;
      else if(CQ == A16)
        next_CQ = A13;
      else if(CQ == A13)
        next_CQ = A17;
      else if(CQ == A17)
        next_CQ = A18;
      else if(CQ == A18)
        next_CQ = A00;
      else if(CQ == A00 | CQ == A01)
        next_CQ = CQ + 1;
      else
        next_CQ = A15;
    end
  end
  CQ = next_CQ;
end

always @(CQ) begin
  if(CQ == A00 | CQ == A01 | CQ == A02)
    outCHAR = blank;
  else if(CQ == A03)
    outCHAR = charS;
  else if(CQ == A04 | CQ == A08 | CQ == A14 | CQ == A15)
    outCHAR = charE;
  else if(CQ == A05)
    outCHAR = charC;
  else if(CQ == A06)
    outCHAR = charU;
  else if(CQ == A07 | CQ == A12 | CQ == A13 | CQ == A16 | CQ == A18)
    outCHAR = charR;
  else if(CQ == A09 | CQ == A17)
    outCHAR = charO;
  else if(CQ == A10)
    outCHAR = charP;
  else if(CQ == A11)
    outCHAR = charN;
end

endmodule  // ------------ end of Step 1B


// Step 2 - Binary up counter with integrated decoder - adapted from Lab 9
// Decoded outputs are used as a "pointer" to the current combination digit

  module up_count_decode(CLK, ARST, SRST, EN, count_state, count_decode);

  input wire CLK;
  input wire ARST;   // asynchronous reset
  input wire SRST;   // synchronous reset
  input wire EN;     // counter enable
  output reg [2:0] count_state;
  output reg [7:0] count_decode;
  reg [2:0] next_count_state;

// Place your code for Step 2 below

  always @(posedge CLK, posedge ARST) begin
    if(SRST == 1'b1 | ARST == 1'b1)
      next_count_state = 2'b0;
    else if(EN == 1'b1)
      next_count_state = next_count_state + 1;
    count_state = next_count_state;
    count_decode = 8'b00000000;
    count_decode[count_state] = 1'b1;
  end

  endmodule   // ----------- end of Step 2

// Step 3 - Linear feedback shift register to generate random combination

module lfsr(CLK, RST, EN, qcombo);

input wire CLK, RST, EN; 
output reg [7:0] qcombo;

// Place your code for Step 3 below

always @(posedge CLK, posedge RST) begin
  if(EN == 1'b1) begin
    qcombo[0] <= qcombo[0] ^ qcombo[7];
    qcombo[1] <= qcombo[1] ^ qcombo[0];
    qcombo[2] <= qcombo[2] ^ qcombo[1];
    qcombo[3] <= qcombo[3] ^ qcombo[2];
    qcombo[4] <= qcombo[4] ^ qcombo[3] ^ qcombo[2] ^ qcombo[0];
    qcombo[5] <= qcombo[5] ^ qcombo[4];
    qcombo[6] <= qcombo[6] ^ qcombo[5];
    qcombo[7] <= qcombo[7] ^ qcombo[6] ^ qcombo[5] ^ qcombo[1];
  end
  if(RST == 1'b1) begin
    qcombo <= 8'b00000001;
  end
end

endmodule   // ----------- end of Step 3



// Step 4 - Combination match detector

module match_detect(inBIT, rCOMBO, PTR, match_out);

input wire inBIT;
input wire [7:0] rCOMBO;
input wire [2:0] PTR;
output reg match_out;

// Place your code for Step 4 below
reg [7:0] storedVal;

always @(inBIT) begin 
  if(rCOMBO[PTR] == inBIT)
    match_out = 1'b1;
  else
    match_out = 1'b0;
end

endmodule   // ----------- end of Step 4


// Step 5 - Sequence recognizer (digital combination lock) state machine

module dcl(CLK, ARST, inM, inR, outNMSG, outLED, outSRST, outEN);

input wire CLK, ARST;
input wire inM;  // match input (inM = 1 if corresponding bits of combo match)
input wire inR;  // (synchronous) relock control input
output reg [1:0] outNMSG;  // number of message to scroll
output reg [2:0] outLED;  // GRN[2], YEL[1], RED[0]
output reg outSRST;  // synchronous reset for combination pointer
output reg outEN;  // enable control for combination pointer
reg [3:0] qstate, next_qstate;  // state of combination detector

localparam SECURE = 4'd0;
localparam ENTER1 = 4'd1;
localparam ENTER2 = 4'd2;
localparam ENTER3 = 4'd3;
localparam ENTER4 = 4'd4;
localparam ENTER5 = 4'd5;
localparam ENTER6 = 4'd6;
localparam ENTER7 = 4'd7;
localparam OPEN   = 4'd8;
localparam ERROR  = 4'd9;

// Place your code for Step 5 below

always @(posedge CLK, posedge ARST, posedge inR) begin
  if(ARST == 1'b1)
    next_qstate = SECURE;
  else if(inR == 1'b1) begin
    if(qstate == OPEN)
      next_qstate = SECURE;
  end
  else if(qstate < ENTER7) begin
    next_qstate = qstate + 1;
    if(inM == 0)
      next_qstate = ERROR;
  end
  else if(qstate == ENTER7) begin
    if(inM == 1)
      next_qstate = OPEN;
    else
      next_qstate = ERROR;
  end
end

always @(next_qstate) begin
  if(next_qstate == SECURE) begin 		// if set to initial locked state
    outNMSG = 2'b01; 				// print 'secure'
    outLED = 3'b000; 				// illuminate 'nothing'
    outSRST = 1'b0;				// do not reset pointer
    outEN = 1'b1; 				// pointer 'unfroze'
  end
  else if(next_qstate == OPEN) begin		// if input correct
    outNMSG = 2'b10; 				// print 'open'
    outLED = 3'b100; 				// illuminate 'green'
    outSRST = 1'b1;				// reset pointer
    outEN = 1'b0; 				// pointer 'froze'
  end
  else if(next_qstate == ERROR) begin 		// if input incorrect
    outNMSG = 2'b11;				// print 'error'
    outLED = 3'b001;				// illuminate 'red'
    outSRST = 1'b1;				// reset pointer
    outEN = 1'b0;				// pointer 'froze'
  end
  else begin					// when providing input
    outNMSG = 2'b00;
    outLED = 3'b010;				// illuminate 'yellow' 
    outSRST = 1'b0;
  end						// do not reset pointer   
  qstate = next_qstate;
end


endmodule   // ----------- end of Step 5
