#!/usr/bin/env bash

BINARY_DIR="build"
OUTPUT_DIR="run_stats"

# directories for different ISA builds
ISA_MODELS=("X86" "ARM") # "POWER")

# NOTE: change as necessary
PROCESSOR_TYPES=("TimingSimple" "O3")

run_simulation() {
    local binary_name=$1
    local isa=$2
    local processor_type=$3
    local gem5_dir="gem5/build/${isa}"
    local bp_script="main.py ${processor_type} ${binary_name}"
    local stats_file="stats-${processor_type}-${binary_name}-${isa}.txt"

    echo "Running simulation for ${binary_name} with ISA ${isa} and processor type ${processor_type}..."
    "${gem5_dir}/gem5.opt" --stats-file="${stats_file}" -d "${OUTPUT_DIR}" "${bp_script}" &
}

for isa in "${ISA_MODELS[@]}"; do
    echo "Starting simulations for ISA ${isa}..."
    # for processor_type in "${PROCESSOR_TYPES[@]}"; do
        # echo "Using processor type ${processor_type}..."
        for binary in "${BINARY_DIR}"/*; do
            binary_name=$(basename "${binary}")
            run_simulation "${binary_name}" "${isa}" # "${processor_type}"
        done
        wait
        # echo "Completed all simulations for processor type ${processor_type}."
    # done
    echo "Completed simulations for ISA ${isa}."
done

echo "All simulations completed."
