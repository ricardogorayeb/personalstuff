#!/bin/bash
BASENAME=`which basename`
SERVICE=rsync
RSYNC=`which rsync`
BZIP2=`which bzip2`
BASENAME=`which basename`
ZABBIXSENDER=`which zabbix_sender`
INVALIDO=0

DIRVMET="/home/muran/data/rdc-sbmn/scan_vmet/"
DIRXPPI="/home/muran/data/rdc-sbmn/scan_xppi/"

DIRBASEVMET="/home/muran/MVOL.sinc/scan_vmet"
DIRBASEXPPI="/home/muran/MVOL.sinc/scan_xppi"

DIRRSYNCVMET=rsync://root@radproc:/VolumesSBMN_VMET
DIRRSYNCXPPI=rsync://root@radproc:/VolumesSBMN_XPPI

########## TESTE ##
#DIRVMET="/home/divabd/radar/sbmn/vmet"
#DIRXPPI="/home/divabd/radar/sbmn/xppi"

#DIRBASEVMET="/home/divabd/radar/MVOL.sinc/vmet"
#DIRBASEXPPI="/home/divabd/radar/MVOL.sinc/xppi"

#DIRRSYNCVMET=rsync://root@172.20.5.21:/VolumesSBMNVMET
#DIRRSYNCXPPI=rsync://root@172.20.5.21:/VolumesSBMNXPPI

HORAMODDIR=$(( `stat -c %Y $DIRVMET` ))
HORATUAL=$(( `date +%s` ))
TEMPODIF=$(( $HORATUAL - $HORAMODDIR ))
echo $TEMPODIF

#ps ax | grep -v grep | grep $SERVICE > /dev/null
#result=$?
#if [ "${result}" -ne "0" ] && [ $TEMPODIF -lt 5000 ] ; then
#  cd /

#SCAN VMET
echo "CHECANDO SCAN VMET"
  for ARQ in $(ls $DIRVMET | tail -n1350);do
	NUMVOL=$(strings $DIRVMET/$ARQ | grep scan[0-9]|wc -l)
	if [ $NUMVOL -eq 17 ]; then
	INVALIDO=0
	   NOMEVOL=$( $BASENAME $ARQ | sed -r 's/(.*)\--(.{2})\:(.{2})\:(.*\..*)/\1\_\2\3/')
	   	ANO=$(echo ${NOMEVOL} | cut -c1,2,3,4)
		MES=$(echo ${NOMEVOL} | cut -c6,7)
		DIA=$(echo ${NOMEVOL} | cut -c9,10)
           if [ -s $DIRBASEVMET/$ANO/$MES/$DIA/${NOMEVOL}.mvol.bz2 ]; then
		echo "ARQUIVO EXISTE" $NOMEVOL
		$(mv $DIRVMET/$ARQ $DIRVMET/0movidos/$ARQ)
	     else	
		echo "ORGANIZANDO.. ARQUIVO VMET " $ARQ
				
			if [ ! -d $DIRBASEVMET/$ANO ]; then mkdir $DIRBASEVMET/$ANO; fi
	
		
			if [ ! -d $DIRBASEVMET/$ANO/$MES ]; then mkdir $DIRBASEVMET/$ANO/$MES; fi
	
		
			if [ ! -d $DIRBASEVMET/$ANO/$MES/$DIA ]; then mkdir $DIRBASEVMET/$ANO/$MES/$DIA; fi
		    
			echo "COPIANDO ARQUIVO"  $ARQ
			$(cp -rp $DIRVMET/$ARQ $DIRBASEVMET/$ANO/$MES/$DIA/${NOMEVOL}.mvol)
			$(mv $DIRVMET/$ARQ $DIRVMET/0movidos/$ARQ)
			bzip2 -f $DIRBASEVMET/$ANO/$MES/$DIA/${NOMEVOL}.mvol
	 fi
else
#	mv $DIRVMET/$ARQ $DIRVMET/invalidos/$ARQ
	INVALIDO=1
	fi
   done
   
  # rsync -avzp  --files-from=<(ls /home/muran/MVOL.sinc/scan_vmet/ | tail -n1570) /home/muran/MVOL.sinc/scan_vmet/  rsync://root@radproc:/VolumesSBMN
    rsync -avzr --no-t --ignore-existing --remove-source-files --exclude-from=/home/muran/exclude.txt --files-from=<(ls $DIRBASEVMET/ | tail -n1350) $DIRBASEVMET/ $DIRRSYNCVMET 
####   rsync -avzp  --files-from=<(ls /home/muran/MVOL.sinc/scan_vmet/ | tail -n1570) /home/muran/MVOL.sinc/scan_vmet/  rsync://root@radproc:/VolumesSBMN_VMET

#SCAN XPPI
echo "CHECANDO  SCAN XPPI"
for ARQ in $(ls $DIRXPPI |  grep -v '^d' | tail -n350);do
#        for ARQ in $(ls $DIRXPPI | tail -n`ls | cat /home/muran/ultimoxppi.txt | cut -c1`); do

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
			echo $ARQ > /home/muran/ultimoxppi.txt
            	bzip2 -f $DIRBASEXPPI/$ANO/$MES/$DIA/${NOMEVOL}_400.mvol
           fi
        fi
   done
       rsync -avzpr --remove-source-files --exclude-from=/home/muran/exclude.txt  --files-from=<(ls $DIRBASEXPPI/ | tail -n350) $DIRBASEXPPI/ $DIRRSYNCXPPI 
else
INVALIDO=2
fi
$ZABBIXSENDER  -z zabbix_server_ip -s "host_on_zabbix_to_receive_data" -k status_num_elevacoes_mn -o `echo $INVALIDO`

