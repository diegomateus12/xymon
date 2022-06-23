#!/bin/bash
#!/bin/ksh
##################################################
#
#     CODIGO Estado y Temperatura STP MOVIL
#
##################################################

############################
#
#     Definicion Parametros
#
############################
Directorio="/tmp/"
Directorio2="/usr/lib/xymon/client/ext/"
expectFile="STP_Temp.exp"
expectFile2="STP_Assoc.exp"
_fechas=`/usr/lib/xymon/client/ext/fechas.pl ${delta}`
#Variable=`echo ${_fechas} | awk '{print $4}'`
Archivo2=/home/super/Notas.gpg
Archivo=/usr/lib/xymon/client/etc/hosts.cfg
Variable=`shuf -i 0-40 -n 1`

Flag="STP"
Prueba="zqpmxwon"

COLUMN="Tarjetas"
Equipo=$1

rm -f {${Directorio}${Equipo}_Tempo.txt}
arcTemporal1=${Directorio}${Equipo}_Tempo.txt

rm -f /tmp/${Equipo}_Links_1.txt
rm -f /tmp/${Equipo}_Links_2.txt
rm -f /tmp/${Equipo}_Links_3.txt
rm -f /tmp/${Equipo}_Links_4.txt
rm -f /tmp/${Equipo}_Links_5.txt
rm -f /tmp/${Equipo}_Links_6.txt
rm -f /tmp/${Equipo}_Links_T.txt
rm -f /tmp/${Equipo}_AlarmasT.txt
rm -f /tmp/${Equipo}_Assoc_Reinicio.txt
arcTemp2=/tmp/${Equipo}_Links_1.txt
arcTemp3=/tmp/${Equipo}_Links_2.txt
arcTemp4=/tmp/${Equipo}_Links_3.txt
arcTemp5=/tmp/${Equipo}_Links_4.txt
arcTemp6=/tmp/${Equipo}_Links_5.txt
arcTemp7=/tmp/${Equipo}_Links_6.txt
arcTempT=/tmp/${Equipo}_Links_T.txt
arcTempA=/tmp/${Equipo}_AlarmasT.txt
AssocReinicio=/tmp/${Equipo}_Assoc_Reinicio.txt


test=/tmp/${Equipo}_Test

###################################################

function AveriguaClave()
{
Clave=`cat ${test} | grep $Flag | awk '{ print $2}'`
echo $Clave
}

#############################

function AveriguaUser()
{
User=`cat ${test} | grep $Flag | awk '{ print $3}'`
echo $User
}

#############################

function AveriguaCount()
{
cd ${directorio}
Count=`cat ${Archivo} | grep STP | awk 'BEGIN { j=0; } { j=j+1; } END { print j;}'`
echo $Count
}

#############################
function ObtenerServidor()
{
cd ${directorio}
Servidor=`grep $Equipo ${Archivo} | awk '{ print $1}'`
echo $Servidor
}

#############################



function AveriguaLineas()
{
Count1=`cat ${arcTemp3} | awk 'BEGIN { j=0; } { j=j+1; } END { print j;}'`
echo $Count1               
}

function ObtenerDato()
{
Dato=`cat ${arcTemp3} | sort -r -k 4 | awk -v k=$k -v fil=$fila1  'BEGIN { FS=" "; j=0; } { j=j+1; if (k==j) { Dat=$fil; } } END { print Dat; }'`
echo $Dato
}

function CompararDato()
{
Dato2=`cat ${arcTemp2} | awk -v dat=$Dato -v n=$n -v fil=$fila2  'BEGIN { FS=" "; j=0; } { j=j+1; if (dat==$fil) { Dat2=$n; } } END { print Dat2; }'`
echo $Dato2
}

function CompararDato2()
{
Dato2=`cat ${arcTemp4} | awk -v dat=$Dato -v n=$n -v fil=$fila2  'BEGIN { FS=" "; j=0; } { j=j+1; if (dat==$fil) { Dat2=$n; } } END { print Dat2; }'`
echo $Dato2
}

#####

function ObtenerDatoA()
{
Dato=`cat ${arcTempA} | awk -v k=$k -v fil=$fila1 -v FS="|" 'BEGIN { j=0; } { j=j+1; if (k==j) { Dat=$fil; } } END { print Dat; }'`
echo $Dato
}

function AveriguaLineasA()
{
Count1=`cat ${arcTempA} | awk 'BEGIN { j=0; } { j=j+1; } END { print j;}'`
echo $Count1               
}

##################################################################


gpg --batch --passphrase $Prueba -d $Archivo2 > $test
Servidor=$(ObtenerServidor)
User=$(AveriguaUser)
Clave=$(AveriguaClave)
rm ${test}

#echo $Servidor
#exit

#if [ "$Equipo" = "STP_MEDELLIN" ]; then
#Clave="Italia_2022"
#fi

##################################################
#------------------------------------------------------------
# Calcular fecha objetivo
#------------------------------------------------------------
_fechas=`/usr/lib/xymon/client/ext/fechas.pl ${delta}`
_yyyy=`echo ${_fechas} | awk '{print $1}'`
_mm=`echo ${_fechas} | awk '{print $3}'`
_dd=`echo ${_fechas} | awk '{print $4}'`
_yy=`echo ${_fechas} | awk '{print $2}'`
fechaLarga="${_yyyy}${_mm}${_dd}"
fechaCorta="${_yy}${_mm}${_dd}"
#echo $fechaCorta 
#exit
########################
#
#      STP Movil
# 
########################

if [ "$Equipo" = "STP_ENTRERRIOS" ]; then
 #Puerto=`expr 5210 + $Variable`
 Puerto=`awk 'BEGIN{srand();print int(rand()*(5800-5000))+5000 }'`
fi
if [ "$Equipo" = "STP_CALI" ]; then
 # Puerto=`expr 5348 + $Variable`
 sleep 1
 Puerto=`awk 'BEGIN{srand();print int(rand()*(5800-5000))+5000 }'`
fi
if [ "$Equipo" = "STP_MEDELLIN" ]; then
 #   Puerto=`expr 5175 + $Variable`
   # Puerto=5173
  sleep 2
  Puerto=`awk 'BEGIN{srand();print int(rand()*(5800-5000))+5000 }'`
fi
if [ "$Equipo" = "STP_BARRANQUILLA" ]; then 
   # Puerto=`expr 5312 + $Variable`
   sleep 3
   Puerto=`awk 'BEGIN{srand();print int(rand()*(5800-5000))+5000 }'`
fi

#Puerto=`awk 'BEGIN{srand();print int(rand()*(5800-5000))+5000 }'`

echo "1"

echo $User
echo $Clave
echo $Servidor
echo $Puerto
#echo $Variable


${Directorio2}${expectFile} $User $Clave $Servidor $Puerto $fechaCorta | sed 's///g' > ${arcTemporal1}

#${Directorio2}${expectFile} $User $Clave $Servidor $Puerto $fechaCorta | sed 's/^M//g' | sed 's/[^@]//g' > ${arcTemporal1}

################
echo "2"

##############################

#COLOR=`cat ${arcTemporal1} | sed 's/..//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($1~/APPLICATION/) { Mostrar=0; print "\n"; } if (Mostrar==1) { print $0; }  if($0~/CARD   VERSION/) { Mostrar=1; printf ("Tarjeta %s %s\n",cont,$0); cont=cont+1;}}' | awk 'BEGIN{FS="\n"; RS=""; OFS=","; cont=1}{if($1~/CARD/) {printf("%s\n",$2); printf("%s\n",$20);}}' | awk '{ printf("%s\t%s\t%s\t%s\t%s\t%s\n",$1,$2,$3,$4,$5,$11); }' | awk '{ printf("%s\n",$6); }' | sed 's/C//' | awk 'BEGIN { COLOR="green"; } { if($1>57) { COLOR="red";  } } END { printf("%s",COLOR); }'`

COLOR=`cat ${arcTemporal1} | sed 's/..//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($1~/APPLICATION/) { Mostrar=0; print "\n"; } if (Mostrar==1) { print $0; }  if($0~/CARD   VERSION/) { Mostrar=1; printf ("Tarjeta %s %s\n",cont,$0); cont=cont+1;}}' | awk 'BEGIN{FS="\n"; RS=""; OFS=","; cont=1}{if($1~/CARD/) {printf("%s",$2); printf("%s\n",$20);}}' | awk '{ printf("%s\t%s\t%s\t%s\t%s\t%s\n",$1,$2,$3,$4,$5,$11); }' | awk '{ printf("%s\n",$6); }' | sed 's/C//'  | awk 'BEGIN { COLOR="green"; } { if($1>80) { COLOR="red";  } } END { printf("%s",COLOR); }'`

echo $COLOR

sudo ssh-keygen -R $Servidor

#################################
#               VISUALIZACION
#################################
Texto="Monitoreo de Temperatura de las tarjetas del $Equipo

CARD   VERSION     TYPE       GPL   STATE   TEMP C"
Muestra2="
$Texto
`cat ${arcTemporal1} | sed 's/..//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($1~/APPLICATION/) { Mostrar=0; print "\n"; } if (Mostrar==1) { print $0; }  if($0~/CARD   VERSION/) { Mostrar=1; printf ("Tarjeta %s %s\n",cont,$0); cont=cont+1;}}' | awk 'BEGIN{FS="\n"; RS=""; OFS=","; cont=1}{if($1~/CARD/) {printf("%s",$2); printf("%s\n",$20);}}' | awk '{ printf("%s\t%s\t%s\t%s\t%s\t%s\n",$1,$2,$3,$4,$5,$11); }'`
"
#fi
MSG="$MSG
$Muestra2"
$BB $BBDISP "status ${Equipo}.$COLUMN $COLOR `date` ${MSG}"


Muestra2=""
MSG=""
COLUMN="Links"
COLOR="green"
LINE_COLOR="green"

cat ${arcTemporal1} | sed 's/..//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/) { Mostrar=0;  } if (Mostrar==1) { printf("%s  \t%s   \t%s\t%s\t%s\t\n",$1,$2,$3,$4,$5); }  if($0~/SLK      LSN/) { Mostrar=1; cont=cont+1;}}' > ${arcTemp3}
cat ${arcTemporal1} | sed 's/..//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/) { Mostrar=0;  } if (Mostrar==1) { printf("%s\t%s,%s  \t%s\t%s\t\n",$1,$2,$4,$5,$6); }  if($0~/ANAME           LOC/) { Mostrar=1; cont=cont+1;}}' > ${arcTemp2}
cat ${arcTemporal1} | sed 's/..//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/ || $0~/LSN           APCN24/) { Mostrar=0; } if (Mostrar==1) { printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$4); }  if($0~/LSN           APCN/ || $0~/LSN           APCI/) { Mostrar=1; }}' > ${arcTemp4}
cat ${arcTemporal1} | sed 's/..//' | sed 's/*//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/) { Mostrar=0; } if (Mostrar==1) { if($5~/TX:/) printf("%s    \t%d\t%d\t%d\t%d\t",$1,$3,$4,$6,$7); if($1~/RCV:/) printf("%d\t%d\n",$2,$3); }  if($0~/IP TPS/) { Mostrar=1; }}' | awk ' { Tx_per = 0; Rx_per = 0; if ($2 != 0) printf("%s    \t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",$1,$2,$3,$4,$5,$6,$7,100*$4/$2,100*$6/$2); else printf("%s    \t%d\t%d\t%d\t%d\t%d\t%d\t0\t0\n",$1,$2,$3,$4,$5,$6,$7);  } ' > ${arcTemp5}
cat ${arcTemporal1} | sed 's/..//' | sed 's/-03-/ 03 /' | sed 's/-02-/ 02 /' | sed 's/-01-/ 01 /' | sed 's/-11-/ 11 /' | sed 's/-12-/ 12 /' | sed 's/-10-/ 10 /' | sed 's/-09-/ 09 /' | sed 's/-08-/ 08 /' | sed 's/-07-/ 07 /' | sed 's/-06-/ 06 /' | sed 's/-05-/ 05 /' | sed 's/-04-/ 04 /' | sed 's/-10-/ 10 /' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/) { Mostrar=0; } if (Mostrar==1) { if($2~/\*/) printf("%s\t",$0); else printf("%s-%s-%s\t%s\n",$3,$2,$1,$4); }  if($0~/SEQN UAM/) { Mostrar=1; }}' | sed 's/--/ /' | grep -v -e '^$' > ${arcTemp6}

cat ${arcTemporal1} | sed 's/..//' | sed 's/*//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/) { Mostrar=0; } if (Mostrar==1) { if($5~/TX:/) printf("%s    \t%d\t%d\t%d\t%d\t",$1,$3,$4,$6,$7); if($1~/RCV:/) printf("%d\t%d\n",$2,$3); }  if($0~/IP TPS/) { Mostrar=1; }}' | awk ' { Tx_per = 0; Rx_per = 0; if ($2 != 0) printf("%s    \t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",$1,$2,$3,$4,$5,$6,$7,100*$4/$2,100*$6/$2); else printf("%s    \t%d\t%d\t%d\t%d\t%d\t%d\t0\t0\n",$1,$2,$3,$4,$5,$6,$7);  } ' | grep -v -e '5na1 ' | grep -v -e '2na1 ' | grep -v -e '1na1 ' | awk ' { if($1~/msssba/ || $1~/msscaa/ || $1~/mssena/ || $1~/msscal5/) printf("%s : %d\n",$1,$8);  } ' > ${arcTemp7}

cat ${arcTemporal1} | sed 's/..//' | sed 's/*//' | awk 'BEGIN { Mostrar=0; cont=1; } { if($0~/Command Completed/) { Mostrar=0; } if (Mostrar==1) { if($5~/TX:/) printf("%s    \t%d\t%d\t%d\t%d\t",$1,$3,$4,$6,$7); if($1~/RCV:/) printf("%d\t%d\n",$2,$3); }  if($0~/IP TPS/) { Mostrar=1; }}' | awk ' { Tx_per = 0; Rx_per = 0; if ($2 != 0) printf("%s    \t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",$1,$2,$3,$4,$5,$6,$7,100*$4/$2,100*$6/$2); else printf("%s    \t%d\t%d\t%d\t%d\t%d\t%d\t0\t0\n",$1,$2,$3,$4,$5,$6,$7);  } ' | grep -v -e '5na1 ' | grep -v -e '2na1 ' | grep -v -e '1na1 ' | awk ' { if($1~/msssba/ || $1~/msscaa/ || $1~/mssena/ || $1~/msscal5/) { printf("%s_tx : %d\n",$1,$4); printf("%s_rx : %d\n",$1,$6);}  } ' | sort > ${arcTemp8}

cat ${arcTemp3}
cat ${arcTemp2}
cat ${arcTemp4}
cat ${arcTemp5}

fila1=1
fila2=2
Dato=""
Dato2=""
Dato3=""
Dato4=""

echo "Previo"
FIRST_LINE=""
FIRST_LINE="$FIRST_LINE | Links Afectados: "
STRING="<table border=0 cellpadding=10><tr><th></th><th>DPC</th><th>DPC_STATUS</th><th>SLK</th><th>LSN</th><th>SLK_STATUS</th><th>SST</th><th>ANAME</th><th>A_STATUS</th><th>A_SST</th></tr>"

k=0
#cat ${arcTemp3} > ${Temporal}
Count1=$(AveriguaLineas)
echo $Count1
    while [ $k -lt $Count1 ]
    do
    k=`expr $k + 1`
    echo $k
    LINE_COLOR='green'
                fila1=1
                fila2=2
                Dato=$(ObtenerDato)
                echo $Dato
                #cat ${arcTemp2} > ${Temporal}
                n=1
                Dato2=$(CompararDato)
                n=3
                Dato3=$(CompararDato)
                n=4
                echo $Dato3
                Dato4=$(CompararDato)
                echo $Dato4
                
                fila1=2
                Dato=$(ObtenerDato)
                fila2=1
                n=2
                echo $Dato3
                Dato5=$(CompararDato2)
                n=3
                Dato6=$(CompararDato2)
                
                cat ${arcTemp3} | sort -r -k 4 | awk -v k=$k -v Result=$Dato2 -v Result2=$Dato3 -v Result3=$Dato4 -v Result4=$Dato5 -v Result5=$Dato6 'BEGIN { FS=" ";  j=0; } { j=j+1; if (k==j) { printf("%s    \t%s   \t%s   \t%s \t%s   \t%s    \t%s      \t%s    \t%s\n",Result4,Result5,$1,$2,$4,$5,Result,Result2,Result3);} }' >> ${arcTempT}
                
                fila1=4
                SLK_STATUS=$(ObtenerDato)
                A_STATUS=$Dato3
                  
                DPC=$Dato5
                DPC_STATUS=$Dato6
                SLK=$Dato
                
                fila1=2
                LSN=$(ObtenerDato)
                
                fila1=5
                SST=$(ObtenerDato)
                
                ANAME=$Dato2
                A_SST=$Dato4
                
                if [[ "$SLK_STATUS" = "OOS-MT-DSBLD" || "$A_STATUS" = "OOS-MT-DSBLD" ]]; then
                    LINE_COLOR='blue'
                fi     
                if [[ "$SLK_STATUS" = "OOS-MT" || "$A_STATUS" = "OOS-MT" ]]; then
                    LINE_COLOR='yellow'
                fi        
                if [[ "$SLK_STATUS" = "IS-ANR" || "$A_STATUS" = "IS-ANR" ]]; then
                    LINE_COLOR='yellow'
                fi
                if [ "$SLK_STATUS" = "OOS-MT" ] && [ "$A_STATUS" = "IS-NR" ]; then
                    LINE_COLOR='red' 
                    COLOR='red'
                    FIRST_LINE="$FIRST_LINE ${SLK}"
                    Assoc="$ANAME "
                fi
                
                
                STRING="$STRING <tr><td>&${LINE_COLOR}</td><td>${DPC}</td><td>${DPC_STATUS}</td><td>${SLK}</td><td>${LSN}</td><td>${SLK_STATUS}</td><td>${SST}</td><td>${ANAME}</td><td>${A_STATUS}</td><td>${A_SST}</td></tr>"
    done


STRING="$STRING </table><br><br>"

Assoc_array=($Assoc)
Assoc_count=${#Assoc[@]}

echo $Assoc_array
echo $Assoc_count

Reporte_Assoc=/data/informes/${Equipo}_Reporte_Registro_Asociaciones.txt

if [ "$COLOR" = "red" ]; then
    if [[ "$Equipo" = "STP_MEDELLIN" || "$Equipo" = "STP_BARRANQUILLA" ]]; then
        ${Directorio2}${expectFile2} $User $Clave $Servidor $Puerto $fechaCorta $Assoc_count ${Assoc_array[@]} | sed 's///g' > ${AssocReinicio}
               
        awk -v fecha2=$fecha1 -v hora2=$hora1 -v min2=$min1 -v Assoc=$Assoc '{ printf("%s\t%s:%s\tREINICION ASOCIACIONES:\t%s\n",fecha2,hora2,min2,Assoc); } ' >> ${Reporte_Assoc}
    fi
fi

Texto="Monitoreo de Links y Associations del $Equipo"

Muestra2="
$Texto

DPC             DPC_STATUS      SLK             LSN             SLK_STATUS      SST             ANAME                   A_STATUS                SST
"

#Muestra2="
#$Texto

#DPC             DPC_STATUS      SLK             LSN             SLK_STATUS      SST             ANAME                   A_STATUS                SST
#`cat ${arcTempT}`

#"

#fi
MSG="$MSG
$Muestra2"
$BB $BBDISP "status ${Equipo}.$COLUMN $COLOR `date` $FIRST_LINE $STRING"




#################################
#               VISUALIZACION
#################################
Muestra2=""
MSG=""
COLUMN="IPTPS"
COLOR="green"


#echo $(date +%D)
#echo $(date +%H)    
#echo $(date +%M)
fecha1=`echo $(date +%D)`
hora1=`echo $(date +%H)`
min1=`echo $(date +%M)`
echo $fecha1
echo $hora1
echo $min1
Reporte_TPS=/data/informes/${Equipo}_Reporte_TPS.xls
cat ${arcTemp5} | awk -v fecha2=$fecha1 -v hora2=$hora1 -v min2=$min1 '{ printf("%s\t%s:%s\t%s\n",fecha2,hora2,min2,$0); } ' >> ${Reporte_TPS}


Texto="Monitoreo de TPS de los LinkSet del $Equipo

LSN             RSVD    MAX     TX_IPS  TX_PEAK RX_IPS  RX_PEAK  TX_%   RX_%"
Muestra2="
$Texto
`cat ${arcTemp5}`
"
#fi
MSG="$MSG
$Muestra2"
$BB $BBDISP "status ${Equipo}.$COLUMN $COLOR `date` ${MSG}"


##################################################################
#
#   STP Alarmas
#
##################################################################

FIRST_LINE=""
Muestra2=""
MSG=""
COLUMN="Alarmas"
COLOR="green"
STRING=""


cat ${arcTemp6}  | sed 's/ \*C /|\*C|/' | sed 's/ \*\* /|\*\*|/' | sed 's/ \* /| \*|/' | sed 's/MPS EPAP-A/|MPS EPAP-A|/' | sed 's/MPS EPAP-B/|MPS EPAP-B|/' | sed 's/REPT-LKSTO: link set restricted/|REPT-LKSTO: link set restricted|/' | sed 's/REPT-LKF: APF - lvl-2 T3 expired/|REPT-LKF: APF - lvl-2 T3 expired|/' | sed 's/REPT-LKF: APF - lvl-2 T2 expired/|REPT-LKF: APF - lvl-2 T2 expired|/' | sed 's/FC Port De-activated/|FC Port De-activated|/'  |  sed 's/LOGBUFROVFL-SECULOG - upload required/|LOGBUFROVFL-SECULOG - upload required|/' | sed 's/DPC is prohibited/|DPC is prohibited|/' | sed 's/REPT-E1F:FAC-E1 LOF failure/|REPT-E1F:FAC-E1 LOF failure|/' | sed 's/REPT-E1F:FAC-E1 LOS failure/|REPT-E1F:FAC-E1 LOS failure|/' | sed 's/IP Connection Unavailable/|IP Connection Unavailable|/' | sed 's/HS CLOCK SYSTEM         /HS CLOCK SYSTEM         |/' | sed 's/REPT-LKSTO: link set prohibited/|REPT-LKSTO: link set prohibited|/' | sed 's/REPT-LKF: not aligned/|REPT-LKF: not aligned|/' | sed 's/IP Connection Restricted/|IP Connection Restricted|/' | sed 's/IP Connection Excess Retransmits/|IP Connection Excess Retransmits|/' | sed 's/REPT-LKF: lost data/|REPT-LKF: lost data|/' | sed 's/REPT-LKF: remote FE loopback/|REPT-LKF: remote FE loopback|/' | sed 's/DPC is restricted/|DPC is restricted|/' | sed 's/Terminal failed/|Terminal failed|/' | sed 's/Loss of Heartbeat/|Loss of Heartbeat|/' | sed 's/System release GPL(s) not approved/|System release GPL(s) not approved|/'  | sed 's/REPT-LKF: rcvd remote out of service/|REPT-LKF: rcvd remote out of service|/' | sed 's/REPT-LKF: OSA - received SIOS/|REPT-LKF: OSA - received SIOS|/' | sed 's/IPSG Ethernet Interface Down/|IPSG Ethernet Interface Down|/'  | sed 's/-SHS clocks failed/-SHS clocks failed|/' | sed 's/ invalid BSN/ invalid BSN|/' | sed 's/REPT-LKF: ABN - rcvd/|REPT-LKF: ABN - rcvd/' | sed 's/Time Unavailable/|Time Unavailable|/'  | sed 's/Ethernet Interface Down/|Ethernet Interface Down|/' |  sed 's/REPT-LKF: MTP link restart delayed/|REPT-LKF: MTP link restart delayed|/' | sed 's/           //' | sed 's/            //' | sed 's/      //' | sed 's/      //' | sed 's/        //'  | awk '  { printf("|%s\n",$0); } ' | awk -v FS="|" '{ printf("|%s |%s|%s|%s|%s\n",$6,$2,$3,$4,$5); } ' | sed 's/-03-/ | 03 | /' | sed 's/-02-/ | 02 | /' | sed 's/-01-/ | 01 | /' | sed 's/-11-/ | 11 | /' | sed 's/-12-/ | 12 | /' | sed 's/-10-/ | 10 | /' | sed 's/-09-/ | 09 | /' | sed 's/-08-/ | 08 | /' | sed 's/-07-/ | 07 | /' | sed 's/-06-/ | 06 | /' | sed 's/-05-/ | 05 | /' | sed 's/-04-/ | 04 | /' | sed 's/-10-/ | 10 | /' | sort -k 6nr -k 4nr -k 2nr -k 7nr | awk -v FS="|" '{ printf("%s%s %s|%s|%s|%s|%s|%s\n",$2,$3,$4,$5,$6,$7,$8,$9); } ' | sed -e 's/[ \t]//' |  sed 's/  / /' | grep -v "|||||" | sed 's/*C/Critical/' | sed 's/| \*|/|Minor|/'  | sed 's/|\*\*|/|Major|/' > ${arcTempA}


STRING="<table border=0 cellpadding=10><tr><th></th><th>Fecha</th><th>Alarm ID</th><th>Severity</th><th>Alarm Title</th><th>Alarm Description</th></tr>"

major=0
minor=0
critical=0
k=0
#cat ${arcTemp3} > ${Temporal}
Count1=$(AveriguaLineasA)
echo $Count1
    while [ $k -lt $Count1 ]
    do
    k=`expr $k + 1`
    echo $k
    LINE_COLOR='green'
                fila1=1
                Fecha=$(ObtenerDatoA)
                echo $Fecha
                fila1=2
                AlarmaID_STP=$(ObtenerDatoA)
                echo $AlarmaID_STP
                fila1=3
                Severity_STP=$(ObtenerDatoA)
                echo $Severity_STP
                fila1=4
                AlarmaTitle_STP=$(ObtenerDatoA)
                echo $AlarmaTitle_STP
                fila1=5
                AlarmaDescription_STP=$(ObtenerDatoA)
                echo $AlarmaDescription_STP
                #cat ${arcTemp2} > ${Temporal}
   
                if [ "$Severity_STP" = "Major" ]; then
                    LINE_COLOR='yellow'
                    major=`expr $major + 1`
                fi
                if [ "$Severity_STP" = "Minor" ]; then
                    LINE_COLOR='yellow'
                    minor=`expr $minor + 1`
                fi
                if [ "$Severity_STP" = "Critical" ]; then
                    LINE_COLOR='red' 
                    critical=`expr $critical + 1`
                fi
                
                if [[ "$AlarmaTitle_STP" = "MPS EPAP-A" || "$AlarmaTitle_STP" = "MPS EPAP-B" ]]; then
                    COLOR='red'
                fi  
                 
                STRING="$STRING <tr><td>&${LINE_COLOR}</td><td>${Fecha}</td><td>${AlarmaID_STP}</td><td>${Severity_STP}</td><td>${AlarmaTitle_STP}</td><td>${AlarmaDescription_STP}</td></tr>"
    done


STRING="$STRING </table><br><br>"



Texto="Monitoreo de Alarmas del $Equipo

"
Muestra2="
$Texto

critical : $critical
major : $major
minor : $minor

"

FIRST_LINE="$FIRST_LINE  |   Monitoreo de Alarmas del $Equipo   |  CRITICAL : $critical   |   MAJOR : $major   |   MINOR : $minor"

#fi
MSG="$MSG
$Muestra2
$STRING"
$BB $BBDISP "status ${Equipo}.$COLUMN $COLOR `date` $FIRST_LINE $STRING"
#$BB $BBDISP "status ${Equipo}.$COLUMN $COLOR `date` ${MSG}"


##################################################################
#
#   STP MSS TPS
#
##################################################################

Muestra2=""
MSG=""
COLUMN="TPS"
COLOR="green"

Texto=""
Muestra2=""

#fi
MSG="$MSG
$Muestra2
"

$BB $BBDISP "status ${Equipo}.$COLUMN $COLOR `date` ${MSG}

`cat ${arcTemp7} | sort`

"

exit

