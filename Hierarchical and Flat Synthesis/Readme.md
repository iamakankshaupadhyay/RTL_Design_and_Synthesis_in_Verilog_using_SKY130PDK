## Hierarchical versus Flat Synthesis

## 1. Hierarchical Synthesis
 Retains the module hierarchy as defined in RTL, synthesizing modules separately.
 
 ###  Synthesis of RTL design (multiple_modules.v) using Yosys tool

1. **Start Yosys**

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
 read_verilog /home/vsduser/VLSI/sky130RTLDesignAndSynthesisWorkshop/verilog_files/multiple_modules.v
  ```

### 4. **Synthesize the design**
  ```shell
synth -top multiple_modules
   ```

### 5. **Technology mapping**
  ```shell
abc -liberty /address_to_your_sky130_file/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

### 6. **Visualize the gate-level netlist**

```shell
show multiple_modules
```
Mentioning the name of file is necessary, because here three modules are generated.
### 8. **Write and view (in text editor GVim) the gate-level netlist**

  ```shell
write_verilog -noattr multiple_modules_hier.v
!gvim multiple_modules_hier.v
   ```
The netlist is illustrated in hierarchical.png: https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Hierarchical%20and%20Flat%20Synthesis/hierarchical.png, and netlist given in: https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Hierarchical%20and%20Flat%20Synthesis/multiple_modules_hier.v.
**Advantages:**
- Faster synthesis time for large designs.
- Improved debugging and analysis due to maintained module boundaries.
- Modular approach, aiding integration with other tools.

**Disadvantages:**
- Cross-module optimizations are limited.
- Reporting can require additional configuration.


## 2. Flattened Synthesis
Merges all modules into a single flat netlist, eliminating hierarchy. The `flatten` command in Yosys collapses the hierarchy, allowing whole-design optimizations.
 ###  Synthesis of RTL design (multiple_modules.v) using Yosys tool

1. **Start Yosys**

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
 read_verilog /home/vsduser/VLSI/sky130RTLDesignAndSynthesisWorkshop/verilog_files/multiple_modules.v
  ```

### 4. **Synthesize the design**
  ```shell
synth -top multiple_modules
   ```

### 5. **Technology mapping**
  ```shell
abc -liberty /address_to_your_sky130_file/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

### 6. **Visualize the gate-level netlist**

```shell
show multiple_modules
```
Mentioning the name of file is necessary, because here three modules are generated.
### 8. **Flatten, write and view (in text editor GVim) the gate-level netlist**

  ```shell
flatten
write_verilog -noattr multiple_modules_hier.v
!gvim multiple_modules_hier.v
   ```
The netlist is illustrated in flatmodule.png: https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Hierarchical%20and%20Flat%20Synthesis/flatmodule.png and netlist given in: https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Hierarchical%20and%20Flat%20Synthesis/multiple_modules_flat.v.

**Advantages:**
- Enables aggressive, cross-module optimizations.
- Results in a unified netlist, sometimes simplifying downstream processes.

**Disadvantages:**
- Longer runtime for large designs.
- Loss of hierarchy complicates debugging and reporting.
- Can increase memory usage and netlist complexity.



