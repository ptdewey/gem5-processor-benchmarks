# Report

### Project Modifications

Originally, we were planning on evaluating performance between multiple different ISA architectures, namely X86 and ARM.
Unfortunately, we ran into numerous issues getting the gem5 simulator working with the ARM ISA on the rlogin cluster, to the point that we had to abandon that part of the project.
Thus, we decided to go into a more in-depth analysis of the Broadwell and Skylake CPU generations that we looked at earlier in the course. Our new focus involved the same benchmark applications that we were planning to use in the comparison between ARM and X86, and still used the gem5 simulator.

Our final benchmark suite consisted of five applications representing a wide range of potential computational science workloads.
It consisted of two graph-related benchmarks: Dijkstra's algorithm and the N-Queens problem; one linear algebra benchmark: General Matrix Multiply (GEMM); and two sorting algorithms: Quicksort and Mergesort.
<!-- TODO: talk about what each benchmark tests -->

### Design Decisions

Additionally, we chose to use the X86O3 CPU model in gem5 for our testing as it is the most advanced option available, and provides common features in modern processors, namely branch prediction.
For branch prediction methods, we chose to use the TAGE predictor as it is the best branch predictor available to date.

### Architectural Generation Specs

<!-- TODO: add sizes, tag latencies -->
- Broadwell (2014) - 14nm
    - l1: size = 32kb, assoc = 8, latency = 4 (both data and instruction)
    - l2: size = 256kb, assoc = 8, latency = 12
    - l3: size = 32768kb, assoc = 8, latency = 50
- Skylake (2015) - 14nm
    - l1: size = 32kb, assoc = 8, latency = 4
    - l2: size = 1024kb, assoc = 16, latency = 14
    - l3: size = 16384kb, assoc = 8, latency = 50

* Note: wanted to look at next generation "Kaby Lake", but it was the same as skylake

The main difference between the Broadwell and Skylake architectures was the changes to the l2 and l3 caches.
The Skylake l2 cache grew to 1024kb and moved to 16-way associativity with a tradeoff of increased latency from 12 to 14 nanoseconds.
The l3 cache shrank from 32mb to 16mb, with no changes in associativity or latency.

<!-- TODO: talk about increased hardware space used for L2 cache? -->
Based on this, it would be a reasonable assumption that Intel chose to reallocate hardware space dedicated to l3 cache storage to add hardware required for increasing the associativity and size of the l2 cache.


<!-- TODO: hybrid model with changed cache sizes? -->

---

# Results

## What we looked at
- 1 ISA (X86)
- 2 Processor Generations (Broadwell, Skylake)
- 4 Benchmarks (GEMM, NQ, QuickSort, MergeSort)
<!-- TODO: add either triangular solve or another graph workload -->
- 1 CPU model (O3CPU)
- 1 Branch prediction method (TAGE)

## Benchmarks
<!--
 TODO: talk about benchmark problem sizes (multiple problem sizes?)

-->

- CPU dcache read/write miss rate is the same across both processors across all benchmarks (L1 caches are the same for both)

<!--
Metrics Worth Looking At:
- system.l2cache.ReadExReq.avgMissLatency::total
- system.l2cache.overallAvgMissLatency.avgMissLatency::total
- system.l2cache.replacements (very big differences between gens)
- system.l2cache.writebacks::total (very big differences between gens)
- system.l2cache.tags.tagAccesses (very big differences between gens)


Maybe worth looking at:
- ipc, cpi
- l1i, l1d, l2, l3, cache hit/miss rates
- avgMissLatency
- cache replacements, writebacks
- tags.dataAccesses, tags.avsOccs::total, tags.avgRefs (mainly l2 and l3)
- snoops, snoop_filter.totSnoops, snoop_filter.totRequests, snoop_filter.hitSingleSnoops (only exists for l2, snoop_filter also for l3)
- branchPred.tage stuff (very different between systems but hard to interpret)
- l3bus.reqLayer0.occupancy
-->

### GEMM
- Broadwell
    - CPI: 0.797
    - IPC: 1.254

- Skylake
    - CPI: 0.800
    - IPC: 1.250

### NQueens

### QuickSort

### MergeSort


## CPU Comparison


## Potential Further Work


