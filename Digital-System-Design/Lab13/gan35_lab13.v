module lab13_top (DIP,i_S1_NC,i_S1_NO,i_S2_NC,i_S2_NO,o_TOPRED,o_MIDRED,o_BOTRED,o_DIS1,o_DIS2,o_DIS3,o_DIS4,o_JUMBO,o_LED_YELLOW);

/*

ECE 270 Lab Experiment 13 - Spring 2019

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
wire [2:0] JUMBO;            // JUMBO[2] = GRN, JUMBO1] = YEL, JUMBO[0] = RED
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

// Bounceless switches - routed to (small) yellow LEDs
// RIGHT PB is S1 -> YEL_RGT, LEFT PB is S2 -> YEL_LFT

wire S1BC, S2BC;

bounceless_switch RGTPB(.CLR(S1_NC), .SET(S1_NO), .Q(S1BC));
bounceless_switch LFTPB(.CLR(S2_NC), .SET(S2_NO), .Q(S2BC));

assign YEL_RGT = S1BC;   // right pushbutton will be used for clocking sequence recognizer 
assign YEL_LFT = S2BC;   // left pushbutton will be used for asynchronous reset 

assign BOTRED = DIP;    // display state of DIP switches on bottom row of red LEDs


// ====================================== DO NOT MODIFY ABOVE ========================================



// Step 1 - Instantiate and test the memory editor provided
//          Comment out all verification code for Step 1 once it has been tested

/*
wire [3:0] dummy4;
wire [3:0] hexaddr;
wire [6:0] hexdata;

assign dummy4 = 4'b0000;

memory STEP1 (.ECLK(S1BC), .WCLK(S2BC), .MWE(1'b1), .RunEdit(DIP[7]), .iADDR(dummy4), .oADDR(hexaddr), .iDATA(DIP[6:0]), .oDATA(hexdata));
hex2dis STEP1A (.inHEX(hexdata[3:0]), .outDIS(DIS1));
hex2dis STEP1B (.inHEX({1'b0,hexdata[6:4]}), .outDIS(DIS2));   // memory data displayed on DIS2:DIS1
hex2dis STEP1C (.inHEX(hexaddr), .outDIS(DIS3));               // memory address displayed on DIS3
*/


// Step 2 - Instantiate and test your program counter
//          Comment out all verification code for Step 2 once it has been tested

/*
wire [3:0] hexaddr;
pc STEP2 (.CLK(S1BC), .RST(S2BC), .PCC(DIP[7]), .POA(DIP[6]), .oADDR(hexaddr));
hex2dis STEP2A (.inHEX(hexaddr), .outDIS(DIS1));
*/




// Step 3 - Instantiate and test your instruction register
//          Comment out all verification code for Step 3 once it has been tested

/*
wire [3:0] hexaddr;
wire [2:0] opcode;
wire [3:0] hexopcode;
ir STEP3 (.CLK(S1BC), .IRL(DIP[7]), .IRA(S2BC), .iDATA(DIP[6:0]), .oOPCODE(opcode), .oADDR(hexaddr));
hex2dis (.inHEX(hexaddr), .outDIS(DIS1));
assign hexopcode = {1'b0,opcode};
hex2dis (.inHEX(hexopcode), .outDIS(DIS4));
*/



// Step 4 - Instantiate and test your ALU
//          Comment out all verification code for Step 4 once it has been tested


// alu STEP4 (.CLK(S1BC), .ALE(DIP[7]), .ALX(DIP[6]), .ALY(DIP[5]), .AOE(DIP[4]), .iDATA(DIP[3:0]), .oDATA(TOPRED[3:0]), .qCC(TOPRED[7:4]));



// Step 5 - Complete the instruction decoder and microsequencer module (you will need to add the system control equations)
//          Instantiate the entire simple computer, using the modules from Steps 1-4 along with the IDMS module provided

wire mwe, pcc, poa, irl, ira, ale, alx, aly, aoe, ipe, ope;

wire cpuclk, memeclk;  // S1BC routing for run/edit mode selection on DIP[7]
wire start, memwclk;   // S2BC routing for run/edit mode selection on DIP[7]
wire memmwe, runstop;

wire [3:0] addrbus;   // address bus
wire [3:0] pcaddr;    // PC address bus output
wire [3:0] iraddr;    // IR address bus output
wire [6:0] dataobus;  // data bus output from memory
wire [6:0] memidata;  // memory input data
wire [3:0] aluodata;  // ALU data output (for STA and OUT) instructions
wire [3:0] aluidata;  // ALU data input

wire [3:0] DIS3hex;
wire [3:0] DIS4hex;
wire [6:0] DIS4o;
wire [2:0] opcode;
wire [3:0] hexeaddr;

assign cpuclk = S1BC & ~DIP[7];   //  DIP[7]=0 -> run mode
assign start = S2BC & ~DIP[7];
assign memeclk = S1BC & DIP[7];   //  DIP[7]=1 -> memory edit mode  (S1BC advances memory pointer)
assign memwclk = (S2BC & DIP[7]) | (S1BC & ~DIP[7]);      // clock for memory write (when MWE = 1)

assign memmwe = mwe | DIP[7];

mux21x7 STEP1A (.A({3'b000,aluodata}), .B(DIP[6:0]), .SEL(DIP[7]), .F(memidata));
memory  STEP1B (.ECLK(memeclk), .WCLK(memwclk), .MWE(memmwe), .RunEdit(DIP[7]), .iADDR(addrbus), .oADDR(hexeaddr), .iDATA(memidata), .oDATA(dataobus));
hex2dis STEP1C (.inHEX(dataobus[3:0]), .outDIS(DIS1));
hex2dis STEP1D (.inHEX({1'b0,dataobus[6:4]}), .outDIS(DIS2));
mux21x4 STEP1E (.A(addrbus), .B(hexeaddr), .SEL(DIP[7]), .F(DIS3hex));
hex2dis STEP1F (.inHEX(DIS3hex), .outDIS(DIS3));

assign addrbus = pcaddr | iraddr;

pc STEP2 (.CLK(cpuclk), .RST(start), .PCC(pcc), .POA(poa), .oADDR(pcaddr));

ir STEP3 (.CLK(cpuclk), .IRL(irl), .IRA(ira), .iDATA(dataobus), .oOPCODE(opcode), .oADDR(iraddr));
assign TOPRED[2:0] = opcode;

mux21x4 STEP4A (.A(dataobus[3:0]), .B(DIP[3:0]), .SEL(ipe), .F(aluidata));
alu STEP4B (.CLK(cpuclk), .ALE(ale), .ALX(alx), .ALY(aly), .AOE(aoe), .iDATA(aluidata), .oDATA(aluodata), .qCC(TOPRED[7:4]));

idms STEP5A (.CLK(cpuclk),.START(start),.SQ(TOPRED[3]),.RUN(runstop),.OP(opcode),.MWE(mwe),.PCC(pcc),.POA(poa),.IRL(irl),.IRA(ira),.ALE(ale),.ALX(alx),.ALY(aly),.AOE(aoe),.IPE(ipe),.OPE(ope));

outport STEP5B (.CLK(cpuclk), .RST(start), .OPE(ope), .iDATA(aluodata), .oDATA(DIS4hex));
hex2dis STEP5C (.inHEX(DIS4hex), .outDIS(DIS4o));
assign DIS4 = {7{~DIP[7]}} & DIS4o;

assign JUMBO[2] = runstop & ~DIP[7];   // green JUMBO -> run mode
assign JUMBO[0] = ~runstop;            // red JUMBO -> machine halted (or switched to memry edit mode)
assign JUMBO[1] = DIP[7];              // yellow JUMBO -> in memory edit mode

assign MIDRED = {ale,alx,aly,aoe,irl,ira,pcc,poa};   // display system control signals on MIDRED



endmodule  // ================================================= end of top-level module ====================================================


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


// 2:1 multiplexer module - 4-bits wide (provided)

module mux21x4 (A, B, SEL, F);

 input wire [3:0] A,B;
 input wire SEL;
 output wire [3:0] F;

 assign F = ({4{~SEL}}) & A | ({4{SEL}}) & B;

endmodule



// 2:1 multiplexer module - 7-bits wide (provided)

module mux21x7 (A, B, SEL, F);

 input wire [6:0] A,B;
 input wire SEL;
 output wire [6:0] F;

 assign F = ({7{~SEL}}) & A | ({7{SEL}}) & B;

endmodule



// Output port (provided)

module outport (CLK, RST, OPE, iDATA, oDATA);

 input wire CLK, RST, OPE;
 input wire [3:0] iDATA;
 output reg [3:0] oDATA;

 always @ (posedge CLK or posedge RST) begin
  if(RST == 1'b1) begin
     oDATA <= 4'b0000;
  end else 
  if (OPE == 1'b1) begin
     oDATA <= iDATA;
  end
 end

endmodule




// HEX digit to 7-segment display code converter module (provided)

 module hex2dis(inHEX, outDIS);

 input wire [3:0] inHEX;
 output reg [6:0] outDIS;

// 7-segment display code definitions for BCD digits
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

  always @ (inHEX) begin
   case(inHEX)
    4'd0: outDIS = char0;
    4'd1: outDIS = char1;
    4'd2: outDIS = char2;
    4'd3: outDIS = char3;
    4'd4: outDIS = char4;
    4'd5: outDIS = char5;
    4'd6: outDIS = char6;
    4'd7: outDIS = char7;
    4'd8: outDIS = char8;
    4'd9: outDIS = char9;
    4'hA: outDIS = charA;
    4'hB: outDIS = charB;
    4'hC: outDIS = charC;
    4'hD: outDIS = charD;
    4'hE: outDIS = charE;
    4'hF: outDIS = charF;
   endcase
 end
 endmodule


// Memory editor module (provided)

 module memory(ECLK, WCLK, MWE, RunEdit, iADDR, oADDR, iDATA, oDATA);

// Note: No MSL or MOE signals required since there are separate "data in" and "data out" busses
// Write to selected location occurs when MWE is asserted and a positive edge on WCLK occurs

   input wire ECLK;         // clock to advance memory pointer in edit mode
   input wire WCLK;         // write iDATA to memory clock
   input wire MWE;          // memory write enable (for STA instruction)
   input wire RunEdit;      // 0 - run program, 1 - edit memory
   input wire [3:0] iADDR;  // memory address (run mode)
   output reg [3:0] oADDR;  // memory address to display (edit mode)
   input wire [6:0] iDATA;  // memory write data (either run or edit mode)
   output wire [6:0] oDATA; // memory read data (either run or edit mode)

   reg [6:0] MEM[15:0];     // memory array (16 x 7)

   always @ (posedge ECLK) begin
     if (RunEdit == 1'b1) begin
       oADDR <= oADDR + 1;
     end else begin
       oADDR <= oADDR;
     end
   end
   
   assign oDATA = RunEdit ? MEM[oADDR]: MEM[iADDR];

   always @ (posedge WCLK) begin
     if (RunEdit == 1'b1) begin
        MEM[oADDR] <= iDATA;
     end else begin
     if (MWE == 1'b1) begin
        MEM[iADDR] <= iDATA;
     end
     end
   end
       
 endmodule  



// =================================================================================================

// Student-written Verilog modules should be inserted below - do not modify modules provided (above)

// =================================================================================================



// Step 2 - Program counter

module pc(CLK, RST, PCC, POA, oADDR);

// NOTE: Tri-state buffers are not used for on-chip busses
// POA will simply be ANDed with (qPC) for output on oADDR
// The on-chip "address bus" will simply be the OR of the
//   various "on chip" address sources (here, PC and IR)

 input wire CLK;           // system clock
 input wire RST;           // asynchronous reset
 input wire PCC;           // PC count enable
 input wire POA;           // PC output enable
 output wire [3:0] oADDR;  // address "bus"

 reg [3:0] qPC;            // program counter bits

// Place your code for Step 2 below

 assign oADDR = {4{POA}} & qPC;

 always @(posedge CLK, posedge RST) begin
   if(RST == 1'b1)
     qPC = 4'b0000;
   else if(PCC == 1'b1)
     qPC = qPC + 1;
 end


endmodule   // ---------------------------- end of Step 2




// Step 3 - Instruction register

module ir(CLK, IRL, IRA, iDATA, oOPCODE, oADDR);

// NOTE: Tri-state buffers are not used for on-chip busses
// IRA will simply be ANDed with (qIR) for output on oADDR
// The on-chip "address bus" will simply be the OR of the
//   various "on chip" address sources (here, PC and IR)

 input wire CLK;             // system clock
 input wire IRL;             // IR load enable
 input wire IRA;             // IR output on address bus enable
 input wire [6:0] iDATA;     // input data bus
 output wire [3:0] oADDR;    // output address bus
 output wire [2:0] oOPCODE;  // opcode output to IDMS

 reg [6:0] qIR;              // instruction register bits

// Place your code for Step 3 below

 assign oOPCODE = qIR[6:4];
 assign oADDR   = {4{IRA}} & qIR[3:0];

 always @(posedge CLK) begin
   if(IRL == 1'b1)
     qIR = iDATA;
 end


endmodule   // ---------------------------- end of Step 3




// Step 4A - 4-bit radix adder/subtractor module with condition codes ("flags")
//           Import the code for CLA4 you wrote for Lab 12 - NO CHANGES should be necessary

module cla4(X, Y, M, S, oCF, oZF, oNF, oVF);

 input wire [3:0] X, Y;	        // Operands (X+Y or X-Y)
 input wire M;                  // add/subtract mode: 0-add, 1-subtract
 output wire [3:0] S;	        // Sum outputs
 output wire oCF, oZF, oNF, oVF;// Condition code outputs

 wire [3:0] C;		        // Carry equations  
 wire [3:0] P, G;		// Propagation and Generation

// Place your cod for Step 3 below

 assign P = X ^ (Y ^ {4{M}});
 assign G = X & (Y ^ {4{M}});
 assign C[3:1] = G[3:1] | C[2:0] & P[3:1];
 assign C[0] = G[0] | M & P[0];
 assign S[3:1] = P[3:1] ^ C[2:0];
 assign S[0] = P[0] ^ M;
 
 assign oCF = C[3];
 assign oZF = ~(S[3] | S[2] | S[1] | S[0]);
 assign oNF = S[3];
 assign oVF = ~(X[3] ^ Y[3] ^ M) & (X[3] ^ S[3]); 

endmodule   // ----------- end of Step 4A



// Step 4B - Arithmetic logic unit module
//           This module will include an instantiation of your CLA4 module    

module alu(CLK, ALE, ALX, ALY, AOE, iDATA, oDATA, qCC);

/*  4-bit, 4-function ALU with separate data in and data out busses

    ADD:  (qA[3:0]) <- (qA[3:0]) + iDATA[3:0]
    SUB:  (qA[3:0]) <- (qA[7:0]) - iDATA[3:0]
    LDA:  (qA[3:0]) <- iDATA[3:0]
    AND:  (qA[3:0]) <- (qA[3:0]) & iDATA[3:0]
    OUT:  Value in qA[3:0] output on oDATA[3:0]

    AOE  ALE  ALX  ALY   Function    CF  ZF  NF  VF
    ===  ===  ===  ===   ========    ==  ==  ==  ==
     0    1    0    0    ADD         X   X   X   X
     0    1    0    1    SUB         X   X   X   X
     0    1    1    0    LDA         -   X   X   - 
     0    1    1    1    AND         -   X   X   - 
     1    0    d    d    OUT         -   -   -   -
     0    0    d    d    <none>      -   -   -   - 
 
      X -> flag affected   - -> flag not affected
 
     Note: If ALE = 0, the state of all register bits should be retained 
*/

 input wire CLK;          // system clock
 input wire ALE;          // ALU enable
 input wire ALX, ALY;     // ALU function select
 input wire AOE;          // data output enable
 input wire [3:0] iDATA;  // input data bus
 output wire [3:0] oDATA; // output data bus
 output wire [3:0] qCC;    // condition code register (CF-ZF-NF-VF)

 output wire [3:0] qA;            // A register
 
// Place your code for Step 4B below
// NOTE: It should include an instantiation of your CLA4 module

 reg [3:0] X, Y;
 wire [3:0] qwCC;
 reg M;

 cla4 STEP4B(X, Y, M, qA, qwCC[3], qwCC[2], qwCC[1], qwCC[0]);
 assign qCC[3:0] = {AOE, ALE, ALX, ALY} == 4'b0100 | {AOE, ALE, ALX, ALY} == 4'b0101 ? qwCC[3:0] : {1'bz, qwCC[2:1], 1'bz};
 
 assign oDATA = AOE & ~ALE ? qA : oDATA;		// OUT 4'bzzzz

 always @(posedge CLK) begin
   case ({AOE, ALE, ALX, ALY})
     4'b0100 : {X, Y, M} = {qA,        iDATA, 1'b0}; 	// ADD
     4'b0101 : {X, Y, M} = {qA,        iDATA, 1'b1};	// SUB
     4'b0110 : {X, Y, M} = {4'd0,       iDATA, 1'b0};	// LDA
     4'b0111 : {X, Y, M} = {qA & iDATA, 4'd0, 1'b0};	// AND
     default;
   endcase
 end


endmodule   // ----------- end of Step 4B


// Step 5 - Complete the IDMS (instruction decoder and microsequencer) module - adapted from class notes 
//          The only part missing is the "system control" set of equations

module idms(CLK, START, SQ, RUN, OP, MWE, PCC, POA, IRL, IRA, ALE, ALX, ALY, AOE, IPE, OPE);
                             
  input wire CLK;
  input wire START;			// asynchronous START pushbutton (reset)
  input wire [2:0] OP;			// opcode bits (input from IR5..IR7)
  output wire MWE;		        // memory write enable (MSL and MOE not needed)
  output wire PCC, POA;		        // PC control signals
  output wire IRL, IRA;		        // IR control signals
  output wire ALE, ALX, ALY, AOE;	// ALU control signals
  output wire IPE;                      // input port enable
  output wire OPE;                      // output port enable

  output reg SQ;                        // state counter
  output reg RUN;                       // run/halt state

  reg next_SQ;					

  wire LDA,STA,ADD,SUB,AND,HLT,INA,OUA;	// opcode names
  wire [1:0] S;			        // state variables

  wire RUN_ar; 			        // asynchronous reset for RUN

  assign HLT = ~OP[2] & ~OP[1] & ~OP[0];	// HLT opcode = 000
  assign LDA = ~OP[2] & ~OP[1] &  OP[0];	// LDA opcode = 001
  assign ADD = ~OP[2] &  OP[1] & ~OP[0];	// ADD opcode = 010
  assign SUB = ~OP[2] &  OP[1] &  OP[0];	// SUB opcode = 011
  assign AND =  OP[2] & ~OP[1] & ~OP[0];	// AND opcode = 100
  assign STA =  OP[2] & ~OP[1] &  OP[0];	// STA opcode = 101
  assign INA =  OP[2] &  OP[1] & ~OP[0];        // INA opcode = 110
  assign OUA =  OP[2] &  OP[1] &  OP[0];        // OUT opcode = 111
  
// Decoded state definitions
  assign S[0] = ~SQ;	// fetch
  assign S[1] =  SQ;	// execute

  // State counter
  always @ (posedge CLK or posedge START) begin
    if(START == 1'b1)	// start in fetch state
      SQ <= 1'b0;
    else 		// if RUN negated, resets SQ
      SQ <= next_SQ;
    end

  always @ (SQ, RUN) begin
    next_SQ = RUN & ~SQ;
  end

  // Run/stop
  assign RUN_ar = S[1] & HLT;
  always @ (posedge RUN_ar or posedge START) begin
    RUN <= 1'b0;
    if(START == 1'b1) begin
      // RUN set to 1 when START asserted
      RUN <= 1'b1;
    end
    else if(RUN_ar == 1'b1)
    begin
      // RUN is cleared when HLT is executed
      RUN <= 1'b0;
    end
  end 

 // System control equations (NOT provided)
 // Place your code for Step 5 below

  assign MWE = S[1] & STA;
  assign PCC = S[0] & RUN;
  assign POA = S[0];
  assign IRL = S[0] & RUN;
  assign IRA = S[1] & (LDA | ADD | SUB | AND | STA | INA | OUA);
  assign AOE = S[1] & (STA | OUA);
  assign ALE = S[1] & RUN & (LDA | ADD | SUB | AND | INA);
  assign ALX = S[1] & (LDA | AND);
  assign ALY = S[1] & (SUB | AND);
  assign IPE = S[1] & INA;
  assign OPE = S[1] & OUA;

endmodule
