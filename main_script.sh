#!/bin/bash

# Main script spawning secondary jobs

./script.sh & # Chromium process handling in background
./statistics.sh # Gather statistics

# Draw plots according to statistics.sh output
if [ -e statsRec.txt ]; then
	gnuplot plot_processCount.gp
fi


