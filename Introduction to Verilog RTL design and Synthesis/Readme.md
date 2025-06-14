## Simulating 2x1 multiplexer using iverilog
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

