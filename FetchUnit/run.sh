#!/bin/bash

# Compile the design files
ghdl -a --std=08 FetchUnit.vhdl
ghdl -a --std=08 IFID_Buffer.vhdl
ghdl -a --std=08 InstMemory.vhdl
ghdl -a --std=08 PC_Module.vhdl

# Compile the testbench
ghdl -a --std=08 tb_FetchUnit.vhdl

# Elaborate the testbench
ghdl -e --std=08 tb_FetchUnit

# Run the simulation
ghdl -r --std=08 tb_FetchUnit --wave=tb_FetchUnit.ghw

# Launch GTKWave for waveform visualization
gtkwave tb_FetchUnit.ghw
