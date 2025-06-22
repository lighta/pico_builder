#!/bin/bash
# Ce script sert à générer une image Docker permettant de l'utiliser ensuite pour builder les UF2.
# (Le passage par Docker sert à avoir une architecture commune peu importe l'host).

docker build -t micropython-picow-builder:latest .

if [ "$1" = "up" ]; then
  docker tag micropython-picow-builder:latest ghcr.io/lighta/micropython-picow-builder:latest
  docker push ghcr.io/lighta/micropython-picow-builder:latest
fi
