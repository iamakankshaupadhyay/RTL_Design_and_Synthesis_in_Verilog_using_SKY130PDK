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


