#!/usr/bin/env bash

build_dir="./build"
output_dir="./benchmark_stats"

# NOTE: change as necessary
# processor_types=("TimingSimple" "O3")

# TODO: architecture generations (broadwell, skylake, {icelake?})
# - add in list and iterate over, add to cli args
generations=("Broadwell" "Skylake")

run_simulation() {
    local binary_name=$1
    local gen=$2
    local isa=$3
    # local processor_type=$4
    local gem5_dir="${HOME}/gem5_workspace/gem5/build/${isa}"
    local script="main.py"
    # local args="--isa ${isa} --binary ${binary_name}"
    local args="${binary_name} ${gen} ${isa}"
    local binname=$(basename "$binary_name")
    local stats_file="stats-${binname}-${gen}-${isa}.txt"

    echo "Running simulation for ${binary_name} with ISA ${isa} and processor type ${processor_type}..."
    "${gem5_dir}/gem5.opt" --stats-file="${stats_file}" -d "${output_dir}" ${script} ${args} &
}

# iterate over ISA types with compiled binaries in ./build
for isa_dir in "$build_dir"/*; do
    isa_type=$(basename "$isa_dir")
    # iterate over architectural generations
    for gen in "${generations[@]}"; do
        # iterate over binaries within ISA build directory
        for binary in "$isa_dir"/*; do
            echo "Processing $binary for generation $gen with ISA $isa_type"
            if [[ -f "$binary" ]]; then
                echo "Processing $binary for generation $gen with ISA $isa_type"
                run_simulation "$binary" $gen $isa_type
            fi
        done
    done
done
wait

echo "All simulations completed."
