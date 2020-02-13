module binary_counter(CLK, OUT, dir);

  input wire CLK;
  input wire dir;
  output reg [3:0] OUT;

  always @ (posedge CLK)
    if(dir == 1)
      OUT <= OUT + 1;
    else if(dir != 0)
      OUT <= OUT - 1;
endmodule

