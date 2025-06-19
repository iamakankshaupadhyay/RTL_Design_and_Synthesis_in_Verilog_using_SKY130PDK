# 📚 Timing Libraries & SKY130 PDK Overview
## 🔍 What is the SKY130 PDK?
The SKY130 Process Design Kit (PDK) is an open-source toolkit provided by SkyWater Technologies. It is built around a 130nm CMOS fabrication process and includes everything needed for digital and analog IC design — including models for timing, power, area, and process variation.

This PDK is widely adopted in open-source silicon design workflows and is supported by tools like Yosys, OpenROAD, and Magic.

## 🧠 Understanding the Library Naming Convention
One of the key components in synthesis and STA (Static Timing Analysis) is the timing library, typically provided in .lib format. A common example: sky130_fd_sc_hd__tt_025C_1v80.lib

Let’s break it down:

| Component | Meaning                         |
| --------- | ------------------------------- |
| `tt`      | Typical process corner          |
| `025C`    | Temperature at **25°C**         |
| `1v80`    | Core supply voltage = **1.80V** |


This naming convention helps designers select the appropriate library based on process, voltage, and temperature (PVT) conditions.

## 📂 How to View the .lib File
To inspect the contents of a timing library file (e.g., cell delays, setup/hold times):

### 🛠️ Step-by-step
🧰 Step 1: Installing GVim and Viewing .lib Files
GVim is the graphical version of vim, a powerful text editor. You can use it to explore .lib timing library files in the SKY130 PDK.
```
sudo apt update
sudo apt install vim-gtk3
```
This installs GVim with GUI support.

📂 Step 2: Open the Timing Library File
Use the following command to open the .lib file in GVim:
```
gvim sky130_fd_sc_hd__tt_025C_1v80.lib
```
### ✅ Why GVim?
Syntax highlighting for better readability

Easy navigation and search (/keyword)

Lightweight and fast for large files like .lib

# ⚙️Hierarchical versus Flat Synthesis

## 1. Hierarchical Synthesis
 Retains the module hierarchy as defined in RTL, synthesizing modules separately.
 
 ###  Synthesis of RTL design (multiple_modules.v) using Yosys tool

### 1. **Start Yosys**

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
The netlist is illustrated as:
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Hierarchical%20and%20Flat%20Synthesis/hierarchical.png" alt="Design & Testbench Overview" width="70%">
</div>
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
The netlist is illustrated as: 
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Hierarchical%20and%20Flat%20Synthesis/flatmodule.png" alt="Design & Testbench Overview" width="70%">
</div>

**Advantages:**
- Enables aggressive, cross-module optimizations.
- Results in a unified netlist, sometimes simplifying downstream processes.

**Disadvantages:**
- Longer runtime for large designs.
- Loss of hierarchy complicates debugging and reporting.
- Can increase memory usage and netlist complexity.



