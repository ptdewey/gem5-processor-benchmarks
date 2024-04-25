# Copyright (c) 2015 Jason Power
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met: redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer;
# redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution;
# neither the name of the copyright holders nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

""" This file creates a single CPU and a two-level cache system.
This script takes a single parameter which specifies a binary to execute.
If none is provided it executes 'hello' by default (mostly used for testing)

See Part 1, Chapter 3: Adding cache to the configuration script in the
learning_gem5 book for more information about this script.
This file exports options for the L1 I/D and L2 cache sizes.

IMPORTANT: If you modify this file, it's likely that the Learning gem5 book
           also needs to be updated. For now, email Jason <power.jg@gmail.com>

"""

# import the m5 (gem5) library created when gem5 is built
import m5

# import all of the SimObjects
from m5.objects import *

# Add the common scripts to our path
m5.util.addToPath("./gem5/configs/")

# import the SimpleOpts module
from common import SimpleOpts

# Binary to execute
SimpleOpts.add_option("binary")
SimpleOpts.add_option("arch_generation")
SimpleOpts.add_option("isa")
args = SimpleOpts.parse_args()

# import the caches
# NOTE: one file can be found for each generation
if args.arch_generation == "broadwell":
    from broadwell_caches import *
elif args.arch_generation == "skylake":
    from skylake_caches import *
else:
    # default case (broadwell)
    from broadwell_caches import *


thispath = os.path.dirname(os.path.realpath(__file__))

# Default to running 'hello', use the compiled ISA to find the binary
# grab the specific path to the binary
binary = str(os.path.join(thispath, args.binary))
# default_binary = os.path.join( thispath, "./nq86")

current_isa = args.isa

# create the system we are going to simulate
system = System()

# Set the clock frequency of the system (and all of its children)
system.clk_domain = SrcClockDomain()
system.clk_domain.clock = "1GHz"
system.clk_domain.voltage_domain = VoltageDomain()

# Set up the system
system.mem_mode = "timing"  # Use timing accesses
system.mem_ranges = [AddrRange("8192MB")]  # Create an address range

# Create a CPU based on `current_isa`
if current_isa == "X86":
    system.cpu = X86O3CPU()
    # system.cpu = TimingSimpleCPU()
elif current_isa == "ARM":
    system.cpu = O3CPU()
    # system.cpu = TimingSimpleCPU()
else:
    print("no isa passed in")
    exit(1)

# set branch prediction method
system.cpu.branchPred = TAGE()

# Create an L1 instruction and data cache
system.cpu.icache = L1ICache(args)
system.cpu.dcache = L1DCache(args)

# Connect the instruction and data caches to the CPU
system.cpu.icache.connectCPU(system.cpu)
system.cpu.dcache.connectCPU(system.cpu)
'''
# Create a memory bus, a coherent crossbar, in this case
system.l2bus = L2XBar()

# Hook the CPU ports up to the l2bus
system.cpu.icache.connectBus(system.l2bus)
system.cpu.dcache.connectBus(system.l2bus)

# Create an L2 cache and connect it to the l2bus
system.l2cache = L2Cache(args)
system.l2cache.connectCPUSideBus(system.l2bus)

# Create a memory bus
system.membus = SystemXBar()

# Connect the L2 cache to the membus
system.l2cache.connectMemSideBus(system.membus)
'''

# Create a memory bus, a coherent crossbar, in this case
system.l2bus = L2XBar()

# Hook the CPU ports up to the l2bus
system.cpu.icache.connectBus(system.l2bus)
system.cpu.dcache.connectBus(system.l2bus)

# Create an L2 cache and connect it to the l2bus
system.l2cache = L2Cache()
system.l2cache.connectCPUSideBus(system.l2bus)

L4set = 0

if (L4set==1): #Add L3 and L4
  #Create a memory bus, for L3 cache
  system.l3bus = L3XBar()

  #Hook up the L2 cache to the L3 cache bus
  system.l2cache.connectMemSideBus(system.l3bus)

  #Create an L3 cache and connect it to the l3 bus
  system.l3cache = L3Cache()
  system.l3cache.connectCPUSideBus(system.l3bus)

  #Create a memory bus, for L4 cache
  system.l4bus = L4XBar()

  #Hook up the L3 cache to the L4 cache bus
  system.l3cache.connectMemSideBus(system.l4bus)

  #Create an L4 cache and connect it to the l4 bus
  system.l4cache = L4Cache()
  system.l4cache.connectCPUSideBus(system.l4bus)

  # Create a memory bus
  system.membus = SystemXBar()

  # Connect the L4 cache to the membus
  system.l4cache.connectMemSideBus(system.membus)

else: #only add L3
  #Create a memory bus, for L3 cache
  system.l3bus = L3XBar()

  #Hook up the L2 cache to the L3 cache bus
  system.l2cache.connectMemSideBus(system.l3bus)

  #Create an L3 acche and connect it to the l3 bus
  system.l3cache = L3Cache()

  system.l3cache.connectCPUSideBus(system.l3bus)

  # Create a memory bus
  system.membus = SystemXBar()

  system.l3cache.connectMemSideBus(system.membus)


# create the interrupt controller for the CPU
system.cpu.createInterruptController()


# NOTE:
# For X86 only we make sure the interrupts care connect to memory.
# Note: these are directly connected to the memory bus and are not cached.
# For other ISA you should remove the following three lines.
if current_isa == "X86":
    system.cpu.interrupts[0].pio = system.membus.mem_side_ports
    system.cpu.interrupts[0].int_requestor = system.membus.cpu_side_ports
    system.cpu.interrupts[0].int_responder = system.membus.mem_side_ports


# Connect the system up to the membus
system.system_port = system.membus.cpu_side_ports

# Create a DDR3 memory controller
system.mem_ctrl = MemCtrl()
system.mem_ctrl.dram = DDR3_1600_8x8()
system.mem_ctrl.dram.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.mem_side_ports

system.workload = SEWorkload.init_compatible(binary)

# Create a process for a simple "Hello World" application
process = Process()
# Set the command
# cmd is a list which begins with the executable (like argv)
process.cmd = [binary]
# Set the cpu to use the process as its workload and create thread contexts
system.cpu.workload = process
system.cpu.createThreads()

# set up the root SimObject and start the simulation
root = Root(full_system=False, system=system)
# instantiate all of the objects we've created above
m5.instantiate()

print(f"Beginning simulation!")
exit_event = m5.simulate()
print(f"Exiting @ tick {m5.curTick()} because {exit_event.getCause()}")

