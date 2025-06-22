#!/bin/bash
set -e

# Usage:
# docker run --rm -v $(pwd)/firmware:/firmware ghcr.io/lighta/micropython-picow-builder RPI_PICO_W
# or:
# docker run --rm -v $(pwd)/firmware:/firmware ghcr.io/lighta/micropython-picow-builder RPI_PICO2_W

BOARD="$1"

if [ -z "$BOARD" ]; then
    echo "Usage: $0 <BOARD>"
    echo "Example boards: RPI_PICO_W or RPI_PICO2_W"
    exit 1
fi

echo "=== BUILDING MICROPYTHON FIRMWARE FOR BOARD: $BOARD ==="

# Paths
cd /opt/micropython/ports/rp2

# Copy user modules if provided
if [ -d /module ]; then
    echo "===> Copying user *.py to modules/"
    mkdir -p modules
    cp /module/*.py modules/ || true
fi

# Build firmware
echo "===> Running make for $BOARD"
make BOARD="$BOARD" -j$(nproc)

# Copy firmware
mkdir -p /firmware
cp "/opt/micropython/ports/rp2/build-${BOARD}/firmware.uf2" "/firmware/firmware_${BOARD}_$(date +%Y%m%d_%H%M%S).uf2"

echo "=== Build completed for $BOARD ==="
echo "UF2 file created:"
ls -lh /firmware/*.uf2
