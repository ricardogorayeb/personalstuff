#!/bin/bash

echo 'Criando diretorios vmet, xppi e movendo os arquivos...'
	if [ ! -d xppi ]; then mkdir xppi; fi
	if [ ! -d vmet ]; then mkdir vmet; fi
	for i in `ls | grep _400`; do
		mv -v $i xppi/
	done
	for i in `find . -maxdepth 1 -name "*.bz2"` ; do
		mv -v $i vmet/
	done

	
echo 'Organizando por ano, mes e dia no diretorio vmet...'
	cd vmet
	for i in `find . -name "*.bz2"`
	do	
		ANO=$(echo $i | cut -c3,4,5,6)
		if [ ! -d $ANO ]; then mkdir $ANO; fi
	
		MES=$(echo $i | cut -c8,9)
		if [ ! -d $ANO/$MES ]; then mkdir $ANO/$MES; fi
	
		DIA=$(echo $i | cut -c11,12)
		if [ ! -d $ANO/$MES/$DIA ]; then mkdir $ANO/$MES/$DIA; fi
	
		mv -v $i $ANO/$MES/$DIA/
	done
	cd ..
echo 'Organizando por ano, mes e dia no diretorio xppi...'
	cd xppi
	for i in `find . -name "*.bz2"`
	do	
		ANO=$(echo $i | cut -c3,4,5,6)
		if [ ! -d $ANO ]; then mkdir $ANO; fi
	
		MES=$(echo $i | cut -c8,9)
		if [ ! -d $ANO/$MES ]; then mkdir $ANO/$MES; fi
	
		DIA=$(echo $i | cut -c11,12)
		if [ ! -d $ANO/$MES/$DIA ]; then mkdir $ANO/$MES/$DIA; fi
	
		mv -v $i $ANO/$MES/$DIA/
	done
	cd ..
