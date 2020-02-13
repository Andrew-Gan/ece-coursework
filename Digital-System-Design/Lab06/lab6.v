module Lab6(I, R, Ci, K, A, B, Co, F);
	input I, R, Ci, K /* synthesis loc="1,2,3,4" */;
	output A, B, Co, F /* synthesis loc="23,22,21,20" */;

	assign A = I & R & Ci & K;
	assign B = I & ~(R & Ci & K) & (R | Ci | K);
	assign Co = ~I & (R | Ci | K);
	assign F = ~R & ~Ci & ~K;
endmodule

