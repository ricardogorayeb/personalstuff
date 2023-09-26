#!/bin/bash

# Controle de execuções simultâneas
# Evita que haja mais de uma instância deste script executando.

ESTE=$(basename ${0})
LOCKFILE=/tmp/${ESTE}.pid

if [[ -s ${LOCKFILE} ]]; then
	PIDLOCK=$(cat ${LOCKFILE})
	if ! kill -0 ${PIDLOCK} 2> /dev/null; then
		echo "${LOCKFILE} existe, mas o processo ${PIDLOCK} não está em execução. Continuando.";
	else
		echo "Script ${ESTE} ainda está em execução (PID ${PIDLOCK}). Saindo."
		exit 2;
	fi
fi

echo $$ > "${LOCKFILE}";

BASENAME=`which basename`
SERVICE=rsync
RSYNC=`which rsync`
BZIP2=`which bzip2`
BASENAME=`which basename`
ZABBIXSENDER=`which zabbix_sender`
INVALIDO=0
NOME_MAQUINA=`hostname`
LOCAL_RADAR=${NOME_MAQUINA: -4}

DIRVMET="/home/muran/data/rdc-$LOCAL_RADAR/scan_vmet/"
DIRXPPI="/home/muran/data/rdc-$LOCAL_RADAR/scan_xppi/"

DIRBASEVMET="/home/muran/MVOL.sinc/scan_vmet"
DIRBASEXPPI="/home/muran/MVOL.sinc/scan_xppi"

DIRRSYNCVMET=rsync://root@radproc:/Volumes${LOCAL_RADAR^^}_VMET
DIRRSYNCXPPI=rsync://root@radproc:/Volumes${LOCAL_RADAR^^}_XPPI

HORAMODDIR=$(( `stat -c %Y $DIRVMET` ))
HORATUAL=$(( `date +%s` ))
TEMPODIF=$(( $HORATUAL - $HORAMODDIR ))

# arquivos de controle para RSYNC

#SCAN VMET
echo "CHECANDO SCAN VMET"

for ARQFULL in $(ls $DIRVMET/*.mvol | tail -n850);do
	ARQ=`basename $ARQFULL`
	NUMVOL=$(strings $DIRVMET/$ARQ | grep scan[0-9]|wc -l)
	echo "QTD ARQS:"$NUMVOL

	if [ $NUMVOL -eq 17 ]; then
		INVALIDO=0
		NOMEVOL=$( $BASENAME $ARQ | sed -r 's/(.*)\--(.{2})\:(.{2})\:(.*\..*)/\1\_\2\3/')
		ANO=$(echo ${NOMEVOL} | cut -c1,2,3,4)
		MES=$(echo ${NOMEVOL} | cut -c6,7)
		DIA=$(echo ${NOMEVOL} | cut -c9,10)
		if [ -s $DIRBASEVMET/$ANO/$MES/$DIA/${NOMEVOL}.mvol.bz2 ]; then
			echo "ARQUIVO EXISTE" $NOMEVOL
			mv $DIRVMET/$ARQ $DIRVMET/0movidos/$ARQ
		else	
			echo "ORGANIZANDO.. ARQUIVO VMET " $ARQ
			if [ ! -d $DIRBASEVMET/$ANO ]; then mkdir $DIRBASEVMET/$ANO; fi
			if [ ! -d $DIRBASEVMET/$ANO/$MES ]; then mkdir $DIRBASEVMET/$ANO/$MES; fi
			if [ ! -d $DIRBASEVMET/$ANO/$MES/$DIA ]; then mkdir $DIRBASEVMET/$ANO/$MES/$DIA; fi
			echo "COPIANDO ARQUIVO"  $ARQ
			$(cp -rp $DIRVMET/$ARQ $DIRBASEVMET/$ANO/$MES/$DIA/${NOMEVOL}.mvol)
			mv $DIRVMET/$ARQ $DIRVMET/0movidos/$ARQ
			bzip2 -f $DIRBASEVMET/$ANO/$MES/$DIA/${NOMEVOL}.mvol
		fi
	else
		INVALIDO=1
	fi
done
   
rsync -avzr --no-t --remove-source-files --exclude-from=/home/muran/exclude.txt --files-from=<(ls $DIRBASEVMET/ | tail -n850) $DIRBASEVMET/ $DIRRSYNCVMET 

#SCAN XPPI
echo "CHECANDO  SCAN XPPI"
for ARQ in $(ls $DIRXPPI | tail -n350);do
	NUMVOL=$(strings $DIRXPPI/$ARQ | grep scan[0-9]|wc -l)
	echo "$NUMVOL"

        if [ $NUMVOL -eq 3 ]; then
		NOMEVOL=$( $BASENAME $ARQ | sed -r 's/(.*)\--(.{2})\:(.{2})\:(.*\..*)/\1\_\2\3/')
		ANO=$(echo ${NOMEVOL} | cut -c1,2,3,4)
		MES=$(echo ${NOMEVOL} | cut -c6,7)
		DIA=$(echo ${NOMEVOL} | cut -c9,10)

		if [ -s $DIRBASEXPPI/$ANO/$MES/$DIA/${NOMEVOL}_400.mvol.bz2 ]; then
			echo "ARQUIVO EXISTE" $NOMEVOL
			mv $DIRXPPI/$ARQ $DIRXPPI/0movidos/$ARQ
		else
			echo "ORGANIZANDO.. ARQUIVO XPPI "$ARQ
			if [ ! -d $DIRBASEXPPI/$ANO ]; then mkdir $DIRBASEXPPI/$ANO; fi
			if [ ! -d $DIRBASEXPPI/$ANO/$MES ]; then mkdir $DIRBASEXPPI/$ANO/$MES; fi
			if [ ! -d $DIRBASEXPPI/$ANO/$MES/$DIA ]; then mkdir $DIRBASEXPPI/$ANO/$MES/$DIA; fi
			echo "COPIANDO ARQUIVO "  $ARQ
			$(cp -rp $DIRXPPI/$ARQ $DIRBASEXPPI/$ANO/$MES/$DIA/${NOMEVOL}_400.mvol)
			mv $DIRXPPI/$ARQ $DIRXPPI/0movidos/$ARQ
			bzip2 -f $DIRBASEXPPI/$ANO/$MES/$DIA/${NOMEVOL}_400.mvol
		fi
        fi
done

rsync -avzpr --remove-source-files --exclude-from=/home/muran/exclude.txt  --files-from=<(ls $DIRBASEXPPI/ | tail -n350) $DIRBASEXPPI/ $DIRRSYNCXPPI 

$ZABBIXSENDER -z 172.20.5.144 -s "srvcrmnradproc1p" -k status_num_elevacoes_$LOCAL_RADAR -o `echo $INVALIDO`

# Remove arquivo de trava
rm -f "${LOCKFILE}";
