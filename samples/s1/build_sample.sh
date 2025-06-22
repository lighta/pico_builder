#!/bin/bash 
#Simple scripts permetant de convertir le sample en firmware.uf2
set -e

echo "=== Starting sample generation ==="

echo "=== Result should be in /firmware folder ==="

cd ../..
cp samples/s1/module/* ./module/.
./build_uf2.sh

echo "=== Done sample generation ==="