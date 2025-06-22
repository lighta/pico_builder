#!/bin/bash 
# Simple helper permettant de convertir le module/main.py en firmware.uf2
set -e

# Set project dir to the script's directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Se placer dans le répertoire du script
cd "$PROJECT_DIR"

MODULE_DIR="${PROJECT_DIR}/module"
FIRMWARE_DIR="${PROJECT_DIR}/firmware"

# Ensure firmware dir exists
mkdir -p "$FIRMWARE_DIR"

# List of boards (for 'ALL' mode)
BOARD_LIST=("RPI_PICO_W" "RPI_PICO2_W")

# Defaults
DEFAULT_IMAGE="micropython-picow-builder:latest"
UPSTREAM_IMAGE="ghcr.io/lighta/micropython-picow-builder:latest"
DOCKER_IMAGE="$DEFAULT_IMAGE"
DO_PULL=false
DO_BUILD_IMAGE=false
BOARD=""

# Function to run docker build for a board
build_board() {
    local board="$1"
    echo "=== BUILDING MICROPYTHON FIRMWARE FOR BOARD: $board ==="
    docker run --rm \
        -v "$MODULE_DIR":/module \
        -v "$FIRMWARE_DIR":/firmware \
        "$DOCKER_IMAGE" "$board"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --board)
            BOARD="$2"
            shift 2
            ;;
        --image)
            DOCKER_IMAGE="$2"
            shift 2
            ;;
        --pull)
            DO_PULL=true
            shift
            ;;
        --build_image)
            DO_BUILD_IMAGE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 --board <BOARD> [--image <DOCKER_IMAGE>] [--pull] [--build_image]"
            echo "Example boards: RPI_PICO_W, RPI_PICO2_W, ALL"
            echo "Defaults:"
            echo "  --image $DEFAULT_IMAGE"
            echo "  --pull → pull from upstream"
            echo "  --build_image → run ./build_builder.sh"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            echo "Usage: $0 --board <BOARD> [--image <DOCKER_IMAGE>] [--pull] [--build_image]"
            exit 1
            ;;
    esac
done

# Check required argument
if [ -z "$BOARD" ]; then
    echo "ERROR: --board <BOARD> is required"
    echo "Usage: $0 --board <BOARD> [--image <DOCKER_IMAGE>] [--pull] [--build_image]"
    exit 1
fi

# Pull and retag only if requested (and only if using default image)
if [ "$DO_PULL" = true ] && [ "$DOCKER_IMAGE" = "$DEFAULT_IMAGE" ]; then
    echo "=== PULLING BUILDER IMAGE: $UPSTREAM_IMAGE ==="
    docker pull "$UPSTREAM_IMAGE"
    echo "=== RETAGGING IMAGE AS: $DEFAULT_IMAGE ==="
    docker tag "$UPSTREAM_IMAGE" "$DEFAULT_IMAGE"
fi

# Build builder image if requested
if [ "$DO_BUILD_IMAGE" = true ]; then
    echo "=== BUILDING LOCAL BUILDER IMAGE VIA ./build_builder.sh ==="
    ./build_builder.sh
fi

# Build logic
if [ "$BOARD" = "ALL" ]; then
    for b in "${BOARD_LIST[@]}"; do
        build_board "$b"
    done
else
    build_board "$BOARD"
fi

echo "=== Build completed ==="
echo "Resulting firmware UF2 files are in: $FIRMWARE_DIR"
