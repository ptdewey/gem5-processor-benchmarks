#!/usr/bin/env bash

build_dir="./build"
output_dir="./run_stats"

# NOTE: change as necessary
processor_types=("TimingSimple" "O3")

run_simulation() {
    local binary_name=$1
    local isa=$2
    local processor_type=$3
    local gem5_dir="${HOME}/gem5_workspace/gem5/build/${isa}"
    local bp_script="main.py ${binary_name} ${isa}"
    local stats_file="stats-${processor_type}-${binary_name}-${isa}.txt"

    echo "Running simulation for ${binary_name} with ISA ${isa} and processor type ${processor_type}..."
    "${gem5_dir}/gem5.opt" --stats-file="${stats_file}" -d "${output_dir}" "${bp_script}" &
}

for isa_dir in "$build_dir"/*; do
    isa_type=$(basename "$isa_dir")
    for binary in "$isa_dir"/*; do
        echo "Processing $binary for ISA $isa_type"
        if [ "$isa_type" == "X86" ]; then
            echo "Running X86 for $binary"
            ./"$binary" &
        elif [ "$isa_type" == "ARM" ]; then
            echo "Running ARM for $binary"
            ./"$binary" &
        else
            echo "Unknown ISA type for $binary"
        fi
    done
    wait
done

echo "All simulations completed."
