#!/bin/bash 
#Simple scripts permetant de convertir le sample en firmware.uf2
set -e

echo "=== Starting sample generation ==="

echo "=== Result should be in /firmware folder ==="

cd ../..
cp samples/s1/module/* ./module/.
./main.sh --board ALL

echo "=== Done sample generation ==="