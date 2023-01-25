#!/bin/bash
ZABBIXSENDER=`which zabbix_sender`



PING=`/home/muran/speedtest-cli --simple | cut -d' ' -f2 | sed -n 1p`
DOWNLOAD=`/home/muran/speedtest-cli --simple | cut -d' ' -f2 | sed -n 2p`
UPLOAD=`/home/muran/speedtest-cli --simple | cut -d' ' -f2 | sed -n 3p`


$ZABBIXSENDER  -z 172.20.5.144 -s "lwrs-sbtt" -k ping_value -o `echo $PING`
$ZABBIXSENDER  -z 172.20.5.144 -s "lwrs-sbtt" -k download_value -o `echo $DOWNLOAD`
$ZABBIXSENDER  -z 172.20.5.144 -s "lwrs-sbtt" -k upload_value -o `echo $UPLOAD`
