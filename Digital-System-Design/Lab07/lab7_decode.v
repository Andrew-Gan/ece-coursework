module Lab7_decode(S,I,DP,Y);
	input wire S;
	input wire [0:3] I;
	output wire DP;
	output wire [0:6] Y;
	reg [0:6] DISP;

	always @ (I) begin
	if(S == 0)
	begin
		case (I)
		4'd0: DISP = 7'b1110111;
		4'd1: DISP = 7'b0011111;
		4'd2: DISP = 7'b1001110;
		4'd3: DISP = 7'b0111101;
		4'd4: DISP = 7'b1001111;
		4'd5: DISP = 7'b1000111;
		4'd6: DISP = 7'b1111011;
		4'd7: DISP = 7'b0110111;
		4'd8: DISP = 7'b1111100;
		4'd9: DISP = 7'b0001110;
		4'd10: DISP = 7'b1110110;
		4'd11: DISP = 7'b0011101;
		4'd12: DISP = 7'b1100111;
		4'd13: DISP = 7'b0000101;
		4'd14: DISP = 7'b0111110;
		4'd15: DISP = 7'b0111011;
		endcase
	end
	if(S == 1)
	begin
		case (I)
		4'd0: DISP = 7'b1111110;
		4'd1: DISP = 7'b0110000;
		4'd2: DISP = 7'b1101101;
		4'd3: DISP = 7'b1111001;
		4'd4: DISP = 7'b0110011;
		4'd5: DISP = 7'b1011011;
		4'd6: DISP = 7'b1011111;
		4'd7: DISP = 7'b1110000;
		4'd8: DISP = 7'b1111111;
		4'd9: DISP = 7'b1111011;
		4'd10: DISP = 7'b1110111;
		4'd11: DISP = 7'b0011111;
		4'd12: DISP = 7'b1001110;
		4'd13: DISP = 7'b0111101;
		4'd14: DISP = 7'b1001111;
		4'd15: DISP = 7'b1000111;
		endcase
	end
	end

	assign Y = ~DISP;
	assign DP = ~S;
endmodule
