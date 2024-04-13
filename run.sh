#!/usr/bin/env bash

GEM5_DIR="gem5/build/X86"
BINARY_DIR="build"
OUTPUT_DIR="run_stats"

# NOTE: change as necessary
declare -a PROCESSOR_TYPES=("TimingSimple" "X86O3")

# Function to run a simulation for a given binary and processor type.
run_simulation() {
    local binary_name=$1
    local processor_type=$2
    local bp_script="${processor_type}_${binary_name}.py"
    local stats_file="stats-${binary_name}-${processor_type}.txt"
    
    echo "Running simulation for ${binary_name} with processor ${processor_type}..."
    "${GEM5_DIR}/gem5.opt" --stats-file="${stats_file}" -d "${OUTPUT_DIR}" "${bp_script}" &
}

# Main loop to iterate over all compiled binaries and processor types.
for binary in "${BINARY_DIR}"/*; do
    binary_name=$(basename "${binary}")
    echo "Starting simulations for ${binary_name}..."
    for processor_type in "${PROCESSOR_TYPES[@]}"; do
        run_simulation "${binary_name}" "${processor_type}"
    done
    wait
    echo "Completed all simulations for ${binary_name}."
done

echo "All simulations completed."
