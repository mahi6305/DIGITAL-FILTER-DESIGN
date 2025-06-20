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
Example: 16-tap serial FIR filter
fir_serial.v

verilog
Copy
Edit
module fir_serial (
  input clk, reset,
  input signed [15:0] x_in,
  input valid_in,
  output reg signed [31:0] y_out,
  output reg valid_out
);
  // delay line
  reg signed [15:0] x_reg [0:15];
  // coefficients
  reg signed [15:0] h [0:15];
  // accumulator
  reg signed [31:0] acc;
  integer i;

  initial $readmemh("coeffs.hex", h);

  always @(posedge clk) begin
    if (reset) begin
      for (i=0; i<16; i=i+1) x_reg[i] <= 0;
      acc <= 0;
      valid_out <= 0;
    end else if (valid_in) begin
      // shift
      for (i=15; i>0; i=i-1) x_reg[i] <= x_reg[i-1];
      x_reg[0] <= x_in;

      // compute MAC
      acc <= 0;
      for (i=0; i<16; i=i+1) acc <= acc + x_reg[i]*h[i];

      y_out <= acc;
      valid_out <= 1;
    end else begin
      valid_out <= 0;
    end
  end
endmodule
testbench.v – apply an impulse, step, sine, or real sample sequence and dump y_out.

# 🔧 5. Simulation and Verification
With Icarus Verilog:
bash
Copy
Edit
iverilog -o fir_sim fir_serial.v testbench.v
vvp fir_sim
gtkwave waveform.vcd
Plot input vs output

Verify impulse response matches design

Check for bit‑growth and overflow

# 🧩 6. VLSI Considerations
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

# 📚 7. Deliverables
Block diagram showing datapath, delay line, MAC, control

Verilog source code: filter module + testbench

Waveforms for impulse and step responses

Synthesis report: area, frequency, power estimations

(Optional) Floorplanning/viewing in FPGA tool (Vivado, Quartus)

