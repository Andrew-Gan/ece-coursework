module Lab7_dorm(S,I,DP,Y);
	input wire S;		// equivalent of I[7]
	input wire [0:6] I;
	output wire DP;		// equivalent of Y[7]
	output wire [0:6] Y;
	reg [0:6] DISP;

	always @* begin	
		DISP = I[0] ? 7'b1110111 : 7'b0111110;	
		if((I[0] == 1) & (I[1] | I[2] | I[3] | I[4] | I[5] | I[6] | S == 1)) begin
			casez (I)
			7'b?100000 : DISP = 7'b0110000;
			7'b??10000 : DISP = 7'b1101101;
			7'b???1000 : DISP = 7'b1111001;
			7'b????100 : DISP = 7'b0110011;
			7'b?????10 : DISP = 7'b1011011;
			7'b??????1 : DISP = 7'b1011111;
			endcase
			if(S == 1)
			DISP = 7'b1110000;
		end
	end

	assign Y = ~DISP;
endmodule

