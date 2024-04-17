#!/usr/bin/env bash

if command -v docker >/dev/null 2>&1; then
    echo "using docker..."
    docker run --rm dockcross/linux-arm64 > dockcross-linux-arm64
elif command -v podman >/dev/null 2>&1; then
    echo "using podman..."
    podman run --rm dockcross/linux-arm64 > dockcross-linux-arm64
else
    echo "Error: neither Docker nor Podman is installed."
    exit 1
fi

chmod +x dockcross-linux-arm64
# mv dockcross-linux-arm64 ~/bin/
