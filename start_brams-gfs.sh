#!/bin/bash
#
###############################################################################################
######	Este script tem por finalidade executar a adequacao dos arquivos de entrada
######  do modelo BRAMS, inicializado com dados oriundos do NCEP.
######
######  Escrito por:			Paulo Kuhn 		-	      2007
######  Ultima alteracao:		Gustavo Ribeiro      	-   Fevereiro/2011
######
###############################################################################################
path_src=/home/brams
path_bin=/usr/local/bin
path_2dp=$path_src/grib2dp
path_pos=$path_src/ramspost-6.0
path_mpi=/opt/mpich3
path_tmp=/tmp
path_dat=/w1/data
path_GSs=$path_src/operacao/GSs
path_cdo=/usr/bin/cdo
SCP=`which scp`
SSH=`which ssh`
###############################################################################################

aa=`date +%Y`
mm=`date +%m`
dd=`date +%d`

hh=$1      ####### Hora de Inicializa��o do Modelo, entrada via teclado.

if [ $hh -eq 00 ] || [ $hh -eq 06 ] || [ $hh -eq 12 ]
then
	echo " 
	+--------------------------------------------+
	  O processamento do BRAMS esta iniciando...
	  Hoje e dia: $dd / $mm / $aa - `date +%T`
	+--------------------------------------------+
		"
    data_sys=$aa$mm$dd$hh
    echo $data_sys
    hhhh=$hh'00'
else
    echo "
             A sintaxe correta deste script e: 

             +-------------------------------------------------------------+
              start_brams-gfs.sh HORA DIR (Onde HORA = 00 ou 12 e DIR = w1) 
             +-------------------------------------------------------------+
         "
    exit
fi

SSH=`which ssh`
###############################################################################################

if [ $hh = '00' ]
then
        NH=96
        NF=17
else
        NH=36
        NF=7
fi

data_arq=`echo $data_sys $NH |awk -f $path_src/operacao/fwddatan.awk | awk '{print $1}'`

aF=`echo $data_arq | cut -c1-4`      ##### mF = ano Final dos arquivos .grb
mF=`echo $data_arq | cut -c5-6`      ##### mF = m�s Final dos arquivos .grb
dF=`echo $data_arq | cut -c7-8`      ##### dF = dia Final dos arquivos .grb
lH=`echo $data_arq | cut -c9-10`     ##### lH = hora Final dos arquivos .grb

###############################################################################################
#### Ajustando o local de trabalho.

dir=$2 


#if [ls -d /$dir/BRAMS52/$data_sys/teste ]
#then 
    Narq=`ls -l /$dir/BRAMS52/$data_sys/gfs.t$hh'z'.pgrb2.0p25.f0* | wc -l`
    ICNf=`ls -s /$dir/BRAMS52/$data_sys/gfs.t$hh'z'.pgrb2.0p25.f096 | awk '{print $1}'`

#    echo $dir $Narq $ICNf $NF $NH 

#    	if [ $Narq -eq $NF ] && [ $ICNf -gt 150000 ]
#    	then
        	echo " O diretorio (/$dir/BRAMS52/$data_sys/teste) ja existe e PATH configurado, continuando..."

		echo "DEFININDO O DIRETORIO DE TRABALHO"

        	path_wrk=/$dir/BRAMS52/$data_sys
        	mkdir $path_wrk/teste/png
	      	path_wrk2=$path_wrk/teste      #### Ajusta o diret�rio de trabalho.

#	else
#		echo "DOWNLOAD NAO FINALIZADO!"

#		echo " O download ainda nao finalizou, aguardando..." > $path_tmp/inicio.msg
#    		sleep 600		###>>> Aguarda 10 minutos
#    		$path_src/operacao/start_brams-gfs.sh $hh &
#    		exit
#    	fi
#else
#	echo "DIRETORIO AINDA NAO CRIADO"

# 	echo " O diretorio nao existe, abortando..." > $path_tmp/inicio.msg
#    	sleep 600		###>>> Aguarda 10 minutos
#    	$path_src/operacao/start_brams-gfs.sh $hh &
#    	exit
#fi

cp -f $path_src/operacao/ramspost.inp         $path_wrk2/ramspost.inp
cp -f $path_pos/ramspost_60	              $path_wrk2/ramspost
cp -f $path_src/operacao/machines.LINUX       $path_wrk2/maquinas
cp -f $path_src/bin/brams-5.3                 $path_wrk2/brams-operacional
cp -f $path_src/operacao/variables.csv        $path_wrk2/variables.csv
cp -f $path_src/operacao/jules.in             $path_wrk2/jules.in
cp -f $path_src/operacao/freezeH2O.dat        $path_wrk2/freezeH2O.dat 
cp -f $path_src/operacao/qr_acr_qg.dat        $path_wrk2/qr_acr_qg.dat
cp -f $path_src/operacao/qr_acr_qs.dat        $path_wrk2/qr_acr_qs.dat
cp -r $path_src/bin/tables/ 		      $path_wrk2/
#cp -r $path_src/operacao/amazonia_all_g1.ctl  $path_wrk2/amazonia_all_g1.ctl

####################################################################################################################

####################################################################################################################
#### Criando os links e copiando os arquivos necessorios no
#### diretorio de trabalho.
####################################################################################################################
##### AQUI comeca o SEED (Conjunto de variaveis alteradas nos processos de execucao dos modelos).
####################################################################################################################

if [ $hh -eq 06 ] || [ $hh -eq 12 ]
then
     cp -f $path_src/operacao/RAMSIN54.sfc     $path_src/operacao/RAMSIN54.sfc
     cp -f $path_src/operacao/RAMSIN54.vfile   $path_src/operacao/RAMSIN54.vfile
     cp -f $path_src/operacao/RAMSIN54.initial $path_src/operacao/RAMSIN54.initial
else
     cp -f $path_src/operacao/RAMSIN54.sfc.operacional     $path_src/operacao/RAMSIN54.sfc
     cp -f $path_src/operacao/RAMSIN54.vfile.operacional   $path_src/operacao/RAMSIN54.vfile
     cp -f $path_src/operacao/RAMSIN54.initial.operacional $path_src/operacao/RAMSIN54.initial
fi
####################################################################################################################
############# Cria e ajusta data de arquivo template amazonia_all_g1.ctl
hora=$hh:'00z' 
dia=`date +%d`
mes=`date +%b`
ano=`date +%Y`
data_template=$hora$dia$mes$ano

cat << eof1 > $path_wrk2/amazonia_all_g1.ctl
dset ^A-A-%y4-%m2-%d2-%h20000-g1.gra
undef -0.9990000E+34
title BRAMS_5.4
options template
xdef 533 linear -91.8639297 0.1387138
ydef 546 linear -48.4687042 0.1254356
zdef 23 levels 1000.0 975.0 950.0 925.0 900.0 875.0 850.0 825.0 800.0 750.0 700.0 650.0 600.0 550.0 500.0 450.0 400.0 350.0 300.0 250.0 200.0 150.0 100.0
tdef $NF linear $data_template 6hr 
vars 23
ACCCON       0 99    - RAMS : accum convective pcp                    [mm]
TOTPCP       0 99    - RAMS : total resolved pcp                      [mm liq  ]
TEMPC       23 99    - RAMS : temperature                             [C       ]
TEMPC2M      0 99    - RAMS : temp - 2m AGL                           [C       ]
TD2M         0 99    - RAMS : dewpoint temp in 2m                     [C       ]
UE_AVG      23 99    - RAMS : ue_avg                                  [m/s     ]
VE_AVG      23 99    - RAMS : ve_avg                                  [m/s     ]
TOPO         0 99    - RAMS : topo                                    [m       ]
RH          23 99    - RAMS : relative humidity                       [pct     ]
GEO         23 99    - RAMS : geopotential height                     [m       ]
LAND         0 99    - RAMS : land frac area                          [        ]
T2MJ         0 99    - RAMS : Temperature at 2m - from JULES          [C       ] 
TD2MJ        0 99    - RAMS : Dewpoint temp at 2m - from JULES        [C       ]
U10MJ        0 99    - RAMS : Zonal Wind at 10m - from JULES          [m/s     ]
V10MJ        0 99    - RAMS : Meridional Wind at 10m - from JULES     [m/s     ]
RH2M         0 99    - RAMS : Relative humidity 2m                    [pct     ]
SST          0 99    - RAMS : water temperature                       [C       ]
CAPE         0 99    - RAMS : cape                                    [J/kg    ]
CINE         0 99    - RAMS : cine                                    [J/kg    ]
OMEG        23 99    - RAMS : omega                                   [Pa/s    ]
W           23 99    - RAMS : w                                       [m/s     ]
RV          23 99    - RAMS : vapor mixing ratio                      [g/kg    ]
SFC_PRESS    0 99    - RAMS : Surface pressure                        [mb]
endvars
eof1
####################################################################################################################

timmax=`grep "TIMMAX   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
imonth=`grep "IMONTH1  ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
idate1=`grep "IDATE1   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
iyear1=`grep "IYEAR1   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
itime1=`grep "ITIME1   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`

ihistdel=`grep "IHISTDEL =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`

ngrids=`grep "NGRIDS   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
nnxp=`grep "NNXP     ="    $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
nnyp=`grep "NNYP     ="    $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
deltax=`grep "DELTAX   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
deltay=`grep "DELTAY   ="  $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
polelat=`grep "POLELAT  =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
polelon=`grep "POLELON  =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
centlat=`grep "CENTLAT  =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
centlon=`grep "CENTLON  =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
nigrids=`grep "NIGRIDS  =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
catt=`grep "CCATT ="        $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'`
if_adap=`grep "IF_ADAP  =" $path_src/operacao/RAMSIN54.sfc | awk '{print $3}'` 

####################################################################################################################
##### Ajuste da grade e resolucao do modelo.
NX=554		
NY=540		
DX=15000.			
DY=15000.		
LAT=-15.0
LON=-55.0
                ####>>> Ligar o CATT o Shaved ETA deve ser desligado.
CAT=0           ####>>> Liga ou desliga o CATT (0=off, 1=on)
ETA=0           ####>>> Liga ou desliga o Shaved ETA (0=off, 1=on)

####################################################################################################################

if [ $hh -eq 12 ]

then

sed "s/TIMMAX   = $timmax/TIMMAX   = 36.,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/TIMMAX   = $timmax/TIMMAX   = 36.,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/TIMMAX   = $timmax/TIMMAX   = 36.,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

else

sed "s/TIMMAX   = $timmax/TIMMAX   = 96.,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/TIMMAX   = $timmax/TIMMAX   = 96.,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/TIMMAX   = $timmax/TIMMAX   = 96.,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial
fi

####################################################################################################################


sed "s/NGRIDS   = $ngrids/NGRIDS   = 1,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/NNXP     = $nnxp/NNXP     = $NX,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/NNYP     = $nnyp/NNYP     = $NY,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/DELTAX   = $deltax/DELTAX   = $DX,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/DELTAY   = $deltay/DELTAY   = $DY,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/POLELAT  = $polelat/POLELAT  = $LAT,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/POLELON  = $polelon/POLELON  = $LON,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/CENTLAT  = $centlat/CENTLAT  = $LAT,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/CENTLON  = $centlon/CENTLON  = $LON,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/NIGRIDS  = $nigrids/NIGRIDS  = 1,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/IF_ADAP  = $if_adap/IF_ADAP  = $ETA,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/CCATT = $catt/CCATT = $CAT,/"              $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.sfc \
                                        && mv $path_tmp/RAMSIN54.tmp.sfc        $path_src/operacao/RAMSIN54.sfc

sed "s/NGRIDS   = $ngrids/NGRIDS   = 1,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile       $path_src/operacao/RAMSIN54.vfile

sed "s/NNXP     = $nnxp/NNXP     = $NX,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/NNYP     = $nnyp/NNYP     = $NY,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/DELTAX   = $deltax/DELTAX   = $DX,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/DELTAY   = $deltay/DELTAY   = $DY,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/POLELAT  = $polelat/POLELAT  = $LAT,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/POLELON  = $polelon/POLELON  = $LON,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/CENTLAT  = $centlat/CENTLAT  = $LAT,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/CENTLON  = $centlon/CENTLON  = $LON,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/NIGRIDS  = $nigrids/NIGRIDS  = 1,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/IF_ADAP  = $if_adap/IF_ADAP  = $ETA,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/CCATT = $catt/CCATT = $CAT,/"              $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.vfile \
                                        && mv $path_tmp/RAMSIN54.tmp.vfile        $path_src/operacao/RAMSIN54.vfile

sed "s/NGRIDS   = $ngrids/NGRIDS   = 1,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/NNXP     = $nnxp/NNXP     = $NX,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/NNYP     = $nnyp/NNYP     = $NY,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/DELTAX   = $deltax/DELTAX   = $DX,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/DELTAY   = $deltay/DELTAY   = $DY,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/POLELAT  = $polelat/POLELAT  = $LAT,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/POLELON  = $polelon/POLELON  = $LON,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/CENTLAT  = $centlat/CENTLAT  = $LAT,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/CENTLON  = $centlon/CENTLON  = $LON,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/NIGRIDS  = $nigrids/NIGRIDS  = 1,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/IF_ADAP  = $if_adap/IF_ADAP  = $ETA,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

sed "s/CCATT = $catt/CCATT = $CAT,/"              $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.initial \
                                        && mv $path_tmp/RAMSIN54.tmp.initial        $path_src/operacao/RAMSIN54.initial

####################################################################################################################

sed "s/IMONTH1  = $imonth/IMONTH1  = $mm,/"   $path_src/operacao/RAMSIN54.sfc > $path_tmp/RAMSIN54.tmp.1
sed "s/IDATE1   = $idate1/IDATE1   = $dd,/"   $path_tmp/RAMSIN54.tmp.1        > $path_tmp/RAMSIN54.tmp.2
sed "s/IYEAR1   = $iyear1/IYEAR1   = $aa,/"   $path_tmp/RAMSIN54.tmp.2        > $path_tmp/RAMSIN54.tmp.3
sed "s/ITIME1   = $itime1/ITIME1   = $hhhh,/" $path_tmp/RAMSIN54.tmp.3        > $path_wrk2/RAMSIN54.sfc

sed "s/IMONTH1  = $imonth/IMONTH1  = $mm,/"   $path_src/operacao/RAMSIN54.vfile > $path_tmp/RAMSIN54.tmp.1
sed "s/IDATE1   = $idate1/IDATE1   = $dd,/"   $path_tmp/RAMSIN54.tmp.1          > $path_tmp/RAMSIN54.tmp.2
sed "s/IYEAR1   = $iyear1/IYEAR1   = $aa,/"   $path_tmp/RAMSIN54.tmp.2          > $path_tmp/RAMSIN54.tmp.3
sed "s/ITIME1   = $itime1/ITIME1   = $hhhh,/" $path_tmp/RAMSIN54.tmp.3          > $path_wrk2/RAMSIN54.vfile

sed "s/IMONTH1  = $imonth/IMONTH1  = $mm,/"   $path_src/operacao/RAMSIN54.initial > $path_tmp/RAMSIN54.tmp.1
sed "s/IDATE1   = $idate1/IDATE1   = $dd,/"   $path_tmp/RAMSIN54.tmp.1            > $path_tmp/RAMSIN54.tmp.2
sed "s/IYEAR1   = $iyear1/IYEAR1   = $aa,/"   $path_tmp/RAMSIN54.tmp.2            > $path_tmp/RAMSIN54.tmp.3
sed "s/ITIME1   = $itime1/ITIME1   = $hhhh,/" $path_tmp/RAMSIN54.tmp.3            > $path_wrk2/RAMSIN54.initial

####################################################################################################################
##### AQUI termina o SED
#
####################################################################################################################
##### AQUI inicia a execucao do MODELO BRAMS.

################
#  MAKESFC mode
################
 
echo ' Building surface files for desired area (MAKESFC mode)' 
echo "Hora de inicio da fase MAKESFC:          "`date +%T`  >> $path_wrk2/duracao.txt

cd $path_wrk2
./brams-operacional -f RAMSIN54.sfc > sfc.out & 

if [ $hh -eq 00 ]
then
        echo " Aguarde geração de arquivos sfc $path_wrk2 "
        sleep 300     ##### Aguarda 5 minutos...
else
        echo " Aguarde geração de arquivos sfc $path_wrk2 "
        sleep 300     ##### Aguarda 5 minutos...
fi


        echo " BRAMS execution in MAKESFC mode succeeds"
        echo " "
##################
#  MAKEVFILE mode
##################
 
echo ' Building initial and boundary conditions for desired area (MAKEVFILE mode)' 
echo "Hora de inicio da fase MAKEVFILE:        "`date +%T`  >> $path_wrk2/duracao.txt

cd $path_wrk2
./brams-operacional -f RAMSIN54.vfile > vfile.out &

##Alterado para só ir para a fase paralela apos o ultimo
##arquivo vfile existir
dia_fim_vfile=`date --date='+4 days' '+%d'`
mes_fim_vfile=`date --date='+4 days' '+%m'`
ano_fim_vfile=`date --date='+4 days' '+%Y'`
lastfile=iv-V-$ano_fim_vfile-$mes_fim_vfile-$dia_fim_vfile-000000-g1.vfm

while [ ! -f $lastfile ] 
do
	sleep 900
done
#####################################

#if [ $hh -eq 00 ]
#then
#        echo " Aguarde 15 minutos para geração de arquivos iv*.vfm em $path_wrk2 "
# 	sleep 900     ##### Aguarda 15 minutos...
#else
#	echo " Aguarde 15 minutos para geração de arquivos iv*.vfm em $path_wrk2 "
#        sleep 900     ##### Aguarda 15 minutos...
#fi

################
#  INITIAL mode
################
echo ' Parallel forecasting (INITIAL mode)' 
echo "Hora de in�cio da fase INITIAL:          "`date +%T`  >> $path_wrk2/duracao.txt

cd $path_wrk2

/opt/mpich3/bin/mpirun -np 160 -machinefile maquinas ./brams-operacional -f RAMSIN54.initial > ramsinit.out &
 
echo "Hora de inicio da fase POST PROCESSING:  "`date +%T`  >> $path_wrk2/duracao.txt

##########################################################################################
############# 			P�s-processamento		         #################	
##########################################################################################
#	$path_src/operacao/new_posproc.sh $hh GFS &             #### Cria as Figuras  ####
##########################################################################################

##########################################################################################
############# 			Gera bin�rios de Chuva   	          ################	
##########################################################################################
#	$path_src/operacao/gera_rain.sh $dd $hh GFS &  	               ### Cria os GSs ###
##########################################################################################

##########################################################################################
#############     Transfere arquivos para pós-processamento na R9002	  ################	
##########################################################################################
#$SSH brams@172.20.4.31 mkdir -p /w1/BRAMS52/$data_sys/teste    
#$SCP $path_wrk2/A-A* brams@172.20.4.31:/w1/BRAMS52/$data_sys/teste
#$SCP $path_wrk2/amazonia_all_g1.ctl brams@172.20.4.31:/w1/BRAMS52/$data_sys/teste
##########################################################################################

echo " ***BRAMS execution ends successfully*** "
echo "Hora Final de Processamento:             "`date +%T`  >> $path_wrk2/duracao.txt

##########################################################################################
#### Cria arquivos NetCDF ####
#$path_src/operacao/net_cdf.sh

##########################################################################################
##### 				Fim do script.		                           #######
##########################################################################################
exit
