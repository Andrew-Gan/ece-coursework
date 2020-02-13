module Lab7_decoder(I,Y);
	input wire [7:0] I;
	output wire [7:0] Y;
	reg [7:0] DISP; 

	always @ (I) begin
		case (I)
		4'd0: DISP = 7'b1110111 & I[7];
		4'd1: DISP = 7'b0011111 & I[7];
		4'd2: DISP = 7'b1001110 & I[7];
		4'd3: DISP = 7'b0111101 & I[7];
		4'd4: DISP = 7'b1001111 & I[7];
		4'd5: DISP = 7'b1000111 & I[7];
		4'd6: DISP = 7'b1111011 & I[7];
		4'd7: DISP = 7'b1101101 & I[7];
		4'd8: DISP = 7'b1111100 & I[7];
		4'd9: DISP = 7'b0001110 & I[7];
		4'd10: DISP = 7'b1110110 & I[7];
		4'd11: DISP = 7'b0011101 & I[7];
		4'd12: DISP = 7'b1100111 & I[7];
		4'd13: DISP = 7'b0000101 & I[7];
		4'd14: DISP = 7'b0111110 & I[7];
		4'd15: DISP = 7'b0111011 & I[7];
		endcase
	end

	assign Y = DISP;
endmodule

