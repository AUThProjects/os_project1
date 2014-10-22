#!/bin/bash -x

# Initializing part
ps xao pid,ppid,pgid,sid,comm | grep chromium | awk '{print $1}' > initialPids;
while read id; do
	kill -s SIGKILL $id
done < initialPids;

# Opening tabs
while read page; do
	chromium-browser $page &
	sleep 5s
done < urls2 #url.in
sleep 2s # 30s;

ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > sortedPids
while read pid; do
	kill -s SIGKILL $pid
	sleep 5s
	ps kstart_time -ef | grep [c]hromium | awk '{print $2}' | tac > sortedPids
done < "`tail -n 1 sortedPids`"
