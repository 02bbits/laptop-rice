#!/bin/bash

SIZES=(8 12 16)
INTERVAL_MS=100 # milliseconds per step

step=$((($(date +%s%3N) / INTERVAL_MS) % ${#SIZES[@]}))
size=${SIZES[$step]}

echo "<span font='$size' color='#ffffff'>||</span>"
