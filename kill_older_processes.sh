#List and kill all USER processes older than TIME
#Source:https://www.baeldung.com/linux/kill-all-processes-older-than-age
#Source: Google IA

TIME=9600 
ps -eo pid,etimes,cmd,user | awk -v user=<your_user> '{if ($2>="$TIME" && $4==user)  print $1}' | grep -v grep

