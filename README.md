# A Comparison of Broadwell and Skylake Processors Using gem5

## Project Structure

The project writeup will be submitted on canvas and not included in the GitHub Repository

[Project Repository](https://github.com/ptdewey/gem5-processor-benchmarks/tree/main/analysis)

### Scripts
We wrote a number of scripts to assist with compiling and running our simulations, each of which can be found in the project root directory on GitHub.

Among these scripts, we have `compile.sh` which when run, will compile each benchmark into a directory called `build/X86` (and `build/ARM` if any additional arguments are appended). There is also a Makefile that calls this script as the default target.

`run.sh` can be called to run simulations for each defined ISA (directory in `build/`), each processor model (defined in an array in the run script), and each binary in the build directory.


Additionally, we have a script called `get-dockcross-image.sh` which fetches a specified Dockcross cross compiler image from docker hub. (This was created when we were focused on profiling ARM CPUs)


### gem5 Configuration

For our gem5 configuration, we used a file `main.py` as the main configuration file, and it allows running of a specified binary.

We also created separate files for specifying CPU cache sizes, `broadwell_caches.py` and `skylake_caches.py`, which are set up to emulate Broadwell and Skylake CPUs respectively.


### Benchmarks

We used 5 different benchmarks for our evaluation, each of which can be found in a subdirectory of `src/Benchmarks/` as follows:

- Graph Theory
    - N-Queens
    - Dijkstra's Algorithm
- Linear Algebra
    - Generalized Matrix Multiplication
- Sorting
    - Mergesort
    - Quicksort


Problem sizes can be modified individually for each benchmark in a `#define` directive near the top of the file. See the writeup for problem sizes we used for analysis.


### Analysis

We also wrote a few scripts to assist with our analysis, each of which can be found in `analysis/`. These were mainly used for aggregating data across many simulation runs, and for performing some statistical tests.


## How to Run

1. Clone repo and move contents to `gem5_workspace` directory
2. Run `make` in project root directory or run `./compile.sh` with no arguments
3. Run `./run.sh` and it will run if there are no issues
4. Statistics will be available in `benchmark_stats/` with stat files named based on ISA, binary, and processor name
5. (Optional) If aggregation is desired, run `Rscript analysis/read_benchmark.R benchmark_stats` on a system with R installed, and a file called `all_stats.csv` will be created in the `benchmark_stats` directory.

