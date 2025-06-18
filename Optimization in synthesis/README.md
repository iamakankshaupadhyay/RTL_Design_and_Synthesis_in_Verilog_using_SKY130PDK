# Optimization in Synthesis

This repository covers optimization in verilog synthesis, focusing on if-else statements, case statements, for loops, generate blocks, and explore how improper coding can lead to inferred latches
Verilog offers powerful control flow constructs that allow designers to express complex decision-making and repeated structures efficiently in hardware. This repository introduces key Verilog constructs like if-else, case, for loops, and generate blocks — each serving a specific role in RTL design.

## 🔹1. if-else statement
Used to make decisions based on logical conditions.
```verilog
if (enable)
  y = d;
else
  y = 0;
```
Ideal for simple conditional logic, commonly used in combinational blocks (always @(*)).

## 🔹2. Nested if statement
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


## 🔹4. for Loops
Used in RTL to replicate logic, initialize arrays, or generate repetitive assignments.
```verilog
integer i;
always @(*) begin
  for (i = 0; i < 4; i = i + 1)
    y[i] = a[i] & b[i];
end
```
Unlike software, for loops in hardware describe parallel replicated logic, not iteration in time.

## 🔹5. generate Blocks
Used for conditional or looped instantiation of modules or logic during elaboration time.
```verilog
genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin : gen_mux
    mux2 U (.a(a[i]), .b(b[i]), .sel(sel), .y(y[i]));
  end
endgenerate
```
Common in scalable designs like buses, arrays of registers, or multi-bit datapaths.













