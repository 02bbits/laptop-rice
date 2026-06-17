#!/bin/bash

width=$(tput cols)
hour=$(date '+%_H')

if [[ "$hour" -ge 4 && "$hour" -lt 12 ]]; then
    echo " "
elif [[ "$hour" -ge 12 && "$hour" -le 17 ]]; then
    Echo " "
else
    echo " "
fi
