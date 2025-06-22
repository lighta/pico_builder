#!/bin/bash 
#Simple helper permettant de convertire le module/main.py en firmware.uf2
set -e

BOARD="$1"

if [ -z "$BOARD" ]; then
    echo "Usage: $0 <BOARD>"
    echo "Example boards: RPI_PICO_W or RPI_PICO2_W"
    exit 1
fi

docker pull ghcr.io/lighta/micropython-picow-builder:latest
echo "=== BUILDING MICROPYTHON FIRMWARE FOR BOARD ($BOARD) ==="
docker run --rm \
    -v $(pwd)/module:/module \
    -v $(pwd)/firmware:/firmware \
    ghcr.io/lighta/micropython-picow-builder:latest $BOARD
echo "=== Result should be in /firmware folder ==="