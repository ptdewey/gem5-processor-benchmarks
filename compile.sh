#!/usr/bin/env bash

# Exit on any error
set -e

# Define the build directories
BUILD_DIR_X86="build/X86"
BUILD_DIR_ARM="build/ARM"

# Ensure the build directories exist
mkdir -p "${BUILD_DIR_X86}"
mkdir -p "${BUILD_DIR_ARM}"

# Function to compile for X86
compile_x86() {
    echo "Compiling for X86..."
    for file in $(find src/Benchmarks -type f -name '*.c'); do
        filename=$(basename "${file}" .c)
        gcc -O0 -ggdb3 -std=c99 -static "${file}" -o "${BUILD_DIR_X86}/${filename}"
    done
}

# Function to compile for ARM using Dockcross
compile_arm() {
    echo "Compiling for ARM..."
    for file in $(find src/Benchmarks -type f -name '*.c'); do
        filename=$(basename "${file}" .c)
        ./dockcross-linux-armv7 bash -c '$CC '"${file}"' -O0 -ggdb3 -std=c99 -static -o '"${BUILD_DIR_ARM}/${filename}"
        # ./dockcross-linux-arm64 bash -c '$CC '"${file}"' -O0 -ggdb3 -std=c99 -o '"${BUILD_DIR_ARM}/${filename}"
    done
}

# Execute compilation functions
compile_x86
! [ -z "$1" ] && compile_arm

echo "Compilation complete."
