## Count unique IPs on access.log apache file
## and send it to Zabbix Server




zabbix_sender -z <zabbix_ip_address> -s "<host_on_zabbix>" -k <item_key> -o "`cat /var/log/apache2/access.log | awk '{ print $1 }' | sed 's/,//' | sort | uniq -c 