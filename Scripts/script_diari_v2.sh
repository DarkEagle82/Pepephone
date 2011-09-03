#!/bin/bash
source script_diari_v2.ini
if [ $UNCONFIG == 1 ]
then
     echo
     echo "Abans has de configurar el arxiu script_diari_v2.ini"
     echo
     exit 1
fi
if [  ${#USUARIO[@]} != ${#TELF[@]} ] || [ ${#USUARIO[@]} != ${#TARIFA[@]} ]
then
     echo "El fitxer de configuraci� no �s correcte, hi ha d'haver el mateix nombre d'usuaris, que de telefons, que de tarifes !!"
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

if [ $# -eq 1 ]
     then
     DATEF=$1
fi

# Encap�alament Correu i assumpte
echo MIME-Version: 1.0 >> $RUTA/informe_diari.txt
echo Content-type: text\/html\; charset=utf-8 >> $RUTA/informe_diari.txt
echo subject: Informe DIARI de consum el dia $DATEF >> $RUTA/informe_diari.txt
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
     echo \<b\>Movil de ${USUARIO[$i]} \<\/b\> Tarifa Actual: ${TARIFA[$i]}\<br\> >> $RUTA/informe_diari.txt
     echo "************************************" \<br\> >> $RUTA/informe_diari.txt
     echo
     echo \<br\> >> $RUTA/informe_diari.txt
     /usr/bin/python $RUTA2/pepephone.py -i $DATEF -f $DATEF -n ${TELF[$i]} >> $RUTA/informe_diari.txt
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

