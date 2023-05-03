# Restore zabbix mysql backup on a new server
create database zabbix;

	MariaDB [(none)]> GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost identified by 'xxxx' ;


# need to change utf options
- sed -i 's/utf8mb4_0900_ai_ci/utf8_general_ci/g' /tmp/BackupsDB-zabbix-21042023.sql 
- sed -i 's/CHARSET=utf8mb4/CHARSET=utf8/g'  /tmp/BackupsDB-zabbix-21042023.sql
-  mysql --verbose -u root -p zabbix < /tmp/BackupsDB-zabbix-21042023.sql

# Create zabbix DB on postgres
sudo -u postgres createdb -O zabbix zabbix

# Zabbix pgsql scripts to initial db setup
cat /usr/share/zabbix-sql-scripts/postgresql/proxy.sql | sudo -u zabbix psql zabbix

# PGLoader command to migrate from mysql to postgresql
pgloader mysql://user:pass@127.0.0.1/zabbix postgresql://user:pass@127.0.0.1/zabbix

Sources:
- https://jsosic.wordpress.com/2014/02/18/migrating-zabbix-from-mysql-to-postgresql/
- https://catonrug.blogspot.com/2020/06/oracle-mysql-postgresql-zabbix.html