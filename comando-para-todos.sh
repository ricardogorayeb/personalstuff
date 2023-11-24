#!/bin/bash
#########################
# Usage: bash comando-para-todos.sh <user> <command>
########################
for n in $(seq 2 9); do 
  echo "Executando comando \"$2\" como \"$1\" em srvcrmncluster${n}p" 
  ssh  -o "StrictHostKeyChecking no" $1@srvcrmncluster${n}p $2
done
for n in $(seq 10 12); do 
  echo "Executando comando \"$2\" como \"$1\" em srvcrmncluster${n}p" 
  ssh  -o "StrictHostKeyChecking no" $1@srvcrmncluster${n}p $2
done
#for n in $(seq 1 2); do 
#  echo "Executando comando \"$1\" em r710${n}" 
#  ssh r710${n} $1
#done

exit 0
