#!/bin/bash
source script_diari_v1.ini
# Restem un dia a la fetxa per calcular el consum el dia anterior.
DATEF=`date -d "-1 day" +%d/%m/%Y`

# Borrem el fitxer d'informe anterior si hi es.

if [ -f $RUTA/informe_diari.txt ]
then
rm $RUTA/informe_diari.txt
fi

# Si li passem un parametre, el fara servir com a fecha.

if [ $# -eq 1 ]
        then
        DATEF=$1
fi

# Consulta del movil1
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

echo Movil $USUARIO1
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo \<b\>Movil de $USUARIO1 \<\/b\> Tarifa Actual: $MOVIL1\<br\> >> $RUTA/informe_diari.txt
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo
echo \<br\> >> $RUTA/informe_diari.txt
/usr/bin/python $RUTA2/pepephone.py -i $DATEF -f $DATEF -n $TELF1 >> $RUTA/informe_diari.txt
echo \<br\> >> $RUTA/informe_diari.txt

echo
echo >> $RUTA/informe_diari.txt
# Consulta del movil2
echo Movil de $USUARIO2
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo \<b\>Movil de $USUARIO2 \<\/b\> Tarifa Actual: $MOVIL2\<br\> >> $RUTA/informe_diari.txt
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo
echo \<br\> >> $RUTA/informe_diari.txt
/usr/bin/python $RUTA2/pepephone.py -i $DATEF -f $DATEF -n $TELF2 >> $RUTA/informe_diari.txt
echo \<br\> >> $RUTA/informe_diari.txt

echo
echo >> $RUTA/informe_diari.txt
# Consulta del movil3
echo Movil de $USUARIO3
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo \<b\>Movil de la Conchi \<\/b\> Tarifa Actual: $MOVIL3\<br\> >> $RUTA/informe_diari.txt
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo
echo \<br\> >> $RUTA/informe_diari.txt
/usr/bin/python $RUTA2/pepephone.py -i $DATEF -f $DATEF -n $TELF3 >> $RUTA/informe_diari.txt
echo \<br\> >> $RUTA/informe_diari.txt

echo
echo >> $RUTA/informe_diari.txt
# Consulta del movil4
echo Movil de $USUARIO4
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo \<b\>Movil de $USUARIO4 \<\/b\>  Tarifa Actual: $MOVIL4\<br\> >> $RUTA/informe_diari.txt
echo "************************************" \<br\> >> $RUTA/informe_diari.txt
echo
echo \<br\> >> $RUTA/informe_diari.txt
/usr/bin/python $RUTA2/pepephone.py -i $DATEF -f $DATEF -n $TELF4 >> $RUTA/informe_diari.txt

echo \<br\> >> $RUTA/informe_diari.txt
echo \<\/html\> >> $RUTA/informe_diari.txt
echo

# Enviament de correu electronic
cat $RUTA/informe_diari.txt | /usr/sbin/sendmail $CORREO
