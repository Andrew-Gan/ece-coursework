module lab9_top (DIP,i_S1_NC,i_S1_NO,i_S2_NC,i_S2_NO,o_TOPRED,o_MIDRED,o_BOTRED,o_DIS1,o_DIS2,o_DIS3,o_DIS4,o_JUMBO,o_LED_YELLOW);

/*

ECE 270 Lab Experiment 9 - Spring 2019

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
assign osc_dis = ~DIP[1];  // DIP[1] used to enable/disable osc output
assign tmr_rst = 1'b0;

defparam I1.TIMER_DIV = "1048576";
OSCTIMER I1 (.DYNOSCDIS(osc_dis), .TIMERRES(tmr_rst), .OSCOUT(osc_out), .TIMEROUT(tmr_out));

// Frequency divider (for on-chip oscillator) - reset controlled by DIP[0]
frequency_divider FDIVBY2 (.clk(tmr_out),.rst(DIP[0]),.clk_out(tim_div));

// Bounceless switches - routed to (small) yellow LEDs
// RIGHT PB is S1 -> YEL_RGT, LEFT PB is S2 -> YEL_LFT

wire S1BC, S2BC;

bounceless_switch RGTPB(.CLR(S1_NC), .SET(S1_NO), .Q(S1BC));
bounceless_switch LFTPB(.CLR(S2_NC), .SET(S2_NO), .Q(S2BC));

assign YEL_RGT = S1BC;  
assign YEL_LFT = S2BC;  

// ====== DO NOT MODIFY ABOVE ======

// Step 1 -------------------------------------------------

// 7-segment display code definitions for Step 1
  localparam charG = 7'b1111011;
  localparam charO = 7'b0011101;
  localparam charP = 7'b1100111;
  localparam charU = 7'b0111110; 
  localparam blank = 7'b0000000;
  
  reg [27:0] STRING;     // 4-character string to output on 7-segment LEDs

  assign BOTRED = DIP;
  assign {DIS4,DIS3,DIS2,DIS1} = STRING;
/* 
  always @(DIP) 
      begin 
	if (DIP[7] == 1) begin 
	   STRING = {charG,charO,charP,charU};
	end
	else begin 
	   STRING ={blank,blank,blank,blank};
      end
  end
*/

// end Step 1 ---- (comment out "always" block above when finished with Step 1)

// Step 2 - binary up counters with undivided and divided internal clock

wire [3:0] countL;
wire [3:0] countR;
assign TOPRED = {countL,countR};
/*
up_down_counter STEP2U (.clk(tmr_out),.rst(DIP[0]),.dir(1'b1),.countout(countL));  // undivided clock
up_down_counter STEP2D (.clk(tim_div),.rst(DIP[0]),.dir(1'b1),.countout(countR));  // divided clock
*/

// Step 3 - binary up counters (with bouncy switch demo)

//up_down_counter STEP3deboun (.clk(S1BC),.rst(DIP[0]),.dir(1'b1),.countout(countL));
//up_down_counter STEP3bouncy (.clk(S1_NO),.rst(DIP[0]),.dir(1'b1),.countout(countR));

// Step 4 - binary up/down count mode

up_down_counter STEP4L (.clk(S2BC),.rst(DIP[0]),.dir(DIP[6]),.countout(countL));  // up/down
up_down_counter STEP4R (.clk(S1BC),.rst(DIP[0]),.dir(1'b1),.countout(countR));    // up only

// Step 5 - 7-segment hexadecimal display of counter values

wire [6:0] hexL;
wire [6:0] hexR;
 
bintohex DIS4H (.binin(countL),.hexout(hexL));
bintohex DIS1H (.binin(countR),.hexout(hexR));

// Write a procedural block that used DIP[7] to select what to display

always @ (DIP) begin
  if(DIP[7] == 1)
    STRING = {charG,charO,charP,charU};
  else
    STRING = {hexL,blank,blank,hexR};
end

// Step 6 - Self-correcting 8-bit ring counter

ring_counter STEP6 (.clk(tim_div),.rst(DIP[0]),.ringout(MIDRED));

// Step 7 - Moore model light sequencer from class notes

moorelsa_sd STEP8 (.clk(tim_div),.reset(DIP[0]),.mode({DIP[3],DIP[2]}),.out(JUMBO)); 

endmodule  // end of top-level module ------------------------------------------------

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

  // Up/down 4-bit binary counter module - used in Steps 2-4

  module up_down_counter(clk, rst, dir, countout);

  input wire clk;
  input wire rst;
  input wire dir; // dir = 1 for up, 0 for down 
  output reg [3:0] countout;

 // Place your up/down counter code below
  always @ (posedge clk) begin
    if(dir == 1'b1)
      countout <= countout + 1;
    else
      countout <= countout - 1;
    if(rst == 1'b1)
     countout <= 0;
  end

  endmodule // end of up/down counter module

  // Step 5 - Binary (hex) code to 7-segment display code conversion module

  module bintohex(binin,hexout);

  // 7-segment hexadecimal display code definitions
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

  input wire [3:0] binin;
  output reg [6:0] hexout; 

// Place your code for bintohex below
  always @ (binin) begin
    case (binin)
      4'd0 : hexout = char0;
      4'd1 : hexout = char1;
      4'd2 : hexout = char2;
      4'd3 : hexout = char3;
      4'd4 : hexout = char4;
      4'd5 : hexout = char5;
      4'd6 : hexout = char6;
      4'd7 : hexout = char7;
      4'd8 : hexout = char8;
      4'd9 : hexout = char9;
      4'd10: hexout = charA;
      4'd11: hexout = charB;
      4'd12: hexout = charC;
      4'd13: hexout = charD;
      4'd14: hexout = charE;
      4'd15: hexout = charF;
    endcase
  end
 
  endmodule   // end of bintohex module

// Step 6 - Ring counter module

module ring_counter(clk, rst, ringout);

input wire clk;
input wire rst;
output reg [7:0] ringout;

// Place your for the self-starting ring counter below
reg [7:0] next_OUT;

always @(posedge clk) begin
  ringout <= next_OUT; 
end 

always @(*) begin 
  if(rst == 1'b0) begin 
    next_OUT[7] = ringout[6];
    next_OUT[6] = ringout[5];
    next_OUT[5] = ringout[4];
    next_OUT[4] = ringout[3];
    next_OUT[3] = ringout[2];
    next_OUT[2] = ringout[1];
    next_OUT[1] = ringout[0];
    next_OUT[0] = (ringout[6:0] == 7'd0);
  end
end

endmodule   // end of ring_counter module

// Moore model of light sequence generator module from class notes (provided)

module moorelsa_sd (clk, reset, mode, out);

input wire clk;
input wire reset;
input wire [1:0] mode;

output reg [2:0] out;
reg [2:0] present_state;
reg [2:0] next_state; 

localparam A0 = 3'b000;
localparam A1 = 3'b001;
localparam A2 = 3'b010;
localparam A3 = 3'b011;
localparam A4 = 3'b100;
localparam A5 = 3'b101;
localparam A6 = 3'b110;
localparam A7 = 3'b111;

// State machine always block 

always @(posedge clk) begin
	if (reset == 1) 
	  present_state <= A0;
	else  
	  present_state <= next_state; 
end 

// Next state combinational logic

always @(mode or present_state) begin 
	case (present_state) 
		A0: begin 
			if (mode == 2'b00)      next_state = A4;
		    	else if (mode == 2'b01) next_state = A1;
		    	else if (mode == 2'b10) next_state = A4;
		    	else if (mode == 2'b11) next_state = A1;
		    end 
		A1: begin 
			if (mode == 2'b00)      next_state = A0;
		    	else if (mode == 2'b01) next_state = A2;
		    	else if (mode == 2'b10) next_state = A0;
		    	else if (mode == 2'b11) next_state = A3;
		    end 
		A2: begin 
			if (mode == 2'b00)      next_state = A1;
		    	else if (mode == 2'b01) next_state = A4;
		    	else if (mode == 2'b10) next_state = A0;
		    	else if (mode == 2'b11) next_state = A0;
		    end 
		A3: begin 
			if (mode == 2'b00)      next_state = A0;
		    	else if (mode == 2'b01) next_state = A0;
		    	else if (mode == 2'b10) next_state = A0;
		    	else if (mode == 2'b11) next_state = A7;
		    end 
		A4: begin 
			if (mode == 2'b00)      next_state = A2;
		    	else if (mode == 2'b01) next_state = A0;
		    	else if (mode == 2'b10) next_state = A6;
		    	else if (mode == 2'b11) next_state = A0;
		    end 
		A5: begin 
		    	next_state = A0;
		    end 
		A6: begin 
			if (mode == 2'b00)      next_state = A0;
		    	else if (mode == 2'b01) next_state = A0;
		    	else if (mode == 2'b10) next_state = A7;
		    	else if (mode == 2'b11) next_state = A0;
		    end 
		A7: begin 
			if (mode == 2'b00)      next_state = A0;
		    	else if (mode == 2'b01) next_state = A0;
		    	else if (mode == 2'b10) next_state = A0;
		    	else if (mode == 2'b11) next_state = A0;
		    end
		endcase
	end 

// Output combinational logic

always @(present_state) begin 
	case(present_state) 
		A0: out = A0; 
		A1: out = A1; 
		A2: out = A2; 
		A3: out = A3; 
		A4: out = A4; 
		A5: out = A5; 
		A6: out = A6; 
		A7: out = A7;
	endcase 
end 

endmodule  
