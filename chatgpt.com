module fir_filter (
  input clk,
  input rst,
  input signed [7:0] data_in,
  output reg signed [15:0] data_out
);

  // Coefficients for the 16-tap FIR filter
  // These are examples, replace with your desired coefficients
  parameter signed [7:0] coefficients [15:0] = '{
    8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h08,
    8'h08, 8'h07, 8'h06, 8'h05, 8'h04, 8'h03, 8'h02, 8'h01
  };

  // Internal registers to store delayed input samples
  reg signed [7:0] delay_line [15:0];

  // Index for accessing delay line
  integer i;

  // Output initialization
  always @(posedge clk) begin
    if (rst) begin
      data_out <= 0;
      for (i = 0; i < 16; i = i + 1)
        delay_line[i] <= 0;
    end else begin
      // Calculate the output based on the delay line and coefficients
      reg signed [15:0] temp_out = 0;
      for (i = 0; i < 16; i = i + 1)
        temp_out = temp_out + (delay_line[i] * coefficients[i]);
      data_out <= temp_out;

      // Update the delay line
      for (i = 15; i > 0; i = i - 1)
        delay_line[i] <= delay_line[i-1];
      delay_line[0] <= data_in;
    end
  end

endmodule


module fir_filter_tb;

  // Inputs
  reg clk;
  reg rst;
  reg signed [7:0] data_in;

  // Outputs
  wire signed [15:0] data_out;

  // Instantiate the Unit Under Test (UUT)
  fir_filter uut (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    data_in = 0;

    // Apply reset
    #10 rst = 0;

    // Test data
    #10 data_in = 1;
    #10 data_in = 2;
    #10 data_in = 3;
    #10 data_in = 4;
    #10 data_in = 5;
    #10 data_in = 6;
    #10 data_in = 7;
    #10 data_in = 8;
    #10 data_in = 9;
    #10 data_in = 10;
    #10 data_in = 11;
    #10 data_in = 12;
    #10 data_in = 13;
    #10 data_in = 14;
    #10 data_in = 15;
    #10 data_in = 16;

    // Finish simulation
    #100 $finish;
  end

endmodule
