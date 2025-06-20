## 1. Combinational Logic Optimizations

### Module 1: opt_check.v

Verilog code:
```verilog
module opt_check (input a , input b , output y);
	assign y = a?b:0;
endmodule
```
This repersents a 2x1 mux where: If `a` is true, `y` is assigned the value of `b`and If `a` is false, `y` is 0. However, the ouput can be simplified to y=a&b.

### Module 2: opt_check2.v

Verilog code:
```verilog
module opt_check2 (input a , input b , output y);
	assign y = a?1:b;
endmodule
```

This repersents a 2x1 mux where: If `a` is true, `y` is assigned the value of `1`and If `a` is false, `y` is 'b'. However, the ouput can be simplified to y=a|b.
 
### Module 3: opt_check3.v
```verilog
module opt_check3 (input a , input b , input c , output y);
 assign y = a?(c?b:0):0;
 endmodule
```
This repersents a 2x1 mux where: 
- Nested ternary logic:
  - If `a = 1`, `y = a&b&c`.
  - If `a = 0`, `y = 0`.
However, the ouput can be simplified to y=a&b&c.

### Synthesis steps 
### 1. Start Yosys

  ```shell
yosys
  ```

### 2. **Read the liberty library**
Library (.lib file) contains standard cells (basic gates, modules etc.) for synthesis.
  ```shell
read_liberty -lib /address_to_your_sky130_file/sky130_fd_sc_hd__tt_025C_1v80.lib
  ```

### 3. **Read the Verilog code**
  ```shell
 read_verilog path/to/module
  ```

### 4. **Synthesize the design**
  ```shell
synth -top module_name
   ```
### 5. **Optimizing the design**
```shell
opt_clean -purge
```

### 5. **Technology mapping**
  ```shell
abc -liberty /address_to_your_sky130_file/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

### 6. **Visualize the gate-level netlist**

```shell
show
```
### Module 1: opt_check.v synthesized as and gate instead of 2x1 mux:

</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/opt_check_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### Module 2: opt_check2.v synthesized as or gate instead of 2x1 mux:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/opt_check2_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### Module 3: opt_check3.v synthesized as three imput and gate instead of 2x1 mux:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/opt_check3_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

## 2. Sequential Logic Optimizations
### Synthesis is performed using steps given in: Synthesis_of_DFF_with_asynchronous_reset/Readme.md

### Module 1: dff_const1.v
Verilog code:

```verilog
module dff_const1(input clk, input reset, output reg q);
always @(posedge clk, posedge reset)
begin
	if(reset)
		q <= 1'b0;
	else
		q <= 1'b1;
end
endmodule
```
This is a D flip-flop where if Asynchronous reset is '1' than output is set to '0', whereas, loads constant `1` when not in reset. 
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/dff_const1_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### Module 2: dff_const2.v

Verilog code:

```verilog
module dff_const2(input clk, input reset, output reg q);
always @(posedge clk, posedge reset)
begin
	if(reset)
		q <= 1'b1;
	else
		q <= 1'b1;
end
endmodule
```
This is a D flip-flop where  output is set to '1' regardless of reset or clk.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/dff_const2_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>

### Module 3: dff_const3.v
Verilog code:

```verilog
module dff_const3(input clk, input reset, output reg q);
reg q1;
always @(posedge clk, posedge reset)
begin
	if(reset)
	begin
		q <= 1'b1;
		q1 <= 1'b0;
	end
	else
	begin
		q1 <= 1'b1;
		q <= q1;
	end
end

endmodule
```
This code represents two D flip flops having same clk and reset, output of first flip flop q1 serves as input to second D flip flop having output q. Input of first D FF is 1.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/dff_const3_netlist.png" alt="Design & Testbench Overview" width="70%">
</div>


## 3. Sequential Logic Optimizations for Unused Outputs
### Module 1: counter_opt.v
Verilog code:
```verilog
module counter_opt (input clk , input reset , output q);
reg [2:0] count;
assign q = count[0];

always @(posedge clk ,posedge reset)
begin
	if(reset)
		count <= 3'b000;
	else
		count <= count + 1;
end

endmodule
```
In this case q is set at count[0] which is toggling on each clock cycle. count[2] and count[1] are unused in this case. So this implementation will require only one D FF for three bit counter.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/counter_opt.png" alt="Design & Testbench Overview" width="70%">
</div>

### Module 2: counter_opt2.v
Verilog code:
```verilog
module counter_opt (input clk , input reset , output q);
reg [2:0] count;
assign q = (count[2:0] == 3'b100);

always @(posedge clk ,posedge reset)
begin
	if(reset)
		count <= 3'b000;
	else
		count <= count + 1;
end

endmodule
```
In this case q = (count[2:0] == 3'b100); so in this implementation all outputs are retained and implementation will require three D FFs.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Combinational%20and%20Sequential%20Optimizations/counter_opt2.png" alt="Design & Testbench Overview" width="70%">
</div>




