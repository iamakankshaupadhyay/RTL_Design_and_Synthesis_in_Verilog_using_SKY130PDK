# Gate-Level Simulation (GLS)

Today’s focus is on three critical topics that bridge the gap between RTL design and post-synthesis validation:

🔌 Gate-Level Simulation (GLS)

⚠️ Synthesis vs Simulation Mismatches

Each concept is reinforced through guided labs and practical examples using Verilog and open-source tools like Yosys and GTKWave.

📌 What You’ll Learn

1️⃣ Gate-Level Simulation (GLS)
GLS is the process of simulating a synthesized gate-level netlist to ensure functional correctness of the synthesized logic and ensuring timing of design is met. GLS is typically done after synthesis, but before layout as functional (no delay) or timing (SDF annotated) simulation. This is done to avoid synthesis and simulation mismatches.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/gatelevelsimulation.png" alt="Design & Testbench Overview" width="70%">
</div>


2️⃣ Synthesis-Simulation Mismatch
Mismatches arise when RTL and post-synthesis simulations behave differently due to missing sensitivity list, blocking and non-blocking statements, and non-standard verilog coding.

3️⃣ Blocking vs. Non-Blocking Assignments in Verilog

Verilog offers two types of procedural assignments:

➡️ Blocking Statements (`=`)

- **Syntax:** `=`
- **Execution:** Sequential, executes immediately.
- **Suitable for:** Combinational logic (e.g., `always @(*)`).
- **Example:**  
  ```verilog
  always @(*) y = a & b;
  ```

➡️ Non-Blocking Statements (`<=`)

- **Syntax:** `<=`
- **Execution:** Scheduled, executes concurrently at the end of the time step.
- **Suitable for:** Sequential logic (e.g., `always @(posedge clk)`).
- **Example:**  
  ```verilog
  always @(posedge clk) q <= d;
  ```

➡️ Comparison Table

| **Blocking (`=`)**                        | **Non-Blocking (`<=`)**                   |
|-------------------------------------------|--------------------------------------------|
| Uses `=` operator                         | Uses `<=` operator                         |
| Sequential, immediate execution           | Concurrent, scheduled at end of timestep   |
| Updates happen instantly in code order    | Updates applied after time step            |
| For combinational logic, temp variables   | For sequential logic, registers/flip-flops |
| Infers combinational logic (gates)        | Infers sequential logic (flip-flops)       |

---
# Gate Level Synthesis Steps
## 1. 2x1 MUX using ternary operator
### Verilog code and Simulation using iverilog

```verilog
module ternary_operator_mux (input i0, input i1, input sel, output y);
  assign y = sel ? i1 : i0;
endmodule
```
- **Function:** `y = i1` if `sel = 1`; else `y = i0`.

</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/ternary_mux.png" alt="Design & Testbench Overview" width="70%">
</div>

---

### Synthesis Using Yosys

Synthesize the above MUX using Yosys.  
_Follow the standard Yosys synthesis flow._

</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/ternary_mux_netlist.png" width="70%">
</div>

### Gate-Level Simulation (GLS) of MUX

Run GLS for the synthesized MUX.  
Use this command (adjust paths as needed):

```shell
iverilog /path/to/primitives.v /path/to/sky130_fd_sc_hd.v ternary_operator_mux.v testbench.v
./a.out
gtkwave dump_file_nake.vcd
```
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/ternary_mux_netlist_waveform.png" width="70%">
</div>

## 2. 2x1 MUX with issue in sensitivity list
### Verilog code and Simulation using iverilog
```verilog
module bad_mux (input i0, input i1, input sel, output reg y);
  always @ (sel) begin
    if (sel)
      y <= i1;
    else 
      y <= i0;
  end
endmodule
```

#### Issues:
- **Incomplete sensitivity list**: Should include `i0`, `i1`, and `sel` or `*`.
- **Non-blocking assignment in combinational logic**: Should use blocking assignments (`=`).
 The output wavefrom illustrates that RTL code is not behaving like 2x1 mux, else the y changes its value to i0 and i1 only at falling or rising edges of sel, respectively as shown below:
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/bad_mux_RTL_waveform.png" width="70%">
</div>

**Corrected version:**
```verilog
always @ (*) begin
  if (sel)
    y = i1;
  else
    y = i0;
end
```

### Synthesis Using Yosys
However, synthesized circuit contains 2x1 mux.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/bad_mux_netlist.png" width="70%">
</div>

### Gate-Level Simulation (GLS) of MUX
The GLS output waveform is behaving like 2x1 mux despite of 2x1 mux RTL simulation not behaving like one.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/bad_mux_GLS_waveform.png" width="70%">
</div>

Hence, this example represents synthesis-simulation mismatch due to error in sensitivity list.

### 3: Blocking Assignment Caveat
### Verilog code and Simulation using iverilog
Verilog code:
The circuit should behave like or and gate.
```verilog
module blocking_caveat (input a, input b, input c, output reg d);
  reg x;
  always @ (*) begin
    d = x & c;
    x = a | b;
  end
endmodule
```
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/blocking_caveat_RTL_waveform.png" width="70%">
</div>

#### What’s wrong?
- The order of assignments causes `d` to use the old value of `x`—not the newly computed value.
- **Best Practice:** Assign intermediate variables before using them.

**Corrected order:**
```verilog
always @ (*) begin
  x = a | b;
  d = x & c;
end
```

### Synthesis of the Blocking Caveat Module using Yosys
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/blocking_caveat_netlist.png" width="70%">
</div>

### Gate-Level Simulation (GLS) of MUX
The GLS output waveform is behaving like normal or and gate.
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Gate%20Level%20Synthesis%20and%20its%20Importance/blocking_caveat_GLS_waveform.png" width="70%">
</div>
Hence, this example represents synthesis-simulation mismatch due to incorrect order of blocking statement.

## 5. Summary

- **Gate-Level Simulation (GLS):** Validates netlist functionality, timing, and testability after synthesis.
- **Synthesis-Simulation Mismatch:** Avoid by using synthesizable, unambiguous RTL code.
- **Blocking vs. Non-Blocking:** Use blocking (`=`) for combinational, non-blocking (`<=`) for sequential logic.
- **Labs:** Reinforce key concepts and highlight common RTL pitfalls.

---

> [!TIP]
>  Always simulate both your RTL and gate-level netlist, and review warnings from synthesis and simulation tools!

---



