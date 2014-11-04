#!/bin/bash

# Initializing part
ps xao pid,ppid,pgid,sid,comm | grep chromium | awk '{print $1}' > CTP_initialPids;
while read id; do
	kill -s SIGKILL $id
done < CTP_initialPids;

# Opening tabs
while read page; do
	chromium-browser $page &
	sleep 5s
done < url.in
sleep 30s

# Closing tabs in reverse start time
ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > CTP_sortedPids
cp CTP_sortedPids CTP_sortedPids2
while read pid; do
	echo $pid
	kill -s SIGKILL $pid
	sleep 5s
	#ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > CTP_sortedPids # to be asked
done < CTP_sortedPids

## Related to bugs #2, #3
#export flag=1
#while [ $flag -ne 0 ]; do
#	pkill -nfq chromium
#	export flag=$?
#done

return $?
