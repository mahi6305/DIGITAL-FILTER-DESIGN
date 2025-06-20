# DIGITAL-FILTER-DESIGN

*COMPANY*: CODETECH IT SOLUTIONS

*NAME*: CHINTHAPARTHI MAHESH BABU

*INTERN ID*: CT08DF379

*DOMAIN*: VLSI

*DURATION*: 8 WEEKS

*MENTOR*: NEELA SANTHOSH KUMAR

# DESCRIPTION OF TASK LIKE HOE YOU PERFORMED AND WHAT YOU HAVE TO DO DONE AND PAST PICTURES OF OUTPUT

# 🎯 1. Filter Specification
Start by defining your filter requirements:

Type: FIR (Finite Impulse Response) or IIR (Infinite Impulse Response)

Response: Low‑pass, high‑pass, band-pass, notch…

Specs: Passband/stopband edges, ripple, attenuation, sampling frequency

Precision: Bit-width (e.g., 16‑bit fixed-point), filter order

Example: A 16‑tap FIR low-pass filter with normalized cutoff frequency 0.25π in fixed-point (16‑bit signed coefficient).

# 🏗 2. Architectural Choices
a) Direct FIR Structure
Multiply–Accumulate (MAC) chain: 16 multipliers + adder tree

Lots of parallel multipliers—fast but area-heavy

b) Tapped Delay Line + Single MAC (Serial FIR)
Use a shift register for input samples

One multiplier + accumulator reused for each tap over 16 cycles

Saves area, increases latency

c) Pipelined MAC Tree
Parallel multiply operations with pipelined adders and registers

Enables high clock frequency

d) Distributed Arithmetic (DA)
No multipliers — use lookup tables (ideal for FIR)

Efficient in FPGAs or LUT-based ASICs

🛠 3. Functional Units
Shift register / delay line

Multipliers: Fixed-point multiply blocks

Accumulators: Adders + registers

Coefficient storage: ROM or registers holding filter coefficients

Controller FSM (for serial / DA architectures)

# ✅ 4. Verilog Module Structure
 16-tap serial FIR filter
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

# 🧩 5. VLSI Considerations

a) Pipelining
Register between multiplier stages and adder stages

Improves maximum frequency

b) Bit‑widths
Guard bits for accumulator to avoid overflow

Use truncated or rounded outputs

c) Resource Sharing
Serial MAC reduces multiplier count

DA replaces multipliers with LUTs (especially FPGA-friendly)

d) Optimization
Coefficient symmetry for linear‑phase FIR: reduces MACs by ~2×

Block floating‑point if dynamic range is large

# 📚 6. Deliverables
Block diagram showing datapath, delay line, MAC, control

Verilog source code: filter module + testbench

Waveforms for impulse and step responses

Synthesis report: area, frequency, power estimations

(Optional) Floorplanning/viewing in FPGA tool (Vivado, Quartus)

*OUTPUT*: 

![Image](https://github.com/user-attachments/assets/f8713d75-66c7-4e37-8cc5-3ff6f6629ccf)
