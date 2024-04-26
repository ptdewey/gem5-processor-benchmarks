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


