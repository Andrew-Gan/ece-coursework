module Lab7(S,I,DP,Y);
	input wire S;		// equivalent of I[7]
	input wire [0:6] I;
	output wire DP;		// equivalent of Y[7]
	output wire [0:6] Y;
	
	assign Y[0] = I[0];
	assign Y[1] = I[1];
	assign Y[2] = I[2];
	assign Y[3] = I[3];
	assign Y[4] = I[4];
	assign Y[5] = I[5];
	assign Y[6] = I[6];
	assign DP = S;
endmodule
