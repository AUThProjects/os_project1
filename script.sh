#!/bin/bash -x

# Initializing part
ps xao pid,ppid,pgid,sid,comm | grep chromium | awk '{print $1}' > CTP_initialPids;
while read id; do
	kill -s SIGKILL $id
done < CTP_initialPids;

# Opening tabs
while read page; do
	chromium-browser $page &
	sleep 2s
done < url.in
sleep 5s

# Closing tabs in reverse start time
ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > CTP_sortedPids
#cp CTP_sortedPids CTP_sortedPids2
#while read pid; do
#	echo $pid
#	kill -s SIGKILL $pid
#	sleep 5s
#	#ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > CTP_sortedPids # to be asked
#done < CTP_sortedPids

#IFS=$'\n'
#for pid in $(cat CTP_sortedPids)
#do
#    echo $pid
#    kill -s SIGKILL $pid
#    sleep 5s
#done

while [ $(wc -l CTP_sortedPids | awk '{print $1}') -ne 0 ]
do
    # Handle defunct processes (kill parent)
    if [[ $last_pid -eq `head -n1 CTP_sortedPids` ]]
    then
        echo "defunct"
        sed -i '1d' CTP_sortedPids
    fi
    kill -s SIGKILL `head -n1 CTP_sortedPids`
    export last_pid=`head -n1 CTP_sortedPids`
    sleep 5s
    ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > CTP_sortedPids
done
exit $?
