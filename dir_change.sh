#!/bin/bash
#Usage: bash dir_change.sh <radar>



YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`


DIR=/radarfs/MVOL/$1/vmet/$YEAR/$MONTH/$DAY
date -d "`stat -c %y $DIR`" +"%s"
