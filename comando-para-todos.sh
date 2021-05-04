#!/bin/bash

#for n in $(seq 1 9); do 
#  echo "Executando comando \"$1\" em blade0${n}" 
#  ssh  -o "StrictHostKeyChecking no" blade0${n} $1
#done
for n in $(seq 11 16); do 
  echo "Executando comando \"$1\" em blade${n}" 
  ssh  -o "StrictHostKeyChecking no" blade${n} $1
done
#for n in $(seq 1 2); do 
#  echo "Executando comando \"$1\" em r710${n}" 
#  ssh r710${n} $1
#done

exit 0
