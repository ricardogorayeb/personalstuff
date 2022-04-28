#!/bin/bash
DATE=`date +"%d%m%Y"`

tar cvzf /mnt/FILES/PUBLICO_COTEC/BACKUP/SQL/bkp-confs.tar.gz /var/www/html/proxy.pac /etc/bind/ /var/named/ /etc/zabbix/ /root/*.sh /etc/postfix/ /etc/stunnel/ 


mysqldump --lock-all-tables --routines --triggers -u root -ppassword zabbix > /mnt/FILES/PUBLICO_COTEC/BACKUP/SQL/BackupsDB-zabbix-$DATE.sql
