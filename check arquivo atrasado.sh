#!/bin/bash


#dia=`date +%d`
#mes=`date +%m`
#ano=`date +%Y` 

#echo $dia
#echo $mes
#echo $ano

#ls -ld /radarfs/MVOL/sbbe/vmet/$ano/$mes/$dia/

#for i in sbbe sbbv sbcz sbmn sbmq sbpv sbsl sbsn sbtf sbtt sbua
#	do

#		if [ -d /radarfs/MVOL/$1/vmet/$ano/$mes/$dia/ ]
#			then
#				HORADIR=$(($(date +%s)-$(stat -c '%Y' /radarfs/MVOL/$1/vmet/$ano/$mes/$dia/`ls /radarfs/MVOL/$1/vmet/$ano/$mes/$dia/ -Art | tail -n 1`)))

#				TEMPOS=$(echo $HORADIR/60 | bc)

#				if [ $TEMPOS -gt 120  ]
#					then
#						echo '1' 
#					else   
#						echo '0'
#				fi
#			else
#				echo '1'
#		fi
#
#	done

#!/bin/bash

#ANO=$(echo $i | cut -c3,4,5,6)
#MES=$(echo $i | cut -c8,9)
#DIA=$(echo $i | cut -c11,12)

ANO=$(date +%Y)
MES=$(date +%m)
DIA=$(date +%d)
HORA=$(date +%H)
MINUTO=$(date +%M)

#Checa se diretorio existe
if [ -d /radarfs/MVOL/$1/vmet/$ANO/$MES/$DIA/ ]
then
	cd /radarfs/MVOL/$1/vmet/$ANO/$MES/$DIA/ 
	#Checa se o diretório está vazio
	RESULTADO=`ls | wc -l`
	if [ $RESULTADO -gt 0 ]; then
		#PEGA O ARQUIVO MAIS RECENTE
		FILE=`ls -Atr | tail -n 1`
		#MINUTOS E HORA DO ARQUIVO MAIS RECENTE
		HORA_ARQUIVO=`echo $FILE | cut -c12-13`
		MINUTO_ARQUIVO=`echo $FILE | cut -c14-15`


		STRING1="$HORA_ARQUIVO:$MINUTO_ARQUIVO:00"
		STARTDATE=$(date -u -d "$STRING1" +"%s")

		#DIFERENCA ENTRE A DATA ATUAL E A DATA DO ARQUIVO
		DIFERENCA=`date -u -d "0 $FINALDATE sec - $STARTDATE sec" +"%M"`

		#SE A DIFERENCA FOR MAIOR QUE 60, ESTA ATRASADO
		if [ $DIFERENCA -gt 60 ]
			then
				echo 1
			else
				echo 0		
		fi
	else
		echo 1
	fi
else
	echo 1
fi
