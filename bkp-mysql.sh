#!/bin/bash
DATE=`date +"%d%m%Y"`


tar cvzf /mnt/FILES/bkp-confs-$DATE.tar.gz /var/www/html/proxy.pac /etc/bind/ /var/named/ /etc/zabbix/ /root/*.sh /etc/postfix/ /etc/stunnel/ /etc/apt/sources.list /etc/apt/sources.list.d/ /etc/grafana/grafana.ini 


sudo -u postgres pg_dump -F p -f zabbix_db_backup_file_path --no-owner --no-privileges -d zabbix

#restore bkp
#psql.exe --host "host_ip" --port "5432" --username "zabbix" --password --dbname "zabbix" -f "zabbix_db_backup_file_path”

#mysqldump --lock-all-tables --routines --triggers -u root -p'yourpassword' zabbix > zabbix_db_backup_file_path
#mysqldump --lock-all-tables --routines --triggers -u grafana -p'yourpassword' grafana > grafana_db_backup_file_path