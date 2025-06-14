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

## 1. Sequential Logic Optimizations
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

### Synthesis is performed using steps given in: Synthesis_of_DFF_with_asynchronous_reset/Readme.md


