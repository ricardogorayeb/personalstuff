#!/bin/bash
ANO=$(date +%Y)
MES=$(date +%m)
DIA=$(date +%d)

if [[ -d /radarfs/MVOL/sbbe/vmet/$ANO/$MES/$DIA ]]
then
	echo /radarfs/MVOL/sbbe/vmet/$ANO/$MES/$DIA/ IN_CREATE,IN_MOVED_TO /radarfs/scripts/sincStorageBE.sh > /var/spool/incron/root

else
	mkdir -p /radarfs/MVOL/sbbe/vmet/$ANO/$MES/$DIA/
	echo /radarfs/MVOL/sbbe/vmet/$ANO/$MES/$DIA/ IN_CREATE,IN_MOVED_TO /radarfs/scripts/sincStorageBE.sh > /var/spool/incron/root
fi
