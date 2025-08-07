#List and kill all USER processes older than TIME
#Source:https://www.baeldung.com/linux/kill-all-processes-older-than-age

TIME=9600 
USER=pid_user
ps -eo pid,etimes,cmd,user | awk '$2 > $TIME && $5 == "$USER"' | awk '{ print $1 }' | xargs kill -9
