#!/bin/bash
source script_mensual_v1.ini
# Restem un dia a la fetxa per calcular el consum el dia anterior.
DATEF=`date -d "-1 month" +%m/%Y`

ANY=`date +%Y`

# Calculem els dies que te el mes anterior

case "$DATEF" in
   01/$ANY | 03/$ANY | 05/$ANY | 07/$ANY | 08/$ANY | 10/$ANY | 12/$ANY )
   DIA=31
   ;;
   02/$ANY)
   DIA=28
   ;;
   04/$ANY | 06/$ANY | 09/$ANY | 11/$ANY )
   DIA=30 ;;
esac

# Borrem el fitxer d'informe anterior si hi es

if [ -f $RUTA/informe_mensual.txt ]
then
rm $RUTA/informe_mensual.txt
fi

# Si li passem un parametre, el fara servir com a fecha.
# Us: $0 mm/yyyy
if [ $# -eq 1 ]
        then
        DATEF=$1
fi
                

echo MIME-Version: 1.0 >> $RUTA/informe_mensual.txt
echo Content-type: text\/html\; charset=utf-8 >> $RUTA/informe_mensual.txt
echo subject: Informe MENSUAL de consum del dia 01/$DATEF al $DIA/$DATEF >> $RUTA/informe_mensual.txt
echo >> $RUTA/informe_mensual.txt
echo \<html\> >> $RUTA/informe_mensual.txt


echo
echo Informe de consum Mensual mes/any: $DATEF
echo Informe de consum Mensual mes/any: $DATEF \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt

# Consulta del movil1
echo Movil $USUARIO1
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo \<b\>Movil de USUARIO1\<\/b\> Tarifa Actual: $MOVIL1\<br\> >> $RUTA/informe_mensual.txt
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF1 >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt

echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>Pepe4.5\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF1 -m pepe5_noprint >> $RUTA/informe_mensual.txt
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa  \<b\>\<font color=\"blue\"\>VIP\<\/font\>\<\/b\> \(sense establiment\) el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF1 -m pepe_vip_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo

# Consulta del movil2
echo Movil $USUARIO2
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo \<b\>Movil de $USUARIO2\<\/b\> Tarifa Actual: $MOVIL2\<br\> >> $RUTA/informe_mensual.txt
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF2 >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt

echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>Pulpo Paul\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF2 -m pepe_pulpo_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>VIP\<\/font\>\<\/b\> \(sense establiment\) el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF2 -m pepe_vip_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>COBAYA\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF2 -m pepe_cobaya_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo

# Consulta del movil3
echo Movil de $USUARIO3
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo \<b\>Movil de $USUARIO3\<\/b\> Tarifa Actual: $MOVIL3\<br\> >> $RUTA/informe_mensual.txt
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF3 >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt

echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>Pulpo Paul\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF3 -m pepe_pulpo_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>4.5 cent\<\/font\>\<\/b\>el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF3 -m pepe5_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo

# Consulta del movil4
echo Movil de $USUARIO4
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo \<b\>Movil de $USUARIO4\<\/b\> Tarifa Actual: $MOVIL4\<br\> >> $RUTA/informe_mensual.txt
echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF4 >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt

echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa  \<b\>\<font color=\"blue\"\>Pulpo Paul\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF4 -m pepe_pulpo_noprint >> $RUTA/informe_mensual.txt
echo \<br\> >> $RUTA/informe_mensual.txt
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>COBAYA\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt
/usr/bin/python $RUTA2/pepephone.py -i 01/$DATEF -f $DIA/$DATEF -n $TELF4 -m pepe_cobaya_noprint >> $RUTA/informe_mensual.txt

echo \<br\> >> $RUTA/informe_mensual.txt
echo \<\/html\> >> $RUTA/informe_mensual.txt
echo

# Enviament de correu electronic
cat $RUTA/informe_mensual.txt | /usr/sbin/sendmail $CORREO
