#!/bin/bash -x

# Get initial PIDs
ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > GS_sortedPids

if [ -e statsRec.txt ]; then
	rm statsRec.txt
fi

export flag="`wc -l GS_sortedPids | awk '{ print $1 }'`"
export iteration=0

while [ $flag -ne 0 ] 
do
	export max_threads=0
	export sum_threads=0
	export max_RSS=0 # Resident Set Size
	export sum_RSS=0
	export sum_vcs=0 # Voluntary Context Switches
	export sum_nvcs=0 #Non-voluntary Context Switches
	export proc_count=$flag
	
	while read pid; do
		# Thread count
		threads="`cat "/proc/$pid/status" | grep -i "threads" | awk '{ print $2 }'`"
		((sum_threads+=threads))
		if [ $threads -gt $max_threads ]; then
			export max_threads=$threads
		fi
		
		# Memory count
		RSS="`cat "/proc/$pid/status" | grep -i "vmrss" | awk '{ print $2 }'`"
		((sum_RSS+=RSS))
		if [ $RSS -gt $max_RSS ]; then
			export max_RSS=$RSS
		fi

		# Context Switching count
		vcs="`cat "/proc/$pid/status" | grep -ie "^voluntary" | awk '{ print $2 }'`"
		((sum_vcs+=vcs))
		
		nvcs="`cat "/proc/$pid/status" | grep -ie "^nonvoluntary" | awk '{ print $2 }'`"
		((sum_nvcs+=nvcs))
	done < GS_sortedPids

	export time="`echo "$iteration * 0.5" | bc -l`"
	
	# Divide by zero exception handling
	if [ $proc_count -ne 0 ]; then	
		export avg_threads="`echo "scale=2;$sum_threads / $proc_count" | bc -l`"
		export sum_RSS_mb="`echo "scale=2;$sum_RSS / 1024" | bc -l`"
		export max_RSS_mb="`echo "scale=2;$max_RSS / 1024" | bc -l`"
		export avg_vcs="`echo "scale=2;$sum_vcs / $proc_count" | bc -l`"
		export avg_nvcs="`echo "scale=2;$sum_nvcs / $proc_count" | bc -l`"
	else
		export avg_threads=0
		export sum_RSS_mb=0
		export max_RSS_mb=0
		export avg_vcs=0
		export avg_nvcs=0
	fi
	
	# Append result in line
	echo "$time $proc_count $max_threads $avg_threads $sum_RSS_mb $max_RSS_mb $avg_vcs $avg_nvcs" >> statsRec.txt

	# Rescan for chromium processes
	ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > GS_sortedPids
	
	# Update flag for next iteration
	export flag="`wc -l GS_sortedPids | awk '{ print $1 }'`"
	sleep 0.5s;
	((iteration++))
done

echo "$iteration 0 0 0 0 0 0 0" # Last iteration means no chromium process

return $?