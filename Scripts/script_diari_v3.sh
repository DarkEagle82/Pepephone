#!/bin/bash
if [ $# -lt 1 ] || [ $# -gt 2 ]
then
     echo
     echo "Falta configurar els parametres !"
     echo "Us: $0 fitxer_config.ini [dd/mm/yyyy]"
     echo
     exit 1
fi
source $1
if [ $UNCONFIG == 1 ]
then
     echo
     echo "Abans has de configurar el $1"
     echo
     exit 1
fi
                                          
if [  ${#USUARIO[@]} != ${#TELF[@]} ] || [ ${#USUARIO[@]} != ${#TARIFA[@]} ]
then
     echo "El fitxer de configuració no és correcte, hi ha d'haver el mateix nombre d'usuaris, que de telefons, que de tarifes !!"
     exit 1
fi
# Restem un dia a la fetxa per calcular el consum el dia anterior.
DATEF=`date -d "-1 day" +%d/%m/%Y`

# Borrem el fitxer d'informe anterior si hi es.

if [ -f $RUTA/informe_diari.txt ]
then
rm $RUTA/informe_diari.txt
fi

# Si li passem un parametre, el fara servir com a fecha.
# Us: $0 dd/mm/yyyy

if [ $# -eq 2 ]
     then
     DATEF=$2
fi

# Encapçalament Correu i assumpte
echo MIME-Version: 1.0 >> $RUTA/informe_diari.txt
echo Content-type: text\/html\; charset=utf-8 >> $RUTA/informe_diari.txt
echo subject: Informe DIARI de $USUARIO de consum el dia $DATEF >> $RUTA/informe_diari.txt
echo >> $RUTA/informe_diari.txt
echo \<html\> >> $RUTA/informe_diari.txt

echo
echo Informe de consum diari en fecha: $DATEF
echo Informe de consum diari en fecha: $DATEF \<br\> >> $RUTA/informe_diari.txt
echo
echo \<br\> >> $RUTA/informe_diari.txt

LINEAS=${#TARIFA[@]}
for ((i=0;i<LINEAS;i++)); do
     # Consulta del moviln
     echo Movil ${USUARIO[$i]}
     echo
     echo "************************************" \<br\> >> $RUTA/informe_diari.txt
     echo \<b\>Movil de ${USUARIO[$i]} \<\/b\> Tarifa Actual: \<font color=\#1E9FEE\>${TARIFA[$i]}\<\/font\>\<br\> >> $RUTA/informe_diari.txt
     echo "************************************" \<br\> >> $RUTA/informe_diari.txt
     echo
     echo \<br\> >> $RUTA/informe_diari.txt
     /usr/bin/python $RUTA2/$PROGRAMA -i $DATEF -f $DATEF -n ${TELF[$i]} >> $RUTA/informe_diari.txt
     echo \<br\> >> $RUTA/informe_diari.txt

     echo
     echo >> $RUTA/informe_diari.txt
done
# Enviament de correu electronic
NUMMAILS=${#CORREO[@]}
for ((i=0;i<NUMMAILS;i++)); do
	cat $RUTA/informe_diari.txt | /usr/sbin/sendmail ${CORREO[$i]}
done
exit 0

