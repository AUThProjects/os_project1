
#echo "$time $proc_count $max_threads $avg_threads $sum_RSS_mb $max_RSS_mb $avg_vcs $avg_nvcs" >> statsRec.txt

set xlabel "time from start (s)"
set ylabel "process count"
set autoscale
set term png
set output "processCount.png"
plot "statsRec.txt" using 1:2 with lines title "Process Count"


set xlabel "time from start (s)"
set ylabel "threads"
set autoscale
set term png
set output "threadsMaxAvg.png"
plot "statsRec.txt" using 1:3 with lines title "Max Threads", "statsRec.txt" using 1:4 with lines title "Avg Threads" 

set xlabel "time from start (s)"
set ylabel "RSS (MB)"
set autoscale
set term png
set output "rssSumMax.png"
plot "statsRec.txt" using 1:5 with lines title "Sum RSS", "statsRec.txt" using 1:6 with lines title "Max RSS" 

set xlabel "time from start (s)"
set ylabel "Context Switches"
set autoscale
set term png
set output "csAvg.png"
plot "statsRec.txt" using 1:7 with lines title "Voluntary", "statsRec.txt" using 1:8 with lines title "Non-voluntary" 
