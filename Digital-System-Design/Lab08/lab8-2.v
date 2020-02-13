module lab8_2(CLKIN, CS, RS, SS, D, NC, NO,BQ, QM, QM_N, QS, QS_N, QFF);

//INPUTS
input wire CLKIN/*synthesis loc="1"*/;
input wire CS   /*synthesis loc="2"*/;
input wire RS   /*synthesis loc="3"*/;
input wire SS   /*synthesis loc="4"*/;
//input wire CM;
//input wire RM;
//input wire SM;
input wire D    /*synthesis loc="8"*/;
input wire NC   /*synthesis loc="9"*/;
input wire NO   /*synthesis loc="10"*/;


//OUTPUTS
output wire BQ   /*synthesis loc="23"*/;
output reg  QFF  /*synthesis loc="18"*/;
output wire QM   /*synthesis loc="17"*/;
output wire QM_N /*synthesis loc="16"*/;
output wire QS   /*synthesis loc="15"*/;
output wire QS_N /*synthesis loc="14"*/;

//step 3
assign CM = CLKIN;
assign SM = D;
assign RM = ~D;

// Bounceless Switch 
assign BQ = ~NO | (NC & BQ);

// Slave Latch 
assign QS = ~(~(SS&CS) & QS_N);
assign QS_N = ~(~(RS&CS) & QS);


// Master Latch 
assign QM = ~(~(SM&CM) & QM_N);
assign QM_N = ~(~(RM&CM) & QM);


// D flip-flop
always @(posedge CLKIN)
  begin
	QFF <= D;
  end
endmodule
