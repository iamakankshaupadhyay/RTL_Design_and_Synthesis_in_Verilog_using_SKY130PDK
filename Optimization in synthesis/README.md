# Optimization in Synthesis

This repository covers optimization in verilog synthesis, focusing on if-else statements, case statements, for loops, generate blocks, and explore how improper coding can lead to inferred latches
Verilog offers powerful control flow constructs that allow designers to express complex decision-making and repeated structures efficiently in hardware. This repository introduces key Verilog constructs like if-else, case, for loops, and generate blocks — each serving a specific role in RTL design.

# 🔹1. if-else statement
Used to make decisions based on logical conditions.
```verilog
if (enable)
  y = d;
else
  y = 0;
```
Ideal for simple conditional logic, commonly used in combinational blocks (always @(*)).

# 🔹2. Nested if statement
Allows multiple levels of decision-making.
```verilog

if (sel == 2'b00)
  y = a;
else if (sel == 2'b01)
  y = b;
else
  y = c;
```
Use when priority-based conditions are needed. Cleanly handles multiple conditions. Recommended over deeply nested ternary operators for clarity.

### ⚠️ Inferred Latch in if-else statements
```verilog
always @(*) begin
  if (enable)
    y = d; // latch inferred if 'else' is missing
end
```
⚠️ If y is not defined for all conditions, synthesis tools will infer a latch to retain its previous value.
🔧 Fix: Always provide else or assign a default value at the beginning.
```verilog
always @(*) begin
  y = y;         // or: y = 0; (default)
  if (enable)
    y = d;
end
```
# 💠 Simulation and Synthesis of 2x1 mux with incomplete if-else statement
Verilog code:

```verilog
module incomp_if (input i0 , input i1 , input i2 , output reg y);
always @ (*)
begin
	if(i0)
		y <= i1;
end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/incomp_if_waveform.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠Inferred latch:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/incomp_if_latchinferred.png" alt="Design & Testbench Overview" width="70%">
</div>

# 💠 Simulation and Synthesis of incomplete Nested if-else statement
Verilog code:

```verilog
module incomp_if2 (input i0 , input i1 , input i2 , input i3, output reg y);
always @ (*)
begin
	if(i0)
		y <= i1;
	else if (i2)
		y <= i3;

end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/incomp_if2_waveform.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠Inferred latch:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/incomp_if2_inferredlatch.png" alt="Design & Testbench Overview" width="70%">
</div>


## 🔹3. case Statement
Cleaner alternative to if-else chains when checking against known, discrete values.
```verilog
case (sel)
  2'b00: y = a;
  2'b01: y = b;
  2'b10: y = c;
  default: y = d;
endcase
```
Great for multiplexers, state machines, and logic decoding. Use default to avoid latch inference.

### ⚠️ Caveats in `case` Statements

While `case` constructs are powerful, **improper use can lead to bugs or unintended hardware behavior**. Below are some key caveats to watch out for:

### 🔸 1. **Partial Assignments Cause Inferred Latches**

If not all outputs are explicitly assigned in every `case` branch (and no `default` is provided), the synthesis tool will **infer a latch** to "remember" the previous value — which is often **unintended** in combinational logic.

#### ❌ *Bad Example – Latch inferred:*

```verilog
always @(*) begin
  case (sel)
    2'b00: y = a;
    2'b01: y = b;
    // 2'b10 and 2'b11 missing — y holds previous value
  endcase
end
```

#### ✅ *Good Practice – Add `default` or cover all cases:*

```verilog
always @(*) begin
  case (sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    2'b11: y = d;
    default: y = 0;  // Ensures full assignment
  endcase
end
```

### 🔸 2. Overlapping condition: **Ambiguous Patterns like `2'b1?` May Not Match as Expected**

Verilog allows the use of **wildcards** like `?` in `casez` or `casex`, which can make matching easier — **but also risk incorrect matching**.

#### ⚠️ `casex`: Treats both `x` and `z` as "don't care"

```verilog
casex (sel)
  2'b1?: y = 1;  // Matches 2'b10 and 2'b11
  2'b00: y = 0;
endcase
```

* ✅ Convenient — but risky if inputs contain unknowns (`x` or `z`), as unintended matches may occur.

#### ⚠️ `casez`: Only treats `z` as "don't care"

```verilog
casez (sel)
  2'b1?: y = 1;   // `?` is treated as Z
  2'b00: y = 0;
endcase
```
* Safer than `casex`, but still requires caution.

#### ✅ *Best Practice*:

* Use `case` instead of `casez`/`casex` when exact match is critical.
* Avoid `?` patterns unless required, and **comment clearly** when used.
  
# 💠 Simulation and Synthesis of 4x1 mux with incomplete case statement
Verilog code: In the following code output y for case 2'b10 and 2'b11 are missing.
```verilog
module incomp_case (input i0 , input i1 , input i2 , input [1:0] sel, output reg y);
always @ (*)
begin
	case(sel)
		2'b00 : y = i0;
		2'b01 : y = i1;
	endcase
end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/incomp_case.png" width="70%">
</div>

### 💠Inferred latch:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/incomp_case_inferredlatch.png" alt="Design & Testbench Overview" width="70%">
</div>

# 💠 Simulation and Synthesis of complete case statement
Verilog code: In the following code default condition is added in the code to define value of output y for case 2'b10 and 2'b11.
```verilog
module comp_case (input i0 , input i1 , input i2 , input [1:0] sel, output reg y);
always @ (*)
begin
	case(sel)
		2'b00 : y = i0;
		2'b01 : y = i1;
		default : y = i2;
	endcase
end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/comp_case_waveform.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠4x1 Multiplexer:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/comp_case_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

# 💠 Simulation and Synthesis of partial case assignment
Verilog code: In the given code for case sel=2'b01, the output value of x is not defined causing inferred latch, despite the fact that default is defined.
```verilog
module partial_case_assign (input i0 , input i1 , input i2 , input [1:0] sel, output reg y , output reg x);
always @ (*)
begin
	case(sel)
		2'b00 : begin
			y = i0;
			x = i2;
			end
		2'b01 : y = i1;
		default : begin
		           x = i1;
			   y = i2;
			  end
	endcase
end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/partial_case_assign_.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠Inferred latch:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/partial_case_assign_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

# 💠 Simulation and Synthesis of overlapping case condition
Verilog code: In the given code for case sel=2'b1?, the ouput value of y depends on simulator if it considers 2'b1? as 2'b11 (y=i3) or 2'b10 (y=i2 or i3).

```verilog
module bad_case (input i0 , input i1, input i2, input i3 , input [1:0] sel, output reg y);
always @(*)
begin
	case(sel)
		2'b00: y = i0;
		2'b01: y = i1;
		2'b10: y = i2;
		2'b1?: y = i3;
	endcase
end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/bad_case_waveform.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Synthesized circuit behaves as normal 4x1 MUX
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/bad_case_netlist_normal_4x1mux.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Gate Level Synthesis indicates simulation-synthesis mismatch 
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/bad_case_netlist_normal_4x1mux_GLS.png" alt="Design & Testbench Overview" width="70%">
</div>


# 🔹4. for Loops
Used in RTL to replicate logic, multiple evaluations, initialize arrays, or generate repetitive assignments. Used inside always block.
```verilog
integer i;
always @(*) begin
  for (i = 0; i < 4; i = i + 1)
    y[i] = a[i] & b[i];
end
```
Unlike software, for loops in hardware describe parallel replicated logic, not iteration in time.

# 💠 Simulation and Synthesis of 4x1 mux using for loop
Verilog code: 

```verilog
module mux_generate (input i0 , input i1, input i2 , input i3 , input [1:0] sel  , output reg y);
wire [3:0] i_int;
assign i_int = {i3,i2,i1,i0};
integer k;
always @ (*)
begin
for(k = 0; k < 4; k=k+1) begin
	if(k == sel)
		y = i_int[k];
end
end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/4x1mux_for.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Synthesized circuit:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/4x1mux_for_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Gate Level Synthesis:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/4x1mux_for_GLS.png" alt="Design & Testbench Overview" width="70%">
</div>

# 💠 Simulation and Synthesis of 8x1 mux using case statement
Verilog code: 

```verilog
module demux_case (output o0 , output o1, output o2 , output o3, output o4, output o5, output o6 , output o7 , input [2:0] sel  , input i);
reg [7:0]y_int;
assign {o7,o6,o5,o4,o3,o2,o1,o0} = y_int;
integer k;
always @ (*)
begin
y_int = 8'b0;
	case(sel)
		3'b000 : y_int[0] = i;
		3'b001 : y_int[1] = i;
		3'b010 : y_int[2] = i;
		3'b011 : y_int[3] = i;
		3'b100 : y_int[4] = i;
		3'b101 : y_int[5] = i;
		3'b110 : y_int[6] = i;
		3'b111 : y_int[7] = i;
	endcase

end
endmodule
```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/demux_case.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Synthesized circuit:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/demux_case_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Gate Level Synthesis:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/demux_case_netlist_GLS.png" alt="Design & Testbench Overview" width="70%">
</div>

# 💠 Simulation and Synthesis of 8x1 mux using for loop
Verilog code: 

```verilog

module demux_generate (output o0 , output o1, output o2 , output o3, output o4, output o5, output o6 , output o7 , input [2:0] sel  , input i);
reg [7:0]y_int;
assign {o7,o6,o5,o4,o3,o2,o1,o0} = y_int;
integer k;
always @ (*)
begin
y_int = 8'b0;
for(k = 0; k < 8; k++) begin
	if(k == sel)
		y_int[k] = i;
end
end
endmodule

```
### 💠Ouput waveform:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/demux_generate.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Synthesized circuit:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/demux_generate_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Gate Level Synthesis:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/demux_generate_netlist_GLS.png" alt="Design & Testbench Overview" width="70%">
</div>


# 🔹5. generate Blocks
Used for conditional or looped instantiation of modules or logic during elaboration time. Defined outside always block.
```verilog
genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin : gen_mux
    mux2 U (.a(a[i]), .b(b[i]), .sel(sel), .y(y[i]));
  end
endgenerate
```
Common in scalable designs like buses, arrays of registers, or multi-bit datapaths.

# 💠 Simulation and Synthesis of 8 bit Ripple Carry Adder using for and generate statements
Verilog code: 
```verilog
module fa (input a , input b , input c, output co , output sum);
	assign {co,sum}  = a + b + c ;
endmodule
```
```verilog
module rca (input [7:0] num1 , input [7:0] num2 , output [8:0] sum);
wire [7:0] int_sum;
wire [7:0]int_co;

genvar i;
generate
	for (i = 1 ; i < 8; i=i+1) begin
		fa u_fa_1 (.a(num1[i]),.b(num2[i]),.c(int_co[i-1]),.co(int_co[i]),.sum(int_sum[i]));
	end

endgenerate
fa u_fa_0 (.a(num1[0]),.b(num2[0]),.c(1'b0),.co(int_co[0]),.sum(int_sum[0]));


assign sum[7:0] = int_sum;
assign sum[8] = int_co[7];
endmodule
```
### 💠Ouput waveform of Ripple carry adder:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/ripplecarryadder_.png" alt="Design & Testbench Overview" width="70%">
</div>

</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/ripplecarryadder_1.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Synthesized circuit Full adder:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/fulladder.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Synthesized circuit Ripple carry adder using generate:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/rca_using_generate.png" alt="Design & Testbench Overview" width="70%">
</div>

### 💠 Gate Level Synthesis:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/rca_GLS.png" alt="Design & Testbench Overview" width="70%">
</div>

</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Optimization%20in%20synthesis/Images/RCA_GLS2.png" alt="Design & Testbench Overview" width="70%">
</div>













