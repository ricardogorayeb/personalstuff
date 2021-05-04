#!/bin/bash

#ANO=$(echo $i | cut -c3,4,5,6)
#MES=$(echo $i | cut -c8,9)
#DIA=$(echo $i | cut -c11,12)

ANO=$(date +%Y)
MES=$(date +%m)
DIA=$(date +%d)
HORA=$(date +%H)
MINUTO=$(date +%M)

cd /radarfs/MVOL/$1/vmet/$ANO/$MES/$DIA/ 
FILE=`ls -Atr | tail -n 1`

HORA_ARQUIVO=`echo $FILE | cut -c12-13`
MINUTO_ARQUIVO=`echo $FILE | cut -c14-15`

echo $HORA_ARQUIVO
echo $MINUTO_ARQUIVO

STRING1="$HORA_ARQUIVO:$MINUTO_ARQUIVO:00"
STARTDATE=$(date -u -d "$STRING1" +"%s")

#FINALDATE=$(date +"%s")
#DIF_HORA=`expr $HORA - $HORA_ARQUIVO`
#DIF_MINUTO=`expr $MINUTO - $MINUTO_ARQUIVO`
#echo $DIF_HORA
#echo $DIF_MINUTO

DIFERENCA=`date -u -d "0 $FINALDATE sec - $STARTDATE sec" +"%M"`

echo $DIFERENCA

if [ $DIFERENCA -lt 60 ]
	then
		if [ ! -e /opt/INPE/$1/$FILE ]
			then
				cp $FILE /opt/INPE/$1
				#cd /opt/INPE/$1
				#bunzip2 $FILE
				#/root/INPE/GERADOR_RADAR/cappi.exe `ls -Atr | tail -n 1` 
			else
				echo "arquivo existe"

		fi
fi
