#!/bin/bash
usage()
{
echo 'Usage: bash junta_pdf.sh 05 2005 01'
echo 'First parameter: Two Digit Year'
echo 'Second pameter: Four Digit Year'
echo 'Third parameter: volume'
exit
}

if [ "$#" -ne 3 ]
then
  usage
fi

YY=$1
YYYY=$2
VOLUME=$3
CAPAS_PATH=/home/ricardo.gorayeb/tmp/boletim/Novos_boletins/$YYYY/boletim_pdf_$YYYY
BOLETIM_PATH=/home/ricardo.gorayeb/tmp/boletim/$YY/newname
BOLETIM_NOVA_CAPA_PATH=/home/ricardo.gorayeb/tmp/boletim/boletim_nova_capa/

if [ ! -d /home/ricardo.gorayeb/tmp/boletim/boletim_nova_capa/$YYYY ]; then
	mkdir /home/ricardo.gorayeb/tmp/boletim/boletim_nova_capa/$YYYY
fi
#ls $CAPAS_PATH/bolclima_$YYYY\01_v01_n01.pdf 
for n in {01..12}
do
#ls $CAPAS_PATH/bolclima_$YYYY$n\_v$VOLUME\_n$n.pdf 
pdfunite $CAPAS_PATH/bolclima_$YYYY$n\_v$VOLUME\_n$n.pdf $BOLETIM_PATH/bolclima_$YYYY$n\_v$VOLUME\_n$n.pdf $BOLETIM_NOVA_CAPA_PATH/$YYYY/bolclima_$YYYY$n\_v$VOLUME\_n$n.pdf
done
