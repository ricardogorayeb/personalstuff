#!/bin/bash

DATA=`date +%d%m%Y`
#PROCESSO=/radarfs/storage/castanheira/
#OCORRENCIAS=`ps ax | grep $PROCESSO | grep -v grep| wc -l`
#echo $PROCESSO 
#echo $OCORRENCIAS
#if [ $OCORRENCIAS -eq 0 ]; then
	echo "Hora Inicio - `date +%d%m%Y-%H:%M`  " >> /radarfs/log/rsync-radproc-castanheira-$DATA.log

	rsync -Crav --ignore-existing /radarfs/MVOL/  /radarfs/storage/castanheira/ >> /radarfs/log/rsync-radproc-castanheira-$DATA.log


	echo "Hora Fim - `date +%d%m%Y-%H:%M` " >> /radarfs/log/rsync-radproc-castanheira-$DATA.log

#fi

