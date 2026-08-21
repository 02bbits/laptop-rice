#!/bin/bash

SIZES=(8 12 16)
INTERVAL_MS=2 # ~2s for full wave (3 steps × 666ms ≈ 2s)

# current step in the cycle
step=$((($(date +%s%4N) / INTERVAL_MS) % ${#SIZES[@]}))

b4=$(((step) % ${#SIZES[@]}))
b3=$(((step + ${#SIZES[@]} - 1) % ${#SIZES[@]}))
b2=$(((step + ${#SIZES[@]} - 2) % ${#SIZES[@]}))
b1=$(((step + ${#SIZES[@]} - 3) % ${#SIZES[@]}))

s1=${SIZES[$b1]}
s2=${SIZES[$b2]}
s3=${SIZES[$b3]}
s4=${SIZES[$b4]}

echo "<span font='$s1' color='#ffffff'>|</span><span font='$s2' color='#ffffff'>|</span><span font='$s3' color='#ffffff'>|</span><span font='$s4' color='#ffffff'>|</span>"
