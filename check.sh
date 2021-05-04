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
		#ULTIMO ARQUIVO DO DIRETORIO
		FILE=`ls -Atr | tail -n 1`
		
		#HORA_ARQUIVO=$(( `echo $FILE | cut -c12-13` * 3600 ))
		#MINUTO_ARQUIVO=$(( `echo $FILE | cut -c14-15` * 60 ))
		#TEMPO_ARQUIVO=$(( $HORA_ARQUIVO + $MINUTO_ARQUIVO ))
		
		#TEMPO DE MODIFICACAO DO ARQUIVO EM SEGUNDOS COMPARADO COM A HORA DE DISPONIBILIZACAO
		# DO ARQUIVO NO CRMN
		#TEMPO_ARQUIVO=$(( `date +%s -r /radarfs/MVOL/$1/vmet/$ANO/$MES/$DIA/$FILE` ))
		
		# PEGA A HORA QUE ESTÁ NO NOME DO ARQUIVO E A TRANSFORMA EM SEGUNDOS
		cd /radarfs/MVOL/$1/vmet/$ANO/$MES/$DIA/
		#TEMPO_ARQUIVO=$(( `echo $FILE | cut -c12-15` ))
		## (?<=) is lookbehind, (?<=_) matches an underscore _ before pattern.
		#\d+ matches one or more number.
		#(?=) is lookahead, (?=\.) matches a dot . after pattern.

		TEMPO_ARQUIVO=$(( `echo $FILE | grep -oP '(?<=_)\d+(?=\.)'` ))
		HORA_ARQUIVO=$(( `date --date $TEMPO_ARQUIVO +%s` ))
		#echo TARQ $TEMPO_ARQUIVO
		#echo HA $HORA_ARQUIVO
		#CALCULA EM SEGUNDOS A HORA ATUAL
		TEMPO_ATUAL=$( date +%s )
		#echo TA $TEMPO_ATUAL

		#CALCULA A DIFERENCA ENTRE A HORA ATUAL E A HORA DO ARQUIVO

		DIFERENCA=$(( $TEMPO_ATUAL - $HORA_ARQUIVO ))
		#echo $DIFERENCA
		#SE A DIFERENCA FOR MAIOR QUE 40M(2400 SEGUNDOS), ESTA ATRASADO (1)
		if [ $DIFERENCA -gt 2400 ]
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
