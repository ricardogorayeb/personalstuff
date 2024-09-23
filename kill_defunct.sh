#!/bin/bash

DEFUNCT_PID=`ps aux | egrep "Z|defunct" | grep -v grep | awk 'NR==2 { print $2 }'`
PARENT_DEFUNCT_PID=`ps -o ppid= $DEFUNCT_PID`
kill -9 $PARENT_DEFUNCT_PID
