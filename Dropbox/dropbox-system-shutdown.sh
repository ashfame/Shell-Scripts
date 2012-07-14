#!/bin/bash

echo '======================================'
echo '==== Dropbox System Shutdown Script'
echo '==== @author Ashfame'
echo '==== @url https://github.com/ashfame'
echo '==== @url https://twitter.com/ashfame'
echo '======================================'

echo 'Waiting for Dropbox to finish sync'

while true
do
	# keep checking for idle dropbox status
	STATUS=`dropbox status`
	
	if [ "$STATUS" = 'Idle' ]; then
		echo 'Dropbox sync complete'
		notify-send "System Shutdown" "System will power off now"
		sleep 10
		shutdown -P
		exit
	fi
	
	# wait for 10 secs for the next check (iteration)
	sleep 10
done

exit
