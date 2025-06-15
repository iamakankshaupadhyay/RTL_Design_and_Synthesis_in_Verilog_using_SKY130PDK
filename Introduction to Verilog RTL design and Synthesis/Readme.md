# Understanding the Basics: Simulator, Design, Testbench, and Synthesizer
## 🔄 Simulator
- RTL design is checked for adherence to the specifications by simulating the design
- Simulator is the tool used for simulating the design
A simulator is a virtual test environment for digital circuits. It mimics how your Verilog code would behave in real hardware by applying inputs, running time-based events, and showing output responses—helping catch bugs early before any physical implementation.

## 📐 Design
- Design is the actual Verilog code or set of Verilog codes which has the intended functionality to meet with the required specifications.
The design refers to your core Verilog module—your actual digital logic (like an ALU, counter, or FSM). It's the hardware description that defines what the circuit does.

## 🎛️ Testbench
- TestBench is the setup to apply stimulus (test_vectors) to the design to check its functionality
A testbench acts as the controller in simulation. It generates input stimuli, monitors outputs, and verifies correctness of your design. It’s not synthesized into hardware—just a helpful tool to ensure your design works as expected.
## 🧬 Synthesizer
Tool used for converting the RTL to netlist. Yosys is the open-source synthesizer used in this course. A synthesizer converts your high-level hardware description (written in Verilog) into a lower-level gate-level representation that can be mapped onto physical hardware such as:FPGAs (Field Programmable Gate Arrays) and ASICs (Application-Specific Integrated Circuits). It performs tasks like:
- Logic optimization
- Resource mapping (e.g., LUTs, flip-flops, carry chains)
- Timing analysis (in later steps)

# How simulator works
- Simulator looks for the changes on the input signals
- Upon change to the input the output is evaluated. If no change to the input, no change to the output!
- Simulator is looking for change in the values of input!
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Introduction%20to%20Verilog%20RTL%20design%20and%20Synthesis/Images/simflow.png" alt="Design & Testbench Overview" width="70%">
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Introduction%20to%20Verilog%20RTL%20design%20and%20Synthesis/Images/testbench.png" alt="Design & Testbench Overview" width="70%">
</div>

# Synthesis Flow
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Introduction%20to%20Verilog%20RTL%20design%20and%20Synthesis/Images/synth.png" alt="Design & Testbench Overview" width="70%">
</div>

# Yosys Setup
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Introduction%20to%20Verilog%20RTL%20design%20and%20Synthesis/Images/yosy.png" alt="Design & Testbench Overview" width="70%">
</div>

# Verify the Synthesis 
</div>
<div align="center">
  <img src="https://github.com/iamakankshaupadhyay/RTL_Design_and_Synthesis_in_Verilog_using_SKY130PDK/blob/master/Introduction%20to%20Verilog%20RTL%20design%20and%20Synthesis/Images/verifysynth.png" alt="Design & Testbench Overview" width="70%">
</div>

# Simulating 2x1 multiplexer using iverilog
### 1. Clone the github repository

```shell
git clone https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop.git
cd sky130RTLDesignAndSynthesisWorkshop/verilog_files
```
### 2. Install Required Tools
**Icarus Verilog (iverilog)** is the open-source simulation tool and **gtkwave** is the waveform viewer to visualize the value change dump file (.vcd).
```shell
sudo apt install iverilog
sudo apt install gtkwave
```
### 3. Simulate the Design
Compile the design (good_mux.v) and testbench (tb_good_mux.v):

```shell
iverilog good_mux.v tb_good_mux.v
```
This command creates a.out file.

### 4. Run the simulation by executing a.out file:

```shell
./a.out
```

### 5. View the waveform:

```shell
gtkwave tb_good_mux.vcd
```


##  Synthesis of RTL design using Yosys tool

**Yosys** is a powerful open-source synthesis tool for digital hardware. It takes your Verilog code and converts it into a gate-level netlist—a hardware blueprint.
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
 read_verilog /home/vsduser/VLSI/sky130RTLDesignAndSynthesisWorkshop/verilog_files/good_mux.v
  ```

### 4. **Synthesize the design**
  ```shell
synth -top good_mux
   ```

### 5. **Technology mapping**
  ```shell
abc -liberty /address_to_your_sky130_file/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

### 6. **Visualize the gate-level netlist**

```shell
show
```
### 8. **Write and view (in text editor GVim) the gate-level netlist**

  ```shell
write_verilog -noattr good_mux_netlist.v
!gvim good_mux_netlist.v
   ```

